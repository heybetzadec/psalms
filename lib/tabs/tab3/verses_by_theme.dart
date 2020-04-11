import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/route_bus.dart';

class VersesByTheme extends StatefulWidget {
  final RouteBus routeBus;
  final int chapterId;

  VersesByTheme({Key key, this.routeBus, this.chapterId}) : super(key: key);

  @override
  _VersesByThemeState createState() => _VersesByThemeState(routeBus, chapterId);
}

class _VersesByThemeState extends State<VersesByTheme> {
  final RouteBus routeBus;
  final int chapterId;

  _VersesByThemeState(this.routeBus, this.chapterId);

  var dataList = new List<Map<String, dynamic>>();

  @override
  void initState() {
    routeBus.dbf.then((db) {
      db
          .rawQuery(
              "SELECT verse_id, text  FROM verse WHERE chapter_id=$chapterId;")
          .then((value) {
        setState(() {
          dataList = value.toList();
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        routeBus: routeBus,
        titleKey: "verses",
        appBar: AppBar(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 2),
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var itemValue = dataList[index].values.toList();
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
                      '${itemValue.first}. ${itemValue[1]}. ${itemValue.last}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
