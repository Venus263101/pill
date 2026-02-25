import '../models/user_model.dart';
import '../models/prescription_model.dart';

class LocalDatabase {
  static final List<UserModel> _users = [];

  static final Map<int, List<PrescriptionModel>>
  _userPrescriptions = {};

  static Future<void> insertUser(UserModel user) async {
    _users.add(user);
  }

  static Future<List<UserModel>> getUsers() async {
    return _users;
  }

  static Future<void> addPrescription(
      int userId, PrescriptionModel prescription) async {
    if (_userPrescriptions.containsKey(userId)) {
      _userPrescriptions[userId]!.add(prescription);
    } else {
      _userPrescriptions[userId] = [prescription];
    }
  }

  static Future<List<PrescriptionModel>>
  getPrescriptions(int userId) async {
    return _userPrescriptions[userId] ?? [];
  }

  static Future<void> deletePrescription(
      int userId, int index) async {
    _userPrescriptions[userId]?.removeAt(index);
  }

  static Future<void> updatePrescription(
      int userId,
      int index,
      PrescriptionModel updatedPrescription) async {
    _userPrescriptions[userId]?[index] =
        updatedPrescription;
  }
  static Future<void> deleteUser(int userId) async {
    _users.removeWhere((user) => user.id == userId);
    _userPrescriptions.remove(userId);
  }
}