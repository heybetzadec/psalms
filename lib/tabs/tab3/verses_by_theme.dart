import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/route_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersesByTheme extends StatefulWidget {
  final RouteBox routeBox;
  final int chapterId;

  VersesByTheme({Key key, this.routeBox, this.chapterId}) : super(key: key);

  @override
  _VersesByThemeState createState() => _VersesByThemeState(routeBox, chapterId);
}

class _VersesByThemeState extends State<VersesByTheme> {
  final RouteBox routeBox;
  final int chapterId;

  double _fontSize = 18;
  var _dataList = new List<Map<String, dynamic>>();

  _VersesByThemeState(this.routeBox, this.chapterId);


  @override
  void initState() {
    getSharedData();
    routeBox.dbf.then((db) {
      db
          .rawQuery(
              "SELECT verse_id, text  FROM verse WHERE chapter_id=$chapterId;")
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
        titleKey: "verses",
        appBar: AppBar(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 2),
        child: ListView.builder(
          itemCount: _dataList.length,
          itemBuilder: (context, index) {
            var itemValue = _dataList[index].values.toList();
            return new Card(
              margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              elevation: 1,
              child: new InkWell(
                onLongPress: () {
                  Clipboard.setData(new ClipboardData(
                      text:
                          '${itemValue.last} - Psalm $chapterId:${itemValue.first}'));
                  Fluttertoast.showToast(
                      msg: "Copied Psalm $chapterId:${itemValue.first}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: ListTile(
                  title: Text(
                      '${itemValue.first}. ${itemValue[1]}. ${itemValue.last}',
                    style: TextStyle(
                        fontSize: _fontSize
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
