import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../database/local_database.dart';
import 'face_registration_screen.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _assistanceLevel = "Independent";

  Future<void> _handleProceed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      assistanceLevel: _assistanceLevel,
    );

    // Save user first
    await LocalDatabase.insertUser(newUser);

    // Open Face Registration Screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FaceRegistrationScreen(userName: newUser.name),
      ),
    );

    // If face registration successful → go back to UserSelection
    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter age";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _assistanceLevel,
                decoration: const InputDecoration(
                  labelText: "Medication Assistance",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Independent",
                    child: Text("Independent"),
                  ),
                  DropdownMenuItem(
                    value: "Caretaker Assistance",
                    child: Text("Caretaker Assistance"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _assistanceLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleProceed,
                child: const Text("Proceed to Face Registration"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}