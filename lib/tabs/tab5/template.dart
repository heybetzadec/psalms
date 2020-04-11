import 'package:flutter/material.dart';
import 'package:psalms/help/route_bus.dart';

class Template extends StatefulWidget {
  final RouteBus routeBus;

  Template({Key key, this.routeBus}) : super(key: key);

  @override
  _TemplateState createState() => _TemplateState(routeBus);
}

class _TemplateState extends State<Template> {
  final RouteBus routeBus;

  _TemplateState(this.routeBus);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
