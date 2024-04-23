
import 'package:flutter_guid/flutter_guid.dart';

import '../../domain/entities/direction.dart';

class LetterConsumerModel {
  Guid letterConsumerId;
  dynamic letterNumber;
  Guid letterId;
  bool requiredAction;
  bool isSeen;
  dynamic seenBy;
  dynamic seenAt;
  Guid departmentId;


  LetterConsumerModel(
      this.letterConsumerId,
      this.letterNumber,
      this.letterId,
      this.requiredAction,
      this.isSeen,
      this.seenBy,
      this.seenAt,
      this.departmentId);

  factory LetterConsumerModel.fromJson(Map<String, dynamic> json){
    return LetterConsumerModel(
        Guid(json['letterConsumerId'].toString()),
        json['letterNumber'],
        Guid(json['letterId'].toString()),
        json['requiredAction'],
        json['isSeen'],
        json['seenBy'],
        json['seenAt'],
        Guid(json['departmentId'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'letterConsumerId': letterConsumerId,
    'letterNumber': letterNumber,
    'letterId': letterId,
    'requiredAction': requiredAction,
    'isSeen': isSeen,
    'seenBy': seenBy,
    'seenAt': seenAt,
    'departmentId': departmentId,
  };

}