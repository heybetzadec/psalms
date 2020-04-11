import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psalms/help/event_key.dart';
import 'package:psalms/help/route_bus.dart';
import 'package:psalms/help/translations.dart';

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String titleKey;
  final AppBar appBar;
  final RouteBus routeBus;

  BaseAppBar({Key key, this.titleKey, this.appBar, this.routeBus}) : super(key: key);

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  _BaseAppBarState createState() => _BaseAppBarState(titleKey, appBar, routeBus);
}

class _BaseAppBarState extends State<BaseAppBar> {
  final String titleKey;
  final AppBar appBar;
  final RouteBus routeBus;

  _BaseAppBarState(this.titleKey, this.appBar, this.routeBus);

  String query = '';
  String _title  = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _title = Translations.of(context).text(titleKey);
    return AppBar(
      title: Text(_title),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search,
            size: 35,
          ),
          onPressed: () async {
            final String selected = await showSearch(
                context: context, delegate: _MySearchDelegate(routeBus));

            if (selected != null && selected != query) {
              setState(() {
                query = selected;
              });
            }
          },
        )
      ],
    );
  }
}

class _MySearchDelegate extends SearchDelegate<String> {
  final RouteBus routeBus;


  var dataList = new List<Map<String, dynamic>>();

  List<String> filterName = new List();

  _MySearchDelegate( this.routeBus);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon((Icons.clear)),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    routeBus.dbf.then((db) {
      db
          .rawQuery(
          "SELECT chapter_id, verse_id, text  FROM verse WHERE lang_id = 1 AND text LIKE '%$query%' LIMIT 100;")
          .then((value) {
          dataList = value;
      });
    });


    return ListView.builder(
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
                  '${itemValue[2]} - ${Translations.of(context).text(
                      "psalm")} ${itemValue[0]}:${itemValue[1]}'));
              Fluttertoast.showToast(
                  msg:
                  "${Translations.of(context).text( "copied_psalm")} ${itemValue[0]}:${itemValue[1]}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            child: ListTile(
              title: Text('${Translations.of(context).text("psalm")} ${itemValue[0]}:${itemValue[1]} ${itemValue[2]}'),
            ),
          ),
        );
      }
    );
  }
}
