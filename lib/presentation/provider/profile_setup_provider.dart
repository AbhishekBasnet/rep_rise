import 'package:flutter/cupertino.dart';

class ProfileSetupProvider extends ChangeNotifier{
  int _age = 18;
  int get age => _age;

  void setAge(int newAge){
    _age= newAge;
    notifyListeners();
  }
}
