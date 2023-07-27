import 'package:user_list/model/status.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final Status status;
  final DateTime createdAt;
  final DateTime updatedAt;

  User(
    this.id,
    this.firstName,
    this.lastName,
    this.status,
    this.createdAt,
    this.updatedAt,
  );

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      firstName = json['first_name'],
      lastName = json['last_name'],
      status = Status.values.byName(json['status']),
      createdAt = DateTime.parse(json['created_at']),
      updatedAt = DateTime.parse(json['updated_at']);

  updated({required Status newStatus}) {
    return User(
      id,
      firstName,
      lastName,
      newStatus,
      createdAt,
      updatedAt,
    );
  }

  renamed({required String newFirstName, required String newLastName}) {
    return User(
      id,
      newFirstName,
      newLastName,
      status,
      createdAt,
      updatedAt,
    );
  }
}
