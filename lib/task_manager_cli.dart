import 'models/task.dart';
import 'repositories/repository_interface.dart';

class TaskManager {
  final Repository<Task> repository;

  TaskManager(this.repository);

  Future<void> addTask(Task task) async {
    await repository.add(task);
  }

  Future<List<Task>> listTasks({String sortBy = 'priority'}) async {
    final tasks = List<Task>.from(await repository.getAll());
    if (sortBy == 'priority') {
      tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else if (sortBy == 'date') {
      tasks.sort((a, b) {
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    }
    return tasks;
  }

  Future<void> completeTask(String id) async {
    final task = await repository.getById(id);
    task.markAsCompleted();
    await repository.update(task);
  }

  Future<void> deleteTask(String id) async {
    await repository.delete(id);
  }
}