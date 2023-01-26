import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/utils/json_response_handler.dart';

class NewJobsPage extends StatefulWidget {
  const NewJobsPage({Key? key}) : super(key: key);

  @override
  State<NewJobsPage> createState() => _NewJobsPageState();
}

class _NewJobsPageState extends State<NewJobsPage> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _negativePromptController =
      TextEditingController();
  final TextEditingController _seedController = TextEditingController();

  List<ActiveModel> _activeModels = [];
  JSONResponseHandler handler = JSONResponseHandler();

  @override
  void initState() {
    super.initState();
    _seedController.text =
        (pow(2, 48) * Random().nextDouble()).toStringAsFixed(0);
    handler.getActiveModels().then((value) {
      setState(() {
        _activeModels = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Container pageContents = Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                  label: Text("Prompt"), border: OutlineInputBorder()),
              maxLines: null,
              minLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _negativePromptController,
              decoration: const InputDecoration(
                  label: Text("Negative prompts"),
                  border: OutlineInputBorder()),
              maxLines: 1,
            ),
            const SizedBox(height: 12),
            FractionallySizedBox(
                widthFactor: 0.5,
                child: TextField(
                  controller: _seedController,
                  decoration: const InputDecoration(
                      label: Text("Seed"), border: OutlineInputBorder()),
                  maxLines: 1,
                )),
            const SizedBox(height: 12),
            const Text("Active Models"),
            _activeModels.isNotEmpty
                ? DropdownButton<String>(
                    onChanged: (item) {},
                    value: "stable_diffusion",                    
                    items: _activeModels.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                          child: Text(e.toString()),
                          value: e.name);
                    }).toList())
                : const Text("None")
          ],
        ));
    return SingleChildScrollView(child: pageContents);
  }
}
