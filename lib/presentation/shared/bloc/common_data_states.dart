abstract class CommonDataStates{}

class CommonDataInitial extends CommonDataStates{}
class CommonDataChangeSelectedBox extends CommonDataStates{}
class IsolateProcessing extends CommonDataStates{}
class IsolateSuccess extends CommonDataStates{
  final String result;

  IsolateSuccess(this.result);

}
class IsolateError extends CommonDataStates{
  final String error;

  IsolateError(this.error);

}
class CommonDataLogOut extends CommonDataStates{}
class CommonDataLoading extends CommonDataStates{}
class CommonDataSuccess extends CommonDataStates{}
class CommonDataSuccessChangePassword extends CommonDataStates{}
class CommonDataError extends CommonDataStates{
  final String error;

  CommonDataError(this.error);
}
class CommonDataChangeSelectedDirection extends CommonDataStates{}
class CommonDataAddDepartmentToAction extends CommonDataStates{}
class CommonDataAddDepartmentToKnow extends CommonDataStates{}
class CommonDataRemoveDepartmentFromAction extends CommonDataStates{}
class CommonDataRemoveDepartmentFromKnow extends CommonDataStates{}
class CommonDataAddTags extends CommonDataStates{}
class CommonDataChangeSelectedSector extends CommonDataStates{}
class CommonDataChangeSelectedDepartment extends CommonDataStates{}
class CommonDataChangeHasExportDate extends CommonDataStates{}
class CommonDataChangeHasNotes extends CommonDataStates{}
class CommonDataChangeDate extends CommonDataStates{}
class CommonDataChangePasswordVisibility extends CommonDataStates{}
class CommonDataChangeHasExportNumber extends CommonDataStates{}
class CommonDataAddOrRemoveAdditional extends CommonDataStates{}
class CommonDataPrintText extends CommonDataStates{}
class CommonDataPickFiles extends CommonDataStates{}
class CommonDataRemoveFile extends CommonDataStates{}
class CommonDataChangeSecurityLevel extends CommonDataStates{}
class CommonDataChangeNecessaryLevel extends CommonDataStates{}