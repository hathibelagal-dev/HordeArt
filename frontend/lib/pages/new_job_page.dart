import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/utils/json_response_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config.dart';
import '../db.dart';
import '../models/active_model.dart';

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

  String _selectedModel = Config.defaultModel;
  String _selectedSampler = Config.defaultSampler;
  String _selectedPostProcessor = Config.defaultPostProcessor;

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

  final SnackBar successBar = const SnackBar(
    content: Text('Job submitted successfully.'),
    backgroundColor: Colors.green,
  );

  final SnackBar errorBar = const SnackBar(
    content: Text('Job could not be submitted.'),
    backgroundColor: Colors.amber,
  );

  @override
  Widget build(BuildContext context) {
    Container pageContents = Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
                valueListenable: DB.getDB().listenable(),
                builder: (context, box, widget) {
                  return DB.getValue("API_KEY",
                              defaultValue: Config.defaultAPIKey) ==
                          Config.defaultAPIKey
                      ? Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.all(8.0),
                          color: Colors.yellow.shade400,
                          child: const Text(
                              "You're currently using the horde anonymously. "
                              "If you have an API key, please go to Settings and enter it there."),
                        )
                      : const Center();
                }),
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
                    onChanged: (item) {
                      setState(() {
                        _selectedModel = item ?? _selectedModel;
                      });
                    },
                    value: _selectedModel,
                    items: _activeModels.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                        value: e.name,
                        child: Text(e.toString()),
                      );
                    }).toList())
                : const Text("None"),
            const SizedBox(height: 12),
            const Text("Sampler Name"),
            DropdownButton<String>(
                onChanged: (item) {
                  setState(() {
                    _selectedSampler = item ?? _selectedSampler;
                  });
                },
                value: _selectedSampler,
                items:
                    Config.availableSamplers.map<DropdownMenuItem<String>>((s) {
                  return DropdownMenuItem<String>(value: s, child: Text(s));
                }).toList()),
            const Text("Post processing"),
            DropdownButton<String>(
                onChanged: (item) {
                  setState(() {
                    _selectedPostProcessor = item ?? _selectedPostProcessor;
                  });
                },
                value: _selectedPostProcessor,
                items: Config.availablePostProcessors
                    .map<DropdownMenuItem<String>>((s) {
                  return DropdownMenuItem<String>(value: s, child: Text(s));
                }).toList()),
            const SizedBox(height: 12),
            FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                    onPressed: () async {
                      bool result = await handler.generateImage(
                          _promptController.text,
                          _negativePromptController.text,
                          _selectedSampler,
                          _seedController.text,
                          _selectedPostProcessor,
                          _selectedModel);
                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(successBar);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(errorBar);
                      }
                    },
                    child: const Text("Start Job")))
          ],
        ));
    return SingleChildScrollView(child: pageContents);
  }
}
