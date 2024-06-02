import 'package:json/json.dart';
import 'package:next_project_cli/next_project_cli.dart';

@JsonCodable()
class Task {
  final String content;
  bool completed;
  Date lastUpdated;

  Task({
    required this.content,
    required this.completed,
    required this.lastUpdated,
  });

  Task.fromContent(String content)
      : this(
          content: content,
          completed: false,
          lastUpdated: Date.now(),
        );
        
  /// Sets the value of the `completed` property to the given `value`.
  ///
  /// The `value` parameter is a boolean that indicates whether the task is completed or not.
  ///
  /// Additionally, this function updates the `lastUpdated` property with the current date and time.
  ///
  /// This function does not return any value.
  void set(bool value) {
    completed = value;
    lastUpdated = Date.now();
  }

  @override
  String toString() {
    return 'Task(content: $content, completed: $completed, lastUpdated: $lastUpdated)';
  }
}
