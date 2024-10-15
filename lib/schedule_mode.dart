class Schedule {
  final String title;
  final DateTime start;
  final DateTime end;

  Schedule({
    required this.title,
    required this.start,
    required this.end,
  });

  // Factory method to create a Schedule from JSON
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      title: json['title'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }
}
