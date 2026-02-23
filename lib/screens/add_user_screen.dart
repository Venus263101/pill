import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../database/local_database.dart';   // make sure this matches your DB file name
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
  bool _isSaving = false;

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    String name = _nameController.text.trim();
    int age = int.parse(_ageController.text.trim());

    // Go to Face Registration
    bool? faceRegistered = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaceRegistrationScreen(
          userName: name,
        ),
      ),
    );

    if (faceRegistered == true) {

      UserModel newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        age: age,
        assistanceLevel: _assistanceLevel,
      );

      await LocalDatabase.insertUser(newUser);

      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add User")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter age" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _assistanceLevel,
                decoration: const InputDecoration(
                  labelText: "Medication Assistance",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Independent",
                    child: Text("Can use pillbox independently"),
                  ),
                  DropdownMenuItem(
                    value: "Assisted",
                    child: Text("Requires caretaker assistance"),
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
                onPressed: _isSaving ? null : _saveUser,
                child: const Text("Proceed to Face Registration"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}