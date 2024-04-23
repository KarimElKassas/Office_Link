import 'package:flutter_guid/flutter_guid.dart';

import '../../domain/entities/sector.dart';

class SectorModel extends Sector{
  const SectorModel(super.sectorId, super.sectorName);

  factory SectorModel.fromJson(Map<String, dynamic> json){
    return SectorModel(
        Guid(json['sectorId'].toString()),
        json['sectorName']);
  }

  Map<String, dynamic> toJson() => {
    'sectorId': sectorId.toString(),
    'sectorName': sectorName,
  };

}