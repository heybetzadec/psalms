import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/event_key.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/help/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerseList extends StatefulWidget {
  final RouteBox routeBox;
  final int chapterId;

  VerseList({Key key, this.routeBox, this.chapterId}) : super(key: key);

  @override
  _VerseListState createState() => _VerseListState(routeBox, chapterId);
}

class _VerseListState extends State<VerseList> {
  final RouteBox routeBox;
  final int chapterId;
  double fontSize = 18;

  _VerseListState(this.routeBox, this.chapterId);

  var dataList = new List<Map<String, dynamic>>();

  @override
  void initState() {
    getSharedData();
    routeBox.dbf.then((db) {
      db
          .rawQuery(
              "SELECT verse_id, text  FROM verse WHERE chapter_id=$chapterId;")
          .then((value) {
        setState(() {
          dataList = value.toList();
        });
      });
    });

//    routeBox.eventBus.on<ChapterClickEvent>().listen((event) {
//      setState(() {
//        getSharedData();
//      });
//    });
    super.initState();
  }

  Future<void> getSharedData() async {
    SharedPreferences sharedData = await SharedPreferences.getInstance();
    setState(() {
      fontSize  = sharedData.getDouble('fontSize');
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
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var itemValue = dataList[index].values;
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
                          '${itemValue.last} - ${Translations.of(context).text("psalm")} $chapterId:${itemValue.first}'));
                  Fluttertoast.showToast(
                      msg:
                          "${Translations.of(context).text("copied_psalm")} $chapterId:${itemValue.first}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: ListTile(
                  title: Text(
                      '${itemValue.first}. ${itemValue.last}',
                    style: TextStyle(
                      fontSize: fontSize
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
