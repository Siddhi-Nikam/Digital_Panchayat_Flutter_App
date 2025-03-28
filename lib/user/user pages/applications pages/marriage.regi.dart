import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:digitalpanchayat/configs/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../firebase_api.dart';
import '../../../reusable component/button.dart';
import '../../../reusable component/file_picking.dart';

class Marriage_regi extends StatefulWidget {
  final String token;
  const Marriage_regi({
    super.key,
    required this.token,
  });

  @override
  State<StatefulWidget> createState() {
    return Marriage_regiState();
  }
}

class Marriage_regiState extends State<Marriage_regi> {
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

  final Map<String, dynamic> _fileNames = {
    'husbandphoto': "No file selected",
    'wifephoto': "No file selected",
    'husbandId': "No file selected",
    'wifeId': "No file selected",
    'husbandLC': "No file selected",
    'wifeLC': "No file selected",
    'witness1': "No file selected",
    'witness1ID': "No file selected",
    'witness2': "No file selected",
    'witness2ID': "No file selected",
    'witness3': "No file selected",
    'witness3ID': "No file selected",
    'invitation': "No file selected",
    'weddingphoto': "No file selected",
    'application': "No file selected",
  };
  FilePickerResult? result; // Make the result nullable

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
      final url = Uri.parse("$BaseUrl/marriagecertificate");

      // Prepare the request
      var request = http.MultipartRequest('POST', url);
      request.fields['applicationId'] = applicationId;
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
            "विवाह नोंदणी अर्ज यशस्वी",
            "तुमचा अर्ज यशस्वीरित्या सबमिट झाला आहे.दाखला मिळविण्यासाठी ग्रामपंचायतीच्या संपर्कात रहा.",
          );
        }
      } else {
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
            "विवाह नोंदणी",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                    "वर फोटो",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames["husbandphoto"]!,
                onPickFile: () {
                  _pickFile("husbandphoto");
                },
              ),
              //2
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("वधू फोटो",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['wifephoto']!,
                onPickFile: () {
                  _pickFile("wifephoto");
                },
              ),
              //3
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("वर चे आधार कार्ड",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames["husbandId"]!,
                onPickFile: () {
                  _pickFile("husbandId");
                },
              ),
              //4
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("वधू चे आधार कार्ड",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['wifeId']!,
                onPickFile: () {
                  _pickFile("wifeId");
                },
              ),
              //5
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("वरचा शाळा सोडल्याचा दाखला  ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['husbandLC']!,
                onPickFile: () {
                  _pickFile('husbandLC');
                },
              ),
              //6
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("वधूचा शाळा सोडल्याचा दाखला ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['wifeLC']!,
                onPickFile: () {
                  _pickFile('wifeLC');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("लग्नात उपस्थित असलेले 3 साक्षीदार",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("साक्षीदार 1 फोटो ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['witness1']!,
                onPickFile: () {
                  _pickFile('witness1');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("साक्षीदारचे आधार कार्ड",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['witness1ID']!,
                onPickFile: () {
                  _pickFile('witness1ID');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("साक्षीदार 2 फोटो",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['witness2']!,
                onPickFile: () {
                  _pickFile('witness2');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("साक्षीदारचे आधार कार्ड",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['witness2ID']!,
                onPickFile: () {
                  _pickFile('witness2ID');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("साक्षीदार 3 फोटो",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['witness3']!,
                onPickFile: () {
                  _pickFile('witness3');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("साक्षीदारचे आधार कार्ड",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['witness3ID']!,
                onPickFile: () {
                  _pickFile('witness3ID');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("लग्नपत्रिका",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['invitation']!,
                onPickFile: () {
                  _pickFile('invitation');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("लग्नाचा ब्राह्मण सोबत फोटो",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['weddingphoto']!,
                onPickFile: () {
                  _pickFile('weddingphoto');
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("विवाह नोंदणी अर्ज",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['application']!,
                onPickFile: () {
                  _pickFile('application');
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
        ));
  }
}
