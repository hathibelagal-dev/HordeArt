import 'package:flutter/material.dart';
import 'package:frontend/completed_jobs_page.dart';
import 'package:frontend/new_job_page.dart';
import 'package:frontend/pending_jobs_page.dart';

class GeneratePage extends StatefulWidget {
  final String title;
  const GeneratePage(this.title, {Key? key}) : super(key: key);

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
              bottom: const TabBar(tabs: [
                Tab(text: "New Job"),
                Tab(text: "Pending"),
                Tab(text: "Completed")
              ])),
          body: const TabBarView(children: [
            NewJobsPage(),
            PendingJobsPage(),
            CompletedJobsPage()
          ]),
        ));
  }
}
