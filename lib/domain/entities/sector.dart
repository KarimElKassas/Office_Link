import 'package:equatable/equatable.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Sector extends Equatable{

  final Guid sectorId;
  final String sectorName;

  const Sector(this.sectorId, this.sectorName);

  @override
  List<Object?> get props => [
    sectorId, sectorName
  ];

}