import 'package:flutter/material.dart';


class StepsScreen extends StatelessWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Steps Screen!'),
      ),
    );
  }

}
