import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class UserActivityPage extends StatefulWidget {
  UserActivityPage({Key? key}) : super(key: key);

  @override
  State<UserActivityPage> createState() => _UserActivityPageState();
}

class _UserActivityPageState extends State<UserActivityPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이용자 활동 기록'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 3, 14),
              locale: 'ko-KR',
              focusedDay: DateTime.now(),
              daysOfWeekHeight: 30,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                });
              },
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
          ],
        ),
      ),
    );
  }
}
