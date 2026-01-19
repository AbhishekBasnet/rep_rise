import 'package:flutter/cupertino.dart';

enum Gender { male, female }

/*
 * Manages the state and navigation logic for the multi-step Profile Setup Wizard.
 *
 * Architecture & Responsibilities:
 * --------------------------------
 * 1. Transient Data Accumulation:
 * - Acts as a temporary holding area for profile attributes (Age, Weight, etc.)
 * as the user progresses through the wizard steps. This data is not committed
 * to the backend until the final submission step (handled by AuthProvider).
 *
 * 2. Navigation Control:
 * - Encapsulates the `PageController` to synchronize the UI (`PageView`) with
 * the business logic.
 * - Manages the `_currentPage` index to drive UI elements like progress bars
 * or "Next/Finish" button labels.
 *
 * Usage:
 * - This provider should be scoped to the Profile Setup route to ensure
 * state is reset when the wizard is exited or completed.
 */

class RegisterProfileProvider extends ChangeNotifier {
  int _age = 25;
  int _goalSteps = 5000;
  Gender _gender = Gender.male;
  int _weight = 50;
  int _height = 150;
  int _currentPage = 0;

  int get goalSteps => _goalSteps;
  Gender get gender => _gender;
  int get weight => _weight;
  int get height => _height;
  int get age => _age;

  int get currentPage => _currentPage;
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  bool get isLastPage => _currentPage == 4;

  void setGoalSteps(int goalSteps) {
    _goalSteps = goalSteps;
    notifyListeners();
  }

  void setGender(Gender gender) {
    _gender = gender;
    notifyListeners();
  }

  void setWeight(int weight) {
    _weight = weight;
    notifyListeners();
  }

  void setHeight(int height) {
    _height = height;
    notifyListeners();
  }

  void setAge(int newAge) {
    _age = newAge;
    notifyListeners();
  }

  void setPage(int currentPage) {
    _currentPage = currentPage;
    notifyListeners();
  }

  void goToNextPage() {
    if (!isLastPage) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    _currentPage++;
    notifyListeners();
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    _currentPage--;
    notifyListeners();
  }

  /// Synchronizes internal state when the user swipes the PageView manually.
  ///
  /// Must be assigned to the `onPageChanged` callback of the [PageView] widget.
  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
