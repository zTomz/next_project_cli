import 'package:json/json.dart';

@JsonCodable()
class Date {
  final int year;
  final int month;
  final int day;

  final int hour;
  final int minute;
  final int second;

  Date({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
  });

  factory Date.now() {
    final date = DateTime.now();

    return Date(
      year: date.year,
      month: date.month,
      day: date.day,
      hour: date.hour,
      minute: date.minute,
      second: date.second,
    );
  }

  @override
  String toString() {
    return 'Date(year: $year, month: $month, day: $day, hour: $hour, minute: $minute, second: $second)';
  }
}
