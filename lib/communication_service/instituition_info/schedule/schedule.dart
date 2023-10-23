import 'dart:async';
import 'dart:collection';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/schedule/TableCalendarUtils.dart';
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

  //create data
  String inst = 'aaaa';
  int inst_id = 1;

  // int sche_id = 1;

  bool loading = true;
  var month = 1; // for DropdownDatePicker
  var year = 1; // for DropdownDatePicker
  bool isCheckedEdit = false; // check for add or view calendar event
  bool isCheckedAddOrUpdate =
      false; // check for add( false)  or update(true) query
  String saveScheduleId = '';

  DateTime _dateStartTimePicker = DateTime.now();
  DateTime _dateEndTimePicker = DateTime.now();
  final GlobalKey _containerkey = GlobalKey();

  final TextEditingController _programController = TextEditingController();
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

  Map<DateTime, List<Event>> _event = {};

  late var kEvents;

  Map<DateTime, List<Event>> get event => _event;

  StreamSubscription<GraphQLResponse<dynamic>>? listener = null;
  late Stream<GraphQLResponse>? stream;

  @override
  void initState() {
    super.initState();
    month = _focusedDay.month;
    year = _focusedDay.year;
    _selectedDay = _focusedDay;
    getEventDataFromDB();
    stream = gql.subscribeInstitutionSchedule("1234");
    print(stream);
    subscribeScheduleChange();
  }

  void subscribeScheduleChange() {
    listener = stream!.listen(
      (snapshot) {
        print('data : ${snapshot.data!}');
        // gql.listInstitutionCommentBoard('1234',nextToken: null).then((result) {
        //   print(result);
        //   _comments = [];
        //   _foundComments = [];
        //   result.forEach((value) {
        //     // print(value.createdAt.toString().substring(0,10));
        //     _comments.add({
        //       'date': value.createdAt.toString().substring(0, 10)?? '',
        //       'title': value.TITLE?? '',
        //       'username': value.USERNAME?? '',
        //       'user_id': value.USER_ID?? '',
        //       'board_id': value.BOARD_ID?? '',
        //       'new_conversation': value.NEW_CONVERSATION_PROTECTOR,
        //       'new_conversation_createdat':
        //       value.NEW_CONVERSATION_CREATEDAT.toString()
        //     });
        //     // _foundComments.add({
        //     //   'date': value.createdAt.toString().substring(0, 10),
        //     //   'title': value.TITLE,
        //     //   'username': value.USERNAME,
        //     //   'user_id': value.USER_ID,
        //     //   'board_id': value.BOARD_ID,
        //     //   'new_conversation_createdat': value.NEW_CONVERSATION_CREATEDAT
        //     //       .toString()
        //     // });
        //   });
        //   _comments.sort((a, b) {
        //     String aa = a['new_conversation_createdat'];
        //
        //     String bb = b['new_conversation_createdat'];
        //     return bb.compareTo(aa);
        //   });
        //   _foundComments = List.from(_comments);
        //   setState(() {
        //     _foundComments = _foundComments;
        //   });
        // });
      },
      onError: (Object e) => safePrint('Error in subscription stream: $e'),
    );
  }

  void getEventDataFromDB() {
    _event = {};
    setState(() {
      loading = true;
    });
    String? monthStr;
    monthStr = month > 9 ? '${month}' : '0${month}';
    gql
        .queryInstitutionScheduleByInstitutionId(
            "1", '${_selectedDay!.year}${monthStr}00')
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
          event[date]!.add(Event(
              value.CONTENT ?? '', value.TIME ?? '', value.SCHEDULE_ID ?? ''));
        } else {
          event.addAll({
            date: [
              Event(value.CONTENT ?? '', value.TIME ?? '',
                  value.SCHEDULE_ID ?? '')
            ]
          });
        }
      });

      kEvents = LinkedHashMap<DateTime, List<Event>>(
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

  // measure size for calender event time set container
  Size? _getSize() {
    if (_containerkey.currentContext != null) {
      final RenderBox renderBox =
          _containerkey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
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

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents!.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents!.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents!.value = _getEventsForDay(end);
    }
  }

  static const List<String> _pickActivity = <String>[
    '내부 활동',
    '외부 활동',
    '내부 강사',
    '외부 강사',
    'java'
  ];

  // CalendarFormat _calendarFormat = CalendarFormat.month;
  //
  // DateTime _focusedDay = DateTime.now();
  //
  // DateTime? _selectedDay;
  // Map<DateTime, List<Event>> _events = {
  //   DateTime.utc(2023, 8, 13): [Event(title: 'title'), Event(title: 'title2'), Event(title: 'title2'), Event(title: 'title2'), Event(title: 'title2'), Event(title: 'title2')],
  //   DateTime.utc(2023, 8, 14): [Event(title: 'title3')],
  // };
  //
  // List<Event> _getEventsForDay(DateTime day) {
  //   return _events[day] ?? [];
  // }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(

      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownDatePicker(
                            inputDecoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            // optional
                            isDropdownHideUnderline: true,
                            // optional
                            isFormValidator: true,
                            // optional
                            startYear: 2022,
                            // optional
                            endYear: 2030,
                            // optional
                            width: 10,
                            // optional
                            locale: "zh_CN",
                            // selectedDay: 14, // optional
                            showDay: false,
                            selectedMonth: month,
                            // optional
                            selectedYear: year,
                            // optional
                            // onChangedDay: (value) => print('onChangedDay: $value'),
                            onChangedMonth: (value) {
                              print('onChangedMonth: $value');
                              month = int.parse(value!);
                            },
                            onChangedYear: (value) {
                              print('onChangedYear: $value');
                              year = int.parse(value!);
                            },
                            //boxDecoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                            // showDay: false,// optional
                            // dayFlex: 2,// optional
                            // locale: "zh_CN",// optional
                            // hintDay: 'Day', // optional
                            // hintMonth: 'Month', // optional
                            // hintYear: 'Year', // optional
                            // hintTextStyle: TextStyle(color: Colors.grey), // optional
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(year, month);
                                // loading = true;
                                getEventDataFromDB();
                              });
                            },
                            icon: Icon(Icons.search))
                      ],
                    ),
                    // TableCalendar(
                    //   firstDay: DateTime.utc(2020, 1, 1),
                    //   lastDay: DateTime.utc(2030, 3, 14),
                    //   // headerVisible: false,
                    //   locale: 'ko-KR',
                    //   focusedDay: _focusedDay,
                    //   daysOfWeekHeight: 30,
                    //   calendarFormat: _calendarFormat,
                    //   rangeStartDay: DateTime(2023, 8, 9),
                    //   rangeEndDay: DateTime(2023, 8, 12),
                    //   calendarStyle: const CalendarStyle(
                    //     isTodayHighlighted: false,
                    //     selectedDecoration: BoxDecoration(
                    //       color: Colors.blue,
                    //       shape: BoxShape.circle,
                    //     ),
                    //     rangeHighlightScale: 1.0,
                    //     // range 색상 조정
                    //     rangeHighlightColor: const Color(0xFFBBDDFF),
                    //     // rangeStartDay 글자 조정
                    //     rangeStartTextStyle: const TextStyle(
                    //       color: const Color(0xFFFAFAFA),
                    //     ),
                    //     // rangeStartDay 모양 조정
                    //     rangeStartDecoration: const BoxDecoration(
                    //       color: const Color(0xFF6699FF),
                    //       shape: BoxShape.circle,
                    //     ),
                    //     // rangeEndDay 글자 조정
                    //     rangeEndTextStyle: const TextStyle(
                    //       color: const Color(0xFFFAFAFA),
                    //     ),
                    //     // rangeEndDay 모양 조정
                    //     rangeEndDecoration: const BoxDecoration(
                    //       color: const Color(0xFF6699FF),
                    //       shape: BoxShape.circle,
                    //     ),
                    //     // startDay, endDay 사이의 글자 조정
                    //     withinRangeTextStyle: const TextStyle(),
                    //     // startDay, endDay 사이의 모양 조정
                    //     withinRangeDecoration:
                    //         const BoxDecoration(shape: BoxShape.circle),
                    //     // marker 여러개 일 때 cell 영역을 벗어날지 여부
                    //     canMarkersOverflow: false,
                    //     // 자동정렬 여부
                    //     markersAutoAligned: true,
                    //     // marker 크기 조절
                    //     markerSize: 10.0,
                    //     // marker 크기 비율 조절
                    //     markerSizeScale: 10.0,
                    //     // marker 의 기준점 조정
                    //     markersAnchor: 0.7,
                    //     // marker margin 조절
                    //     markerMargin:
                    //         const EdgeInsets.symmetric(horizontal: 0.3),
                    //     // marker 위치 조정
                    //     markersAlignment: Alignment.bottomCenter,
                    //     // 한줄에 보여지는 marker 갯수
                    //     markersMaxCount: 4,
                    //     markersOffset: const PositionedOffset(),
                    //     // marker 모양 조정
                    //     markerDecoration: const BoxDecoration(
                    //       color: Colors.red,
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    //   selectedDayPredicate: (day) {
                    //     return isSameDay(_selectedDay, day);
                    //   },
                    //   onDaySelected: (selectedDay, focusedDay) {
                    //     if (!isSameDay(_selectedDay, selectedDay)) {
                    //       // Call `setState()` when updating the selected day
                    //       setState(() {
                    //         _selectedDay = selectedDay;
                    //         _focusedDay =
                    //             focusedDay; // update `_focusedDay` here as well
                    //       });
                    //     }
                    //   },
                    //   onFormatChanged: (format) {
                    //     if (_calendarFormat != format) {
                    //       setState(() {
                    //         _calendarFormat = format;
                    //       });
                    //     }
                    //   },
                    //   onPageChanged: (focusedDay) {
                    //     _focusedDay = focusedDay;
                    //   },
                    //   eventLoader: _getEventsForDay,
                    // ),
                    TableCalendar<Event>(
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
                      onDaySelected: _onDaySelected,
                      onRangeSelected: _onRangeSelected,
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
                    const SizedBox(height: 8.0),
                    _selectedDay == null
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isCheckedEdit
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isCheckedEdit = !isCheckedEdit;
                                          if (isCheckedAddOrUpdate)
                                            isCheckedAddOrUpdate =
                                                !isCheckedAddOrUpdate;
                                          _programController.clear();
                                          _tagController.clearTags();
                                        });
                                      },
                                      icon: Icon(Icons.arrow_back),
                                    )
                                  : const SizedBox(),
                              Text(
                                  '${_selectedDay!.year}년 ${_selectedDay!.month}월 ${_selectedDay!.day}일'),
                              Row(
                                children: [
                                  isCheckedEdit
                                      ? IconButton(
                                          onPressed: () async {
                                            print('${DateTime.now()}');
                                            print(_tagController.getTags);
                                            String start =
                                                '${_dateStartTimePicker.hour.toString().padLeft(2, '0')}시 ${_dateStartTimePicker.minute.toString().padLeft(2, '0')} 분';
                                            print('start : $start');
                                            String end =
                                                '${_dateEndTimePicker.hour.toString().padLeft(2, '0')}시 ${_dateEndTimePicker.minute.toString().padLeft(2, '0')}분';
                                            print('end : $end');
                                            print(_getSize());
                                            if (!_formKey.currentState!
                                                .validate()) return;
                                            String? monthStr;
                                            monthStr = _selectedDay!.month > 9
                                                ? '${_selectedDay!.month}'
                                                : '0${_selectedDay!.month}';
                                            String? dateStr;
                                            dateStr = _selectedDay!.day > 9
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
                                                    '$inst_id',
                                                    saveScheduleId,
                                                    _programController.text
                                                        .trim(),
                                                    _tagController.getTags
                                                        .toString(),
                                                    '$start ~ $end',
                                                    '${_selectedDay!.year}$monthStr$dateStr')
                                                : await gql.createScheduledata(
                                                    '$inst_id',
                                                    SCHE_ID,
                                                    _programController.text
                                                        .trim(),
                                                    _tagController.getTags
                                                        .toString(),
                                                    '$start ~ $end',
                                                    '${_selectedDay!.year}$monthStr$dateStr');
                                            {
                                              if (isChecked) {
                                                if (kEvents.containsKey(date)) {
                                                  if (isCheckedAddOrUpdate)
                                                    kEvents[date].removeWhere(
                                                        (event) =>
                                                            event.sche_id ==
                                                            saveScheduleId);
                                                  kEvents[date]!.add(Event(
                                                      _programController.text
                                                          .trim(),
                                                      '$start ~ $end',
                                                      isCheckedAddOrUpdate
                                                          ? saveScheduleId
                                                          : SCHE_ID));
                                                } else {
                                                  kEvents.addAll({
                                                    date: [
                                                      Event(
                                                          _programController
                                                              .text
                                                              .trim(),
                                                          '$start ~ $end',
                                                          SCHE_ID)
                                                    ]
                                                  });
                                                }
                                                setState(() {
                                                  isCheckedEdit =
                                                      !isCheckedEdit;
                                                  if (isCheckedAddOrUpdate)
                                                    isCheckedAddOrUpdate =
                                                        !isCheckedAddOrUpdate;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    '일정이 저장되었습니다.',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ));
                                                // sche_id++;
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    '예기치 못한 오류로 저장이 안되었습니다. 다시 시도해주세요.',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ));
                                              }
                                            }
                                          },
                                          icon: Icon(Icons.save))
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isCheckedEdit = !isCheckedEdit;
                                            });
                                          },
                                          icon: Icon(Icons.add)),
                                ],
                              )
                            ],
                          ),
                    isCheckedEdit
                        ? Column(
                            children: [
                              Center(
                                  child: Text(isCheckedAddOrUpdate
                                      ? '프로그램 수정'
                                      : '프로그램 추가')),
                              Row(
                                children: [
                                  Text('태그 : '),
                                  Expanded(
                                    child: Autocomplete<String>(
                                      optionsViewBuilder:
                                          (context, onSelected, options) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Material(
                                              elevation: 4.0,
                                              child: ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 200),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final dynamic option =
                                                        options
                                                            .elementAt(index);
                                                    return TextButton(
                                                      onPressed: () {
                                                        onSelected(option);
                                                      },
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      15.0),
                                                          child: Text(
                                                            '#$option',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      74,
                                                                      137,
                                                                      92),
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
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<String>.empty();
                                        }
                                        return _pickActivity
                                            .where((String option) {
                                          return option.contains(
                                              textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      onSelected: (String selectedTag) {
                                        _tagController.addTag = selectedTag;
                                      },
                                      fieldViewBuilder: (context, ttec, tfn,
                                          onFieldSubmitted) {
                                        return TextFieldTags(
                                          textEditingController: ttec,
                                          focusNode: tfn,
                                          textfieldTagsController:
                                              _tagController,
                                          initialTags: const [
                                            'OO 복지관',
                                          ],
                                          textSeparators: const [' ', ','],
                                          letterCase: LetterCase.normal,
                                          validator: (String tag) {
                                            if (_tagController.getTags!
                                                .contains(tag)) {
                                              return '이미 등록한 태그 입니다.';
                                            }
                                            return null;
                                          },
                                          inputfieldBuilder: (context, tec, fn,
                                              error, onChanged, onSubmitted) {
                                            return ((context, sc, tags,
                                                onTagDelete) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: TextField(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  controller: tec,
                                                  focusNode: fn,
                                                  decoration: InputDecoration(
                                                    border:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 74, 137, 92),
                                                          width: 3.0),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 74, 137, 92),
                                                          width: 3.0),
                                                    ),
                                                    // helperText: '관련 태그를 입력해주세요',
                                                    helperStyle:
                                                        const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 74, 137, 92),
                                                    ),
                                                    hintText:
                                                        _tagController.hasTags
                                                            ? ''
                                                            : '관련 태그를 입력해주세요',
                                                    errorText: error,
                                                    prefixIconConstraints:
                                                        BoxConstraints(
                                                            maxWidth:
                                                                _distanceToField *
                                                                    0.74),
                                                    prefixIcon: tags.isNotEmpty
                                                        ? SingleChildScrollView(
                                                            controller: sc,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                                children: tags
                                                                    .map((String
                                                                        tag) {
                                                              return Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        20.0),
                                                                  ),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          74,
                                                                          137,
                                                                          92),
                                                                ),
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        10.0),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                    vertical:
                                                                        4.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    InkWell(
                                                                      child:
                                                                          Text(
                                                                        '#$tag',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        //print("$tag selected");
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            4.0),
                                                                    InkWell(
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        size:
                                                                            14.0,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            233,
                                                                            233,
                                                                            233),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        onTagDelete(
                                                                            tag);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList()),
                                                          )
                                                        : null,
                                                  ),
                                                  onChanged: onChanged,
                                                  onSubmitted: onSubmitted,
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
                              Row(
                                children: [
                                  Text('프로그램 시간'),

                                  Stack(children: [
                                    Container(
                                        key: _containerkey,
                                        child: hourMinute5IntervalStart()),
                                    Positioned(
                                        top: 40,
                                        left: 58,
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 30),
                                        ))
                                  ]),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '~',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Stack(
                                    children: [
                                      hourMinute5IntervalEnd(),
                                      Positioned(
                                          top: 40,
                                          left: 58,
                                          child: Text(
                                            ':',
                                            style: TextStyle(fontSize: 30),
                                          ))
                                    ],
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
                                  Text('프로그램 설명 : '),
                                  Expanded(
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '내용을 입력해주세요';
                                          }
                                        },
                                        style: TextStyle(color: Colors.black),
                                        controller: _programController,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        : ValueListenableBuilder<List<Event>>(
                            valueListenable: _selectedEvents!,
                            builder: (context, value, _) {
                              return value.isEmpty
                                  ? const Text('등록된 일정이 없습니다')
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: value.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              saveScheduleId =
                                                  value[index].sche_id;
                                              print('save:${saveScheduleId}');
                                              isCheckedAddOrUpdate =
                                                  !isCheckedAddOrUpdate;

                                              setState(() {
                                                isCheckedEdit = !isCheckedEdit;
                                              });
                                            },
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${value[index].title}',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  '${value[index].time}',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  print('delete');
                                                  showDialog(
                                                      context: context,
                                                      useRootNavigator: false,
                                                      // without this, info.ifRouteChanged(context) dont recognize context change. check page stack
                                                      builder: (BuildContext
                                                          dontext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('삭제하시겠습니까?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  final date = DateTime.utc(
                                                                      _selectedDay!
                                                                          .year,
                                                                      _selectedDay!
                                                                          .month,
                                                                      _selectedDay!
                                                                          .day);
                                                                  gql.deleteScheduledata(
                                                                      "1",
                                                                      value[index]
                                                                          .sche_id);

                                                                  kEvents[date].removeWhere((event) =>
                                                                      event
                                                                          .sche_id ==
                                                                      value[index]
                                                                          .sche_id);

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text('네')),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text('아니요'))
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: Icon(Icons.delete)),
                                          ),
                                        );
                                      },
                                    );
                            },
                          )
                  ],
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
      time: DateTime(2023),
      spacing: 20,
      itemHeight: 40,
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
      time: DateTime(2023),
      spacing: 20,
      itemHeight: 40,
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
