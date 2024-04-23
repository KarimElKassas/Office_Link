import 'package:foe_archiving/data/models/letter_model.dart';

abstract class IncomeExternalLettersStates{}

class IncomeExternalLettersInitial extends IncomeExternalLettersStates{}
class IncomingExternalLettersSearchLetters extends IncomeExternalLettersStates{}
class IncomeExternalLoadingDirection extends IncomeExternalLettersStates{}
class IncomeExternalDirectionSuccess extends IncomeExternalLettersStates{}
class IncomeExternalDirectionError extends IncomeExternalLettersStates{
  final String error;

  IncomeExternalDirectionError(this.error);

}
class IncomeExternalLettersLoading extends IncomeExternalLettersStates{
  final List<LetterModel> oldLetters;
  final bool isFirstFetch;

  IncomeExternalLettersLoading(this.oldLetters, this.isFirstFetch);

}
class IncomeExternalLettersSuccess extends IncomeExternalLettersStates{
  final List<LetterModel> lettersList;

  IncomeExternalLettersSuccess(this.lettersList);
}
class IncomeExternalLettersError extends IncomeExternalLettersStates{
  final String error;

  IncomeExternalLettersError(this.error);
}
