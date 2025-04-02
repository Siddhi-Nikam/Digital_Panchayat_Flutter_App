import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import '../../../configs/config.dart';
import '../../../firebase_api.dart';
import '../../../reusable component/button.dart';
import '../../../reusable component/file_picking.dart';

class utaraPage extends StatefulWidget {
  final String token;
  const utaraPage({required this.token, super.key});
  @override
  _utaraPageState createState() => _utaraPageState();
}

class _utaraPageState extends State<utaraPage> {
  late String uname;
  late String mob;
  late String adhar;
  late final String applicationId =
      DateTime.now().millisecondsSinceEpoch.toString();
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
        String? fcmToken = await FirebaseApi().getFCMToken();
        if (fcmToken != null) {
          _sendPushNotification(
            fcmToken,
            "8A उतारा अर्ज यशस्वी",
            "तुमचा अर्ज यशस्वीरित्या सबमिट झाला आहे.दाखला मिळविण्यासाठी ग्रामपंचायतीच्या संपर्कात रहा.",
          );
        }
      } else {
        print("Failed to send notification. Error: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  final Map<String, dynamic> _fileNames = {
    'seventwelve': "No file selected",
    'purchaseletter': "No file selected",
    'stamppaper': "No file selected",
    'permissionletter': "No file selected",
  };
  FilePickerResult? result; // Make the result nullable

  // Function to pick a single file
  Future _pickFile(String key) async {
    result = await FilePicker.platform.pickFiles();

    if (result != null && result!.files.isNotEmpty) {
      PlatformFile file = result!.files.first;
      print("Selected file path: ${file.path}"); // Debugging: Log the file path

      setState(() {
        _fileNames[key] = file.path ?? "No file selected";
      });
    } else {
      setState(() {
        _fileNames[key] = "No file selected";
      });
    }
  }

  Future<void> _submitFiles() async {
    try {
      // API endpoint
      final url = Uri.parse("$BaseUrl/eightAcertificate");

      // Prepare the request
      var request = http.MultipartRequest('POST', url);
      request.fields['applicationId'] = applicationId;
      request.fields['uname'] = uname;
      request.fields['mob'] = mob;
      request.fields['addedBy'] = adhar;

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
        print("Files uploaded successfully!");
        String? fcmToken = await FirebaseApi().getFCMToken();
        if (fcmToken != null) {
          _sendPushNotification(
            fcmToken,
            "जन्म दाखला अर्ज यशस्वी",
            "तुमचा अर्ज यशस्वीरित्या सबमिट झाला आहे.दाखला मिळविण्यासाठी ग्रामपंचायतीच्या संपर्कात रहा.",
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text("Request submitted successfully"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text("Error while submitting"),
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
        title: Text('8A उतारा', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  enabled: false,
                  initialValue: applicationId,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "ApplicationId",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              //1
              Padding(padding: EdgeInsets.only(top: 10)),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "7/12 उतारा",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames["seventwelve"],
                onPickFile: () {
                  _pickFile("seventwelve");
                },
              ),
              //2
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("खरेदी पत्र / बक्षीस पत्र",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['purchaseletter'],
                onPickFile: () {
                  _pickFile("purchaseletter");
                },
              ),
              //3
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("चतुर सीमा (100 रुपयांचा बॉन्ड पेपर)",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames["stamppaper"],
                onPickFile: () {
                  _pickFile("stamppaper");
                },
              ),
              //4
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("आणेवारी संमती पत्र",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['permissionletter'],
                onPickFile: () {
                  _pickFile("permissionletter");
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
      ),
    );
  }
}
