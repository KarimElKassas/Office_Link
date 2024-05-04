import 'package:dartz/dartz.dart';
import 'package:foe_archiving/core/error/failure.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/letter_consumer_model.dart';
import 'package:foe_archiving/data/models/letter_model.dart';

import '../../core/use_case/base_use_case.dart';
import '../usecase/letter_consumer/create_letter_consumer_use_case.dart';

abstract class BaseLetterRepository{
  Future<Either<Failure,Map<String,dynamic>>> createInternalDefaultLetter(TokenAndDataParameters parameters);
  Future<Either<Failure,Map<String,dynamic>>> createExternalLetter(TokenAndDataParameters parameters);
  Future<Either<Failure,String>> createArchivedLetter(TokenAndDataParameters parameters);
  Future<Either<Failure,String>> createLetterTag(TokenAndDataParameters parameters);
  Future<Either<Failure,String>> createLetterFiles(TokenAndDataParameters parameters);
  Future<Either<Failure,List<LetterFilesModel>>> getLetterFiles(TokenAndOneGuidParameters parameters);
  Future<Either<Failure,String>> createLetterConsumer(CreateLetterConsumersParameters parameters);
  Future<Either<Failure,String>> addAdditionalInfo(TokenAndDataParameters parameters);
  Future<Either<Failure,List<AdditionalInformationModel>>> getAdditionalInfoByLetterId(TokenAndOneGuidParameters parameters);
  Future<Either<Failure,List<LetterModel>>> getAllInternalDefaultLetters(TokenAndDataParameters parameters);
  Future<Either<Failure,List<LetterModel>>> getAllOutgoingDefaultLetters(TokenAndDataParameters parameters);
  Future<Either<Failure,LetterModel>> getInternalDefaultLetterById(TokenAndOneGuidParameters parameters);
  Future<Either<Failure,List<LetterConsumerModel>>> getLetterConsumers(TokenAndOneGuidParameters parameters);
  Future<Either<Failure,String>> deleteInternalDefaultLetter(TokenAndOneGuidParameters parameters);
  Future<Either<Failure,List<LetterModel>>> getArchivedLetters(TokenAndDataParameters parameters);
  Future<Either<Failure,List<LetterModel>>> getArchivedOutgoingLetters(TokenAndDataParameters parameters);
  Future<Either<Failure,LetterModel>> getArchivedLetterById(TokenAndOneGuidParameters parameters);
  Future<Either<Failure,List<LetterModel>>> getAllExternalLetters(TokenAndDataParameters parameters);
  Future<Either<Failure,LetterModel>> getExternalLetterById(TokenAndOneGuidParameters parameters);
  Future<Either<Failure,String>> deleteInternalArchivedLetter(TokenAndOneGuidParameters parameters);
}