
import 'package:flutter_guid/flutter_guid.dart';

import '../../domain/entities/direction.dart';

class DirectionModel extends Direction{
  const DirectionModel(super.directionId, super.directionName);

  factory DirectionModel.fromJson(Map<String, dynamic> json){
    return DirectionModel(
        Guid(json['directionId'].toString()),
        json['directionName']);
  }

  Map<String, dynamic> toJson() => {
    'directionId': directionId.toString(),
    'directionName': directionName,
  };

}