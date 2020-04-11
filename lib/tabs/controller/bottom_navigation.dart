import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/help/translations.dart';

enum TabItem { chapter, words, theme, names, other }

Map<TabItem, String> tabName = {
  TabItem.chapter: 'Surələr',
  TabItem.words: 'Words',
  TabItem.theme: 'Theme',
  TabItem.names: 'Names',
  TabItem.other: 'Other',
};

Map<TabItem, IconData> tabIcons = {
  TabItem.chapter: FontAwesomeIcons.bookOpen,
  TabItem.words: FontAwesomeIcons.tag,
  TabItem.theme: FontAwesomeIcons.inbox,
  TabItem.names: FontAwesomeIcons.key,
  TabItem.other: FontAwesomeIcons.cog,
};

class BottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final RouteBox routeBox;

  const BottomNavigation({
    Key key,
    this.currentTab,
    this.onSelectTab,
    this.routeBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    tabName = {
      TabItem.chapter: Translations.of(context).text("psalms"),
      TabItem.words: Translations.of(context).text("word"),
      TabItem.theme: Translations.of(context).text("theme"),
      TabItem.names: Translations.of(context).text("doc"),
      TabItem.other: Translations.of(context).text("other"),
    };

    return BottomNavigationBar(
      showSelectedLabels: true,
      selectedFontSize: 13,
      unselectedFontSize: 13,
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.chapter),
        _buildItem(tabItem: TabItem.words),
        _buildItem(tabItem: TabItem.theme),
        _buildItem(tabItem: TabItem.names),
        _buildItem(tabItem: TabItem.other),
      ],
      onTap: (index) {
        onSelectTab(
          TabItem.values[index],
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String text = tabName[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        tabIcons[tabItem],
        color: _colorTabMatching(item: tabItem),
      ),
      title: Padding(padding: EdgeInsets.only(
        top: 3,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
      )
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? Colors.teal : Colors.black54;
  }
}
