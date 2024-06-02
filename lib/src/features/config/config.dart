import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as path;

// ignore: avoid_classes_with_only_static_members
abstract final class Config {
  static late Directory databaseDirectory;

  /// Initializes the config of next_project_cli.
  static Future<void> init() async {
    databaseDirectory = Directory(path.join(HOME, 'next_project_cli'));

    if (!await databaseDirectory.exists()) {
      databaseDirectory.createSync(recursive: true);
    }
  }
}
