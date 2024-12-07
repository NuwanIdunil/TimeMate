class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final String email;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'email': email,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      email: map['email'],
    );
  }
}
