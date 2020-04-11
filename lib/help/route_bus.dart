import 'package:event_bus/event_bus.dart';
import 'package:sqflite/sqflite.dart';

class RouteBus {
  final EventBus eventBus;
  final Future<Database> dbf;
  int languageId;
  double fontSize;

  RouteBus({
    this.eventBus,
    this.dbf,
    this.languageId,
    this.fontSize,
  });
}
