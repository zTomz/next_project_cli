import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:interact/interact.dart';
import 'package:next_project_cli/next_project_cli.dart';

Future<void> listProject(Project project) async {
  final (answers, indexToDelete) = MultiSelect(
    prompt: 'Tasks of project ${project.name}',
    options: [
      ...project.tasks.map((task) => task.content),
      'Create a new task',
    ],
    defaults: [
      ...project.tasks.map((task) => task.completed),
      false,
    ],
    actionEntryIndex: project.tasks.length,
  ).interact();

  // Create a new task
  if (answers.contains(project.tasks.length)) {
    final newTask = Input(
      prompt: "What's the new task?",
      validator: (value) {
        if (value.isNotEmpty) {
          return true;
        } else {
          throw ValidationError('The task cannot be empty');
        }
      },
    ).interact();

    final task = Task.fromContent(newTask);
    project.tasks.add(task);

    await Database.saveProject(project);

    return;
  }

  if (indexToDelete == project.tasks.length) {
    return;
  }

  // Delete a task if neccessary
  if (indexToDelete != null) {
    final removedTask = project.tasks.removeAt(indexToDelete);
    echo(green('Task "${removedTask.content}" deleted.'));
  }

  // Save the project
  for (int i = 0; i < project.tasks.length; i++) {
    final task = project.tasks[i];
    task.set(answers.contains(i));
  }
  await Database.saveProject(project);
}

/// Load a project from the database. Handles exceptions.
Future<Project> loadProject(String projectName) async {
  late final Project project;

  try {
    project = await Database.loadProject(projectName: projectName);
  } on ProjectNotExistingExeption catch (e) {
    printerr(red("Project not found: ${e.projectName}."));

    exit(1);
  }

  return project;
}
