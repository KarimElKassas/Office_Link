import 'package:flutter_guid/flutter_guid.dart';

class AdditionalInformationTypeModel{
  final Guid additionalInfoTypeId;
  final String additionalInfoTitle;
  final dynamic departmentId;
  final int valuePower;
  final Guid createdBy;
  final dynamic createdAt;
  final dynamic lastModifiedBy;
  final dynamic lastModifiedAt;
  bool isSelected = false;

  AdditionalInformationTypeModel(
      this.additionalInfoTypeId,
      this.additionalInfoTitle,
      this.departmentId,
      this.valuePower,
      this.createdBy,
      this.createdAt,
      this.lastModifiedBy,
      this.lastModifiedAt,
      this.isSelected);

  factory AdditionalInformationTypeModel.fromJson(Map<String,dynamic> json){
    return AdditionalInformationTypeModel(
        Guid(json['additionalInformationTypeId'].toString()),
        json['title'],
        json['departmentId'],
        int.parse(json['valuePower'].toString()),
        Guid(json['createdBy'].toString()),
        json['createAt'],
        json['lastModfiedBy'] ,
        json['lastModfiedAt'],
        false);
  }
  Map<String, dynamic> toJson() => {
    'additionalInformationTypeId': additionalInfoTypeId.toString(),
    'title': additionalInfoTitle,
    'departmentId': departmentId,
    'valuePower': valuePower,
    'createdBy': createdBy,
    'createAt': createdAt,
    'lastModfiedBy': lastModifiedBy,
    'lastModfiedAt': lastModifiedAt,
    'isSelected': isSelected,
  };

}