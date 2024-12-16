import 'package:flutter/material.dart';

class FilePickerRow extends StatelessWidget {
  final String fileName;
  final VoidCallback onPickFile;

  const FilePickerRow({
    super.key,
    required this.fileName,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 157, 196, 228)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  fileName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  onPressed: onPickFile,
                  child: const Text(
                    "फाइल निवडा",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
