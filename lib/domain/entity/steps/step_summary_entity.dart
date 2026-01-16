import 'package:equatable/equatable.dart';

class StepSummaryEntity  extends Equatable{
  final int totalSteps;
  final int totalGoal;
  final int avgGoal;

  const StepSummaryEntity({
    required this.totalSteps,
    required this.totalGoal,
    required this.avgGoal,
});

  @override
  List<Object?> get props => [totalGoal,totalSteps,avgGoal];

}