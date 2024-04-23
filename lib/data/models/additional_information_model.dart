import 'package:flutter_guid/flutter_guid.dart';

class AdditionalInformationModel{
  final Guid additionalInfoId;
  final Guid letterId;
  final String? additionInfoDescription;
  final dynamic infoDate;
  final Guid departmentId;
  final Guid additionalInfoTypeId;
  final int valueType;
  final Guid createdBy;
  final dynamic createdAt;
  final dynamic lastModifiedBy;
  final dynamic lastModifiedAt;
  bool isSelected = false;


  AdditionalInformationModel(
      this.additionalInfoId,
      this.letterId,
      this.additionInfoDescription,
      this.infoDate,
      this.departmentId,
      this.additionalInfoTypeId,
      this.valueType,
      this.createdBy,
      this.createdAt,
      this.lastModifiedBy,
      this.lastModifiedAt,
      this.isSelected);

  factory AdditionalInformationModel.fromJson(Map<String,dynamic> json){
    return AdditionalInformationModel(
        Guid(json['additionalInformationId'].toString()),
        Guid(json['letterId'].toString()),
        json['description'],
        json['date'],
        Guid(json['departmentId'].toString()),
        Guid(json['additionalInformationTypeId'].toString()),
        int.parse(json['valueType'].toString()),
        Guid(json['createdBy'].toString()),
        json['createdAt'],
        json['lastModfiedBy'],
        json['lastModfiedAt'],
        false
    );
  }
}