import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:psalms/help/route_box.dart';

class NameList extends StatefulWidget {
  final RouteBox routeBox;

  NameList({Key key, this.routeBox}) : super(key: key);

  @override
  _NameListState createState() => _NameListState(routeBox);
}

class _NameListState extends State<NameList> {
  final RouteBox routeBox;

  _NameListState(this.routeBox);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Html(
          data: """
    <!--For a much more extensive example, look at example/main.dart-->
    <div>
      <h1>Demo Page</h1>
      <p>This is a fantastic nonexistent product that you should buy!</p>
      <h2>Pricing</h2>
      <p>Lorem ipsum <b>dolor</b> sit amet.</p>
      <h2>The Team</h2>
      <p>There isn't <i>really</i> a team...</p>
      <h2>Installation</h2>
      <p>You <u>cannot</u> install a nonexistent product!</p>
      <!--You can pretty much put any html in here!-->
    </div>
  """,
          //Optional parameters:
          padding: EdgeInsets.all(8.0),
          backgroundColor: Colors.white70,
          defaultTextStyle: TextStyle(fontFamily: 'serif'),
          linkStyle: const TextStyle(
            color: Colors.redAccent,
          ),

          //Must have useRichText set to false for this to work.
        ),
      ),
    );
  }
}
