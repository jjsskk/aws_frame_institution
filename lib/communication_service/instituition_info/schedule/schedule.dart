import 'dart:async';
import 'dart:collection';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/schedule/TableCalendarUtils.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:textfield_tags/textfield_tags.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final gql = GraphQLController.Obj;
  var textStyleWhite =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  var textStyleBlack =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  //create data
  String inst = 'aaaa';
  int inst_id = 1;

  bool loading = true;
  bool isCheckedEdit =
      false; // check for edit( add or update) or view calendar event
  bool isCheckedAddOrUpdate =
      false; // check for add( false)  or update(true) query
  String saveScheduleId = '';
  List<String> tagsFromDB = [];

  int startHour = 0; //used to update program start time
  int startMin = 0; //used to update program start time
  int endHour = 0; //used to update program end time
  int endMin = 0; //used to update program end time

  DateTime _dateStartTimePicker = DateTime.now();
  DateTime _dateEndTimePicker = DateTime.now();
  final GlobalKey _containerkey = GlobalKey();

  TextEditingController _programController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final TextfieldTagsController _tagController = TextfieldTagsController();
  late double _distanceToField;

  // for calendar event
  ValueNotifier<List<Event>>? _selectedEvents = null;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late var kFirstDay;
  late var kLastDay;

  Map<DateTime, List<Event>> _event = {};

  late var _kEvents;

  Map<DateTime, List<Event>> get event => _event;

  StreamSubscription<GraphQLResponse<dynamic>>? listener = null;
  late Stream<GraphQLResponse>? stream;

  //dropdownvalues
  var month = 1; // for DropdownDatePicker
  var year = 2023; // for DropdownDatePicker
  List<String> monthList = [
    '1월',
    '2월',
    '3월',
    '4월',
    '5월',
    '6월',
    '7월',
    '8월',
    '9월',
    '10월',
    '11월',
    '12월',
  ];
  List<String> yearList = [];

  String dropdownYear = '';
  String dropdownMonth = '';

  Widget filterMorningOrAfter(String time) {
    var tempBox = time.split("~");
    var name = time.substring(0, 2);
    var num = int.parse(name);
    if (0 <= num && num <= 11)
      name = "오전";
    else
      name = "오후";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(name, style: textStyleWhite),
          Text(tempBox.first.trim(), style: textStyleWhite),
          Text('-', style: textStyleWhite),
          Text(tempBox.last.trim(), style: textStyleWhite)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    makeYearDropdownValues();
    _selectedDay = _focusedDay;
    getEventDataFromDB();
    // stream = gql.subscribeInstitutionSchedule("1234");
    // print(stream);
    // subscribeScheduleChange();
  }

  void selelctCalender() {
    kFirstDay = DateTime(year, month, 1);
    kLastDay = DateTime(year, month + 1, 0);
  }

  // void subscribeScheduleChange() {
  //   listener = stream!.listen(
  //     (snapshot) {
  //       print('data : ${snapshot.data!}');
  //       getEventDataFromDB();
  //     },
  //     onError: (Object e) => safePrint('Error in subscription stream: $e'),
  //   );
  // }

  void getEventDataFromDB() {
    _event = {};
    setState(() {
      loading = true;
    });
    selelctCalender();
    String? monthStr;
    monthStr = month > 9 ? '${month}' : '0${month}';
    gql
        .queryInstitutionScheduleByInstitutionId(
            '${_selectedDay!.year}${monthStr}00')
        .then((result) {
      //       gql.queryInstitutionScheduleByInstitutionId("1").then((result) {
      print(result);
      result.forEach((value) {
        // print("${value.id}");
        int year = int.parse(value.DATE.substring(0, 4));
        int month = int.parse(value.DATE.substring(4, 6));
        int day = int.parse(value.DATE.substring(6, 8));
        final date = DateTime.utc(year, month, day);
        if (event.containsKey(date)) {
          event[date]!.add(Event(value.CONTENT ?? '', value.TIME ?? '',
              value.SCHEDULE_ID ?? '', value.TAG));
        } else {
          event.addAll({
            date: [
              Event(value.CONTENT ?? '', value.TIME ?? '',
                  value.SCHEDULE_ID ?? '', value.TAG)
            ]
          });
        }
      });

      _kEvents = LinkedHashMap<DateTime, List<Event>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(event);
      if (_selectedEvents == null)
        _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      else {
        _selectedEvents!.removeListener(() {});
        _selectedEvents!.dispose();
        _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      }

      _selectedEvents!.value.sort((a, b) {
        String aa = a.time.substring(0, 7);
        // print(aa);
        String bb = b.time.substring(0, 7);
        return aa.compareTo(bb);
      });
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    _selectedEvents!.dispose();
    if (listener != null) listener?.cancel();
    super.dispose();
  }

  void makeYearDropdownValues() {
    month = _focusedDay.month;
    year = _focusedDay.year;
    var tempYear = year - 3;
    for (; tempYear < year + 4; tempYear++) yearList.add('$tempYear년');

    dropdownMonth = '$month월';
    dropdownYear = '$year년';
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return _kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents!.value = _getEventsForDay(selectedDay);
    }
  }

  static const List<String> _pickActivity = <String>[
    '내부 활동',
    '외부 활동',
    '내부 강사',
    '외부 강사',
    'java'
  ];

  var blue = const Color(0xff1f43f3);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      body: loading
          ? LoadingPage()
          : Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width,
                maxHeight: double.infinity,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("image/ui (2).png"),
                  // 여기에 배경 이미지 경로를 지정합니다.
                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 25,
                              width: MediaQuery.of(context).size.width / 3.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage("image/report (20).png"),
                                  // 여기에 배경 이미지 경로를 지정합니다.
                                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                ),
                              ),
                              child: Center(
                                child: DropdownButton<String>(
                                  dropdownColor: blue,
                                  value: dropdownYear,
                                  icon: Icon(
                                    // Add this
                                    Icons.arrow_drop_down, // Add this
                                    color: Colors.white, // Add this
                                  ),
                                  onChanged: (String? value) {
                                    setState(
                                      () {
                                        dropdownYear = value!;
                                        year =
                                            int.parse(value!.substring(0, 4));
                                      },
                                    );
                                    print(year);
                                  },
                                  items: yearList.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 25,
                              width: MediaQuery.of(context).size.width / 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage("image/report (20).png"),
                                  // 여기에 배경 이미지 경로를 지정합니다.
                                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                ),
                              ),
                              child: Center(
                                child: DropdownButton<String>(
                                  dropdownColor: blue,
                                  value: dropdownMonth,
                                  icon: Icon(
                                    // Add this
                                    Icons.arrow_drop_down, // Add this
                                    color: Colors.white, // Add this
                                  ),
                                  onChanged: (String? value) {
                                    setState(
                                      () {
                                        dropdownMonth = value!;
                                        int len = value!.length;
                                        month = int.parse(value!
                                            .substring(0, len > 2 ? 2 : 1));
                                      },
                                    );
                                    print(month);
                                  },
                                  items: monthList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: DropdownDatePicker(
                            //     inputDecoration: InputDecoration(
                            //         enabledBorder: const OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //               color: Colors.grey, width: 1.0),
                            //         ),
                            //         border: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(10))),
                            //     // optional
                            //     isDropdownHideUnderline: true,
                            //     // optional
                            //     isFormValidator: true,
                            //     // optional
                            //     startYear: 2022,
                            //     // optional
                            //     endYear: 2030,
                            //     // optional
                            //     width: 10,
                            //     // optional
                            //     locale: "zh_CN",
                            //     // selectedDay: 14, // optional
                            //     showDay: false,
                            //     selectedMonth: month,
                            //     // optional
                            //     selectedYear: year,
                            //     // optional
                            //     // onChangedDay: (value) => print('onChangedDay: $value'),
                            //     onChangedMonth: (value) {
                            //       print('onChangedMonth: $value');
                            //       month = int.parse(value!);
                            //     },
                            //     onChangedYear: (value) {
                            //       print('onChangedYear: $value');
                            //       year = int.parse(value!);
                            //     },
                            //     //boxDecoration: BoxDecoration(
                            //     // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                            //     // showDay: false,// optional
                            //     // dayFlex: 2,// optional
                            //     // locale: "zh_CN",// optional
                            //     // hintDay: 'Day', // optional
                            //     // hintMonth: 'Month', // optional
                            //     // hintYear: 'Year', // optional
                            //     // hintTextStyle: TextStyle(color: Colors.grey), // optional
                            //   ),
                            // ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _focusedDay = DateTime(year, month);
                                        // loading = true;
                                        getEventDataFromDB();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.search,
                                      color: blue,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage("image/community (20).png"),
                            // 여기에 배경 이미지 경로를 지정합니다.
                            fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TableCalendar<Event>(
                            headerVisible: false,
                            locale: 'ko-KR',
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: _focusedDay,
                            daysOfWeekHeight: 30,
                            rowHeight: MediaQuery.of(context).size.height / 17,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            rangeStartDay: _rangeStart,
                            rangeEndDay: _rangeEnd,
                            calendarFormat: _calendarFormat,
                            rangeSelectionMode: _rangeSelectionMode,
                            eventLoader: _getEventsForDay,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: blue,
                                shape: BoxShape.circle,
                              ),
                              // Use `CalendarStyle` to customize the UI
                              isTodayHighlighted: false,
                              // marker 여러개 일 때 cell 영역을 벗어날지 여부
                              canMarkersOverflow: false,
                              // 자동정렬 여부
                              markersAutoAligned: true,
                              // marker 크기 조절
                              markerSize: 10.0,
                              // marker 크기 비율 조절
                              markerSizeScale: 10.0,
                              // marker 의 기준점 조정
                              markersAnchor: 0.7,
                              // marker margin 조절
                              markerMargin:
                                  const EdgeInsets.symmetric(horizontal: 0.3),
                              // marker 위치 조정
                              markersAlignment: Alignment.bottomCenter,
                              // 한줄에 보여지는 marker 갯수
                              markersMaxCount: 4,
                              markersOffset: const PositionedOffset(),
                              // marker 모양 조정
                              markerDecoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              outsideDaysVisible: false,
                            ),
                            onDaySelected:
                                isCheckedEdit ? null : _onDaySelected,
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      _selectedDay == null
                          ? const SizedBox()
                          : Container(
                              constraints: BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                image: DecorationImage(
                                  image: AssetImage("image/community (20).png"),
                                  // 여기에 배경 이미지 경로를 지정합니다.
                                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        isCheckedEdit
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isCheckedEdit =
                                                        !isCheckedEdit;
                                                    if (isCheckedAddOrUpdate)
                                                      isCheckedAddOrUpdate =
                                                          !isCheckedAddOrUpdate;
                                                    _programController.clear();
                                                    _tagController.clearTags();
                                                    startHour = startMin =
                                                        endMin = endHour = 0;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.arrow_circle_left,
                                                  size: 35,
                                                  color: blue,
                                                ),
                                              )
                                            : const SizedBox(),
                                        Text(
                                          '${_selectedDay!.year}년 ${_selectedDay!.month}월 ${_selectedDay!.day}일',
                                          style: textStyleBlack,
                                        ),
                                        Row(
                                          children: [
                                            isCheckedEdit
                                                ? InkWell(
                                                    onTap: () async {
                                                      print(
                                                          '${DateTime.now()}');
                                                      print(_tagController
                                                          .getTags);
                                                      String start =
                                                          '${_dateStartTimePicker.hour.toString().padLeft(2, '0')}시 ${_dateStartTimePicker.minute.toString().padLeft(2, '0')}분';
                                                      print('start : $start');
                                                      String end =
                                                          '${_dateEndTimePicker.hour.toString().padLeft(2, '0')}시 ${_dateEndTimePicker.minute.toString().padLeft(2, '0')}분';
                                                      print('end : $end');
                                                      if (!_formKey
                                                          .currentState!
                                                          .validate()) return;
                                                      String? monthStr;
                                                      monthStr = _selectedDay!
                                                                  .month >
                                                              9
                                                          ? '${_selectedDay!.month}'
                                                          : '0${_selectedDay!.month}';
                                                      String? dateStr;
                                                      dateStr = _selectedDay!
                                                                  .day >
                                                              9
                                                          ? '${_selectedDay!.day}'
                                                          : '0${_selectedDay!.day}';
                                                      String SCHE_ID =
                                                          '${DateTime.now()}';
                                                      final date = DateTime.utc(
                                                          _selectedDay!.year,
                                                          _selectedDay!.month,
                                                          _selectedDay!.day);

                                                      bool isChecked = isCheckedAddOrUpdate
                                                          ? await gql.updateScheduledata(
                                                              saveScheduleId,
                                                              _programController
                                                                  .text
                                                                  .trim()
                                                                  .trim(),
                                                              _tagController
                                                                  .getTags,
                                                              '$start ~ $end',
                                                              '${_selectedDay!.year}$monthStr$dateStr')
                                                          : await gql.createScheduledata(
                                                              SCHE_ID,
                                                              _programController
                                                                  .text
                                                                  .trim()
                                                                  .trim(),
                                                              _tagController
                                                                  .getTags,
                                                              '$start ~ $end',
                                                              '${_selectedDay!.year}$monthStr$dateStr');
                                                      {
                                                        if (isChecked) {
                                                          getEventDataFromDB();
                                                          _programController
                                                              .clear();
                                                          _tagController
                                                              .clearTags();
                                                          // if (kEvents.containsKey(date)) {
                                                          //   if (isCheckedAddOrUpdate)
                                                          //     kEvents[date].removeWhere(
                                                          //         (event) =>
                                                          //             event.sche_id ==
                                                          //             saveScheduleId);
                                                          //   kEvents[date]!.add(Event(
                                                          //       _programController.text
                                                          //           .trim(),
                                                          //       '$start ~ $end',
                                                          //       isCheckedAddOrUpdate
                                                          //           ? saveScheduleId
                                                          //           : SCHE_ID));
                                                          // } else {
                                                          //   kEvents.addAll({
                                                          //     date: [
                                                          //       Event(
                                                          //           _programController
                                                          //               .text
                                                          //               .trim(),
                                                          //           '$start ~ $end',
                                                          //           SCHE_ID)
                                                          //     ]
                                                          //   });
                                                          // }
                                                          setState(() {
                                                            isCheckedEdit =
                                                                !isCheckedEdit;
                                                            if (isCheckedAddOrUpdate)
                                                              isCheckedAddOrUpdate =
                                                                  !isCheckedAddOrUpdate;
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                              '일정이 저장되었습니다.',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ));
                                                          // sche_id++;
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                              '예기치 못한 오류로 저장이 안되었습니다. 다시 시도해주세요.',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image.asset(
                                                          "image/community (3).png"),
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isCheckedEdit =
                                                            !isCheckedEdit;
                                                      });
                                                    },
                                                    icon: Icon(Icons
                                                        .add_circle_outlined),
                                                    color: blue,
                                                    iconSize: 30,
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                    isCheckedEdit
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Center(
                                                    child: Text(
                                                  isCheckedAddOrUpdate
                                                      ? '프로그램 수정'
                                                      : '프로그램 추가',
                                                  style: textStyleBlack,
                                                )),
                                                Row(
                                                  children: [
                                                    Text('태그 : '),
                                                    Expanded(
                                                      child:
                                                          Autocomplete<String>(
                                                        optionsViewBuilder:
                                                            (context,
                                                                onSelected,
                                                                options) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                    vertical:
                                                                        4.0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topCenter,
                                                              child: Material(
                                                                elevation: 4.0,
                                                                child:
                                                                    ConstrainedBox(
                                                                  constraints:
                                                                      const BoxConstraints(
                                                                          maxHeight:
                                                                              200),
                                                                  child: ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        options
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      final dynamic
                                                                          option =
                                                                          options
                                                                              .elementAt(index);
                                                                      return TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          onSelected(
                                                                              option);
                                                                        },
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 15.0),
                                                                            child:
                                                                                Text(
                                                                              '#$option',
                                                                              textAlign: TextAlign.left,
                                                                              style: const TextStyle(
                                                                                color: Color.fromARGB(255, 74, 137, 92),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        optionsBuilder:
                                                            (TextEditingValue
                                                                textEditingValue) {
                                                          if (textEditingValue
                                                                  .text ==
                                                              '') {
                                                            return const Iterable<
                                                                String>.empty();
                                                          }
                                                          return _pickActivity
                                                              .where((String
                                                                  option) {
                                                            return option.contains(
                                                                textEditingValue
                                                                    .text
                                                                    .toLowerCase());
                                                          });
                                                        },
                                                        onSelected: (String
                                                            selectedTag) {
                                                          _tagController
                                                                  .addTag =
                                                              selectedTag;
                                                        },
                                                        fieldViewBuilder: (context,
                                                            ttec,
                                                            tfn,
                                                            onFieldSubmitted) {
                                                          return TextFieldTags(
                                                            textEditingController:
                                                                ttec,
                                                            focusNode: tfn,
                                                            textfieldTagsController:
                                                                _tagController,
                                                            initialTags:
                                                                isCheckedAddOrUpdate
                                                                    ? tagsFromDB
                                                                    : const [
                                                                        '강사',
                                                                      ],
                                                            textSeparators: const [
                                                              ' ',
                                                              ','
                                                            ],
                                                            letterCase:
                                                                LetterCase
                                                                    .normal,
                                                            validator:
                                                                (String tag) {
                                                              if (_tagController
                                                                  .getTags!
                                                                  .contains(
                                                                      tag)) {
                                                                return '이미 등록한 태그 입니다.';
                                                              }
                                                              return null;
                                                            },
                                                            inputfieldBuilder:
                                                                (context,
                                                                    tec,
                                                                    fn,
                                                                    error,
                                                                    onChanged,
                                                                    onSubmitted) {
                                                              return ((context,
                                                                  sc,
                                                                  tags,
                                                                  onTagDelete) {
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10.0),
                                                                  child:
                                                                      TextField(
                                                                    maxLength:
                                                                        10,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    controller:
                                                                        tec,
                                                                    focusNode:
                                                                        fn,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border:
                                                                          const UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: const Color(0xff1f43f3),
                                                                            width:
                                                                                3.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          const UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: const Color(0xff1f43f3),
                                                                            width:
                                                                                3.0),
                                                                      ),
                                                                      // helperText: '관련 태그를 입력해주세요',
                                                                      helperStyle:
                                                                          const TextStyle(
                                                                        color: Colors.black,
                                                                      ),
                                                                      hintText: _tagController
                                                                              .hasTags
                                                                          ? ''
                                                                          : '관련 태그를 입력해주세요',
                                                                      errorText:
                                                                          error,
                                                                      prefixIconConstraints:
                                                                          BoxConstraints(
                                                                              maxWidth: _distanceToField * 0.74),
                                                                      prefixIcon: tags
                                                                              .isNotEmpty
                                                                          ? SingleChildScrollView(
                                                                              controller: sc,
                                                                              scrollDirection: Axis.horizontal,
                                                                              child: Row(
                                                                                  children: tags.map((String tag) {
                                                                                return Container(
                                                                                  decoration: const BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(20.0),
                                                                                      ),
                                                                                      color: Color(0xff1f43f3)
                                                                                      //Color.fromARGB(255, 74, 137, 92),
                                                                                      ),
                                                                                  margin: const EdgeInsets.only(right: 10.0),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      InkWell(
                                                                                        child: Text(
                                                                                          '#$tag',
                                                                                          style: const TextStyle(color: Colors.white),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          print("$tag selected");
                                                                                        },
                                                                                      ),
                                                                                      const SizedBox(width: 4.0),
                                                                                      InkWell(
                                                                                        child: const Icon(
                                                                                          Icons.cancel,
                                                                                          size: 14.0,
                                                                                          color: Color.fromARGB(255, 233, 233, 233),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          onTagDelete(tag);
                                                                                        },
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }).toList()),
                                                                            )
                                                                          : null,
                                                                    ),
                                                                    onChanged:
                                                                        onChanged,
                                                                    onSubmitted:
                                                                        onSubmitted,
                                                                  ),
                                                                );
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    Text('시간:'),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Stack(children: [
                                                            hourMinute5IntervalStart(),
                                                            Positioned(
                                                                top: 40,
                                                                left: 48,
                                                                child: Text(
                                                                  ':',
                                                                  style: TextStyle(
                                                                      fontSize: 30),
                                                                ))
                                                          ]),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            '~',
                                                            style: TextStyle(
                                                                fontSize: 30),
                                                          ),

                                                          Stack(
                                                            children: [
                                                              hourMinute5IntervalEnd(),
                                                              Positioned(
                                                                  top: 40,
                                                                  left: 48,
                                                                  child: Text(
                                                                    ':',
                                                                    style: TextStyle(
                                                                        fontSize: 30),
                                                                  ))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),


                                                    // Container(
                                                    //   margin: EdgeInsets.symmetric(vertical: 50),
                                                    //   child: new Text(
                                                    //     _dateStartTimePicker.hour
                                                    //             .toString()
                                                    //             .padLeft(2, '0') +
                                                    //         ':' +
                                                    //         _dateStartTimePicker.minute
                                                    //             .toString()
                                                    //             .padLeft(2, '0') +
                                                    //         ':' +
                                                    //         _dateStartTimePicker.second
                                                    //             .toString()
                                                    //             .padLeft(2, '0'),
                                                    //     style: TextStyle(
                                                    //         fontSize: 24,
                                                    //         fontWeight: FontWeight.bold),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('설명 : '),
                                                    Expanded(
                                                      child: Form(
                                                        key: _formKey,
                                                        child: TextFormField(
                                                          maxLength: 45,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return '내용을 입력해주세요';
                                                            }
                                                          },
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          controller:
                                                              _programController,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                          )
                                        : ValueListenableBuilder<List<Event>>(
                                            valueListenable: _selectedEvents!,
                                            builder: (context, value, _) {
                                              return value.isEmpty
                                                  ? Text(
                                                      '등록된 일정이 없습니다',
                                                      style: textStyleBlack,
                                                    )
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: value.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Row(
                                                          children: [
                                                            Container(
                                                              height: 15,
                                                              width: 15,
                                                              // Width of the vertical divider
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            20.0),
                                                                      ),
                                                                      color: Color(
                                                                          0xff1f43f3)
                                                                      // Color.fromARGB(255, 74, 137, 92),
                                                                      ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  saveScheduleId =
                                                                      value[index]
                                                                          .sche_id;
                                                                  print(
                                                                      'save:${saveScheduleId}');
                                                                  isCheckedAddOrUpdate =
                                                                      !isCheckedAddOrUpdate;
                                                                  _programController =
                                                                      TextEditingController(
                                                                          text:
                                                                              value[index].title);
                                                                  tagsFromDB =
                                                                      value[index]
                                                                          .tags;
                                                                  startHour = int.parse(value[
                                                                          index]
                                                                      .time
                                                                      .substring(
                                                                          0,
                                                                          2));
                                                                  startMin = int.parse(value[
                                                                          index]
                                                                      .time
                                                                      .substring(
                                                                          4,
                                                                          6));
                                                                  endHour = int.parse(value[
                                                                          index]
                                                                      .time
                                                                      .substring(
                                                                          10,
                                                                          12));
                                                                  endMin = int.parse(value[
                                                                          index]
                                                                      .time
                                                                      .substring(
                                                                          14,
                                                                          16));

                                                                  setState(() {
                                                                    isCheckedEdit =
                                                                        !isCheckedEdit;
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          15,
                                                                      horizontal:
                                                                          10),
                                                                  constraints:
                                                                      BoxConstraints(
                                                                    maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    maxHeight:
                                                                        double
                                                                            .infinity,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image: AssetImage(
                                                                          "image/community (7).png"),
                                                                      // 여기에 배경 이미지 경로를 지정합니다.
                                                                      fit: BoxFit
                                                                          .fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Container(
                                                                                  constraints: BoxConstraints(
                                                                                    maxHeight: double.infinity,
                                                                                  ),
                                                                                  width: MediaQuery.of(context).size.width / 4.5,
                                                                                  decoration: const BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(20.0),
                                                                                      ),
                                                                                      color: Color(0xff1f43f3)
                                                                                      // Color.fromARGB(255, 74, 137, 92),
                                                                                      ),
                                                                                  child: Center(child: filterMorningOrAfter(value[index].time))),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                    children: value[index].tags.map((String tag) {
                                                                                  return Flexible(
                                                                                    child: Container(
                                                                                      constraints: BoxConstraints(
                                                                                        maxWidth: MediaQuery.of(context).size.width / 6,
                                                                                      ),
                                                                                      decoration: const BoxDecoration(
                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(20.0),
                                                                                          ),
                                                                                          color: Color(0xff1f43f3)
                                                                                          // Color.fromARGB(255, 74, 137, 92),
                                                                                          ),
                                                                                      margin: const EdgeInsets.only(right: 10.0),
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                                                                      child: InkWell(
                                                                                        child: Text(
                                                                                          '#$tag',
                                                                                          style: const TextStyle(fontSize: 12, color: Colors.white),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          print("$tag selected");
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }).toList()),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Text(
                                                                                  '${value[index].title}',
                                                                                  style: textStyleBlack,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              IconButton(
                                                                                  onPressed: () {
                                                                                    print('delete');
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        useRootNavigator: false,
                                                                                        // without this, info.ifRouteChanged(context) dont recognize context change. check page stack
                                                                                        builder: (BuildContext dontext) {
                                                                                          return AlertDialog(
                                                                                            title: Text('삭제하시겠습니까?'),
                                                                                            actions: [
                                                                                              TextButton(
                                                                                                  onPressed: () async {
                                                                                                    bool isChecked = await gql.deleteScheduledata(value[index].sche_id);
                                                                                                    {
                                                                                                      if (isChecked) {
                                                                                                        getEventDataFromDB();
                                                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                                          content: Text(
                                                                                                            '일정이 삭제되었습니다.',
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                          ),
                                                                                                        ));
                                                                                                        // kEvents[date].removeWhere((event) =>
                                                                                                        //     event
                                                                                                        //         .sche_id ==
                                                                                                        //     value[index]
                                                                                                        //         .sche_id);
                                                                                                      } else {
                                                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                                          content: Text(
                                                                                                            '오류가 발생되어 삭제되지 않았습니다.',
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                          ),
                                                                                                        ));
                                                                                                      }
                                                                                                    }

                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Text('네')),
                                                                                              TextButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Text('아니요'))
                                                                                            ],
                                                                                          );
                                                                                        });
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons.highlight_remove_rounded,
                                                                                    color: blue,
                                                                                  )),
                                                                              const SizedBox(
                                                                                height: 42,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                            },
                                          )
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  /// SAMPLE
  Widget hourMinute12H() {
    return new TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _dateStartTimePicker = time;
        });
      },
    );
  }

  Widget hourMinuteSecond() {
    return new TimePickerSpinner(
      isShowSeconds: true,
      onTimeChange: (time) {
        setState(() {
          _dateStartTimePicker = time;
        });
      },
    );
  }

  Widget hourMinute5IntervalStart() {
    return new TimePickerSpinner(
      time: DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day,
          startHour, startMin),
      spacing: 20,
      itemHeight: 40,
      itemWidth: 38,
      minutesInterval: 5,
      onTimeChange: (time) {
        setState(() {
          _dateStartTimePicker = time;
        });
      },
    );
  }

  Widget hourMinute5IntervalEnd() {
    return new TimePickerSpinner(
      time: DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day,
          endHour, endMin),
      spacing: 20,
      itemHeight: 40,
      itemWidth: 38,

      minutesInterval: 5,
      onTimeChange: (time) {
        setState(() {
          _dateEndTimePicker = time;
        });
      },
    );
  }

  Widget hourMinute12HCustomStyle() {
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
      highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateStartTimePicker = time;
        });
      },
    );
  }
}
