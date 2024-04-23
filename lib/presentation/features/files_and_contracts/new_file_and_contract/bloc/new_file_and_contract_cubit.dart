import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/domain/usecase/files_and_contracts/create_contract_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_files/create_letter_files_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_tags/create_letter_tags_use_case.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/use_case/base_use_case.dart';
import '../../../../../core/utils/app_version.dart';
import '../../../../../core/utils/prefs_helper.dart';
import '../../../../../data/models/user_model.dart';
import 'new_file_and_contract_states.dart';

class NewFileAndContractCubit extends Cubit<NewFileAndContractStates>{
  NewFileAndContractCubit(): super(NewFileAndContractInitial());

  static NewFileAndContractCubit get(context) => BlocProvider.of(context);

  CreateContractUseCase createContractUseCase = sl<CreateContractUseCase>();
  CreateLetterTagUseCase createLetterTagUseCase = sl<CreateLetterTagUseCase>();
  CreateLetterFileUseCase createLetterFileUseCase = sl<CreateLetterFileUseCase>();

  CommonDataCubit commonDataCubit = sl<CommonDataCubit>();
  final myToken = Preference.prefs.getString('sessionToken')!;

  TextEditingController letterAboutController = TextEditingController();
  TextEditingController letterNumberController = TextEditingController();
  TextEditingController letterContentController = TextEditingController();
  ScrollController scrollController = ScrollController();

  DateTime letterDate = DateTime.now();


  void changeCalendarDate(DateTime newDate){
    letterDate = newDate;
    emit(NewFileAndContractChangeDate());
  }

  Future<void> uploadContract() async {
    emit(NewFileAndContractLoading());

    Map<String, dynamic> dataMap = {
      'letterAbout' : letterAboutController.text.toString(),
      'letterContent': letterContentController.text.toString(),
      'letterNumber': letterNumberController.text.toString(),
      'letterStateId': Constants.acceptedLetterStateGuid.toString(),
      'confidentialityId': commonDataCubit.securityLevel.toString(),
      'letterDate': letterDate.toString(),
    };

    final result = await createContractUseCase(TokenAndDataParameters(myToken, dataMap));
    result.fold(
            (l) => emit(NewFileAndContractError(l.errMessage)),
            (letterId)async{
          print("LETTER ID : $letterId");
          if(sl<CommonDataCubit>().selectedTagsList.isNotEmpty){
            print("TAGS : ${sl<CommonDataCubit>().selectedTagsList}");
            for(var tag in sl<CommonDataCubit>().selectedTagsList){
              uploadLetterTags(Guid(letterId), tag.tagId, myToken);
            }
          }
          if(sl<CommonDataCubit>().pickedFiles.isNotEmpty){
            await uploadLetterFiles(Guid(letterId), myToken);
          }

          clearTools();
          emit(NewFileAndContractSuccess());
        });
  }

  Future<void> uploadLetterTags(Guid letterId, Guid tagId,String token)async {
    var map = {
      'tagId': tagId.toString(),
      'letterId':letterId.toString(),
    };
    final result = await createLetterTagUseCase(TokenAndDataParameters(token,map));
    result.fold(
            (l) => emit(NewFileAndContractError(l.errMessage)),
            (r) {});
  }

  Future<void> uploadLetterFiles(Guid letterId, String token)async {
    await sl<CommonDataCubit>().preparedFiles();
    var map = {
      'letterId': letterId.toString(),
      'files':sl<CommonDataCubit>().multipartFiles,
    };
    final result = await createLetterFileUseCase(TokenAndDataParameters(token,map));
    result.fold(
            (l) => emit(NewFileAndContractError(l.errMessage)),
            (r) {});
  }

  void clearTools(){
    letterAboutController.clear();
    letterContentController.clear();
    letterNumberController.clear();
    letterDate = DateTime.now();
    sl<CommonDataCubit>().clearTools();
  }

}