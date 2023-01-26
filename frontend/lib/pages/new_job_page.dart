import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/utils/json_response_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config.dart';
import '../db.dart';

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
                              "You're currently using the horde anonymously. " +
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
                    onChanged: (item) {},
                    value: Config.defaultModel,
                    items: _activeModels.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                        value: e.name,
                        child: Text(e.toString()),
                      );
                    }).toList())
                : const Text("None")
          ],
        ));
    return SingleChildScrollView(child: pageContents);
  }
}
