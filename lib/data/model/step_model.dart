import '../../domain/entity/step_entity.dart';
import '../../core/util/date_formatter.dart';

class StepModel extends StepEntity {
  StepModel({required super.date, required super.stepCount});

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      date: json['date'],
      stepCount: json['step_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toBackendFormat,
      'step_count': stepCount,
    };
  }
}