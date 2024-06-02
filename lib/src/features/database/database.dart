import 'dart:convert';
import 'dart:io';

import 'package:next_project_cli/next_project_cli.dart';
import 'package:path/path.dart' as path;

// ignore: avoid_classes_with_only_static_members
abstract final class Database {
  /// Loads a project from the database.
  static Future<Project> loadProject({required String projectName}) async {
    final jsonFile = _getProjectFile(projectName);

    if (!await jsonFile.exists()) {
      throw ProjectNotExistingExeption(projectName);
    }

    final jsonMap = jsonDecode(await jsonFile.readAsString());

    return Project.fromJson(jsonMap as Map<String, dynamic>);
  }

  /// Saves a project to the database. Returns an instance of [DatabaseProjectResult.saved].
  static Future<DatabaseProjectResult> saveProject(Project project) async {
    final projectFile = _getProjectFile(project.name);

    await projectFile.writeAsString(jsonEncode(project.toJson()));

    return DatabaseProjectResult.saved;
  }

  /// Creates a new project in the database. If it already exists, it will
  /// return [DatabaseProjectResult.alreadyExists].
  static Future<DatabaseProjectResult> createProject(Project project) async {
    final projectFile = _getProjectFile(project.name);

    if (await projectFile.exists()) {
      return DatabaseProjectResult.alreadyExists;
    }

    await projectFile.writeAsString(jsonEncode(project.toJson()));

    return DatabaseProjectResult.created;
  }

  /// Loads all projects from the database.
  static Future<List<Project>> loadAllProjects() async {
    final List<Project> projects = <Project>[];

    // Load all projects
    for (final projectFile in Config.databaseDirectory.listSync()) {
      if (path.extension(projectFile.path) != '.json') continue;

      projects.add(
        await loadProject(
          projectName: path.basenameWithoutExtension(projectFile.path),
        ),
      );
    }

    return projects;
  }

  /// Deletes a project from the database.
  static Future<void> deleteProject(String projectName) async {
    final projectFile = _getProjectFile(projectName);

    if (!await projectFile.exists()) {
      throw ProjectNotExistingExeption(projectName);
    }

    await projectFile.delete();
  }

  /// Deletes all projects from the database.
  static Future<void> deleteAllProjects() async {
    for (final projectFile in Config.databaseDirectory.listSync()) {
      if (path.extension(projectFile.path) != '.json') continue;

      await projectFile.delete();
    }
  }

  static File _getProjectFile(String projectName) {
    return File(
      path.join(Config.databaseDirectory.path, '$projectName.json'),
    );
  }
}
