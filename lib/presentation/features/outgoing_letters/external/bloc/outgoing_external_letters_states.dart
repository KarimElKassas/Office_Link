import 'package:foe_archiving/data/models/letter_model.dart';

abstract class OutgoingExternalLettersStates{}

class OutgoingExternalLettersInitial extends OutgoingExternalLettersStates{}
class IncomingExternalLettersSearchLetters extends OutgoingExternalLettersStates{}
class OutgoingExternalLoadingDirection extends OutgoingExternalLettersStates{}
class OutgoingExternalDirectionSuccess extends OutgoingExternalLettersStates{}
class OutgoingExternalDirectionError extends OutgoingExternalLettersStates{
  final String error;

  OutgoingExternalDirectionError(this.error);

}
class OutgoingExternalLettersLoading extends OutgoingExternalLettersStates{
  final List<LetterModel> oldLetters;
  final bool isFirstFetch;

  OutgoingExternalLettersLoading(this.oldLetters, this.isFirstFetch);

}
class OutgoingExternalLettersSuccess extends OutgoingExternalLettersStates{
  final List<LetterModel> lettersList;

  OutgoingExternalLettersSuccess(this.lettersList);
}
class OutgoingExternalLettersError extends OutgoingExternalLettersStates{
  final String error;

  OutgoingExternalLettersError(this.error);
}
