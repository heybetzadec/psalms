import 'package:flutter/material.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/const.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/help/translations.dart';
import 'package:psalms/tabs/tab3/verses_by_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterByTheme extends StatefulWidget {
  final RouteBox routeBox;
  final int themeId;

  ChapterByTheme({Key key, this.routeBox, this.themeId}) : super(key: key);

  @override
  _ChapterByThemeState createState() => _ChapterByThemeState(routeBox, themeId);
}

class _ChapterByThemeState extends State<ChapterByTheme> {
  final RouteBox routeBox;
  final int themeId;

  double _fontSize = 18;
  var _dataList = new List<Map<String, dynamic>>();
  
  _ChapterByThemeState(this.routeBox, this.themeId);


  @override
  void initState() {
    getSharedData();
    routeBox.dbf.then((db) {
      db
          .rawQuery(
              "SELECT chapter_id  FROM theme_chapter WHERE theme_id = $themeId;")
          .then((value) {
        setState(() {
          _dataList = value.toList();
        });
      });
    });
    super.initState();
  }

  Future<void> getSharedData() async {
    SharedPreferences sharedData = await SharedPreferences.getInstance();
    setState(() {
      _fontSize  = sharedData.getDouble('fontSize');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        routeBox: routeBox,
        titleKey: 'verses',
        appBar: AppBar(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 2),
        child: ListView.builder(
          itemCount: _dataList.length,
          itemBuilder: (context, index) {
            var itemValue = _dataList[index].values;
            return new Card(
              margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              elevation: 1,
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(Const.customRoute((context) {
                    return VersesByTheme(
                      routeBox: routeBox,
                      chapterId: itemValue.first,
                    );
                  }));
                },
                child: ListTile(
                  title: Text(
                      '${Translations.of(context).text("psalm")} ${itemValue.first}',
                    style: TextStyle(
                      fontSize: _fontSize
                    ),
                  ),
                ),
              ),
//                color: Colors.transparent,
            );
          },
        ),
      ),
    );
  }
}
