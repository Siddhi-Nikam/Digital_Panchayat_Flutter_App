import 'package:flutter/material.dart';

import 'admindrawer.dart';

class PaidTax extends StatefulWidget {
  const PaidTax({super.key});

  @override
  State<StatefulWidget> createState() {
    return PaidTaxState();
  }
}

class PaidTaxState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("कर", style: TextStyle(color: Colors.white)),
      ),
      drawer: const AdminDrawer(),
    );
  }
}
