abstract class NewLetterStates{}

class NewLetterInitial extends NewLetterStates{}
class NewLetterChangeLetterIncoming extends NewLetterStates{}
class NewLetterLoading extends NewLetterStates{}
class NewLetterSuccess extends NewLetterStates{}
class NewLetterError extends NewLetterStates{
  final String error;

  NewLetterError(this.error);
}
class NewLetterPickFiles extends NewLetterStates{}
class NewLetterRemoveFile extends NewLetterStates{}
class NewLetterChangeSecurityLevel extends NewLetterStates{}
class NewLetterChangeLetterType extends NewLetterStates{}
class NewLetterChangeIncomingOutgoingType extends NewLetterStates{}
class NewLetterChangeLetterDirectionType extends NewLetterStates{}
class NewLetterChangeDate extends NewLetterStates{}