import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/utils/app_version.dart';
import 'package:hive/hive.dart';

class LetterModel{
  final Guid letterId;
  final String letterAbout;
  final String letterContent;
  final String letterNumber;
  final dynamic letterStateId;
  final dynamic letterDate;
  final Guid confidentialityId;
  final dynamic lastModifiedAt;
  final dynamic lastModifiedBy;
  final dynamic createdAt;
  final Guid createdBy;
  final dynamic departmentId;
  final dynamic departmentName;
  final dynamic sectorId;
  final dynamic directionId;
  dynamic directionName;
  final dynamic internalDefaultLetterId;
  final dynamic internalArchiveLetterId;
  final dynamic externalLetterId;
  final dynamic parentLetterId;
  final List<Guid>? repliesLetterIds;
  final bool? hasReply;
  final bool? isReply;
  final bool? isIncoming;

  LetterModel(
      this.letterId,
      this.letterAbout,
      this.letterContent,
      this.letterNumber,
      this.letterStateId,
      this.letterDate,
      this.confidentialityId,
      this.lastModifiedAt,
      this.lastModifiedBy,
      this.createdAt,
      this.createdBy,
      this.departmentId,
      this.departmentName,
      this.sectorId,
      this.directionId,
      this.directionName,
      this.internalDefaultLetterId,
      this.internalArchiveLetterId,
      this.externalLetterId,
      this.parentLetterId,
      this.repliesLetterIds,
      this.hasReply,
      this.isReply,
      this.isIncoming);

  factory LetterModel.fromJson(Map<String, dynamic> json){
    return LetterModel(
        Guid(json['letterId'].toString()),
        json['letterAbout'],
        json['letterContent'],
        json['letterNumber'],
        json['letterStateId'],
        json['letterDate'],
        Guid(json['confidentialityId'].toString()),
        json['lastModifiedAt'],
        json['lastModifiedBy'],
        json['createdAt'],
        Guid(json['createdBy'].toString()),
        json['department'] == null ? null : Guid(json['department']['departmentId'].toString()),
        json['department'] == null ? null : json['department']['departmentName'].toString(),
        json['department'] == null ? null : Guid(json['department']['sectorId'].toString()),
        json['directionId'] == null ? null : Guid(json['directionId'].toString()),
        json['direction'] == null ? null : json['direction']['directionName'].toString(),
        json['internalDefaultLetterId'],
        json['internalArchiveLetterId'],
        json['externalLetterId'],
        json['parentLetterId'],
        json['repliesLetterIds'] == null ? null : (json['repliesLetterIds'] as List<Guid>),
        json['hasReply'],
        json['isReply'],
        json['isIncoming']
    );
  }

}

class LetterFilesModel {
  Guid letterFileId;
  String fileName;
  dynamic fileSize;
  dynamic filePath;
  Guid letterId;


  LetterFilesModel(this.letterFileId, this.fileName, this.fileSize, this.filePath, this.letterId);

  factory LetterFilesModel.fromJson(Map<String, dynamic> json) {
    return LetterFilesModel(
      Guid(json['letterFileId'].toString()),
        json['fileName'],
        json['fileSize'],
        Constants.sharePath + json['filePath'],
        Guid(json['letterId'].toString()),
    );
  }

  Map<String, dynamic> filesToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileListId'] = letterFileId;
    data['filePath'] = filePath;
    data['fileSize'] = fileSize;
    data['fileName'] = fileName;
    data['letterId'] = letterId;
    return data;
  }
}

@HiveType(typeId: 4)
class DepartmentLetters {
  @HiveField(0)
  int departmentId;
  @HiveField(1)
  int letterId;
  @HiveField(2)
  bool requiredAction;
  bool isSeen;
  dynamic seenAt;

  DepartmentLetters(
      this.departmentId,
      this.letterId,
      this.requiredAction,
      this.isSeen,
      this.seenAt
      );

  factory DepartmentLetters.fromJson(Map<String, dynamic> json) {
    return DepartmentLetters(
        int.parse(json['departmentId'].toString()),
        int.parse(json['letterId'].toString()),
        json['requiredAction'],
        json['seenBy'] == null ? false : true,
        json['seenAt'],
    );
  }

  Map<String, dynamic> filesToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['departmentId'] = departmentId;
    data['letterId'] = letterId;
    data['requiredAction'] = requiredAction;
    data['isSeen'] = isSeen;
    data['seenAt'] = seenAt;
    return data;
  }
}
@HiveType(typeId: 5)
class LetterTags {
  @HiveField(0)
  int tagId;
  @HiveField(1)
  int letterId;

  LetterTags(
      this.tagId,
      this.letterId);

  factory LetterTags.fromJson(Map<String, dynamic> json) {
    return LetterTags(
        int.parse(json['tagId'].toString()),
        json['letterId'],
    );
  }

  Map<String, dynamic> tagsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tagId'] = tagId;
    data['letterId'] = letterId;
    return data;
  }
}
@HiveType(typeId: 6)
class LetterMentions {
  @HiveField(0)
  int letterMentionId;
  @HiveField(1)
  int letterId;
  @HiveField(2)
  String letterNumber;

  LetterMentions(
      this.letterMentionId,
      this.letterId,
      this.letterNumber);

  factory LetterMentions.fromJson(Map<String, dynamic> json) {
    return LetterMentions(
        int.parse(json['letterMentionId'].toString()),
        int.parse(json['letterId'].toString()),
        json['letterNumber'],
    );
  }

  Map<String, dynamic> mentionsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['letterMentionId'] = letterMentionId;
    data['letterId'] = letterId;
    data['letterNumber'] = letterNumber;
    return data;
  }
}