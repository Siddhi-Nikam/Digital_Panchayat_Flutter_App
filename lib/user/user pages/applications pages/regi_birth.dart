import 'package:digitalpanchayat/configs/config.dart';
import 'package:digitalpanchayat/firebase_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../reusable component/button.dart';
import '../../../reusable component/file_picking.dart';

class RegiBirth extends StatefulWidget {
  final String token;

  const RegiBirth({
    super.key,
    required this.token,
  });

  @override
  State<StatefulWidget> createState() {
    return RegiBirthState();
  }
}

class RegiBirthState extends State<RegiBirth> {
  late String uname;
  late String mob;
  late String adhar;

  @override
  void initState() {
    super.initState();
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
    'applicantId': "No file selected",
    'LC': "No file selected",
    'fatherId': "No file selected",
    'motherId': "No file selected",
    'hospitalCertificate': "No file selected",
    'parentAffidavit': "No file selected",
  };

  FilePickerResult? result;

  Future<void> _pickFile(String key) async {
    result = await FilePicker.platform.pickFiles();

    if (result != null && result!.files.isNotEmpty) {
      PlatformFile file = result!.files.first;
      setState(() {
        _fileNames[key] = file.path ?? "No file selected";
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
      final url = Uri.parse("$BaseUrl/registerbirth");

      var request = http.MultipartRequest('POST', url);
      request.fields['uname'] = uname;
      request.fields['mob'] = mob;
      request.fields["addedBy"] = adhar;

      for (var entry in _fileNames.entries) {
        if (entry.value != "No file selected") {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value),
          );
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text("Request submitted successfully"),
        ));

        // Get the FCM token and send push notification
        String? fcmToken = await FirebaseApi().getFCMToken();
        if (fcmToken != null) {
          _sendPushNotification(
            fcmToken,
            "जन्म नोंदणी यशस्वी",
            "तुमचा अर्ज यशस्वीरित्या सबमिट झाला आहे.दाखला मिळविण्यासाठी ग्रामपंचायतीच्या संपर्कात रहा.",
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error while submitting"),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Error while submitting"),
      ));
      print("Error while submitting: $e");
    }
  }

  void showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "जन्म नोंदणी",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              readOnly: true,
              initialValue: uname,
              decoration: InputDecoration(
                labelText: uname,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              initialValue: mob,
              decoration: InputDecoration(
                labelText: mob,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _buildFilePickerRow("अर्जदाराचे ओळखपत्र", "applicantId"),
            _buildFilePickerRow("शाळा सोडल्याचा दाखला", "LC"),
            _buildFilePickerRow("वडिलांचे ओळखपत्र", "fatherId"),
            _buildFilePickerRow("आईचे ओळखपत्र", "motherId"),
            _buildFilePickerRow(
                "रुग्णालयाचे प्रमाणपत्र", "hospitalCertificate"),
            _buildFilePickerRow("शपथपत्र", "parentAffidavit"),
            const SizedBox(height: 20),
            btn(
              text: 'सबमिट करा',
              onPressed: () {
                _submitFiles();
              },
              bg_color: Colors.blue,
              textcolor: Colors.white,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePickerRow(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FilePickerRow(
          fileName: _fileNames[key]!,
          onPickFile: () {
            _pickFile(key);
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
