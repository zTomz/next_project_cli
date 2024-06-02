import 'package:json/json.dart';
import 'package:next_project_cli/src/models/date.dart';
import 'package:next_project_cli/src/models/task.dart';
import 'package:uuid/uuid.dart';

@JsonCodable()
class Project {
  final String name;
  final String uuid;
  final Date createdAt;
  final List<Task> tasks;

  Project({
    required this.name,
    required this.uuid,
    required this.createdAt,
    required this.tasks,
  });

  factory Project.fromName({required String name}) {
    return Project(
      name: name,
      uuid: const Uuid().v4(),
      createdAt: Date.now(),
      tasks: [],
    );
  }

  @override
  String toString() {
    return 'Project(name: $name, uuid: $uuid, createdAt: $createdAt, tasks: $tasks)';
  }
}

class ProjectNotExistingExeption implements Exception {
  final String projectName;

  ProjectNotExistingExeption(this.projectName);

  @override
  String toString() {
    return 'The project $projectName does not exist.';
  }
}

enum DatabaseProjectResult {
  created,
  saved,
  alreadyExists,
}
