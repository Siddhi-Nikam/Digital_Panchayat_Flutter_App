import 'package:flutter/material.dart';

import '../admindrawer.dart';

class applications extends StatefulWidget {
  const applications({super.key});

  @override
  State<StatefulWidget> createState() {
    return applicationsState();
  }
}

class applicationsState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title:
            const Text("Applications", style: TextStyle(color: Colors.white)),
      ),
      drawer: const AdminDrawer(),
    );
  }
}
