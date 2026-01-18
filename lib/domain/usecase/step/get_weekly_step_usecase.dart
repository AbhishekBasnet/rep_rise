import 'package:rep_rise/domain/entity/steps/step_entity.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';

class GetWeeklyStepUsecase {

  final StepRepository stepRepository;
  GetWeeklyStepUsecase(this.stepRepository);
  Future<List<StepEntity>> execute() async{
    return await stepRepository.getWeeklySteps();
  }

}
