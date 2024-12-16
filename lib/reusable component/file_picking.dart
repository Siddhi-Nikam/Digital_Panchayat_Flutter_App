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
            BoxDecoration(color: const Color.fromARGB(255, 199, 228, 253)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.file_copy,
                color: Colors.grey.shade600,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  fileName,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 49, 46, 46)),
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
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 46, 43, 43)),
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
