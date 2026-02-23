import 'package:flutter/material.dart';
import '../database/local_database.dart';
import '../models/user_model.dart';
import 'add_user_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final data = await LocalDatabase.getUsers();
    if (!mounted) return;
    setState(() {
      users = data;
    });
  }

  Future<void> confirmDelete(UserModel user) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: Text("Are you sure you want to delete ${user.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (result == true) {
      await LocalDatabase.deleteUser(user.id);
      loadUsers();
    }
  }

  Future<void> navigateToAddUser() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddUserScreen(),
      ),
    );

    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select User")),
      body: users.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No Users Added",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: navigateToAddUser,
              icon: const Icon(Icons.add),
              label: const Text("Add User"),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle:
            Text("Age: ${user.age} | ${user.assistanceLevel}"),
            onLongPress: () => confirmDelete(user),
          );
        },
      ),
      floatingActionButton: users.isNotEmpty
          ? FloatingActionButton(
        onPressed: navigateToAddUser,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}