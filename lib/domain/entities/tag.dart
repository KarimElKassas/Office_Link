import 'package:equatable/equatable.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Tag extends Equatable{

  final Guid tagId;
  final String tagName;

  const Tag(this.tagId, this.tagName);

  @override
  List<Object?> get props => [
    tagId, tagName
  ];

}