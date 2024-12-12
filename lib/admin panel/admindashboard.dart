import 'package:flutter/material.dart';

import 'admindrawer.dart';

class admindashboard extends StatefulWidget {
  const admindashboard({super.key, required token});

  @override
  State<StatefulWidget> createState() {
    return admindashboardState();
  }
}

class admindashboardState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'प्रशासक डॅशबोर्ड',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          left: 10,
          right: 10,
        ),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Card(
              elevation: 10.0,
              shadowColor: Colors.black,
              color: Colors.blue,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey.shade800,
                            size: 50,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Users Count : 5000",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ))),
        ),
      ),
    );
  }
}
