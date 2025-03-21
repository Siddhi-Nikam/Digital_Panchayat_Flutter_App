import 'package:flutter/material.dart';

class Paymentsuccessed extends StatelessWidget {
  const Paymentsuccessed({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            size: 100,
            color: Colors.green,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Payment Successful..!",
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
