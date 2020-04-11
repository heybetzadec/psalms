import 'package:flutter/material.dart';
import 'package:psalms/help/route_box.dart';

class NameMean extends StatefulWidget {
  final RouteBox routeBox;

  NameMean({Key key, this.routeBox}) : super(key: key);

  @override
  _NameMeanState createState() => _NameMeanState(routeBox);
}

class _NameMeanState extends State<NameMean> {
  final RouteBox routeBox;

  _NameMeanState(this.routeBox);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
