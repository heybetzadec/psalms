import 'package:flutter/material.dart';
import 'package:psalms/help/route_bus.dart';

class Template extends StatefulWidget {
  final RouteBox routeBox;

  Template({Key key, this.routeBox}) : super(key: key);

  @override
  _TemplateState createState() => _TemplateState(routeBox);
}

class _TemplateState extends State<Template> {
  final RouteBox routeBox;

  _TemplateState(this.routeBox);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
