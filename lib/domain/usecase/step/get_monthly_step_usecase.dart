import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';

class GetMonthlyStepUsecase {
  final StepRepository stepRepository;
  GetMonthlyStepUsecase({required this.stepRepository});
  Future<StepSummaryEntity> execute(int year,int month) async {
    return await stepRepository.getMonthlyStats(year, month);
  }
}
