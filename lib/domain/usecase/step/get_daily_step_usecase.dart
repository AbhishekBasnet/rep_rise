import 'package:rep_rise/domain/entity/steps/daily_step_entity.dart';
import 'package:rep_rise/domain/repositories/step/step_repository.dart';



class GetDailyStepUsecase {
  final StepRepository stepRepository;

  GetDailyStepUsecase({required this.stepRepository});

  Future<DailyStepEntity> execute () async{
    return await stepRepository.getDailySteps();
}
}