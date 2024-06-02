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
  final description = "List all projects.";

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

    // TODO: Open the project
    final project = projects.firstWhere(
      (project) => project.name == projects[selection].name,
    );

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
}
