import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/letter_consumer_model.dart';
import 'package:foe_archiving/domain/usecase/archived_letter/get_archived_letter_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_all_additional_info_by_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_department_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/delete_internal_default_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_consumer/get_letter_consumers_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_files/get_letter_files_use_case.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/utils/prefs_helper.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../../../data/models/selected_department_model.dart';
import '../../../../../data/models/user_model.dart';
import 'archived_letter_details_states.dart';

class ArchivedLetterDetailsCubit extends Cubit<ArchivedLetterDetailsStates>{
  ArchivedLetterDetailsCubit() : super(ArchivedLetterDetailsInitial());

  static ArchivedLetterDetailsCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken')!;
  
  GetLetterConsumersUseCase getLetterConsumersUseCase = sl<GetLetterConsumersUseCase>();
  GetArchivedLetterByIdUseCase getArchivedLetterByIdUseCase = sl<GetArchivedLetterByIdUseCase>();
  GetAllAdditionalInfoByLetterUseCase getAllAdditionalInfoByLetterUseCase = sl<GetAllAdditionalInfoByLetterUseCase>();
  GetLetterFilesUseCase getLetterFilesUseCase = sl<GetLetterFilesUseCase>();
  GetDepartmentByIdUseCase getDepartmentByIdUseCase = sl<GetDepartmentByIdUseCase>();
  DeleteInternalDefaultLetterUseCase defaultLetterUseCase = sl<DeleteInternalDefaultLetterUseCase>();

  List<SelectedDepartmentModel?> selectedActionDepartmentsList = [];
  List<SelectedDepartmentModel?> selectedKnowDepartmentsList = [];

  List<AdditionalInformationModel?> additionalInfoList = [];
  List<LetterFilesModel> filesList = [];
  List<LetterConsumerModel> consumersList = [];

  LetterModel? letterModel;
  Color letterNumberColor = ColorManager.goldColor;


  CommonDataCubit commonDataCubit = sl<CommonDataCubit>();

  String letterAttachmentsToString(){
    if(filesList.isEmpty){
      return AppStrings.notFound.tr();
    }else if(filesList.length == 1){
      return AppStrings.oneFile.tr();
    }else if(filesList.length == 2){
      return AppStrings.twoFiles.tr();
    }else{
      return "${filesList.length} ${AppStrings.files.tr()}";
    }
  }


  Future<void> getLetter(Guid letterId) async {
    emit(ArchivedLetterDetailsLoading());
    print("LETTER ID :$letterId");
    final result = await getArchivedLetterByIdUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(ArchivedLetterDetailsError(l.errMessage)),
            (r) {
            letterModel = r;
          if(letterModel != null){
            getLetterConsumers(letterModel!.letterId);
            getAdditionalInfo(letterModel!.letterId);
            getLetterFiles(letterModel!.letterId);
          }
          emit(ArchivedLetterDetailsSuccess());
        });
  }


  Future<void> getLetterConsumers(Guid letterId) async {
    emit(ArchivedLetterDetailsLoading());

    final result = await getLetterConsumersUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(ArchivedLetterDetailsError(l.errMessage)),
            (r) {
              consumersList = [];
              consumersList = r;
              emit(ArchivedLetterDetailsSuccess());
        });
  }
  Future<void> getAdditionalInfo(Guid letterId) async {
    emit(ArchivedLetterDetailsLoading());

    final result = await getAllAdditionalInfoByLetterUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(ArchivedLetterDetailsError(l.errMessage)),
            (r) {
              additionalInfoList = [];
              additionalInfoList = r;
              emit(ArchivedLetterDetailsSuccess());
        });
  }


  Future<void> getLetterFiles(Guid letterId) async {
    emit(ArchivedLetterDetailsLoading());

    final result = await getLetterFilesUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(ArchivedLetterDetailsError(l.errMessage)),
            (r) {
              filesList = [];
              filesList = r;
              emit(ArchivedLetterDetailsSuccess());
        });
  }

  Future<void> deleteLetter() async {
    emit(ArchivedLetterDetailsLoading());

    final result = await defaultLetterUseCase(TokenAndOneGuidParameters(myToken,letterModel!.letterId));
    result.fold(
            (l) => emit(ArchivedLetterDetailsErrorDeleteLetter(l.errMessage)),
            (r) {
          //deleteLetterFromCache(letterModel.letterId, letterType);
          emit(ArchivedLetterDetailsSuccessfulDeleteLetter());
        });
  }

  void changeLetterNumberColor(Color newColor){
    if(letterNumberColor != newColor){
      letterNumberColor = newColor;
      emit(ArchivedLetterDetailsChangeColor());
    }
  }

  bool isLetterMine(LetterModel letterModel){
    var userMap = jsonDecode(Preference.getString("User").toString());
    if(userMap != null){
      UserModel myUserModel = UserModel.fromJson(userMap);
      return myUserModel.departmentId == letterModel.departmentId;
    }else{
      return false;
    }
  }

  List<PlatformFile> pickedFiles = [];
  void preparePickedFiles(){
    if(filesList.isNotEmpty){
      for (var element in filesList) {
        pickedFiles.add(PlatformFile(name: element.fileName, size: 0,path: element.filePath));
      }
    }
  }


  Future<String> getDepartmentName(Guid departmentId) async {
    final result = await getDepartmentByIdUseCase(GetDepartmentByIdParameters(myToken,departmentId));
    String name = '';
    result.fold(
            (l) {
          emit(ArchivedLetterDetailsError(l.errMessage));
          name = 'EMPTY';
        },
            (r) {
          print("NAME HERE IS :$r");
          name = r.departmentName;
          emit(ArchivedLetterDetailsSuccess());
        });
    return name;
  }

}