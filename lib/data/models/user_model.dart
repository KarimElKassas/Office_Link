import 'package:flutter_guid/flutter_guid.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/user.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends User{
  UserModel(
      @HiveField(0)
      super.userId,
      @HiveField(1)
      super.userName,
      @HiveField(2)
      super.departmentId,
      @HiveField(3)
      super.roleId);

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
        Guid(json['applicationUserId'].toString()),
        json['userHandle'],
        Guid(json['departmentId'].toString()),
        Guid(json['roleId'].toString()));
  }

  Map<String, dynamic> toJson() => {
    'applicationUserId': userId.toString(),
    'userHandle': userName,
    'departmentId': departmentId.toString(),
    'roleId': roleId.toString(),
  };

}