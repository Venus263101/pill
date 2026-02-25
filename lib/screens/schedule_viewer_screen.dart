import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ScheduleViewerScreen extends StatelessWidget {
  final UserModel user;

  const ScheduleViewerScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Viewer"),
      ),
      body: Center(
        child: Text(
          "Schedule for ${user.name}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}