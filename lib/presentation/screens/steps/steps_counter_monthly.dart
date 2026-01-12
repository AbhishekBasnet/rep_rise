import 'package:flutter/material.dart';

class StepsCounterMonthly extends StatelessWidget {
  const StepsCounterMonthly({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Matching your other cards
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_walk,
                color: Colors.purpleAccent,
                size: 28,
              ),
              SizedBox(width: 10),

              Text(
                "256,480",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          Text(
            "Total steps this month",

          ),
        ],
      ),
    );
  }
}
