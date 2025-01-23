import 'dart:convert';
import 'dart:io';
import 'package:digitalpanchayat/user/outter%20pages/userdrawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class issue extends StatefulWidget {
  final String token;
  const issue({super.key, required this.token});

  @override
  State<StatefulWidget> createState() {
    return _ServiceState();
  }
}

class _ServiceState extends State<issue> {
  File? _image;
  final issue_title = TextEditingController();
  final issue_desp = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
      });
    }
  }

  void showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Sended successfully"),
    ));
  }

  void showerrortoast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Something went wrong"),
    ));
  }

  Future send_issue() async {
    try {
      var regbody = {
        "title": issue_title.text,
        "descp": issue_desp.text,
        "image": _image.toString()
      };
      var response = await http.post(
        Uri.parse('http://10.0.2.2:4000/createIssue'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regbody),
      );
      print(regbody);
      // Handle the response
      if (response.statusCode == 200) {
        print('issue added successfully');
        showSuccessToast();
      } else {
        showerrortoast();
        print('Failed to add: ${response.body}');
      }
    } catch (err) {
      print("Response error : $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "समस्या",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: AppDrawer(
          token: widget.token,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'समस्या',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: issue_title,
                  decoration: InputDecoration(
                    label: const Text(
                      "समस्या शीर्षक",
                      style: TextStyle(color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: "समस्या शीर्षक..",
                  ),
                ),
                const SizedBox(height: 20),
                const Text('समस्येचे वर्णन',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  child: TextField(
                    controller: issue_desp,
                    decoration: InputDecoration(
                      label: const Text(
                        "समस्येचे वर्णन",
                        style: TextStyle(color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "समस्येचे वर्णन..",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        send_issue();
                        issue_desp.clear();
                        issue_title.clear();
                      },
                      child: const Text(
                        "पाठवा",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
