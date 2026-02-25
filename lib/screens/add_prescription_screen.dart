import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/prescription_model.dart';
import '../database/local_database.dart';

class AddPrescriptionScreen extends StatefulWidget {
  final UserModel user;
  final PrescriptionModel? existingPrescription;
  final int? editIndex;

  const AddPrescriptionScreen({
    Key? key,
    required this.user,
    this.existingPrescription,
    this.editIndex,
  }) : super(key: key);

  @override
  State<AddPrescriptionScreen> createState() =>
      _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState
    extends State<AddPrescriptionScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _medicineNameController =
  TextEditingController();
  final TextEditingController _durationController =
  TextEditingController();

  int _dosagePerDay = 1;
  List<TimeOfDay?> _selectedTimes = [null];

  String? _frequency;
  String? _compartment;
  String? _intakeInstruction;

  @override
  void initState() {
    super.initState();

    if (widget.existingPrescription != null) {
      final p = widget.existingPrescription!;

      _medicineNameController.text = p.medicineName;
      _dosagePerDay = p.dosagePerDay;

      _selectedTimes = p.times.map((timeString) {
        final format = timeString.split(":");
        final hour = int.parse(format[0]);
        final minute = int.parse(format[1].split(" ")[0]);
        return TimeOfDay(hour: hour, minute: minute);
      }).toList();

      _frequency = p.frequency;
      _durationController.text = p.durationDays.toString();
      _compartment = p.compartment;
      _intakeInstruction = p.intakeInstruction;
    }
  }

  void _updateDosage(int value) {
    setState(() {
      _dosagePerDay = value;
      _selectedTimes =
          List.generate(value, (_) => null);
    });
  }

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked =
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTimes[index] = picked;
      });
    }
  }

  Future<void> _savePrescription() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTimes.contains(null)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
            content:
            Text("Please select all dosage times.")),
      );
      return;
    }

    final prescription = PrescriptionModel(
      medicineName:
      _medicineNameController.text.trim(),
      dosagePerDay: _dosagePerDay,
      times: _selectedTimes
          .map((t) => t!.format(context))
          .toList(),
      frequency: _frequency!,
      durationDays:
      int.parse(_durationController.text),
      compartment: _compartment!,
      intakeInstruction:
      _intakeInstruction!,
    );

    if (widget.editIndex != null) {
      await LocalDatabase.updatePrescription(
        widget.user.id,
        widget.editIndex!,
        prescription,
      );
    } else {
      await LocalDatabase.addPrescription(
        widget.user.id,
        prescription,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing =
        widget.existingPrescription != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? "Edit Prescription"
              : "Add Prescription",
        ),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              /// Medicine Name
              TextFormField(
                controller:
                _medicineNameController,
                decoration:
                const InputDecoration(
                  labelText:
                  "Medicine Name",
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Please enter medicine name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Dosage Per Day
              DropdownButtonFormField<int>(
                value: _dosagePerDay,
                decoration:
                const InputDecoration(
                  labelText:
                  "Dosage Per Day",
                ),
                items: [1, 2, 3, 4]
                    .map(
                      (e) =>
                      DropdownMenuItem(
                        value: e,
                        child:
                        Text("$e times"),
                      ),
                )
                    .toList(),
                onChanged: (value) {
                  _updateDosage(value!);
                },
              ),
              const SizedBox(height: 16),

              /// Time Selection
              Column(
                children:
                List.generate(
                  _dosagePerDay,
                      (index) =>
                      ListTile(
                        title: Text(
                          _selectedTimes[index] ==
                              null
                              ? "Select Time ${index + 1}"
                              : _selectedTimes[
                          index]!
                              .format(
                              context),
                        ),
                        trailing:
                        const Icon(
                            Icons
                                .access_time),
                        onTap: () =>
                            _selectTime(
                                index),
                      ),
                ),
              ),
              const SizedBox(height: 16),

              /// Frequency
              DropdownButtonFormField<
                  String>(
                value: _frequency,
                decoration:
                const InputDecoration(
                  labelText:
                  "Frequency",
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Daily",
                      child: Text("Daily")),
                  DropdownMenuItem(
                      value:
                      "Alternate Days",
                      child: Text(
                          "Alternate Days")),
                  DropdownMenuItem(
                      value:
                      "Every 2 Days",
                      child:
                      Text("Every 2 Days")),
                  DropdownMenuItem(
                      value: "Weekly",
                      child:
                      Text("Weekly")),
                ],
                validator: (value) =>
                value == null
                    ? "Please select frequency"
                    : null,
                onChanged: (value) {
                  setState(() {
                    _frequency =
                        value;
                  });
                },
              ),
              const SizedBox(height: 16),

              /// Duration
              TextFormField(
                controller:
                _durationController,
                keyboardType:
                TextInputType.number,
                decoration:
                const InputDecoration(
                  labelText:
                  "Duration (Days)",
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Please enter duration";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Compartment
              DropdownButtonFormField<
                  String>(
                value: _compartment,
                decoration:
                const InputDecoration(
                  labelText:
                  "Compartment",
                ),
                items: const [
                  DropdownMenuItem(
                      value: "1",
                      child: Text(
                          "Compartment 1")),
                  DropdownMenuItem(
                      value: "2",
                      child: Text(
                          "Compartment 2")),
                  DropdownMenuItem(
                      value: "3",
                      child: Text(
                          "Compartment 3")),
                ],
                validator: (value) =>
                value == null
                    ? "Select compartment"
                    : null,
                onChanged: (value) {
                  setState(() {
                    _compartment =
                        value;
                  });
                },
              ),
              const SizedBox(height: 16),

              /// Intake Instruction
              DropdownButtonFormField<
                  String>(
                value:
                _intakeInstruction,
                decoration:
                const InputDecoration(
                  labelText:
                  "Intake Instruction",
                ),
                items: const [
                  DropdownMenuItem(
                      value:
                      "Before Food",
                      child: Text(
                          "Before Food")),
                  DropdownMenuItem(
                      value:
                      "After Food",
                      child: Text(
                          "After Food")),
                  DropdownMenuItem(
                      value:
                      "With Food",
                      child: Text(
                          "With Food")),
                ],
                validator: (value) =>
                value == null
                    ? "Select instruction"
                    : null,
                onChanged: (value) {
                  setState(() {
                    _intakeInstruction =
                        value;
                  });
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width:
                double.infinity,
                child:
                ElevatedButton(
                  onPressed:
                  _savePrescription,
                  child: Text(
                      isEditing
                          ? "Update Prescription"
                          : "Save Prescription"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}