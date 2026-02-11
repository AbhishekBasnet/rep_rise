import 'package:rep_rise/domain/entity/steps/daily_step_entity.dart';
import 'package:rep_rise/domain/entity/steps/weekly_step_entity.dart';
import 'package:rep_rise/domain/repositories/step/step_repository.dart';

class GetWeeklyStepUsecase {

  final StepRepository stepRepository;
  GetWeeklyStepUsecase({required this.stepRepository});
  Future<List<WeeklyStepEntity>> execute() async{
    return await stepRepository.getWeeklySteps();
  }

}
