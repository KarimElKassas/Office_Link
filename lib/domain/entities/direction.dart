import 'package:equatable/equatable.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Direction extends Equatable{

  final Guid directionId;
  final String directionName;

  const Direction(this.directionId, this.directionName);

  @override
  List<Object?> get props => [
    directionId, directionName
  ];

}