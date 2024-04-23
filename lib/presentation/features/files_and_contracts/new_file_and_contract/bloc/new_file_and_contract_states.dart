abstract class NewFileAndContractStates{}

class NewFileAndContractInitial extends NewFileAndContractStates{}
class NewFileAndContractChangeDate extends NewFileAndContractStates{}
class NewFileAndContractChangeLetterType extends NewFileAndContractStates{}
class NewFileAndContractLoading extends NewFileAndContractStates{}
class NewFileAndContractSuccess extends NewFileAndContractStates{}
class NewFileAndContractError extends NewFileAndContractStates{
  final String error;

  NewFileAndContractError(this.error);
}

