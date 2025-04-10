import 'package:flutter/material.dart';
import 'userdrawer.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class userdashboard extends StatefulWidget {
  final String token;
  const userdashboard({required this.token, super.key});

  @override
  State<userdashboard> createState() {
    return userdashboardState();
  }
}

class userdashboardState extends State<userdashboard> {
  late String adhar;
  late String uname;
  late String mob;
  late String DOB;
  late String email;
  late String village;
  @override
  void initState() {
    super.initState();

    // Decode JWT token and extract the necessary fields
    try {
      Map<String, dynamic> jwtdecodetoken = JwtDecoder.decode(widget.token);
      adhar = jwtdecodetoken['adhar'];
      uname = jwtdecodetoken['uname'];
      mob = jwtdecodetoken['mob'];
      DOB = jwtdecodetoken['DOB'];
      email = jwtdecodetoken['email'];
      village = jwtdecodetoken['village'];
    } catch (e) {
      print('Token format is invalid: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 248, 249),
        appBar: AppBar(
          title: const Text(
            'वापरकर्ता डॅशबोर्ड',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: AppDrawer(
          token: widget.token,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 10,
                  right: 10,
                ),
                child: SizedBox(
                  height: 350,
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
                            const SizedBox(height: 10),
                            Text(
                              "नाव : $uname\nगाव : $village\nमोबाईल नंबर : $mob\nजन्मतारीख : ${DOB.split(' ')[0]}\nईमेल आयडी : $email",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
