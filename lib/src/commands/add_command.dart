import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:next_project_cli/next_project_cli.dart';

class AddCommand extends Command {
  @override
  final name = "add";

  @override
  final description =
      "Add a task to a project. E. g. npcli add <project> -t <task>";

  AddCommand() {
    argParser.addOption(
      "task",
      abbr: "t",
      help: "The task you want to add.",
    );
  }

  @override
  Future<void> run() async {
    final projectToAddTheTask = argResults?.arguments.firstOrNull;
    final task = argResults?.option("task");

    if (projectToAddTheTask == null) {
      printerr(
        red(
          "Please provide the name of the project you want to add a task to. E. g. npcli add <project> -t <task>",
        ),
      );

      exit(1);
    }

    if (task == null || task.isEmpty) {
      printerr(red("Please provide the content of the task."));

      exit(1);
    }

    final project = await loadProject(projectToAddTheTask);

    project.tasks.add(Task.fromContent(task));
    await Database.saveProject(project);
  }
}
