import 'package:flutter_guid/flutter_guid.dart';

class SelectedDepartmentModel{

  Guid departmentId;
  String departmentName;
  Guid sectorId;
  String sectorName;
  String actionName;

  SelectedDepartmentModel(this.departmentId, this.departmentName, this.sectorId, this.sectorName, this.actionName);

}