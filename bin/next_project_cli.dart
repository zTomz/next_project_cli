import 'package:args/command_runner.dart';
import 'package:next_project_cli/next_project_cli.dart';
import 'package:next_project_cli/src/commands/add_command.dart';
import 'package:next_project_cli/src/commands/create_project_command.dart';
import 'package:next_project_cli/src/commands/delete_command.dart';
import 'package:next_project_cli/src/commands/list_command.dart';

void main(List<String> arguments) async {
  // Initializes the config
  await Config.init();

  CommandRunner(
    "npcli",
    "A project management tool.",
  )
    ..addCommand(CreateProjectCommand())
    ..addCommand(AddCommand())
    ..addCommand(ListCommand())
    ..addCommand(DeleteCommand())
    ..run(arguments);
}
