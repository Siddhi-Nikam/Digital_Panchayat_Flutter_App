import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../reusable component/button.dart';
import '../../../reusable component/file_picking.dart';
import '../../outter pages/userdrawer.dart';
import 'package:http/http.dart' as http;

class RegiBirth extends StatefulWidget {
  final String token;
  const RegiBirth({super.key, required this.token});

  @override
  State<StatefulWidget> createState() {
    return RegiBirthState();
  }
}

class RegiBirthState extends State<RegiBirth> {
  final Map<String, dynamic> _fileNames = {
    'applicantId': "No file selected",
    'LC': "No file selected",
    'fatherId': "No file selected",
    'motherId': "No file selected",
    'hospitalCertificate': "No file selected",
    'parentAffidavit': "No file selected",
  };
  FilePickerResult? result; // Make the result nullable

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
      final url = Uri.parse("");

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
            "जन्म नोंदणी",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: AppDrawer(
          token: widget.token,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
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
                fileName: _fileNames["applicantId"]!,
                onPickFile: () {
                  _pickFile("applicantId");
                },
              ),
              //2
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("शाळा सोडल्याचा दाखला शाळा सोडल्याचा दाखला",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['LC']!,
                onPickFile: () {
                  _pickFile("LC");
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
                fileName: _fileNames["fatherId"]!,
                onPickFile: () {
                  _pickFile("fatherId");
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
                fileName: _fileNames['motherId']!,
                onPickFile: () {
                  _pickFile("motherId");
                },
              ),
              //5
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("जन्म झालेल्या रुग्णालयाचे प्रमाणपत्र",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['hospitalCertificate']!,
                onPickFile: () {
                  _pickFile('hospitalCertificate');
                },
              ),
              //6
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("जन्म रुग्णालयात झाला नसल्यास पालकांचे शपथपत्र",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              FilePickerRow(
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
