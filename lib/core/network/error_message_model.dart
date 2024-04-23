import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final int? statusCode;
  final String? statusMessage;

  const Failure(this.statusCode, this.statusMessage);

  factory Failure.fromJson(Map<String, dynamic> json) =>
      Failure(
          json["status"],
          json["message"]);

  @override
  List<Object?> get props => [
    statusCode,
    statusMessage
  ];
}