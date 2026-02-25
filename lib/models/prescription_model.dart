class PrescriptionModel {
  final String medicineName;
  final int dosagePerDay;
  final List<String> times;
  final String frequency;
  final int durationDays;
  final String compartment;
  final String intakeInstruction;

  PrescriptionModel({
    required this.medicineName,
    required this.dosagePerDay,
    required this.times,
    required this.frequency,
    required this.durationDays,
    required this.compartment,
    required this.intakeInstruction,
  });
}