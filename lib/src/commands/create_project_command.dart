import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:next_project_cli/next_project_cli.dart';

class CreateProjectCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  @override
  final name = "create";
  @override
  final description = "Create a new project.";

  // CreateProjectCommand() {}

  @override
  Future<void> run() async {
    final name = argResults?.arguments.firstOrNull;

    if (name == null) {
      printerr(red("Please provide a name for the project."));

      exit(1);
    }

    final project = Project.fromName(name: name);
    final result = await Database.createProject(project);

    switch (result) {
      case DatabaseProjectResult.alreadyExists:
        printerr(red("Project already exists."));
      case DatabaseProjectResult.created:
        print(green("Project created successfully."));
      // This case cannot happen
      default:
        break;
    }
  }
}
