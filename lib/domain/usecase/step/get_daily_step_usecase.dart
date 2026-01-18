import 'package:rep_rise/domain/entity/steps/step_entity.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';



class GetDailyStepUsecase {
  final StepRepository stepRepository;

  GetDailyStepUsecase(this.stepRepository);

  Future<StepEntity> execute () async{
    return await stepRepository.getDailySteps();
}
}