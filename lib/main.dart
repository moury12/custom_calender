import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Calculate the minimum and maximum allowed months
  // DateTime get _minDate => DateTime(_focusedDay.year, _focusedDay.month - 6);
  // DateTime get _maxDate => DateTime(_focusedDay.year, _focusedDay.month + 6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Table'),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildDaysOfWeek(),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String formattedMonth = DateFormat.yMMMM().format(_focusedDay); // e.g. September 2024
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Disable the back button if the user is at the minimum date
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: /*_focusedDay.isAfter(_minDate)
                ?*/ () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
              });
            }
              /*  : null,*/
          ),
          Text(
            formattedMonth,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // Disable the forward button if the user is at the maximum date
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: _focusedDay.isBefore(DateTime(DateTime.now().year, DateTime.now().month + 6))
                ? () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
              });
            }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: daysOfWeek
            .map((day) => Expanded(
          child: Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.bold))),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildCalendar() {
    final int daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final int firstWeekdayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1).weekday;

    List<Widget> rows = [];
    List<Widget> daysRow = [];

    // Fill empty cells for the first row before the first day of the month
    for (int i = 1; i < firstWeekdayOfMonth; i++) {
      daysRow.add(Expanded(child: Container()));
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      if (daysRow.length == 7) {
        rows.add(Row(children: daysRow));
        daysRow = [];
      }

      final currentDay = DateTime(_focusedDay.year, _focusedDay.month, day);
      daysRow.add(Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = currentDay;
            });
          },
          child: Container(
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: _isSameDay(currentDay, _selectedDay) ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: _isSameDay(currentDay, _selectedDay) ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ));
    }

    // Fill remaining empty cells for the last row
    while (daysRow.length < 7) {
      daysRow.add(Expanded(child: Container()));
    }
    rows.add(Row(children: daysRow));

    return Expanded(
      child: Column(
        children: rows,
      ),
    );
  }

  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
}
