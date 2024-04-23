abstract class LetterReplyStates{}

class LetterReplyInitial extends LetterReplyStates{}
class LetterReplyChangeColor extends LetterReplyStates{}
class LetterReplyLoadingSend extends LetterReplyStates{}
class LetterReplySuccessSend extends LetterReplyStates{}
class LetterReplyErrorSend extends LetterReplyStates{
  final String error;

  LetterReplyErrorSend(this.error);
}