import '../../../../../data/models/letter_model.dart';

abstract class OutgoingInternalLettersStates{}

class OutgoingInternalLettersInitial extends OutgoingInternalLettersStates{}
class OutgoingInternalLettersSearchLetters extends OutgoingInternalLettersStates{}
class OutgoingInternalLettersLoading extends OutgoingInternalLettersStates{
  final List<LetterModel> oldLetters;
  final bool isFirstFetch;

  OutgoingInternalLettersLoading(this.oldLetters, this.isFirstFetch);

}
class OutgoingInternalLettersSuccess extends OutgoingInternalLettersStates{
  final List<LetterModel> lettersList;

  OutgoingInternalLettersSuccess(this.lettersList);
}
class OutgoingInternalLettersError extends OutgoingInternalLettersStates{
  final String error;

  OutgoingInternalLettersError(this.error);
}
