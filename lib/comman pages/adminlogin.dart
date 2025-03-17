import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:digitalpanchayat/config.dart';
import '../admin panel/admindashboard.dart';

class Adminlogin extends StatefulWidget {
  const Adminlogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminloginState();
  }
}

class _AdminloginState extends State<Adminlogin> {
  bool _obscureText = true;
  void showhide() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final adminController = TextEditingController();
  final adminpassController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Logged in successfully"),
    ));
  }

  void showErrorToast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Something went wrong"),
    ));
  }

  Future<void> adminlogin() async {
    if (adminController.text.isNotEmpty &&
        adminpassController.text.isNotEmpty) {
      var regbody = {
        "adminname": adminController.text, // Avoid spaces in JSON keys
        "password": adminpassController.text
      };

      try {
        var response = await http.post(
          Uri.parse('$BaseUrl/adminlogin'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody),
        );
        print(response);
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['status'] == true) {
          var mytoken = jsonResponse['token'];
          await prefs.setString('token', mytoken);
          showSuccessToast();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => admindashboard(token: mytoken),
            ),
          );
        } else {
          if (mounted) {
            showErrorToast();
          }
        }
      } catch (e) {
        if (mounted) {
          showErrorToast();
        }
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "प्रशासक लॉगिन",
                  style: TextStyle(
                      color: Color.fromARGB(255, 2, 115, 207),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: adminController,
                    decoration: InputDecoration(
                      labelText: "प्रशासक",
                      hintText: "प्रशासक नाव प्रविष्ट करा",
                      fillColor: Colors.white,
                      suffixIcon: const Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: adminpassController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "पासवर्ड",
                      hintText: "तुमचा पासवर्ड टाका",
                      suffixIcon: IconButton(
                        onPressed: showhide,
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: adminlogin,
                      child: const Text(
                        "लॉगिन",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
