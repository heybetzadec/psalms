import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psalms/help/base_app_bar.dart';
import 'package:psalms/help/event_key.dart';
import 'package:psalms/help/route_bus.dart';
import 'package:psalms/help/translations.dart';
import 'package:psalms/main.dart';
import 'package:psalms/tabs/controller/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Other extends StatefulWidget {
  final RouteBus routeBus;

  Other({Key key, this.routeBus}) : super(key: key);

  @override
  _OtherState createState() => _OtherState(routeBus);
}

class _OtherState extends State<Other> {
  final RouteBus routeBus;
  double _fontSize = 18;

  _OtherState(this.routeBus);

  List _langs = ["Engilish", "Türkçe"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentLang;

  void add() {
    setState(() {
      if(_fontSize < 24)
        _fontSize++;
      setSharedData();
    });
  }

  void minus() {
    setState(() {
      if (_fontSize > 13)
        _fontSize--;
      setSharedData();
    });
  }

  Future<String> setSharedData() async {
    SharedPreferences sharedData = await SharedPreferences.getInstance();
    sharedData.setDouble('fontSize', _fontSize);
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentLang = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        routeBus: routeBus,
        titleKey: "psalms",
        appBar: AppBar(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Center(
          child: Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        right: 20
                    ),
                    child: Text(
                      Translations.of(context).text("choose_language"),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  DropdownButton(
                    value: _currentLang,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                    top: 35,
                    bottom: 10
                  ),
                child: Text(
                  Translations.of(context).text("font_size"),
                  style: TextStyle(
                      fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        right: 25,
                    ),
                    child: new FloatingActionButton(
                      onPressed: minus,
                      child: new Icon(
                          const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                          color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  new Text('$_fontSize', style: new TextStyle(fontSize: 30.0)),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: new FloatingActionButton(
                      onPressed: add,
                      child: new Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          )
        )
      ),
    );
  }

  void changedDropDownItem(String _currentLang) {
    if(_currentLang == _langs[0]){
      Locale newLocale = Locale('en', 'TR');
      Main.setLocale(context, newLocale);
    } else {
      Locale newLocale = Locale('tr', 'TR');
      Main.setLocale(context, newLocale);
    }
    App.setOptionChange(context, 25);
    setState(() {
      this._currentLang = _currentLang;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _langs) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }

}
