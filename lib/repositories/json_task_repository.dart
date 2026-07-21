import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../exceptions/task_exceptions.dart';
import 'repository_interface.dart';

class JsonTaskRepository implements Repository<Task> {
  final File file;
  List<Task> _tasks = [];

  JsonTaskRepository(String filePath) : file = File(filePath) {
    _loadSync();
  }

  void _loadSync() {
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync('[]');
    }
    try {
      final content = file.readAsStringSync();
      if (content.trim().isEmpty) {
        _tasks = [];
        return;
      }
      final List<dynamic> jsonList = jsonDecode(content);
      _tasks = jsonList.map((j) => Task.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      _tasks = [];
    }
  }

  @override
  Future<List<Task>> getAll() async => List.unmodifiable(_tasks);

  @override
  Future<Task> getById(String id) async {
    return _tasks.firstWhere(
          (t) => t.id == id,
      orElse: () => throw TaskNotFoundException(id),
    );
  }

  @override
  Future<void> add(Task item) async {
    _tasks.add(item);
    await save();
  }

  @override
  Future<void> update(Task item) async {
    final index = _tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) throw TaskNotFoundException(item.id);
    _tasks[index] = item;
    await save();
  }

  @override
  Future<void> delete(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) throw TaskNotFoundException(id);
    _tasks.removeAt(index);
    await save();
  }

  @override
  Future<void> save() async {
    final jsonList = _tasks.map((t) => t.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}