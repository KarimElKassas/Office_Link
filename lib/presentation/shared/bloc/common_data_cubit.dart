import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/core/helpers/background_tasks.dart' as back;
import 'package:foe_archiving/data/models/additional_information_type_model.dart';
import 'package:foe_archiving/data/models/department_model.dart';
import 'package:foe_archiving/data/models/direction_model.dart';
import 'package:foe_archiving/data/models/sector_model.dart';
import 'package:foe_archiving/data/models/tag_model.dart';
import 'package:foe_archiving/domain/usecase/auth/change_password_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/add_department_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/add_direction_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/add_tag_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_all_additional_info_types_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_department_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_departments_by_sector_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_directions_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_sectors_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_tags_use_case.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_states.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/localization/strings_manager.dart';
import '../../../core/utils/app_version.dart';
import '../../../core/utils/prefs_helper.dart';
import '../../../data/models/selected_department_model.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/usecase/auth/login_user_use_case.dart';

class CommonDataCubit extends Cubit<CommonDataStates>{
  CommonDataCubit() : super(CommonDataInitial());

  static CommonDataCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken')!;
  
  ChangePasswordUseCase changePasswordUseCase = sl<ChangePasswordUseCase>();
  GetDirectionsUseCase getDirectionsUseCase = sl<GetDirectionsUseCase>();
  GetTagsUseCase getTagsUseCase = sl<GetTagsUseCase>();
  GetSectorsUseCase getSectorsUseCase = sl<GetSectorsUseCase>();
  GetDepartmentsBySectorUseCase getDepartmentsBySectorUseCase = sl<GetDepartmentsBySectorUseCase>();
  GetDepartmentByIdUseCase getDepartmentByIdUseCase = sl<GetDepartmentByIdUseCase>();
  GetAllAdditionalInfoTypesUseCase getAllAdditionalInfoTypesUseCase = sl<GetAllAdditionalInfoTypesUseCase>();
  AddDepartmentUseCase addDepartmentUseCase = sl<AddDepartmentUseCase>();
  AddDirectionUseCase addDirectionUseCase = sl<AddDirectionUseCase>();
  AddTagUseCase addTagUseCase = sl<AddTagUseCase>();

  int selectedMenuBox = 0;
  String? selectedSortMethod;
  List<String> sortMethods = [AppStrings.letterNumber.tr(),AppStrings.letterDirection.tr(),AppStrings.letterDate.tr()];
  ScrollController scrollController = ScrollController();
  PageController elPageController = PageController();


  //-------------- Additional Information Functionality --------------//
  bool hasExportDate = false;
  bool hasNotes = false;
  bool hasExportNumber = false;
  bool isPassword = true;
  IconData suffix = Icons.visibility_rounded;
  DateTime letterExportDate = DateTime.now();
  TextEditingController notesController = TextEditingController();
  TextEditingController exportNumberController = TextEditingController();
  TextEditingController addDepartmentController = TextEditingController();
  TextEditingController addTagController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  List<AdditionalInformationTypeModel> filteredAdditionalList = [];

  List<Map<Guid,TextEditingController>> textControllersList = [];

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;
    emit(CommonDataChangePasswordVisibility());
  }

  TextEditingController? getInfoController(Guid infoId){
    for(var map in textControllersList){
      if(map.containsKey(infoId)){
        return map[infoId];
      }
    }
    return null;
  }
  List<Map<Guid,DateTime>> dateTimeList = [];
  DateTime? getAdditionalDateTime(Guid infoId){
    for(var map in dateTimeList){
      if(map.containsKey(infoId)){
        return map[infoId];
      }
    }
    return DateTime.now();
  }

  void updateDateInList(Guid infoId, DateTime newDate){
    var map = dateTimeList.firstWhere((element) => element.containsKey(infoId));
    map[infoId] = newDate;
    emit(CommonDataChangeDate());
  }

  void addOrRemoveAdditionalInfo(Guid infoId, bool newValue,DateTime newDate){
    var model = additionalTypesList.firstWhere((element) => element.additionalInfoTypeId == infoId);
    model.isSelected = newValue;
    additionalTypesList[additionalTypesList.indexWhere((element) => element.additionalInfoTypeId == infoId)] = model;
    if(newValue == true){
      if(additionalTypesList.firstWhere((element) => element.additionalInfoTypeId == infoId).valuePower == 2){
        // here we add text controller to list
        textControllersList.add({infoId : TextEditingController()});
        filteredAdditionalList.add(additionalTypesList.where((element) => element.additionalInfoTypeId == infoId).first);
      }else{
        // here we add dateTime to list
        dateTimeList.add({infoId : newDate});
        filteredAdditionalList.add(additionalTypesList.where((element) => element.additionalInfoTypeId == infoId).first);
      }

    }else{
      if(additionalTypesList.firstWhere((element) => element.additionalInfoTypeId == infoId).valuePower == 2){
        // here we remove text controller from the list
        textControllersList.removeWhere((element) => element.containsKey(infoId));
        filteredAdditionalList.removeWhere((element) => element.additionalInfoTypeId == infoId);
      }else{
        // here we remove datetime from the list
        dateTimeList.removeWhere((element) => element.containsKey(infoId));
        filteredAdditionalList.removeWhere((element) => element.additionalInfoTypeId == infoId);
      }
    }
    if(filteredAdditionalList.isNotEmpty){
      filteredAdditionalList.sort((a,b) => a.valuePower.compareTo(b.valuePower));
    }
    emit(CommonDataAddOrRemoveAdditional());
  }


  void sortAdditionalList(){
    additionalTypesList.sort((a,b) => a.valuePower.compareTo(b.valuePower));
  }

  void changeHasExportDate(bool newValue){
    hasExportDate = newValue;
    emit(CommonDataChangeHasExportDate());
  }
  void changeHasNotes(bool newValue){
    hasNotes = newValue;
    emit(CommonDataChangeHasNotes());
  }
  void changeCalendarDate(DateTime newDate){
    letterExportDate = newDate;
    emit(CommonDataChangeDate());
  }
  void changeHasExportNumber(bool newValue){
    hasExportNumber = newValue;
    emit(CommonDataChangeHasExportNumber());
  }


  //-------------- Pick Files Functionality --------------//
  List<PlatformFile> pickedFiles = [];
  List<MultipartFile> multipartFiles = [];
  List<String>? filesSize;
  List<String>? filesName;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: AppStrings.pickFiles.tr(),
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      pickedFiles.addAll(result.files);
    }
    emit(CommonDataPickFiles());
  }
  void deleteFile(PlatformFile file){
    pickedFiles.retainWhere((element) => element != file);
    emit(CommonDataRemoveFile());
  }
  //-------------- Necessary & Security Functionality --------------//
  Guid securityLevel = Constants.topSecretGuid;
  int necessaryLevel = 1;
  void changeSecurityLevel(Guid newLevel){
    securityLevel = newLevel;
    emit(CommonDataChangeSecurityLevel());
  }
  void changeNecessaryLevel(int newLevel){
    necessaryLevel = newLevel;
    emit(CommonDataChangeNecessaryLevel());
  }
  //-------------- Notification Functionality --------------//
  ScrollController notificationsScrollController = ScrollController();
  int unReadNotificationsCount = 0;

  void clearSelectedAdditionalInfo(){
      textControllersList.clear();
      dateTimeList.clear();
      additionalTypesList.clear();
      filteredAdditionalList.clear();
      getAllAdditionalTypes();
      sortAdditionalList();

  }
  void clearTools(){
    hasExportDate = false;
    hasNotes = false;
    hasExportNumber = false;
    selectedDirection = null;
    selectedTagsList.clear();
    selectedActionDepartmentsList.clear();
    selectedKnowDepartmentsList.clear();
    notesController.clear();
    exportNumberController.clear();
    pickedFiles.clear();
    multipartFiles.clear();
    filesName?.clear();
    filesSize?.clear();
    necessaryLevel = 1;
    securityLevel = Constants.topSecretGuid;
    clearSelectedAdditionalInfo();
  }

  void changeSelectedBox(int boxNumber){
    if(selectedMenuBox != boxNumber){

      // logout button
      if(boxNumber != 6){
        clearTools();
      }

      selectedMenuBox = boxNumber;
      elPageController.jumpToPage(boxNumber);
      emit(CommonDataChangeSelectedBox());
    }

  }
  Future<void> changePassword() async {
    emit(CommonDataLoading());

    Map<String, dynamic> dataMap = {
      'password' : newPasswordController.text.toString(),
    };

    final result = await changePasswordUseCase(TokenAndDataParameters(myToken,dataMap));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) => emit(CommonDataSuccessChangePassword()));
  }

  void logOut() async {
    await Preference.prefs.remove('sessionToken');
    await Preference.prefs.remove('User');
    //emit(CommonDataLogOut());
  }

  String myDepartment = "";
  Future<void> getDepartmentById() async {
    emit(CommonDataLoading());
    
    UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
    final result = await getDepartmentByIdUseCase(GetDepartmentByIdParameters(myToken,model.departmentId));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
          myDepartment = r.departmentName;
          emit(CommonDataSuccess());
        });
  }
  Future<void> createDepartment() async {
    emit(CommonDataLoading());
    Map<String,dynamic> data = {
      'departmentName' : addDepartmentController.text.toString(),
      'sectorId' : selectedSectorModel!.sectorId.toString()
    };
    final result = await addDepartmentUseCase(TokenAndDataParameters(myToken,data));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
              departmentsList.add(r);
              addDepartmentController.clear();
          emit(CommonDataSuccess());
        });
  }
  Future<void> createDirection(String directionName) async {
    emit(CommonDataLoading());
    Map<String,dynamic> data = {
      'directionName' : directionName,
    };
    final result = await addDirectionUseCase(TokenAndDataParameters(myToken,data));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
          directionsList.add(r);
          emit(CommonDataSuccess());
        });
  }
  Future<void> createTag() async {
    emit(CommonDataLoading());
    Map<String,dynamic> data = {
      'tagName' : addTagController.text.toString(),
    };
    final result = await addTagUseCase(TokenAndDataParameters(myToken,data));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
              addTagController.clear();
              tagsList.add(r);
              emit(CommonDataSuccess());
        });
  }
  List<DirectionModel> directionsList = [];
  Future<void> getAllDirections() async {
    if(!isSecretary()){
      return;
    }
    emit(CommonDataLoading());
    
    final result = await getDirectionsUseCase(OnlyTokenParameters(myToken));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
          directionsList = [];
          directionsList = r;
          emit(CommonDataSuccess());
        });
  }

  List<TagModel> tagsList = [];
  Future<void> getAllTags() async {
    emit(CommonDataLoading());

    final result = await getTagsUseCase(OnlyTokenParameters(myToken));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
          tagsList = [];
          tagsList = r;
          emit(CommonDataSuccess());
        });
  }

  List<SectorModel> sectorsList = [];
  Future<void> getAllSectors() async {
    emit(CommonDataLoading());
    
    //print('MY TOKEN $sessionToken');
    final result = await getSectorsUseCase(OnlyTokenParameters(myToken));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
          sectorsList = [];
          sectorsList = r;
          emit(CommonDataSuccess());
        });
  }

  List<DepartmentModel> departmentsList = [];
  Future<void> getDepartmentsBySector(Guid sectorId) async {
    emit(CommonDataLoading());
    
    final result = await getDepartmentsBySectorUseCase(GetDepartmentsBySectorParameters(myToken,sectorId));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
          departmentsList = [];
          departmentsList = r;
          UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
          departmentsList.removeWhere((element) => element.departmentId == model.departmentId);
          emit(CommonDataSuccess());
        });
  }

  List<AdditionalInformationTypeModel> additionalTypesList = [];
  Future<void> getAllAdditionalTypes() async {
    emit(CommonDataLoading());
    
    final result = await getAllAdditionalInfoTypesUseCase(OnlyTokenParameters(myToken));
    result.fold(
            (l) => emit(CommonDataError(l.errMessage)),
            (r) {
          additionalTypesList = [];
          additionalTypesList = r;
          emit(CommonDataSuccess());
        });
  }
  String getSecurityValueFromId(Guid securityLevel){
    if(securityLevel == Constants.topSecretGuid){
      return AppStrings.verySecure.tr();
    }else if(securityLevel == Constants.secretGuid){
      return AppStrings.secure.tr();
    }else{
      return AppStrings.normal.tr();
    }
  }

  DirectionModel? selectedDirection;
  void changeSelectedDirection(DirectionModel model) {
    selectedDirection = model;
    emit(CommonDataChangeSelectedDirection());
  }
  SectorModel? selectedSectorModel;
  void changeSelectedSector(SectorModel model) {
    print("CHANGED SECTOR $model");
    selectedSectorModel = model;
    selectedDepartmentModel = null;
    getDepartmentsBySector(model.sectorId);
    emit(CommonDataChangeSelectedSector());
  }
  DepartmentModel? selectedDepartmentModel;
  void changeSelectedDepartment(DepartmentModel model) {
    print("CHANGED SECTOR $model");
    selectedDepartmentModel = model;
    emit(CommonDataChangeSelectedDepartment());
  }

  List<SelectedDepartmentModel> selectedActionDepartmentsList = [];
  List<SelectedDepartmentModel> selectedKnowDepartmentsList = [];
  List<Map<String,dynamic>> uploadDepartmentsList = [];

  void removeFromAction(SelectedDepartmentModel model){
    selectedActionDepartmentsList.remove(model);
    emit(CommonDataRemoveDepartmentFromAction());
  }
  void removeFromKnow(SelectedDepartmentModel model){
    selectedKnowDepartmentsList.remove(model);
    emit(CommonDataRemoveDepartmentFromKnow());
  }

  void addAllDepartmentsToAction(){
    departmentsList.where((element) => element.sectorId == selectedSectorModel!.sectorId).toList().forEach((department) {
      addDepartmentToAction(department);
    });
    emit(CommonDataAddDepartmentToAction());
  }
  void addAllDepartmentsToKnow(){
    departmentsList.where((element) => element.sectorId == selectedSectorModel!.sectorId).toList().forEach((department) {
      addDepartmentToKnow(department);
    });
    emit(CommonDataAddDepartmentToKnow());
  }
  void addDepartmentToAction(DepartmentModel model){
    if(isDepartmentFoundAsAction(model)){
      var department = selectedActionDepartmentsList.where((element) => element.departmentId == model.departmentId).first;
      selectedActionDepartmentsList.remove(department);
    }else if(isDepartmentFoundAsKnow(model)){
      // remove from know then add to action
      var department = selectedKnowDepartmentsList.where((element) => element.departmentId == model.departmentId).first;
      selectedKnowDepartmentsList.remove(department);

      var sector = sectorsList.where((element) => element.sectorId == model.sectorId).first;
      selectedActionDepartmentsList.add(SelectedDepartmentModel(model.departmentId, model.departmentName, sector.sectorId,sector.sectorName, AppStrings.action.tr()));
    }else{
      var sector = sectorsList.where((element) => element.sectorId == model.sectorId).first;
      selectedActionDepartmentsList.add(SelectedDepartmentModel(model.departmentId, model.departmentName, sector.sectorId,sector.sectorName, AppStrings.action.tr()));
    }
    emit(CommonDataAddDepartmentToAction());
  }
  bool isDepartmentFoundAsAction(DepartmentModel model){
    if(selectedActionDepartmentsList.where((element) => element.departmentId == model.departmentId).isNotEmpty){
      var department = selectedActionDepartmentsList.where((element) => element.departmentId == model.departmentId).first;
      return department.actionName == AppStrings.action.tr();
    }else{
      return false;
    }
  }
  bool isDepartmentFoundAsKnow(DepartmentModel model){
    if(selectedKnowDepartmentsList.where((element) => element.departmentId == model.departmentId).isNotEmpty){
      var department = selectedKnowDepartmentsList.where((element) => element.departmentId == model.departmentId).first;
      return department.actionName == AppStrings.know.tr();
    }else{
      return false;
    }
  }
  void addDepartmentToKnow(DepartmentModel model){

    if(isDepartmentFoundAsKnow(model)){
      var department = selectedKnowDepartmentsList.where((element) => element.departmentId == model.departmentId).first;
      selectedKnowDepartmentsList.remove(department);
    }else if(isDepartmentFoundAsAction(model)){
      // remove from action then add to know
      var department = selectedActionDepartmentsList.where((element) => element.departmentId == model.departmentId).first;
      selectedActionDepartmentsList.remove(department);

      var sector = sectorsList.where((element) => element.sectorId == model.sectorId).first;
      selectedKnowDepartmentsList.add(SelectedDepartmentModel(model.departmentId, model.departmentName, sector.sectorId,sector.sectorName, AppStrings.know.tr()));
    }else{
      var sector = sectorsList.where((element) => element.sectorId == model.sectorId).first;
      selectedKnowDepartmentsList.add(SelectedDepartmentModel(model.departmentId, model.departmentName, sector.sectorId,sector.sectorName, AppStrings.know.tr()));
    }

    emit(CommonDataAddDepartmentToKnow());
  }
  List<TagModel> selectedTagsList = [];
  void addOrRemoveTag(TagModel model){
    selectedTagsList.contains(model) ?
    selectedTagsList.remove(model) : selectedTagsList.add(model);
    emit(CommonDataAddTags());
  }

  /*void printPdf(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }*/
  bool isSecretary(){
    var userMap = jsonDecode(Preference.getString("User").toString());
    if(userMap != null){
      UserModel myUserModel = UserModel.fromJson(userMap);
      return myUserModel.roleId == Constants.secretaryRoleId;
    }else{
      return false;
    }
  }
  Future<void> preparedFiles()async {
    multipartFiles = [];
    filesSize = [];
    filesName = [];
    print("IN PREPARE\n");
    for(int i = 0; i < pickedFiles.length; i++) {
      final file = await MultipartFile.fromFile(pickedFiles[i].path!, filename: pickedFiles[i].name,);
      multipartFiles.add(file);
      print("AFTER ADD\n");
    }
  }
  void departmentLetterList(){
    uploadDepartmentsList = [];
    for (var element in selectedActionDepartmentsList) {
      Map<String,dynamic> map = {
        'requiredAction': true,
        'departmentId' : element.departmentId.toString()
      };
      uploadDepartmentsList.add(map);
    }
    for (var element in selectedKnowDepartmentsList) {
      Map<String,dynamic> map = {
        'requiredAction': false,
        'departmentId' : element.departmentId.toString()
      };
      uploadDepartmentsList.add(map);
    }
  }


  //==============// Encryption //==============//
  Future<void> encryptPDFInBackground(String filePath) async {

    final ReceivePort receivePort = ReceivePort();
    final token = RootIsolateToken.instance;

    await Isolate.spawn(
      back.encryptPDFInBackground,
      [token,filePath, receivePort.sendPort,],
    );
    final Completer<void> completer = Completer<void>();
    receivePort.listen((message) {
      print("MESSAGE FROM ENCRYPTION");
      completer.complete();
      receivePort.close();
    });
    return completer.future;
  }

  Future<void> decryptPDFInBackground(String encryptedFilePath) async {
    final ReceivePort receivePort = ReceivePort();
    final token = RootIsolateToken.instance;
    await Isolate.spawn(
      back.decryptPDFInBackground,
      [token, encryptedFilePath, receivePort.sendPort],
    );
    final Completer<void> completer = Completer<void>();
    receivePort.listen((message) {
      print("MESSAGE FROM DECRYPTION : \n$message");
      completer.complete();
      receivePort.close();
    });
    return completer.future;
  }}