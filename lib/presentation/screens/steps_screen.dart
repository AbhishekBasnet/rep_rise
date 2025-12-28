import 'package:flutter/material.dart';


class StepsScreen extends StatelessWidget {
  const StepsScreen({super.key});

  // void test(){
  //   return  Navigator.push(context,  MaterialPageRoute(builder: (context) => const UpdateStepsTest();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steps Screen')),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to the Steps Screen!'),
            ElevatedButton(onPressed: () {

            },
                child: const Text('Test api')),
          ],
        ),
      ),
    );
  }
}
