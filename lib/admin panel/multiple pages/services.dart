import 'dart:convert';

import 'package:digitalpanchayat/configs/config.dart';
import 'package:flutter/material.dart';
import '../admindrawer.dart';
import 'package:http/http.dart' as http;

class services extends StatefulWidget {
  const services({super.key});

  @override
  State<StatefulWidget> createState() {
    return serviceState();
  }
}

class serviceState extends State<services> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _decsrpcontroller = TextEditingController();
  void showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text(
        "service added successfully",
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  void showerrortoast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text(
        "Something went wrong",
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  Future<dynamic> service_send() async {
    try {
      // Changed to proceed if valid
      var regbody = {
        "title": _titlecontroller.text,
        "descp": _decsrpcontroller.text
      };

      var response = await http.post(
        Uri.parse("$BaseUrl/createService"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regbody),
      );
      print(regbody);
      // Handle the response
      if (response.statusCode == 200) {
        print('instruction added successfully');
        showSuccessToast();
      } else {
        showerrortoast();
        print('Failed to add: ${response.body}');
      }
    } catch (e) {
      print('failed to load: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("सेवा", style: TextStyle(color: Colors.white)),
      ),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  textAlign: TextAlign.left,
                  "Title of Instruction",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _titlecontroller,
                  maxLines: null,
                  decoration: InputDecoration(
                    label: const Text('Service title'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: "Enter title...",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Description of Service",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _decsrpcontroller,
                  maxLines: null,
                  decoration: InputDecoration(
                    label: const Text('Describe Instruction'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: "Enter description...",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        service_send();
                        _titlecontroller.clear();
                        _decsrpcontroller.clear();
                      },
                      child: const Text(
                        "Send",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
