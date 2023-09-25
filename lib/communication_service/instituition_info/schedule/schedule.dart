import 'dart:collection';

import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/schedule/TableCalendarUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';

//
// class Event {
//   // final DateTime date;
//   String title;
//
//   Event({required this.title});
// }

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final gql = GraphQLController.Obj;
  bool loading = true;
  late var month ; // for DropdownDatePicker
  late var year ; // for DropdownDatePicker

  late final ValueNotifier<List<Event>> _selectedEvents;
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

  @override
  void initState() {
    super.initState();
    month = _focusedDay.month;
    year = _focusedDay.year;
    _selectedDay = _focusedDay;  String? monthStr;
    monthStr = _selectedDay!.month > 9
        ? '${_selectedDay!.month}'
        : '0${_selectedDay!.month}';
    gql.queryInstitutionScheduleByInstitutionId("1",  '${_selectedDay!.year}${monthStr}00').then((result) {

      // gql.queryInstitutionScheduleByInstitutionId("1").then((result) {
      print(result);
      result.forEach((value) {
        // print("${value.id}");
        int year = int.parse(value.DATE.substring(0, 4));
        int month = int.parse(value.DATE.substring(4, 6));
        int day = int.parse(value.DATE.substring(6, 8));
        final date = DateTime.utc(year, month, day);
        if (event.containsKey(date)) {
          event[date]!.add(Event(value.CONTENT,value.TIME,value.SCHEDULE_ID));
        } else {
          event.addAll({
            date: [Event(value.CONTENT,value.TIME,value.SCHEDULE_ID)]
          });
        }
      });

      kEvents = LinkedHashMap<DateTime, List<Event>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(event);
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

      setState(() {

        loading = false;
      });
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
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

      _selectedEvents.value = _getEventsForDay(selectedDay);
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
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

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
    return loading
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
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
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
                    rowHeight: MediaQuery.of(context).size.height/17,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
                      markerMargin: const EdgeInsets.symmetric(horizontal: 0.3),
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
                  _selectedDay == null ? const SizedBox(): Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Text('${_selectedDay!.year}년 ${_selectedDay!.month}월 ${_selectedDay!.day}일 '),
                      Row(
                        children: [
                          Icon(Icons.add),
                        ],
                      )
                    ],
                  ),
                  ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return value.length== 0 ?
                      Text('등록된 강의가 없습니다') : ListView.builder(
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
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => print('${value[index]}'),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${value[index].title}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    '${value[index].time}',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              trailing: IconButton(onPressed: (){
                                print('delete');
                              }, icon: Icon(Icons.delete)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
          ),
        );
  }
}
