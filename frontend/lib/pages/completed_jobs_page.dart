import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CompletedJobsPage extends StatefulWidget {
  const CompletedJobsPage({Key? key}) : super(key: key);

  @override
  State<CompletedJobsPage> createState() => _CompletedJobsPageState();
}

class _CompletedJobsPageState extends State<CompletedJobsPage> {
  List<Image> _images = [];

  Future<void> getAllImages() async {
    Directory directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = directory.listSync();
    if (_images.isNotEmpty) return;
    for (FileSystemEntity file in files) {
      if (file is File && file.path.endsWith(".webp")) {
        setState(() {
          _images.add(Image.file(file));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAllImages();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: _images)));
  }
}
