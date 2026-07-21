import 'dart:io';
import 'package:test/test.dart';
import 'package:task_manager_cli/models/task.dart';
import 'package:task_manager_cli/repositories/json_task_repository.dart';
import 'package:task_manager_cli/task_manager_cli.dart';
import 'package:task_manager_cli/exceptions/task_exceptions.dart';

void main() {
  late File testFile;
  late JsonTaskRepository repo;
  late TaskManager manager;

  setUp(() {
    testFile = File('test_tasks.json');
    if (testFile.existsSync()) testFile.deleteSync();
    repo = JsonTaskRepository('test_tasks.json');
    manager = TaskManager(repo);
  });

  tearDown(() {
    if (testFile.existsSync()) testFile.deleteSync();
  });

  test('1. L\'ajout d\'une tâche doit augmenter la liste', () async {
    final task = StandardTask(id: '1', title: 'Faire les courses');
    await manager.addTask(task);
    final tasks = await manager.listTasks();
    expect(tasks.length, 1);
    expect(tasks.first.title, 'Faire les courses');
  });

  test('2. Les tâches urgentes doivent avoir une priorité HIGH', () {
    final urgentTask = UrgentTask(id: '2', title: 'Rendre le projet');
    expect(urgentTask.priority, Priority.high);
  });

  test('3. Marquer une tâche comme terminée modifie son statut', () async {
    final task = StandardTask(id: '3', title: 'Réviser Dart');
    await manager.addTask(task);
    await manager.completeTask('3');
    final updatedTask = await repo.getById('3');
    expect(updatedTask.isCompleted, isTrue);
  });

  test('4. Une recherche sur un ID inexistant lève une TaskNotFoundException', () {
    expect(() => manager.completeTask('999'), throwsA(isA<TaskNotFoundException>()));
  });

  test('5. Un titre vide lève une InvalidTaskDataException', () {
    expect(() => StandardTask(id: '4', title: '   '), throwsA(isA<InvalidTaskDataException>()));
  });
}