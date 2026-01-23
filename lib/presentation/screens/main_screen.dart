import 'package:flutter/material.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/home_screen.dart';
import 'package:rep_rise/presentation/screens/nav_bar/main_app_bar/main_app_bar.dart';
import 'package:rep_rise/presentation/screens/nav_bar/steps/steps_screen.dart';
import 'package:rep_rise/presentation/screens/nav_bar/workout/workout_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), //Workout
    GlobalKey<NavigatorState>(), //Steps
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // android ko back button lae directly exit gardaina
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Try to pop the current tab's navigator first
        final NavigatorState? currentNavigator = navigatorKeys[_selectedIndex].currentState;
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
        } else {
          // If the tab is at the root, choose to exit or switch to home tab
          if (_selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
          }
        }
      },
      child: Scaffold(
        appBar: const MainAppBar(),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildNavigator(0, const HomeScreen()),
            _buildNavigator(1, const WorkoutScreen()),
            _buildNavigator(2, const StepsScreen()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
            BottomNavigationBarItem(icon: Icon(Icons.snowshoeing), label: 'Steps'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigator(int index, Widget rootPage) {
    return Navigator(
      key: navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            //TODO: can add a switch statement here for sub-pages in this tab
            return rootPage;
          },
        );
      },
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('    STACK: Pushed ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('    STACK: Popped ${route.settings.name}');
  }
}
