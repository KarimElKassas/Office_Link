import '../../../../../data/models/letter_model.dart';

abstract class AllFilesAndContractsStates{}

class AllFilesAndContractsInitial extends AllFilesAndContractsStates{}
class AllFilesAndContractsSearchLetters extends AllFilesAndContractsStates{}
class AllFilesAndContractsLoading extends AllFilesAndContractsStates{
  final List<LetterModel> oldLetters;
  final bool isFirstFetch;

  AllFilesAndContractsLoading(this.oldLetters, this.isFirstFetch);

}
class AllFilesAndContractsSuccess extends AllFilesAndContractsStates{
  final List<LetterModel> lettersList;

  AllFilesAndContractsSuccess(this.lettersList);
}
class AllFilesAndContractsError extends AllFilesAndContractsStates{
  final String error;

  AllFilesAndContractsError(this.error);
}
