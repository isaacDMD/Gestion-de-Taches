import '../exceptions/task_exceptions.dart';

enum Priority { low, medium, high }

/// Interface pour la sérialisation JSON
abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}

/// Classe abstraite représentant une tâche générique
abstract class Task implements JsonSerializable {
  final String id;
  String title;
  Priority priority;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  }) {
    if (title.trim().isEmpty) {
      throw InvalidTaskDataException('Le titre ne peut pas être vide.');
    }
  }

  String get type;

  void markAsCompleted() {
    isCompleted = true;
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'priority': priority.name,
    'dueDate': dueDate?.toIso8601String(),
    'isCompleted': isCompleted,
    'type': type,
  };

  static Task fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final id = json['id'] as String;
    final title = json['title'] as String;
    final priority = Priority.values.byName(json['priority'] as String);
    final dueDate = json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null;
    final isCompleted = json['isCompleted'] as bool;

    if (type == 'Urgent') {
      return UrgentTask(
        id: id,
        title: title,
        dueDate: dueDate,
        isCompleted: isCompleted,
      );
    } else {
      return StandardTask(
        id: id,
        title: title,
        priority: priority,
        dueDate: dueDate,
        isCompleted: isCompleted,
      );
    }
  }

  @override
  String toString() {
    final status = isCompleted ? '[✓]' : '[ ]';
    final dateStr = dueDate != null ? ' (Limite: ${dueDate.toString().split(' ')[0]})' : '';
    return '$status #$id - $title [$type | Priorité: ${priority.name.toUpperCase()}]$dateStr';
  }
}

/// Tâche classique
class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    super.priority = Priority.medium,
    super.dueDate,
    super.isCompleted,
  });

  @override
  String get type => 'Standard';
}

/// Tâche urgente (Priorité toujours HIGH)
class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.dueDate,
    super.isCompleted,
  }) : super(priority: Priority.high);

  @override
  String get type => 'Urgent';
}