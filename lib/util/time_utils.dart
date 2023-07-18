import 'dart:ui';

import 'package:intl/intl.dart';


extension StringNExtensions on String? {

  /// 是不是空
  bool get isEmptyStr {
    if (this == null) return true;
    if (["", "null", null].contains(this)) {
      return true;
    }
    if (this!.trim() == '') {
      return true;
    }
    return this!.isEmpty;
  }

}

///时间工具类

class TbrTimeUtils {
  /// 字符串转DateTime
  static DateTime formatTimeStr(String timeStr,
      {String? newPattern = "yyyy-MM-dd HH:mm:ss"}) {
    bool patternIsDefault = newPattern == "yyyy-MM-dd HH:mm:ss";
    if (timeStr.isEmptyStr) {
      return DateTime.now();
    }else if (timeStr.length == 4 && patternIsDefault) {
      newPattern = "yyyy";
    }else if (timeStr.length == 5 && patternIsDefault) {
      newPattern = "yyyy-MM";
    }else if (timeStr.length == 10 && patternIsDefault) {
      newPattern = "yyyy-MM-dd";
    }else if (timeStr.length == 13 && patternIsDefault) {
      newPattern = "yyyy-MM-dd HH";
    }else if (timeStr.length == 16 && patternIsDefault) {
      newPattern = "yyyy-MM-dd HH:mm";
    }
    return DateFormat(newPattern).parse(timeStr);
  }

  static String formatTime(DateTime time,
      {String? newPattern = "yyyy-MM-dd HH:mm:ss"}) {
    return DateFormat(newPattern, const Locale('zh').toString()).format(time);
  }

  static DateTime calculationTime(DateTime time,
      {double second = 0,
      double minute = 0,
      double hours = 0,
      double day = 0,
      int month = 0,
      int year = 0}) {
    int milliseconds = 0;
    if (second != 0) {
      milliseconds += (second * 1000).toInt();
    }
    if (minute != 0) {
      milliseconds += (minute * 1000 * 60).toInt();
    }
    if (hours != 0) {
      milliseconds += (hours * 1000 * 60 * 60).toInt();
    }
    if (day != 0) {
      milliseconds += (day * 1000 * 60 * 60 * 24).toInt();
    }
    time = time.add(Duration(milliseconds: milliseconds));
    return time;
  }

  ///获取倒计时时间
  static String leftTimeStr(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int day = (duration.inSeconds ~/ 3600) ~/ 24;
    int hour = (duration.inSeconds ~/ 3600) % 24;
    int minute = duration.inSeconds % 3600 ~/ 60;
    // 如果用到秒的话计算
    int second = duration.inSeconds % 60;
    if (day > 0) {
      return "$day天$hour小时";
    } else if (hour > 0) {
      return "$hour小时$minute分钟";
    } else if (minute > 0) {
      return "$minute分钟$second秒";
    }
    return "$second秒";
  }

  ///获取现在的时间
  static int getDayNow() {
    var nowTime = DateTime.now();
    return nowTime.millisecondsSinceEpoch;
  }

  ///获取今天的开始时间
  static int getDayBegin() {
    var nowTime = DateTime.now();
    var day = DateTime(nowTime.year, nowTime.month, nowTime.day, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  ///获取昨天的开始时间
  static int getBeginDayOfYesterday() {
    var nowTime = DateTime.now();
    var yesterday = nowTime.add(const Duration(days: -1));
    var day = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  ///获取昨天的结束时间
  static int getEndDayOfYesterday() {
    var nowTime = DateTime.now();
    var yesterday = nowTime.add(const Duration(days: -1));
    var day =
        DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
    return day.millisecondsSinceEpoch;
  }

  ///获取本周的开始时间
  static int getBeginDayOfWeek() {
    var nowTime = DateTime.now();
    var weekday = nowTime.weekday;
    var yesterday = nowTime.add(Duration(days: -(weekday - 1)));
    var day = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  ///获取本月的开始时间
  static int getBeginDayOfMonth() {
    var nowTime = DateTime.now();
    var day = DateTime(nowTime.year, nowTime.month, 1, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  ///获取本年的开始时间
  static int getBeginDayOfYear() {
    var nowTime = DateTime.now();
    var day = DateTime(nowTime.year, 1, 1, 0, 0, 0);
    return day.millisecondsSinceEpoch;
  }

  /// 传入秒数获取对应格式时间文本
  ///
  /// @len - 需要转换的时间 单位 /s
  ///
  /// @format : 格式
  static String getFormat(int len, {String format = 'MMSS'}) {
    if (format == 'MMSS') {
      //xx:xx
      return '${len ~/ 600}${(len ~/ 60) % 10}:${(len % 60) ~/ 10}${len % 10}';
    } else {
      return '';
    }
  }

  /// 时间戳转换为对应格式文本
  ///
  /// @milliseconds - 要转换的时间戳
  ///
  /// @isTenType - 是否为十位时间戳，默认后端给的都是十位需要补齐13位
  ///
  /// @format : 格式
  static String millisecondsForDate(
    int milliseconds, {
    String format = 'yy-mm-dd',
    bool isTenType = true,
  }) {
    // 时间戳是否为十位-补足十三位
    if (isTenType) {
      milliseconds *= 1000;
    }
    // 转换为DateTime类型
    DateTime time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    // 根据需求返回对应格式时间文本
    if (format == 'yy-mm-dd-hh-mm-ss') {
      //年-月-日-时-分-秒
      return '${time.year}年${time.month}月${time.day}日 ${time.hour}:${time.minute}:${time.second}秒';
    } else if (format == 'yy-mm-dd') {
      //年-月-日
      return '${time.year}年${time.month}月${time.day}日';
    } else if (format == 'yy-mm') {
      //年-月
      return '${time.year}年${time.month}月';
    } else if (format == 'yy') {
      //年
      return '${time.year}年';
    } else if (format == 'mm-dd') {
      //月-日
      return '${time.month}月${time.day}日';
    } else if (format == 'record') {
      //记录类型
      if (time.year == DateTime.now().year) {
        //今年的消息-不显示年份
        return '${time.month}月${time.day}日  ${time.hour >= 10 ? time.hour : '0${time.hour}'}:${time.minute >= 10 ? time.minute : '0${time.minute}'}';
      } else {
        return '${time.year}年${time.month}月${time.day}日  ${time.hour >= 10 ? time.hour : '0${time.hour}'}:${time.minute >= 10 ? time.minute : '0${time.minute}'}';
      }
    } else if (format == 'duration') {
      //时长类型
      int hour = milliseconds ~/ 3600;
      String hourTime;
      int minute = (milliseconds % 3600) ~/ 60;
      String minuteTime;
      int second = milliseconds % 60;
      String secondTime;

      if (hour == 0) {
        hourTime = '00';
      } else if (hour < 10) {
        hourTime = '0$hour';
      } else {
        hourTime = hour.toString();
      }

      if (minute == 0) {
        minuteTime = '00';
      } else if (minute < 10) {
        minuteTime = '0$minute';
      } else {
        minuteTime = minute.toString();
      }

      if (second == 0) {
        secondTime = '00';
      } else if (second < 10) {
        secondTime = '0$second';
      } else {
        secondTime = second.toString();
      }

      return hourTime + ':' + minuteTime + ':' + secondTime;
    } else if (format == 'info') {
      //消息类型-根据当前时间计算出该时间距今已过去多久-x分钟前-x小时前-x天前
      //获取时间差-
      Duration now = DateTime.now().difference(time);
      if (now.inDays > 30) {
        return '${now.inDays ~/ 30}个月前';
      } else if (now.inHours > 24) {
        return '${now.inHours ~/ 24}天前';
      } else if (now.inMinutes > 60) {
        return '${now.inMinutes ~/ 60}小时前';
      } else if (now.inSeconds > 60) {
        return '${now.inSeconds ~/ 60}分钟前';
      } else {
        return '刚刚';
      }
    } else {
      return '';
    }
  }

  /// 日期转时间戳
  static int dateToTimestamp(String date, {isMicroseconds = false}) {
    DateTime dateTime = DateTime.parse(date);
    int timestamp = dateTime.millisecondsSinceEpoch;
    if (isMicroseconds) {
      timestamp = dateTime.microsecondsSinceEpoch;
    }
    return timestamp;
  }

  /// 时间戳转时间格式
  static DateTime timestampToDate(int timestamp) {
    DateTime dateTime = DateTime.now();

    ///如果是十三位时间戳返回这个
    if (timestamp.toString().length == 13) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp.toString().length == 16) {
      ///如果是十六位时间戳
      dateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    }
    return dateTime;
  }

  ///时间戳转日期
  ///[timestamp] 时间戳
  ///[onlyNeedDate ] 是否只显示日期 舍去时间
  static String timestampToDateStr(int timestamp, {onlyNeedDate = false}) {
    DateTime dataTime = timestampToDate(timestamp);
    String dateTime = dataTime.toString();

    ///去掉时间后面的.000
    dateTime = dateTime.substring(0, dateTime.length - 4);
    if (onlyNeedDate) {
      List<String> dataList = dateTime.split(" ");
      dateTime = dataList[0];
    }
    return dateTime;
  }

  /// 将传进来的 时间戳/日期格式 转成 DateTime 格式
  static DateTime _changeTimeDate(time) {
    ///如果传进来的是字符串 13/16位 而且不包含-
    DateTime dateTime = DateTime.now();
    if (time is String) {
      if ((time.length == 13 || time.length == 16) && !time.contains("-")) {
        dateTime = timestampToDate(int.parse(time));
      } else {
        dateTime = DateTime.parse(time);
      }
    } else if (time is int) {
      dateTime = timestampToDate(time);
    }
    return dateTime;
  }

  ///判断日期是不是在这个期间
  ///[startData] 开始时间 格式可以是 字符串或者时间戳
  /// [endData] 结束时间 格式可以是 字符串或者时间戳
  ///[days] 间隔几天,可以不传入结束时间依靠间隔天数来判断是否在期限内
  static bool checkDateDuring({required startData, endData, days = 1}) {
    if (startData.toString().isEmptyStr) {
      return false;
    }

    ///当前时间
    DateTime nowDate = DateTime.now();

    ///开始时间
    DateTime startDate = _changeTimeDate(startData);

    ///结束时间
    DateTime endDate = endData.toString().isEmptyStr
        ? _changeTimeDate(endData)
        : startDate.add(Duration(days: days));

    ///如果在开始时间以后结束时间以前
    return nowDate.isAfter(startDate) && nowDate.isBefore(endDate);
  }

  ///检测时间距离当前是今天 昨天 前天还是某个日期 跨年显示 年-月-日 不跨年显示 月-日
  static String getDateScope({required checkDate}) {
    String temp = DateTime.now().toString();
    List listTemp = temp.split(" ");
    temp = listTemp[0];
    DateTime nowTime = DateTime.parse(temp);
    DateTime checkTime = _changeTimeDate(checkDate);

    Duration diff = checkTime.difference(nowTime);

    ///如果不同年 返回 年-月-日 小时:分钟 不显示秒及其.000
    if (checkTime.year != nowTime.year) {
      return checkTime.toString().substring(0, checkTime.toString().length - 7);
    }

    /// 同年判断是不是前天/昨天/今天/
    if ((diff < const Duration(hours: 24)) &&
        (diff > const Duration(hours: 0))) {
      return "今天 ${dataNum(checkTime.hour)}:${dataNum(checkTime.minute)}";
    } else if ((diff < const Duration(hours: 0)) &&
        (diff > const Duration(hours: -24))) {
      return "昨天 ${dataNum(checkTime.hour)}:${dataNum(checkTime.minute)}";
    } else if (diff < const Duration(hours: -24) &&
        diff > const Duration(hours: -48)) {
      return "前天 ${dataNum(checkTime.hour)}:${dataNum(checkTime.minute)}";
    }

    ///如果剩下都不是就返回 月-日 然后时间
    return checkTime.toString().substring(5, checkTime.toString().length - 7);
  }

  static String dataNum(numb) {
    if (numb < 10) {
      return "0$numb";
    }
    return numb.toString();
  }

  static String weekDayStr(DateTime time) {
    switch (time.weekday) {
      case 1:
        return "一";
      case 2:
        return "二";
      case 3:
        return "三";
      case 4:
        return "四";
      case 5:
        return "五";
      case 6:
        return "六";
      case 7:
        return "日";
    }
    return "";
  }

}
