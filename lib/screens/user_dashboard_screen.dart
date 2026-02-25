import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/prescription_model.dart';
import '../database/local_database.dart';
import 'add_prescription_screen.dart';
import 'schedule_viewer_screen.dart';
import 'settings_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  final UserModel user;

  const UserDashboardScreen({super.key, required this.user});

  @override
  State<UserDashboardScreen> createState() =>
      _UserDashboardScreenState();
}

class _UserDashboardScreenState
    extends State<UserDashboardScreen> {
  List<PrescriptionModel> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    final data = await LocalDatabase.getPrescriptions(
        widget.user.id);
    setState(() {
      _prescriptions = data;
    });
  }

  Future<void> _addPrescription() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddPrescriptionScreen(user: widget.user),
      ),
    );

    if (result == true) {
      _loadPrescriptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user.name}'s Dashboard"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_prescriptions.isNotEmpty)
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Prescription",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  ..._prescriptions.asMap().entries.map((entry) {
                    int index = entry.key;
                    PrescriptionModel p = entry.value;

                    return Card(
                      child: ListTile(
                        title: Text(
                          p.medicineName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${p.dosagePerDay} times | ${p.frequency}\nCompartment ${p.compartment}",
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              final result =
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddPrescriptionScreen(
                                        user: widget.user,
                                        existingPrescription: p,
                                        editIndex: index,
                                      ),
                                ),
                              );

                              if (result == true) {
                                _loadPrescriptions();
                              }
                            } else if (value == 'delete') {
                              await LocalDatabase
                                  .deletePrescription(
                                  widget.user.id,
                                  index);
                              _loadPrescriptions();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),

            Card(
              child: ListTile(
                leading:
                const Icon(Icons.medication),
                title:
                const Text("Add Prescription"),
                onTap: _addPrescription,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading:
                const Icon(Icons.schedule),
                title:
                const Text("Schedule Viewer"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ScheduleViewerScreen(
                              user:
                              widget.user),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading:
                const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SettingsScreen(
                              user:
                              widget.user),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}