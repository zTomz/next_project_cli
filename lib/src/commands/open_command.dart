import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:next_project_cli/next_project_cli.dart';

class OpenCommand extends Command {
  @override
  final name = "open";

  @override
  final description = "Open a project. E. g. npcli open <project>";

  @override
  Future<void> run() async {
    final projectToOpen = argResults?.arguments.firstOrNull;

    if (projectToOpen == null) {
      printerr(red("Please provide a name for the project."));
      exit(1);
    }

    late final Project project;

    try {
      project = await Database.loadProject(projectName: projectToOpen);
    } on ProjectNotExistingExeption catch (e) {
      printerr(red("Project not found: ${e.projectName}."));
    }

    await listProject(project);
  }
}
