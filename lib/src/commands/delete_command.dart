import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:next_project_cli/next_project_cli.dart';

class DeleteCommand extends Command {
  @override
  final name = "delete";

  @override
  final description = "Delete a project. E. g. npcli delete <project>";

  DeleteCommand() {
    argParser.addFlag(
      "all",
      abbr: "a",
      help: "Delete all projects.",
    );
  }

  @override
  Future<void> run() async {
    if (argResults?["all"] == true) {
      if ((await Database.loadAllProjects()).isEmpty) {
        printerr(orange("No projects found."));

        return;
      }

      await Database.deleteAllProjects();

      print(green("All projects deleted successfully."));

      return;
    }

    final projectToDelete = argResults?.arguments.firstOrNull;

    if (projectToDelete == null) {
      printerr(red("Please provide a name for the project."));

      exit(1);
    }

    try {
      await Database.deleteProject(projectToDelete);

      print(green("Project deleted successfully."));
    } on ProjectNotExistingExeption catch (e) {
      printerr(red("Project not found: ${e.projectName}."));
    }
  }
}
