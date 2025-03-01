import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:digitalpanchayat/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../reusable component/button.dart';
import '../../../reusable component/file.text.dart';
import '../../../reusable component/file_picking.dart';

class DeathRegi extends StatefulWidget {
  final String token;
  const DeathRegi({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DeathRegiState();
  }
}

class DeathRegiState extends State<DeathRegi> {
  late String uname;
  late String mob;
  @override
  void initState() {
    super.initState();

    // Decode JWT token and extract the necessary fields
    try {
      Map<String, dynamic> jwtdecodetoken = JwtDecoder.decode(widget.token);
      uname = jwtdecodetoken['uname'];
      mob = jwtdecodetoken['mob'];
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
        _fileNames[key] = file.name;
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
      final url = Uri.parse("$BaseUrl/");

      // Prepare the request
      var request = http.MultipartRequest('POST', url);

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
              fileName: _fileNames["personId"]!,
              onPickFile: () {
                _pickFile("personId");
              },
            ),
            CustomAlignedText(
              text: 'मृत्यु नोंद मागणी अर्ज',
            ),
            FilePickerRow(
              fileName: _fileNames["application"]!,
              onPickFile: () {
                _pickFile("application");
              },
            ),
            CustomAlignedText(
              text: 'मृत व्यक्तीचा रहिवासी दाखला',
            ),
            FilePickerRow(
              fileName: _fileNames["recidence"]!,
              onPickFile: () {
                _pickFile("recidence");
              },
            ),
            CustomAlignedText(
              text: 'साक्षीदारचे आधार कार्ड ',
            ),
            FilePickerRow(
              fileName: _fileNames["witnessId"]!,
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
