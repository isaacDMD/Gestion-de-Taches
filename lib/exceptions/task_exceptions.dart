class TaskException implements Exception {
  final String message;
  TaskException(this.message);

  @override
  String toString() => 'TaskException: $message';
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException(String id) : super('Tâche introuvable avec l\'ID : $id');
}

class InvalidTaskDataException extends TaskException {
  InvalidTaskDataException(String msg) : super('Donnée de tâche invalide : $msg');
}