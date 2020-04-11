import 'package:flutter/material.dart';
import 'package:psalms/tabs/controller/for_route.dart';

class NameMean extends StatefulWidget {
  final ValueChanged<ForRoute> onPush;

  NameMean({Key key, this.onPush}) : super(key: key);

  @override
  _NameMeanState createState() => _NameMeanState(onPush);
}

class _NameMeanState extends State<NameMean> {
  final ValueChanged<ForRoute> onPush;

  _NameMeanState(this.onPush);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
