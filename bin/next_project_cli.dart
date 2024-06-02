import 'package:args/command_runner.dart';
import 'package:next_project_cli/next_project_cli.dart';

void main(List<String> arguments) async {
  // Initializes the config
  await Config.init();

  CommandRunner(
    "npcli",
    "A project management tool.",
  )
    ..addCommand(CreateProjectCommand())
    ..addCommand(AddCommand())
    ..addCommand(OpenCommand())
    ..addCommand(ListCommand())
    ..addCommand(DeleteCommand())
    ..run(arguments);
}
