abstract class ExternalLetterDetailsStates{}
class ExternalLetterDetailsInitial extends ExternalLetterDetailsStates{}
class ExternalLetterDetailsChangeColor extends ExternalLetterDetailsStates{}
class ExternalLetterDetailsLoading extends ExternalLetterDetailsStates{}
class ExternalLetterDetailsSuccess extends ExternalLetterDetailsStates{}
class ExternalLetterDetailsError extends ExternalLetterDetailsStates{
  final String error;

  ExternalLetterDetailsError(this.error);
}
class ExternalLetterDetailsSuccessfulDeleteLetter extends ExternalLetterDetailsStates{}
class ExternalLetterDetailsErrorDeleteLetter extends ExternalLetterDetailsStates{
  final String error;

  ExternalLetterDetailsErrorDeleteLetter(this.error);
}