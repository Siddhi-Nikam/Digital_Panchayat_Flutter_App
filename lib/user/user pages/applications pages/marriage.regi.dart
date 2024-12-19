import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../reusable component/button.dart';
import '../../../reusable component/file_picking.dart';

class Marriage_regi extends StatefulWidget {
  const Marriage_regi({super.key});

  @override
  State<StatefulWidget> createState() {
    return Marriage_regiState();
  }
}

class Marriage_regiState extends State {
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
                  child: Text("वधू फोटो",
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
                  child: Text("वर चे आधार कार्ड",
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
                  child: Text("वधू चे आधार कार्ड",
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
                  child: Text("वरचा शाळा सोडल्याचा दाखला  ",
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
                  child: Text("वधूचा शाळा सोडल्याचा दाखला ",
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
                fileName: _fileNames['parentAffidavit']!,
                onPickFile: () {
                  _pickFile('parentAffidavit');
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
        ));
  }
}
