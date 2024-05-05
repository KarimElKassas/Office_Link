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
import 'package:foe_archiving/domain/usecase/files_and_contracts/get_contract_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/delete_internal_default_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_consumer/get_letter_consumers_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_files/get_letter_files_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_tags/get_letter_tags_use_case.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/all_files_and_contracts/bloc/all_files_and_contracts_cubit.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/file_and_contract_details/bloc/file_and_contract_details_states.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/utils/prefs_helper.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../../../data/models/selected_department_model.dart';
import '../../../../../data/models/user_model.dart';
import '../../../../../domain/usecase/files_and_contracts/delete_contract_use_case.dart';

class FileAndContractDetailsCubit extends Cubit<FileAndContractDetailsStates>{
  FileAndContractDetailsCubit() : super(FileAndContractDetailsInitial());

  static FileAndContractDetailsCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken')!;
  
  GetContractByIdUseCase getContractByIdUseCase = sl<GetContractByIdUseCase>();
  GetLetterFilesUseCase getLetterFilesUseCase = sl<GetLetterFilesUseCase>();
  GetLetterTagsUseCase getLetterTagsUseCase = sl<GetLetterTagsUseCase>();
  DeleteContractUseCase deleteContractUseCase=sl<DeleteContractUseCase>();

  List<LetterFilesModel> filesList = [];
  List<LetterTags> tagsList = [];

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

  Future<void> getContract(Guid letterId) async {
    emit(FileAndContractDetailsLoading());
    print("LETTER ID :$letterId");
    final result = await getContractByIdUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(FileAndContractDetailsError(l.errMessage)),
            (r) {
            letterModel = r;
          if(letterModel != null){
            getLetterFiles(letterModel!.letterId);
          }
          emit(FileAndContractDetailsSuccess());
        });
  }

  Future<void> getLetterFiles(Guid letterId) async {
    emit(FileAndContractDetailsLoading());
    print("MY TOKEN : $myToken");
    final result = await getLetterFilesUseCase(TokenAndOneGuidParameters(myToken,letterId));
    print("RESULT : $result");
    result.fold(
            (l) => emit(FileAndContractDetailsError(l.errMessage)),
            (r) {
              filesList = [];
              filesList = r;
              emit(FileAndContractDetailsSuccess());
        });
  }


  Future<void> deleteContract(AllFilesAndContractsCubit allFilesAndContractsCubit) async {
    emit(FileAndContractDetailsLoading());
    debugPrint('letter id :${letterModel!.letterId}');
    debugPrint('token :$myToken');
    final result = await deleteContractUseCase(TokenAndOneGuidParameters(myToken,letterModel!.letterId));
    result.fold(
            (l) => emit(FileAndContractDetailsErrorDeleteLetter(l.errMessage)),
            (r) {
              allFilesAndContractsCubit.removeLetterFromListById(letterModel!.letterId);
          //deleteLetterFromCache(letterModel.letterId, letterType);
          emit(FileAndContractDetailsSuccessfulDeleteLetter());

        });
  }


  void changeLetterNumberColor(Color newColor){
    if(letterNumberColor != newColor){
      letterNumberColor = newColor;
      emit(FileAndContractDetailsChangeColor());
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

}