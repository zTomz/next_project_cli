import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:next_project_cli/next_project_cli.dart';

class AddCommand extends Command {
  @override
  final name = "add";

  @override
  final description = "Add a task to a project.";

  @override
  Future<void> run() async {
    final projectToAddTheTask = argResults?.arguments.firstOrNull;
    final task = argResults?.arguments[1];

    if (projectToAddTheTask == null) {
      printerr(
        red(
          "Please provide the name of the project you want to add a task to.",
        ),
      );

      exit(1);
    }

    if (task == null || task.isEmpty) {
      printerr(red("Please provide the content of the task."));

      exit(1);
    }

    late final Project project;

    try {
      project = await Database.loadProject(projectName: projectToAddTheTask);
    } on ProjectNotExistingExeption catch (e) {
      printerr(red("Project not found: ${e.projectName}."));

      exit(1);
    }

    project.tasks.add(Task.fromContent(task));
    await Database.saveProject(project);
  }
}
