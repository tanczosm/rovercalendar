// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime kFirstDay = DateTime(1970, 1, 1);
DateTime kLastDay = DateTime(2100, 1, 1);

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59);
}

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isSameMonth(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month;
}

class RoverCalendar extends StatefulWidget {
  const RoverCalendar({
    Key? key,
    required this.color,
    required this.onChange,
    this.initialDate,
    this.weekFormat = false,
    this.weekStartsMonday = false,
    this.iconColor,
    this.rowHeight,
    this.locale,
    this.width,
    this.height,
  }) : super(key: key);

  final bool weekFormat;
  final bool weekStartsMonday;
  final Color color;
  final Future<dynamic> Function() onChange;
  final DateTime? initialDate;
  final Color? iconColor;
  final double? rowHeight;
  final String? locale;
  final double? width;
  final double? height;

  @override
  State<StatefulWidget> createState() => _RoverCalendarState();
}

class _RoverCalendarState extends State<RoverCalendar> {
  late DateTime focusedDay;
  late DateTime selectedDay;
  late bool weekFormat;
  late DateTimeRange selectedRange;
  late TextStyle? dateStyle;
  late TextStyle? dayOfWeekStyle;
  late TextStyle? inactiveDateStyle;
  late TextStyle? selectedDateStyle;
  late TextStyle? titleStyle;

  @override
  void initState() {
    super.initState();
    weekFormat = widget.weekFormat;
    focusedDay = widget.initialDate ?? DateTime.now();
    selectedDay = widget.initialDate ?? DateTime.now();
    selectedRange = DateTimeRange(
      start: selectedDay.startOfDay,
      end: selectedDay.endOfDay,
    );
    SchedulerBinding.instance
        .addPostFrameCallback((_) => setSelectedDay(selectedRange.start));
  }

  CalendarFormat get calendarFormat =>
      weekFormat ? CalendarFormat.week : CalendarFormat.month;

   StartingDayOfWeek get startingDayOfWeek => widget.weekStartsMonday
      ? StartingDayOfWeek.monday
      : StartingDayOfWeek.sunday;

  Color get color => widget.color;

  Color get lightColor => widget.color.withOpacity(0.85);

  Color get lighterColor => widget.color.withOpacity(0.60);

  void setSelectedDay(
    DateTime? newSelectedDay, [
    DateTime? newSelectedEnd,
  ]) {
    final newRange = newSelectedDay == null
        ? null
        : DateTimeRange(
            start: newSelectedDay.startOfDay,
            end: newSelectedEnd ?? newSelectedDay.endOfDay,
          );
    setState(() {
      selectedDay = newSelectedDay ?? selectedDay;
      selectedRange = newRange ?? selectedRange;
      if (widget.onChange != null) {
        // todo: assign newRange to FFState variable
        widget.onChange();
      }
    });
  }

  void toggleFormat() {
    weekFormat = !weekFormat;
  }

  @override
  Widget build(BuildContext context) {
    dateStyle = FlutterFlowTheme.of(context).bodyText1;
    dayOfWeekStyle = FlutterFlowTheme.of(context).bodyText1;
    inactiveDateStyle = FlutterFlowTheme.of(context).bodyText1;
    selectedDateStyle = FlutterFlowTheme.of(context).bodyText1;
    titleStyle = FlutterFlowTheme.of(context).bodyText1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CalendarHeader(
          focusedDay: focusedDay,
          onMonthTap: () => setState( toggleFormat ),
          onLeftChevronTap: () => setState(
            () => focusedDay = widget.weekFormat
                ? _previousWeek(focusedDay)
                : _previousMonth(focusedDay),
          ),
          onRightChevronTap: () => setState(
            () => focusedDay = widget.weekFormat
                ? _nextWeek(focusedDay)
                : _nextMonth(focusedDay),
          ),
          onTodayButtonTap: () => setState(() => focusedDay = DateTime.now()),
          titleStyle: titleStyle,
          iconColor: widget.iconColor,
          locale: widget.locale,
        ),
        TableCalendar(
          focusedDay: focusedDay,
          selectedDayPredicate: (date) => isSameDay(selectedDay, date),
          firstDay: kFirstDay,
          lastDay: kLastDay,
          calendarFormat: calendarFormat,
          headerVisible: false,
          locale: widget.locale,
          rowHeight: widget.rowHeight ?? MediaQuery.of(context).size.width / 7,
          calendarStyle: CalendarStyle(
            defaultTextStyle:
                dateStyle ?? const TextStyle(color: Color(0xFF5A5A5A)),
            weekendTextStyle:
                dateStyle ?? const TextStyle(color: const Color(0xFF5A5A5A)),
            holidayTextStyle:
                dateStyle ?? const TextStyle(color: const Color(0xFF5C6BC0)),
            selectedTextStyle:
                const TextStyle(color: Color(0xFFFAFAFA), fontSize: 16.0)
                    .merge(selectedDateStyle),
            todayTextStyle:
                const TextStyle(color: Color(0xFFFAFAFA), fontSize: 16.0)
                    .merge(selectedDateStyle),
            outsideTextStyle: const TextStyle(color: Color(0xFF9E9E9E))
                .merge(inactiveDateStyle),
            selectedDecoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: lighterColor,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: lightColor,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 3,
            canMarkersOverflow: true,
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          startingDayOfWeek: startingDayOfWeek,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle:
                const TextStyle(color: Color(0xFF616161)).merge(dayOfWeekStyle),
            weekendStyle:
                const TextStyle(color: Color(0xFF616161)).merge(dayOfWeekStyle),
          ),
          onDaySelected: (newSelectedDay, _) {
            if (!isSameDay(selectedDay, newSelectedDay)) {
              setSelectedDay(newSelectedDay);
              if (!isSameMonth(focusedDay, newSelectedDay)) {
                setState(() => focusedDay = newSelectedDay);
              }
            }
          },
        ),
      ],
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onMonthTap,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    required this.onTodayButtonTap,
    this.iconColor,
    this.titleStyle,
    this.locale,
  }) : super(key: key);

  final DateTime focusedDay;
  final VoidCallback onMonthTap;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onTodayButtonTap;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final String? locale;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(),
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: InkWell(
                  child: Text(
                  DateFormat.yMMMM(locale).format(focusedDay),
                  style: const TextStyle(fontSize: 17).merge(titleStyle),
                  ),
                  onTap: onMonthTap
                ),
            ),
            CustomIconButton(
              icon: Icon(Icons.calendar_today, color: iconColor),
              onTap: onTodayButtonTap,
            ),
            CustomIconButton(
              icon: Icon(Icons.chevron_left, color: iconColor),
              onTap: onLeftChevronTap,
            ),
            CustomIconButton(
              icon: Icon(Icons.chevron_right, color: iconColor),
              onTap: onRightChevronTap,
            ),
          ],
        ),
      );
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    this.padding = const EdgeInsets.all(10),
  }) : super(key: key);

  final Icon icon;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: padding,
            child: Icon(
              icon.icon,
              color: icon.color,
              size: icon.size,
            ),
          ),
        ),
      );
}

DateTime _previousWeek(DateTime week) {
  return week.subtract(const Duration(days: 7));
}

DateTime _nextWeek(DateTime week) {
  return week.add(const Duration(days: 7));
}

DateTime _previousMonth(DateTime month) {
  if (month.month == 1) {
    return DateTime(month.year - 1, 12);
  } else {
    return DateTime(month.year, month.month - 1);
  }
}

DateTime _nextMonth(DateTime month) {
  if (month.month == 12) {
    return DateTime(month.year + 1, 1);
  } else {
    return DateTime(month.year, month.month + 1);
  }
}
