#CLI Task Manager (Dart)

Application en ligne de commande développée en Dart pur pour gérer des tâches avec persistance JSON local.

## Exigences techniques validées
- **Classes abstraites & Héritage** : `Task` (abstraite), `StandardTask`, `UrgentTask`.
- **Interfaces** : `JsonSerializable`, `Repository<T>`.
- **Génériques** : `Repository<T>`.
- **Exceptions sur-mesure** : `TaskException`, `TaskNotFoundException`, `InvalidTaskDataException`.
- **Tests unitaires** : 5 tests unitaires dans `test/task_manager_test.dart`.

## Lancement
```bash
dart run bin/task_manager_cli.dart
