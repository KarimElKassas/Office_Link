import 'package:equatable/equatable.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Department extends Equatable{

  final Guid departmentId;
  final String departmentName;
  final Guid sectorId;

  const Department(this.departmentId, this.departmentName,this.sectorId);

  @override
  List<Object?> get props => [
    departmentId, departmentName, sectorId
  ];

}