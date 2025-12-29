import 'package:rep_rise/core/util/extension/date_formatter.dart';

import '../../domain/entity/user_registration_entity.dart';

class UserRegistrationModel extends UserRegistrationEntity {
  UserRegistrationModel({
    required super.username,
    required super.email,
    required super.password,

  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "email": email,

    };
  }
}