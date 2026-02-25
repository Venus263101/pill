import 'dart:async';
import 'package:flutter/material.dart';

class FaceRegistrationScreen extends StatefulWidget {
  final String userName;

  const FaceRegistrationScreen({
    super.key,
    required this.userName,
  });

  @override
  State<FaceRegistrationScreen> createState() =>
      _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState
    extends State<FaceRegistrationScreen> {
  bool _isProcessing = false;

  Future<void> _captureFace() async {
    setState(() {
      _isProcessing = true;
    });

    // 🔹 Mock delay (since no ESP32 yet)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // 🔹 Return success to previous screen
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Registration"),
      ),
      body: Center(
        child: _isProcessing
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Capturing face..."),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Register face for ${widget.userName}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _captureFace,
              child: const Text("Capture Face"),
            ),
          ],
        ),
      ),
    );
  }
}