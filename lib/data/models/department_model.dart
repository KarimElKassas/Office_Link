import 'package:flutter_guid/flutter_guid.dart';

import '../../domain/entities/department.dart';

class DepartmentModel extends Department{
  const DepartmentModel(super.departmentId, super.departmentName, super.sectorId);

  factory DepartmentModel.fromJson(Map<String, dynamic> json){
    return DepartmentModel(
        Guid(json['departmentId'].toString()),
        json['departmentName'],
        Guid(json['sectorId'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'departmentId': departmentId.toString(),
    'departmentName': departmentName,
    'sectorId': sectorId.toString(),
  };

}