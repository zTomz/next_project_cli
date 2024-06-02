import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:interact/interact.dart';
import 'package:next_project_cli/next_project_cli.dart';

class ListCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  @override
  final name = "list";
  @override
  final description =
      "List all projects. E. g. npcli list";

  @override
  Future<void> run() async {
    final projects = await Database.loadAllProjects();

    if (projects.isEmpty) {
      print(orange("No projects found."));
    } else {
      await _openProject(projects);
    }
  }

  Future<void> _openProject(List<Project> projects) async {
    final selection = Select(
      prompt: 'Choose a project',
      options: projects.map((project) => project.name).toList(),
    ).interact();

    final project = projects.firstWhere(
      (project) => project.name == projects[selection].name,
    );

    await listProject(project);
  }
}
