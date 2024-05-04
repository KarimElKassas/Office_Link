abstract class ArchivedLetterDetailsStates{}
class ArchivedLetterDetailsInitial extends ArchivedLetterDetailsStates{}
class ArchivedLetterDetailsChangeColor extends ArchivedLetterDetailsStates{}
class ArchivedLetterDetailsLoading extends ArchivedLetterDetailsStates{}
class ArchivedLetterDetailsSuccess extends ArchivedLetterDetailsStates{}
class ArchivedLetterDetailsError extends ArchivedLetterDetailsStates{
  final String error;

  ArchivedLetterDetailsError(this.error);
}
class ArchivedLetterDetailsSuccessfulDeleteLetter extends ArchivedLetterDetailsStates{}
class ArchivedLetterDetailsErrorDeleteLetter extends ArchivedLetterDetailsStates{
  final String error;

  ArchivedLetterDetailsErrorDeleteLetter(this.error);
}
class ArchivedDeleteSuccess extends ArchivedLetterDetailsStates{}