import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        _fileNames,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: ElevatedButton(
                        onPressed: _pickFile,
                        child: const Text("Pick a File"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
  

}
