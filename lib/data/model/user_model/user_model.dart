import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String role;

  @HiveField(4)
  final DateTime dateCreated;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.dateCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "dateCreated": dateCreated,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      dateCreated: json["dateCreated"],
    );
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'],
      name: data['name'],
      role: data['role'],
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return '''
      "Id": $id,
      "user Name": $name,
      "user Email": $email,
      "role": $role,
      "date created: $dateCreated
  ''';
  }
}
