import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Const {
  static const String launchQRString = 'https://abejapos.com/';

  static const String requestUrl =
      'http://5.189.153.175:2706/service/dicts/menu?idDepartment=3&digitalMenu=1';
  static const String MACADDR = '0C:98:38:FA:9F:FD';
  static const String IND = '2';

  static const Color primaryColor = Colors.deepPurple;
  static const Color activeColor = Colors.black;
  static const Color appBackgroundColor = Colors.white;
  static const Color appBarTextColor = Colors.black;
  static const Color normalColor = Colors.black45;
  static const Color scanButton = Color(0xFFB74093);
  static const Color scanColor = Colors.white;
  static const Color indicatorColor = Colors.blue;
  static const Color indicatorBottomColor = Colors.blueGrey;
  static const Color menuCardTextColor = Colors.white;

  static const Color subMenuCardBackColor = Colors.white;
  static const Color subMenuCardTextColor = Colors.black;

  static const Color cardTextColor = Colors.black;
  static const Color cardSubTextColor = Colors.black45;

  static const Color dividerColor = Colors.black45;

  static const Color cardDetailBackground = Colors.white;

  static const double menuListCardRadius = 10.0;
  static const double menuCategoryHeight = 90.0;

  static const String menuFontName = "CirceRounded-Regular";
  static const String menuListFontName = "HelveticaNeue-Regular";

  static const String menuImageUrl =
      "http://5.189.153.175:2706/service/dicts/screenMenuCategory/image?path=";
  static const String itemImageUrl =
      "http://5.189.153.175:2706/service/dicts/screenMenuItem/image?path=";

  static String removeIfNull(dynamic element) {
    if (element != null) {
      return element.toString();
    } else {
      return "";
    }
  }

  static String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  static Route<Object> customRoute(buildContext) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: buildContext,
      );
    } else {
      return MaterialPageRoute(
        builder: buildContext,
      );
    }
  }
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xff2980b9),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);
