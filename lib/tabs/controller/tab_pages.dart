import 'package:flutter/material.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/tabs/controller/bottom_navigation.dart';
import 'package:psalms/tabs/controller/for_route.dart';
import 'package:psalms/tabs/tab1/chapter_list.dart';
import 'package:psalms/tabs/tab2/letter_list.dart';
import 'package:psalms/tabs/tab3/theme_list.dart';
import 'package:psalms/tabs/tab4/name_list.dart';
import 'package:psalms/tabs/tab5/other.dart';

class TabPages extends StatelessWidget {
  final String title;
  final ValueChanged<ForRoute> onPush;
  final TabItem tabItem;
  final RouteBox routeBox;

  TabPages({this.title, this.onPush, this.tabItem, this.routeBox});

  Widget widgetTab;

  @override
  Widget build(BuildContext context) {
    switch (tabItem) {
      case TabItem.chapter:
        {
          widgetTab = ChapterList(
            routeBox: routeBox,
          );
        }
        break;
      case TabItem.words:
        {
          widgetTab = LetterList(
            routeBox: routeBox,
          );
        }
        break;
      case TabItem.theme:
        {
          widgetTab = ThemeList(
            routeBox: routeBox,
          );
        }
        break;
      case TabItem.other:
        {
          widgetTab = Other(
            routeBox: routeBox,
          );
        }
        break;
      default:
        {
          widgetTab = ChapterList(
            routeBox: routeBox,
          );
        }
        break;
    }
    return Scaffold(body: widgetTab);
  }
}
