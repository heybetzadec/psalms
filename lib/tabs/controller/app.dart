import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:psalms/help/event_key.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/tabs/controller/bottom_navigation.dart';
import 'package:psalms/tabs/controller/tab_navigator.dart';
import 'package:sqflite/sqflite.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();

  static void setOptionChange(BuildContext context, double fontSize) async {
    AppState state = context.findAncestorStateOfType<AppState>();
    state.optionChangeSize(fontSize);
  }
}

class AppState extends State<App> {
  TabItem _currentTab = TabItem.chapter;
  EventBus _eventBus = new EventBus();
  RouteBox _routeBox;
  double _fontSize = 16;

  optionChangeSize(double fontSize) {
    setState(() {
      _fontSize = fontSize;
    });
  }

  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.chapter: GlobalKey<NavigatorState>(),
    TabItem.words: GlobalKey<NavigatorState>(),
    TabItem.theme: GlobalKey<NavigatorState>(),
    TabItem.names: GlobalKey<NavigatorState>(),
    TabItem.other: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    var dbf = getDatabase();
    _routeBox = new RouteBox(
        eventBus: _eventBus,
        dbf: dbf,
        languageId: 1,
        fontSize: _fontSize,
    );
    super.initState();
  }

  void _selectTab(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.chapter:
        {
          _eventBus.fire(ChapterClickEvent('event'));
        }
        break;
      case TabItem.words:
        {
          _eventBus.fire(LetterClickEvent('event'));
        }
        break;
      case TabItem.theme:
        {
          _eventBus.fire(ThemeClickEvent('event'));
        }
        break;
      case TabItem.names:
        {
          _eventBus.fire(NameClickEvent('event'));
        }
        break;
      case TabItem.other:
        {
          _eventBus.fire(OtherClickEvent('event'));
        }
        break;
      default:
        {
          _eventBus.fire(ChapterClickEvent('event'));
        }
        break;
    }

    if (tabItem == _currentTab) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.chapter) {
            // select 'main' tab
            _selectTab(TabItem.chapter);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.chapter),
          _buildOffstageNavigator(TabItem.words),
          _buildOffstageNavigator(TabItem.theme),
          _buildOffstageNavigator(TabItem.names),
          _buildOffstageNavigator(TabItem.other),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
          routeBox: _routeBox,
        ),
      ),
    );
  }

  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "phalms_data.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "phalms_data.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    var db = await openDatabase(path, readOnly: true);
//    db.execute('PRAGMA encoding = "UTF-8";');

    return db;
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        routeBox: _routeBox,
        tabItem: tabItem,
      ),
    );
  }
}
