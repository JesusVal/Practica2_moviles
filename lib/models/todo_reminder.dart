// TODO: convertir en adapter de Hive y utilizar build runner para generar el adapter
import 'package:hive/hive.dart';
part 'todo_reminder.g.dart';

@HiveType(typeId: 1, adapterName: "ReminderAdapter")
class TodoRemainder {
  @HiveField(0)
  final String todoDescription;

  @HiveField(1)
  final String hour;

  TodoRemainder({
    this.todoDescription,
    this.hour,
  });
}
