import 'package:flutter/material.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/const.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/help/translations.dart';
import 'package:psalms/tabs/tab2/word_list.dart';

class LetterList extends StatefulWidget {
  final RouteBox routeBox;

  LetterList({Key key, this.routeBox}) : super(key: key);

  @override
  _LetterListState createState() => _LetterListState(routeBox);
}

class _LetterListState extends State<LetterList> {
  final RouteBox routeBox;
  
  List<Map<String, dynamic>> _dataList;
  
  
  _LetterListState(this.routeBox);


  @override
  void initState() {
    _dataList = new List<Map<String, dynamic>>();
    _dataList.add({'letter_id': 0, 'letter_name': 'All'});
    routeBox.dbf.then((db) {
      db.rawQuery("SELECT letter_id, letter_name  FROM letter;").then((value) {
        setState(() {
          _dataList.addAll(value);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        routeBox: routeBox,
        titleKey: "words",
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
                    return WordList(
                      routeBox: routeBox,
                      letterId: itemValue.first,
                    );
                  }));
                },
                child: ListTile(
                  title: Text(' ${itemValue.last}'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
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
