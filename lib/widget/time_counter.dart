import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tomato_work/theme/color.dart';

/// 负责处理番茄工作法的计时功能
class TimeCounter extends StatefulWidget {
  TimeCounterController controller;

  TimeCounter(this.controller);

  @override
  State<StatefulWidget> createState() {
    return controller;
  }
}

class TimeCounterController extends State<TimeCounter> {
  static final int statusNotStart = 0;
  static final int statusWorking = 1;
  static final int statusRest = 2;

  /// 一个番茄时间,分钟
  int tomatoDuration;

  /// 休息时间，分钟
  int restDuration;

  /// 一次番茄时间结束
  OnWorkFinishCallback onWorkFinishCallback;

  /// 一次休息时间结束
  OnRestFinishCallback onRestFinishCallback;

  OnWorkInvalidCallback onWorkInvalidCallback;

  OnRestStartCallback onRestStartCallback;

  OnWorkStartCallback onWorkStartCallback;

  int _status = statusNotStart;

  String _statusShowStr = "未开始";

  DateTime _curTime;

  Duration _duration = Duration(seconds: -1);

  Timer _timer;

  ///倒计时显示的字符串
  String showTime;

  /// 背景色
  Color backgroundColor = BaseColor.green65C6A6;

  TimeCounterController({
    this.tomatoDuration = 25,
    this.restDuration = 5,
    this.onRestFinishCallback,
    this.onWorkFinishCallback,
    this.onWorkInvalidCallback,
    this.onRestStartCallback,
    this.onWorkStartCallback
  }) {
    if (tomatoDuration < 0 || restDuration < 0) {
      throw "tomatoDuration or restDuration can not small than zero";
    }
    _curTime = DateTime.parse("2012-12-12 00:00:00");
    _curTime = _curTime.add(Duration(minutes: tomatoDuration));
    showTime = getTimeStr();
  }

  ///开始计时,[needTime]是需要倒计时的时间，分钟计算
  void _startCount(int needTime, CountFinishCallback callback) {
    //首先重置当前时间
    _curTime = DateTime.parse("2012-12-12 00:00:00");
    _curTime = _curTime.add(Duration(minutes: needTime));

    var duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (timer) {
      _curTime = _curTime.add(_duration);
      showTime = getTimeStr();
      print(showTime);
      if (showTime == "00:00") {
        callback();
        timer.cancel();
      }
      setState(() {});
    });
  }

  void _reset() {
    _curTime = DateTime.parse("2012-12-12 00:00:00");
    _curTime = _curTime.add(Duration(minutes: tomatoDuration));
    showTime = getTimeStr();
  }

  void _switchStatus(int status) {
    setState(() {
      _status = status;
      if (_status == statusNotStart) {
        backgroundColor = BaseColor.green65C6A6;
        _statusShowStr = "未开始";
      } else if (_status == statusWorking) {
        backgroundColor = BaseColor.redD98080;
        _statusShowStr = "进行中";
      } else {
        backgroundColor = BaseColor.green65C6A6;
        _statusShowStr = "休息中";
      }
    });
  }

  //开始进入休息时间
  void _startRest() {
    _switchStatus(statusRest);
    if(onRestStartCallback != null){
      onRestStartCallback();
    }
    print("开始进行休息区间计时");
    _startCount(restDuration, () {
      if (onRestFinishCallback != null) {
        onRestFinishCallback();
      }
      start();
    });
  }

  void start() {
    _switchStatus(statusWorking);
    if(onWorkStartCallback != null){
      onWorkStartCallback();
    }
    _startCount(tomatoDuration, () {
      if (onWorkFinishCallback != null) {
        onWorkFinishCallback();
      }
      _startRest();
    });
  }

  void cancel() {
    print("call cancel");
    _reset();
    _switchStatus(statusNotStart);
    if (_timer != null) {
      _timer.cancel();
    }
    setState(() {});
  }

  /// 获取当前倒计时的时间
  String getTimeStr() {
    return '${_curTime.minute.toString().padLeft(2, '0')}:${_curTime.second.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          print("on long press");
          if (_status == statusNotStart) {
            start();
          } else if (_status == statusWorking) {
            if (onWorkInvalidCallback != null) {
              onWorkInvalidCallback();
            }
            cancel();
          } else {
            cancel();
          }
        },
        child: ClipOval(
            child: Container(
          width: 190,
          height: 190,
          decoration: BoxDecoration(color: backgroundColor),
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(showTime,
                    style: TextStyle(color: BaseColor.white, fontSize: 36)),
              ),
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 90),
                      child: Text(
                        _statusShowStr,
                        style: TextStyle(color: BaseColor.white),
                      ))),
            ],
          ),
        )));
  }
}

typedef CountFinishCallback = void Function();

///一次工作结束
typedef OnWorkFinishCallback = void Function();

/// 一次休息结束
typedef OnRestFinishCallback = void Function();

/// 一次番茄工作被废弃
typedef OnWorkInvalidCallback = void Function();

/// 一次番茄工作开始
typedef OnWorkStartCallback = void Function();

/// 一次休息开始
typedef OnRestStartCallback = void Function();
