abstract class LetterDetailsStates{}
class LetterDetailsInitial extends LetterDetailsStates{}
class LetterDetailsChangeColor extends LetterDetailsStates{}
class LetterDetailsLoading extends LetterDetailsStates{}
class LetterDetailsSuccess extends LetterDetailsStates{}
class LetterDetailsError extends LetterDetailsStates{
  final String error;

  LetterDetailsError(this.error);
}
class LetterDetailsSuccessfulDeleteLetter extends LetterDetailsStates{}
class LetterDetailsErrorDeleteLetter extends LetterDetailsStates{
  final String error;

  LetterDetailsErrorDeleteLetter(this.error);
}