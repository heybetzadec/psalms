import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/const.dart';
import 'package:psalms/help/event_key.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/help/translations.dart';
import 'package:psalms/tabs/tab1/verse_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinycolor/tinycolor.dart';

class ChapterList extends StatefulWidget {
  final RouteBox routeBox;

  ChapterList({Key key, this.routeBox}) : super(key: key);

  @override
  _ChapterListState createState() => _ChapterListState(routeBox);
}

class _ChapterListState extends State<ChapterList> {
  final RouteBox routeBox;

  _ChapterListState(this.routeBox);

  var _dataList = new List<Map<String, dynamic>>();
  var _searchList = new List<Map<String, dynamic>>();
  FocusNode __searchFocusNode;
  TextEditingController _searchController = new TextEditingController();
  bool _searchFocus = false;
  ScrollController _scrollController;
  double _fontSize = 18;

  @override
  void initState() {
    __searchFocusNode = FocusNode();
    _scrollController = ScrollController();
    getSharedData();
    routeBox.dbf.then((db) {
      db
          .rawQuery("SELECT chapter_id  FROM verse GROUP BY chapter_id; ")
          .then((value) {
        setState(() {
          _dataList = value.toList();
          _searchList = _dataList;
        });
      });
    });

    routeBox.eventBus.on<ChapterClickEvent>().listen((event) {
      __searchFocusNode.unfocus();
      _searchController.clear();
      setState(() {
        getSharedData();
        _searchList = _dataList;
      });
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          __searchFocusNode.unfocus();
          _searchFocus = false;
        }
      },
    );

    __searchFocusNode.addListener(() {
      setState(() {
        _searchFocus = __searchFocusNode.hasFocus;
      });
    });
    
    super.initState();
  }


  Future<void> getSharedData() async {
    SharedPreferences sharedData = await SharedPreferences.getInstance();
    var fontSize  = sharedData.getDouble('fontSize');
    if(_fontSize == null){ // if app first time open
      _fontSize = 18;
      sharedData.setDouble("fontSize", _fontSize);
    }
    setState(() {
      _fontSize = fontSize;
    });
  }

  @override
  void dispose() {
    __searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        routeBox: routeBox,
        titleKey: "psalms",
        appBar: AppBar(),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            flexibleSpace: Container(
              margin: EdgeInsets.only(
                top: 4,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                autocorrect: false,
                textInputAction: TextInputAction.search,
                focusNode: __searchFocusNode,
                onChanged: (value) {
                  var searched = new List<Map<String, dynamic>>();
                  setState(() {
                    searched.addAll(_dataList.where((element) {
                      String item =
                          element.values.last.toString().toLowerCase();
                      value = value
                          .toLowerCase()
                          .replaceAll("[^0-9.]", "")
                          .replaceAll(new RegExp('[^0-9.]'), '');
                      print(value);
                      return item.contains(value);
                    }));
                  });
                  setState(() {
                    _searchList = searched;
                  });
                },
                decoration: InputDecoration(
                    hintText: Translations.of(context).text("page_search"),
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: getSearchSuffix(_searchFocus),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    fillColor: Colors.red),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var itemValue = _searchList[index].values;
                return new Card(
                  margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  elevation: 1,
                  child: new InkWell(
                    onTap: () {
                      __searchFocusNode.unfocus();
                      Navigator.of(context).push(Const.customRoute((context) {
                        return VerseList(
                          routeBox: routeBox,
                          chapterId: itemValue.first,
                        );
                      })).then((value) {
                        _searchController.clear();
                        setState(() {
                          _searchList = _dataList;
                        });
                      });
                    },
                    child: ListTile(
                      title: Text(
                        '${Translations.of(context).text("psalm")} ${itemValue.first}',
                        style: TextStyle(fontSize: _fontSize),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
                  ),
                );
              },
              childCount: _searchList.length,
            ),
          ),
        ],
      ),
    );
  }

  getSearchSuffix(bool isFocus) {
    if (isFocus) {
      return IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (_searchController.text.length == 0) {
              __searchFocusNode.unfocus();
            } else {
              _searchController.clear();
            }
            setState(() {
              _searchList = _dataList;
            });
          });
    } else {
      return Icon(
        Icons.list,
        size: 30,
        color: Colors.black26,
      );
    }
  }
}
