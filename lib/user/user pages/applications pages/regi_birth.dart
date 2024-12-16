import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../reusable component/button.dart';
import '../../../reusable component/file_picking.dart';
import '../../outter pages/userdrawer.dart';

class RegiBirth extends StatefulWidget {
  final String token;
  const RegiBirth({super.key, required this.token});

  @override
  State<StatefulWidget> createState() {
    return RegiBirthState();
  }
}

class RegiBirthState extends State<RegiBirth> {
  String _fileNames = "No file selected";
  FilePickerResult? result; // Make the result nullable

  // Function to pick a single file
  Future _pickFile() async {
    result = await FilePicker.platform.pickFiles();

    if (result != null && result!.files.isNotEmpty) {
      PlatformFile file = result!.files.first;
      setState(() {
        _fileNames = file.name;
      });
    } else {
      setState(() {
        _fileNames = "No file selected";
      });
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
                fileName: _fileNames,
                onPickFile: () {
                  _pickFile();
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
                fileName: _fileNames,
                onPickFile: () {
                  _pickFile();
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
                fileName: _fileNames,
                onPickFile: () {
                  _pickFile();
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
                fileName: _fileNames,
                onPickFile: () {
                  _pickFile();
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
                fileName: _fileNames,
                onPickFile: () {
                  _pickFile();
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
                fileName: _fileNames,
                onPickFile: () {
                  _pickFile();
                },
              ),

              btn(
                text: 'सबमिट करा',
                onPressed: () {},
                bg_color: Colors.blue,
                textcolor: Colors.white,
                fontSize: 25,
              ),
            ],
          ),
        ));
  }
}
