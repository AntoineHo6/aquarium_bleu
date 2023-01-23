abstract class Task {
  String docId;
  String title;
  String desc;
  DateTime dueDate;
  bool isCompleted;

  Task(
    this.docId, {
    required this.title,
    required this.desc,
    required this.dueDate,
    this.isCompleted = false,
  });
}
