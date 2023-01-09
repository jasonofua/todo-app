class Todo {
  final String id;
  bool completed;
  String content;
  String createdAt;

  Todo({required this.id, this.completed = false, this.content = '',  this.createdAt = '' });
}