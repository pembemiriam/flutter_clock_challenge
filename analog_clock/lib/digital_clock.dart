// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.black,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  String _time;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = 50.0;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontSize: fontSize,

    );

    if (int.parse(hour) <= 12){
      _time = 'morning';

    }else if(int.parse(hour) >= 16){
      _time = 'evening';

    }else
      _time = 'afternoon';

    return DefaultTextStyle(
      style: defaultStyle,
      child: Stack(
        children: <Widget>[

          Positioned(left: 80, bottom: 50, child:
          Row(
            children: <Widget>[
              Text(hour),
              Text(':'),
              Text(minute,
              style: TextStyle(color: Colors.yellow[500]),),
              Text(_time == 'morning'? 'am':'pm' ),
            ],
          )
         ),
          Positioned(
            left: 80,
            bottom: 30,
            child: RichText(
              text: TextSpan(
                text: 'Hey, its ',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                children: <TextSpan>[
                  TextSpan(text: _time,
                  style: TextStyle(color: Colors.yellow[500])),
                  TextSpan(
                    text: '...'
                  )
                ]
              ),



            )
          )
        ],
      ),
    );
  }
}
