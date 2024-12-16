import 'package:flutter/material.dart';

class MarriageRegi extends StatefulWidget {
  const MarriageRegi({super.key});

  @override
  State<MarriageRegi> createState() {
    return MarriageRegiState();
  }
}

class MarriageRegiState extends State<MarriageRegi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "जन्म नोंदणी",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
