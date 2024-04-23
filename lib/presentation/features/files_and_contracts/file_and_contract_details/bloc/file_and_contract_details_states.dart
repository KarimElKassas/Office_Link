abstract class FileAndContractDetailsStates{}
class FileAndContractDetailsInitial extends FileAndContractDetailsStates{}
class FileAndContractDetailsChangeColor extends FileAndContractDetailsStates{}
class FileAndContractDetailsLoading extends FileAndContractDetailsStates{}
class FileAndContractDetailsSuccess extends FileAndContractDetailsStates{}
class FileAndContractDetailsError extends FileAndContractDetailsStates{
  final String error;

  FileAndContractDetailsError(this.error);
}
class FileAndContractDetailsSuccessfulDeleteLetter extends FileAndContractDetailsStates{}
class FileAndContractDetailsErrorDeleteLetter extends FileAndContractDetailsStates{
  final String error;

  FileAndContractDetailsErrorDeleteLetter(this.error);
}