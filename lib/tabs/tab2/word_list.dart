import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/const.dart';
import 'package:psalms/help/event_key.dart';
import 'package:psalms/help/route_box.dart';
import 'package:psalms/help/translations.dart';
import 'package:psalms/tabs/tab2/verses_by_word.dart';

class WordList extends StatefulWidget {
  final RouteBox routeBox;
  final int letterId;

  WordList({Key key, this.routeBox, this.letterId}) : super(key: key);

  @override
  _WordListState createState() => _WordListState(routeBox, letterId);
}

class _WordListState extends State<WordList> {
  final RouteBox routeBox;
  final int letterId;


  var _dataList = new List<Map<String, dynamic>>();
  var _searchList = new List<Map<String, dynamic>>();
  FocusNode __searchFocusNode;
  TextEditingController _searchController = new TextEditingController();
  bool _searchFocus = false;
  ScrollController _scrollController;

  _WordListState(this.routeBox, this.letterId);


  @override
  void initState() {
    __searchFocusNode = FocusNode();
    _scrollController = ScrollController();

    var where = ";";
    if (letterId != 0) {
      where = "WHERE letter_id = $letterId;";
    }
    routeBox.dbf.then((db) {
      db
          .rawQuery(
              "SELECT firstline_id, firstline_name, chapter_id, verse_id  FROM firstline $where")
          .then((value) {
        setState(() {
          _dataList = value.toList();
          _searchList = _dataList;
        });
      });
    });

    routeBox.eventBus.on<LetterClickEvent>().listen((event) {
      __searchFocusNode.unfocus();
      _searchController.clear();
      _searchList = _dataList;
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          __searchFocusNode.unfocus();
          _searchFocus = false;
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    __searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    __searchFocusNode.addListener(() {
      setState(() {
        _searchFocus = __searchFocusNode.hasFocus;
      });
    });

    return Scaffold(
      appBar: BaseAppBar(
        routeBox: routeBox,
        titleKey: "words",
        appBar: AppBar(),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
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
                          element.values.toList()[1].toString().toLowerCase();
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
                var itemValue = _searchList[index].values.toList();
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
                        return VersesByWord(
                          routeBox: routeBox,
                          chapterId: itemValue[2],
                          verseId: itemValue[3],
                        );
                      })).then((value) {
                        _searchController.clear();
                        setState(() {
                          _searchList = _dataList;
                        });
                      });
                    },
                    child: ListTile(
                      title: Text(' ${itemValue[1]}'),
                      trailing: Text(
                          '${Translations.of(context).text("psalm")} ${itemValue[2]}. ${Const.removeIfNull(itemValue[3])}'),
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
