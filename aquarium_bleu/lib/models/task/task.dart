abstract class Task {
  String id;
  String title;
  String desc;
  DateTime dueDate;

  Task(
    this.id, {
    required this.title,
    required this.desc,
    required this.dueDate,
  });
}
