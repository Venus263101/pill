class UserModel {
  final int id;
  final String name;
  final int age;
  final String assistanceLevel;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.assistanceLevel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'assistanceLevel': assistanceLevel,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      assistanceLevel: map['assistanceLevel'],
    );
  }
}