import 'package:flutter/material.dart';
import 'package:frontend/db.dart';

class PendingJobsPage extends StatefulWidget {
  const PendingJobsPage({Key? key}) : super(key: key);

  @override
  State<PendingJobsPage> createState() => _PendingJobsPageState();
}

class _PendingJobsPageState extends State<PendingJobsPage> {
  List<String> _pendingJobs = [];

  @override
  void initState() {
    super.initState();
    _pendingJobs = DB.getValue("pending").split(",");
    _pendingJobs = _pendingJobs.where((element) => element.length > 1).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Found ${_pendingJobs.length} job(s)",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._pendingJobs.map((job) {
                return Text(job);
              }).toList(),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {
                    checkStatuses();
                  },
                  child: const Text("Update"))
            ])));
  }

  Future<void> checkStatuses() async {}
}
