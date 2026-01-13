
import 'package:flutter/foundation.dart';

class StepsProvider extends ChangeNotifier{
  final int _totalDailySteps = 0;
  final int _walkedDailySteps = 0;
  final int _percentage =  1;


  int get percentage => _percentage;
  int get totalDailySteps => _totalDailySteps;
  int get walkedDailySteps => _walkedDailySteps;

}