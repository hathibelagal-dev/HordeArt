import 'package:flutter/material.dart';
import 'package:frontend/db.dart';
import 'package:frontend/utils/json_response_handler.dart';

import '../models/job_status.dart';

class PendingJobsPage extends StatefulWidget {
  const PendingJobsPage({Key? key}) : super(key: key);

  @override
  State<PendingJobsPage> createState() => _PendingJobsPageState();
}

class _PendingJobsPageState extends State<PendingJobsPage> {
  List<String> _pendingJobs = [];
  JSONResponseHandler handler = JSONResponseHandler();

  bool _checking = false;

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
              _checking
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        checkStatuses();
                      },
                      child: const Text("Update"))
            ])));
  }

  Future<void> checkStatuses() async {
    setState(() {
      _checking = true;
    });
    for (String job in _pendingJobs) {
      JobStatus status = await handler.getJobStatus(job);
      if (status.done) {
        if(status.valid) {
          await addCompletedJob(job);
          await removePendingJob(job);
        } else {
          print("Removing because invalid");
          await removePendingJob(job);
        }
      }
    }
    String pending = DB.getValue("pending");
    setState(() {
      _pendingJobs =
          pending.split(",").where((element) => element.length > 2).toList();
      _checking = false;
    });
  }

  Future<void> addCompletedJob(String job) async {
    String completed = DB.getValue("completed");
    completed += "," + job;
    await DB.setValue("completed", completed);
  }

  Future<void> removePendingJob(String job) async {
    String pending = DB.getValue("pending");
    pending = pending
        .split(",")
        .where((element) => element != job)
        .toList()
        .join(",");
    print(pending);
    await DB.setValue("pending", pending);
  }
}
