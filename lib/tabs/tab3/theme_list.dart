import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/const.dart';
import 'package:psalms/help/event_key.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/help/translations.dart';
import 'package:psalms/tabs/tab3/chapter_by_theme.dart';

class ThemeList extends StatefulWidget {
  final RouteBox routeBox;

  ThemeList({Key key, this.routeBox}) : super(key: key);

  @override
  _ThemeListState createState() => _ThemeListState(routeBox);
}

class _ThemeListState extends State<ThemeList> {
  final RouteBox routeBox;

  var _dataList = new List<Map<String, dynamic>>();
  var _searchList = new List<Map<String, dynamic>>();
  FocusNode _searchFocusNode;
  TextEditingController _searchController = new TextEditingController();
  bool _searchFocus = false;
  ScrollController _scrollController;

  _ThemeListState(this.routeBox);


  @override
  void initState() {
    _searchFocusNode = FocusNode();
    _scrollController = ScrollController();

    routeBox.dbf.then((db) {
      db.rawQuery("SELECT theme_id, theme_name  FROM theme;").then((value) {
        setState(() {
          _dataList = value.toList();
          _searchList = _dataList;
        });
      });
    });

    routeBox.eventBus.on<ThemeClickEvent>().listen((event) {
      _searchFocusNode.unfocus();
      _searchController.clear();
      setState(() {
        _searchList = _dataList;
      });
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          _searchFocusNode.unfocus();
          _searchFocus = false;
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _searchFocusNode.addListener(() {
      setState(() {
        _searchFocus = _searchFocusNode.hasFocus;
      });
    });

    return Scaffold(
      appBar: BaseAppBar(
        routeBox: routeBox,
        titleKey: "theme",
        appBar: AppBar(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 2),
        child: CustomScrollView(
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
                  focusNode: _searchFocusNode,
                  onChanged: (value) {
                    var searched = new List<Map<String, dynamic>>();
                    setState(() {
                      searched.addAll(_dataList.where((element) {
                        String item =
                            element.values.last.toString().toLowerCase();
                        value = value.toLowerCase();
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
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    elevation: 1,
                    child: new InkWell(
                      onTap: () {
                        _searchFocusNode.unfocus();
                        Navigator.of(context).push(Const.customRoute((context) {
                          return ChapterByTheme(
                            routeBox: routeBox,
                            themeId: itemValue.first,
                          );
                        })).then((value) {
                          _searchController.clear();
                          setState(() {
                            _searchList = _dataList;
                          });
                        });
                      },
                      child: ListTile(
                        title: Text(' ${itemValue.last}'),
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
      ),
    );
  }

  getSearchSuffix(bool isFocus) {
    if (isFocus) {
      return IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (_searchController.text.length == 0) {
              _searchFocusNode.unfocus();
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
