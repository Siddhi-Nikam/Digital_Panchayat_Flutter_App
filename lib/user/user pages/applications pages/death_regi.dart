import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:digitalpanchayat/configs/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../firebase_api.dart';
import '../../../reusable component/button.dart';
import '../../../reusable component/file.text.dart';
import '../../../reusable component/file_picking.dart';

class DeathRegi extends StatefulWidget {
  final String token;
  const DeathRegi({
    super.key,
    required this.token,
  });

  @override
  State<StatefulWidget> createState() {
    return DeathRegiState();
  }
}

class DeathRegiState extends State<DeathRegi> {
  late String uname;
  late String mob;
  late String adhar;
  @override
  void initState() {
    super.initState();

    // Decode JWT token and extract the necessary fields
    try {
      Map<String, dynamic> jwtdecodetoken = JwtDecoder.decode(widget.token);
      uname = jwtdecodetoken['uname'];
      mob = jwtdecodetoken['mob'];
      adhar = jwtdecodetoken['adhar'];
    } catch (e) {
      print('Token format is invalid: $e');
    }
  }

  final Map<String, dynamic> _fileNames = {
    'personId': "No file selected",
    'application': "No file selected",
    'recidence': "No file selected",
    'witnessId': "No file selected"
  };

  FilePickerResult? result;
  // Function to pick a single file
  Future _pickFile(String key) async {
    result = await FilePicker.platform.pickFiles();

    if (result != null && result!.files.isNotEmpty) {
      PlatformFile file = result!.files.first;
      setState(() {
        _fileNames[key] = file.path;
      });
    } else {
      setState(() {
        _fileNames[key] = "No file selected";
      });
    }
  }

  Future<void> _sendPushNotification(
      String token, String title, String body) async {
    final url = Uri.parse("$BaseUrl/send-notification");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": token,
          "title": title,
          "body": body,
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully! $token ,$title, $body ");
      } else {
        print("Failed to send notification. Error: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  Future<void> _submitFiles() async {
    try {
      // API endpoint
      final url = Uri.parse("$BaseUrl/deathCertificate");

      // Prepare the request
      var request = http.MultipartRequest('POST', url);

      request.fields['uname'] = uname;
      request.fields['mob'] = mob;
      request.fields["addedBy"] = adhar;

      // Add files to the request
      for (var entry in _fileNames.entries) {
        if (entry.value != "No file selected") {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value),
          );
        }
      }
      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        String? fcmToken = await FirebaseApi().getFCMToken();
        if (fcmToken != null) {
          _sendPushNotification(
            fcmToken,
            "मृत्यू नोंदणी अर्ज यशस्वी",
            "तुमचा अर्ज यशस्वीरित्या सबमिट झाला आहे.दाखला मिळविण्यासाठी ग्रामपंचायतीच्या संपर्कात रहा.",
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text("Request Failed"),
        ));
        print("Failed to upload files. Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error while submitting files: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "मृत्यू नोंदणी",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "अर्जदाराचे नाव",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                enabled: false,
                readOnly: true,
                initialValue: uname,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: uname,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "अर्जदाराचा मोबाईल नंबर",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true,
                enabled: false,
                initialValue: mob,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: mob,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            CustomAlignedText(
              text: 'मृत व्यक्तीचे आधार कार्ड',
            ),
            FilePickerRow(
              fileName: _fileNames["personId"],
              onPickFile: () {
                _pickFile("personId");
              },
            ),
            CustomAlignedText(
              text: 'मृत्यु नोंद मागणी अर्ज',
            ),
            FilePickerRow(
              fileName: _fileNames["application"],
              onPickFile: () {
                _pickFile("application");
              },
            ),
            CustomAlignedText(
              text: 'मृत व्यक्तीचा रहिवासी दाखला',
            ),
            FilePickerRow(
              fileName: _fileNames["recidence"],
              onPickFile: () {
                _pickFile("recidence");
              },
            ),
            CustomAlignedText(
              text: 'साक्षीदारचे आधार कार्ड ',
            ),
            FilePickerRow(
              fileName: _fileNames["witnessId"],
              onPickFile: () {
                _pickFile("witnessId");
              },
            ),
            btn(
              text: 'सबमिट करा',
              onPressed: () {
                _submitFiles();
              },
              bg_color: Colors.blue,
              textcolor: Colors.white,
              fontSize: 25,
            ),
          ],
        ),
      ),
    );
  }
}
