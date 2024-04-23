import 'package:equatable/equatable.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends Equatable{
  @HiveField(0)
  final Guid userId;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final Guid departmentId;
  @HiveField(3)
  final Guid roleId;

  User(this.userId, this.userName, this.departmentId, this.roleId);

  @override
  List<Object?> get props => [
    userId, userName, departmentId, roleId
  ];

}