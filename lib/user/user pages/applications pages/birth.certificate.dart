import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../reusable component/button.dart';
import '../../../reusable component/file.text.dart';
import '../../../reusable component/file_picking.dart';

class BirthCertificate extends StatefulWidget {
  const BirthCertificate({super.key});

  @override
  State<BirthCertificate> createState() {
    return BirthCertificateState();
  }
}

class BirthCertificateState extends State<BirthCertificate> {
  final Map<String, dynamic> _fileNames = {
    'fatherId': "No file selected",
    'motherId': "No file selected",
    'evidance': "No file selected",
    'marriageCertificate': "No file selected"
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
          "जन्म दाखला",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(10)),
            CustomAlignedText(
              text: 'वडिलांचे ओळखपत्र',
            ),
            FilePickerRow(
              fileName: _fileNames["fatherId"]!,
              onPickFile: () {
                _pickFile("fatherId");
              },
            ),
            CustomAlignedText(
              text: 'आईचे ओळखपत्र',
            ),
            FilePickerRow(
              fileName: _fileNames["motherId"]!,
              onPickFile: () {
                _pickFile("motherId");
              },
            ),
            CustomAlignedText(
              text: 'जन्म स्थान संबंधी पुरावा',
            ),
            FilePickerRow(
              fileName: _fileNames["evidance"]!,
              onPickFile: () {
                _pickFile("evidance");
              },
            ),
            CustomAlignedText(
              text: 'पालकांच्या लग्नाचे प्रमाणपत्र',
            ),
            FilePickerRow(
              fileName: _fileNames["marriageCertificate"]!,
              onPickFile: () {
                _pickFile("marriageCertificate");
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
