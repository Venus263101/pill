import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../database/local_database.dart';
import 'add_user_screen.dart';
import 'user_dashboard_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({Key? key}) : super(key: key);

  @override
  State<UserSelectionScreen> createState() =>
      _UserSelectionScreenState();
}

class _UserSelectionScreenState
    extends State<UserSelectionScreen> {
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await LocalDatabase.getUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _addUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddUserScreen(),
      ),
    );

    if (result == true) {
      _loadUsers();
    }
  }

  Future<void> _deleteUser(UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: Text(
              "Are you sure you want to delete ${user.name}? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await LocalDatabase.deleteUser(user.id);
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select User"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(
        child: Text("No Users Found"),
      )
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6),
            child: ListTile(
              title: Text(
                user.name,
                style: const TextStyle(
                    fontWeight:
                    FontWeight.bold),
              ),
              subtitle: Text(
                "Age: ${user.age} | ${user.assistanceLevel}",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        UserDashboardScreen(
                            user: user),
                  ),
                );
              },
              onLongPress: () =>
                  _deleteUser(user),
            ),
          );
        },
      ),
    );
  }
}