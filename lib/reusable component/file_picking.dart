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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            fileName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: ElevatedButton(
            onPressed: onPickFile,
            child: const Text("Pick a File"),
          ),
        ),
      ],
    );
  }
}
