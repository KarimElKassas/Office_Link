import 'package:foe_archiving/data/models/letter_model.dart';

abstract class OutgoingArchivedLettersStates{}

class OutgoingArchivedLettersInitial extends OutgoingArchivedLettersStates{}
class OutgoingLettersSearchLetters extends OutgoingArchivedLettersStates{}
class OutgoingArchivedLettersLoading extends OutgoingArchivedLettersStates{
  final List<LetterModel> oldLetters;
  final bool isFirstFetch;

  OutgoingArchivedLettersLoading(this.oldLetters, this.isFirstFetch);

}
class OutgoingArchivedLettersSuccess extends OutgoingArchivedLettersStates{
  final List<LetterModel> lettersList;

  OutgoingArchivedLettersSuccess(this.lettersList);
}
class OutgoingArchivedLettersError extends OutgoingArchivedLettersStates{
  final String error;

  OutgoingArchivedLettersError(this.error);
}