import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../reusable component/button.dart';
import '../../../reusable component/file_picking.dart';

class Niradhar extends StatefulWidget {
  final String token;
  const Niradhar({required this.token, super.key});
  @override
  _NiradharState createState() => _NiradharState();
}

class _NiradharState extends State<Niradhar> {
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
    'application': "No file selected",
    'family head death certificate': "No file selected",
    'adhar card': "No file selected",
    'ration card': "No file selected",
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
              //1
              Padding(padding: EdgeInsets.only(top: 10)),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "अर्जदाराचे ओळखपत्र",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames["application"]!,
                onPickFile: () {
                  _pickFile("application");
                },
              ),
              //2
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("शाळा सोडल्याचा दाखला ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['family head death certificate']!,
                onPickFile: () {
                  _pickFile("family head death certificate");
                },
              ),
              //3
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("वडिलांचे ओळखपत्र",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames["adhar card"]!,
                onPickFile: () {
                  _pickFile("adhar card");
                },
              ),
              //4
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("आईचे ओळखपत्र",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['ration card']!,
                onPickFile: () {
                  _pickFile("ration card");
                },
              ),

              btn(
                text: 'सबमिट करा',
                onPressed: () {
                  // _submitFiles();
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
