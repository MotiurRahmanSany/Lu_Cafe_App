import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> userCart;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.userCart,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
    List<String>? userCart,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      userCart: userCart ?? this.userCart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'userCart': userCart,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['\$id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        userCart: List<String>.from(
          (map['userCart'] as List<dynamic>).map((item) => item as String),
        ));
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, userCart: $userCart)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        listEquals(other.userCart, userCart);
  }

  @override
  int get hashCode {
    return uid.hashCode ^ name.hashCode ^ email.hashCode ^ userCart.hashCode;
  }
}
