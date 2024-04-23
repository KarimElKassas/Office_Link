import 'package:foe_archiving/data/models/letter_model.dart';

abstract class IncomeInternalLettersStates{}

class IncomeInternalLettersInitial extends IncomeInternalLettersStates{}
class IncomingInternalLettersSearchLetters extends IncomeInternalLettersStates{}
class IncomeInternalLettersLoading extends IncomeInternalLettersStates{
  final List<LetterModel> oldLetters;
  final bool isFirstFetch;

  IncomeInternalLettersLoading(this.oldLetters, this.isFirstFetch);

}
class IncomeInternalLettersSuccess extends IncomeInternalLettersStates{
  final List<LetterModel> lettersList;

  IncomeInternalLettersSuccess(this.lettersList);
}
class IncomeInternalLettersError extends IncomeInternalLettersStates{
  final String error;

  IncomeInternalLettersError(this.error);
}
