import 'dart:io';
import 'package:task_manager_cli/models/task.dart';
import 'package:task_manager_cli/repositories/json_task_repository.dart';
import 'package:task_manager_cli/task_manager_cli.dart';
import 'package:task_manager_cli/exceptions/task_exceptions.dart';

void main() async {
  final repo = JsonTaskRepository('tasks.json');
  final manager = TaskManager(repo);

  print('=== GESTIONNAIRE DE TÂCHES CLI ===');

  while (true) {
    print('\nOptions:');
    print('1. Ajouter une tâche standard');
    print('2. Ajouter une tâche urgente');
    print('3. Lister les tâches (tri par priorité)');
    print('4. Lister les tâches (tri par date limite)');
    print('5. Marquer une tâche comme terminée');
    print('6. Supprimer une tâche');
    print('7. Quitter');
    stdout.write('Choix > ');

    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          stdout.write('Titre: ');
          final title = stdin.readLineSync() ?? '';
          stdout.write('Priorité (low/medium/high) [medium]: ');
          final prioStr = stdin.readLineSync()?.trim().toLowerCase() ?? 'medium';
          final priority = Priority.values.firstWhere(
                (p) => p.name == prioStr,
            orElse: () => Priority.medium,
          );
          stdout.write('Date limite (YYYY-MM-DD) [optionnel]: ');
          final dateStr = stdin.readLineSync()?.trim();
          final dueDate = (dateStr != null && dateStr.isNotEmpty) ? DateTime.parse(dateStr) : null;

          final id = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
          await manager.addTask(StandardTask(id: id, title: title, priority: priority, dueDate: dueDate));
          print('Tâche ajoutée avec succès !');
          break;

        case '2':
          stdout.write('Titre de la tâche urgente: ');
          final title = stdin.readLineSync() ?? '';
          stdout.write('Date limite (YYYY-MM-DD) [optionnel]: ');
          final dateStr = stdin.readLineSync()?.trim();
          final dueDate = (dateStr != null && dateStr.isNotEmpty) ? DateTime.parse(dateStr) : null;

          final id = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
          await manager.addTask(UrgentTask(id: id, title: title, dueDate: dueDate));
          print('Tâche urgente ajoutée avec succès !');
          break;

        case '3':
          final tasks = await manager.listTasks(sortBy: 'priority');
          _printTaskList(tasks);
          break;

        case '4':
          final tasks = await manager.listTasks(sortBy: 'date');
          _printTaskList(tasks);
          break;

        case '5':
          stdout.write('ID de la tâche à terminer: ');
          final id = stdin.readLineSync()?.trim() ?? '';
          await manager.completeTask(id);
          print('Tâche marquée comme terminée !');
          break;

        case '6':
          stdout.write('ID de la tâche à supprimer: ');
          final id = stdin.readLineSync()?.trim() ?? '';
          await manager.deleteTask(id);
          print('Tâche supprimée !');
          break;

        case '7':
          print('Au revoir !');
          exit(0);

        default:
          print('Option invalide.');
      }
    } on TaskException catch (e) {
      print('Erreur : ${e.message}');
    } catch (e) {
      print('Erreur inattendue : $e');
    }
  }
}

void _printTaskList(List<Task> tasks) {
  if (tasks.isEmpty) {
    print('Aucune tâche enregistrée.');
    return;
  }
  print('\n--- LISTE DES TÂCHES ---');
  for (var task in tasks) {
    print(task);
  }
}