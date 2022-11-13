import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Utils.dart';
import 'package:intl/intl.dart';

class TimeSetting extends StatefulWidget {
  const TimeSetting({super.key, required this.title});

  final String title;

  @override
  State<TimeSetting> createState() => _TimeSettingState();
}

class _TimeSettingState extends State<TimeSetting> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildDatePicker(),
          TextButton(
              onPressed: (){
                final value = DateFormat('HH:mm').format(dateTime);
                Utils.showSnackBar(context, '알람 시간 $value');
                Navigator.pop(context);
              }, child: const Text('완료')
          ),
        ],
      ),
    ),
  );

  Widget buildDatePicker() => SizedBox(
    height: 180,
    child: CupertinoDatePicker(
      initialDateTime: dateTime,
      mode: CupertinoDatePickerMode.time,
      minuteInterval: 1,
      //use24hFormat: true,
      onDateTimeChanged: (dateTime) =>
          setState(() => this.dateTime = dateTime),
    ),
  );

  DateTime getDateTime() {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day, now.hour, 0);
  }
}