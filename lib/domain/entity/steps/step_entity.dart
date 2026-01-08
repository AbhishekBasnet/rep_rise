class StepEntity {
  final DateTime date;
  final int steps;
  final int? goal;
  final String? dayName;


  const StepEntity({
    required this.date,
    required this.steps, this.goal, this.dayName,
  });
}