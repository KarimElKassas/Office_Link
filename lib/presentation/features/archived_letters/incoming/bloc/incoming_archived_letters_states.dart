import 'package:foe_archiving/data/models/letter_model.dart';

abstract class IncomingArchivedLettersStates{}

class IncomingArchivedLettersInitial extends IncomingArchivedLettersStates{}
class IncomingLettersSearchLetters extends IncomingArchivedLettersStates{}
class ArchivedDeleteSuccess extends IncomingArchivedLettersStates{}
class IncomingArchivedLettersLoading extends IncomingArchivedLettersStates{
  final List<LetterModel> oldLetters;
  final bool isFirstFetch;

  IncomingArchivedLettersLoading(this.oldLetters, this.isFirstFetch);

}
class IncomingArchivedLettersSuccess extends IncomingArchivedLettersStates{
  final List<LetterModel> lettersList;

  IncomingArchivedLettersSuccess(this.lettersList);
}
class IncomingArchivedLettersError extends IncomingArchivedLettersStates{
  final String error;

  IncomingArchivedLettersError(this.error);
}