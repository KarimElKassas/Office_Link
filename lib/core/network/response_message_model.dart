import 'package:equatable/equatable.dart';

class ResponseModel extends Equatable {
  final bool? statusCode;
  final String? statusMessage;
  final dynamic data;
  final List<dynamic> errors;
  const ResponseModel(this.statusCode, this.statusMessage,this.data,this.errors);

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      ResponseModel(
          json["success"],
          json["message"],
          json["data"],
          json["errors"]??[]
      );

  @override
  List<Object?> get props => [
    statusCode,
    statusMessage,
    data,
    errors,
  ];
}