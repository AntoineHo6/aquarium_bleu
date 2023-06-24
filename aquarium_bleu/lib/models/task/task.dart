abstract class Task {
  String docId;
  String title;
  String desc;
  DateTime dueDate;

  Task(
    this.docId, {
    required this.title,
    required this.desc,
    required this.dueDate,
  });
}
