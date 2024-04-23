import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/presentation/features/letter_reply/bloc/letter_reply_states.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theming/color_manager.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../../../core/utils/app_version.dart';
import '../../../../core/utils/prefs_helper.dart';
import '../../../../domain/usecase/additional_information/add_additional_info_use_case.dart';
import '../../../../domain/usecase/letter/create_internal_default_letter_use_case.dart';
import '../../../../domain/usecase/letter_consumer/create_letter_consumer_use_case.dart';
import '../../../../domain/usecase/letter_files/create_letter_files_use_case.dart';
import '../../../../domain/usecase/letter_tags/create_letter_tags_use_case.dart';
import '../../../shared/bloc/common_data_cubit.dart';

class LetterReplyCubit extends Cubit<LetterReplyStates>{
  LetterReplyCubit() : super(LetterReplyInitial());

  static LetterReplyCubit get(context) => BlocProvider.of(context);

  CreateInternalDefaultLetterUseCase createInternalDefaultLetterUseCase = sl<CreateInternalDefaultLetterUseCase>();
  CreateLetterTagUseCase createLetterTagUseCase = sl<CreateLetterTagUseCase>();
  CreateLetterFileUseCase createLetterFileUseCase = sl<CreateLetterFileUseCase>();
  CreateLetterConsumerUseCase createLetterConsumerUseCase = sl<CreateLetterConsumerUseCase>();
  AddAdditionalInfoUseCase addAdditionalInfoUseCase = sl<AddAdditionalInfoUseCase>();

  Color letterNumberColor = ColorManager.goldColor;
  final myToken = Preference.prefs.getString('sessionToken')!;

  TextEditingController letterAboutController = TextEditingController();
  TextEditingController letterNumberController = TextEditingController();
  TextEditingController letterContentController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void changeLetterNumberColor(Color newColor){
    if(letterNumberColor != newColor){
      letterNumberColor = newColor;
      emit(LetterReplyChangeColor());
    }
  }

  Future<void> replyOnLetter(Guid parentLetterId) async {
    emit(LetterReplyLoadingSend());
    Map<String, dynamic> dataMap = {
      'letterAbout' : letterAboutController.text.toString(),
      'letterContent': letterContentController.text.toString(),
      'letterNumber': letterNumberController.text.toString(),
      'letterStateId': Constants.acceptedLetterStateGuid.toString(),
      'letterDate': DateTime.now().toString(),
      'confidentialityId': sl<CommonDataCubit>().securityLevel.toString(),
      'parentLetterId': parentLetterId.toString(),
    };

    final result = await createInternalDefaultLetterUseCase(TokenAndDataParameters(myToken, dataMap));
    result.fold(
            (l) => emit(LetterReplyErrorSend(l.errMessage)),
            (r)async{
          if(sl<CommonDataCubit>().selectedTagsList.isNotEmpty){
            for(var tag in sl<CommonDataCubit>().selectedTagsList){
              await uploadLetterTags(Guid(r['letterId'].toString()), tag.tagId, myToken);
            }
          }
          if(sl<CommonDataCubit>().pickedFiles.isNotEmpty){
            await uploadLetterFiles(Guid(r['letterId'].toString()), myToken);
          }
          if(sl<CommonDataCubit>().selectedActionDepartmentsList.isNotEmpty || sl<CommonDataCubit>().selectedKnowDepartmentsList.isNotEmpty){
            print("NOT EMPTY LIST");
            await uploadLetterConsumers(Guid(r['letterId'].toString()), myToken);
          }
          if(sl<CommonDataCubit>().textControllersList.isNotEmpty || sl<CommonDataCubit>().dateTimeList.isNotEmpty){
            await uploadLetterAdditionalTextInfo(Guid(r['letterId'].toString()), myToken);
            await uploadLetterAdditionalDateInfo(Guid(r['letterId'].toString()), myToken);
          }
          clearTools();
          emit(LetterReplySuccessSend());
        });
  }

  Future<void> uploadLetterTags(Guid letterId, Guid tagId,String token)async {
    var map = {
      'tagId': tagId.toString(),
      'letterId':letterId.toString(),
    };
    final result = await createLetterTagUseCase(TokenAndDataParameters(token,map));
    result.fold(
            (l) => emit(LetterReplyErrorSend(l.errMessage)),
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
            (l) => emit(LetterReplyErrorSend(l.errMessage)),
            (r) {});
  }

  Future<void> uploadLetterConsumers(Guid letterId, String token)async {
    sl<CommonDataCubit>().departmentLetterList();
    final result = await createLetterConsumerUseCase(CreateLetterConsumersParameters(token,letterId,sl<CommonDataCubit>().uploadDepartmentsList));
    result.fold(
            (l) => emit(LetterReplyErrorSend(l.errMessage)),
            (r) {});
  }

  Future<void> uploadLetterAdditionalTextInfo(Guid letterId, String token)async {
    var textList = sl<CommonDataCubit>().textControllersList;
    if(textList.isNotEmpty){
      for(int i = 0; i < textList.length; i++){
        var map = {
          'letterId': letterId.toString(),
          'description':textList[i].values.first.text.toString(),
          'additionalInformationTypeId':textList[i].keys.first.toString(),
          'valueType' : 2
        };

        final result = await addAdditionalInfoUseCase(TokenAndDataParameters(token,map));
        result.fold(
                (l) => emit(LetterReplyErrorSend(l.errMessage)),
                (r) {});
      }
    }
  }
  Future<void> uploadLetterAdditionalDateInfo(Guid letterId, String token)async {
    var dateList = sl<CommonDataCubit>().dateTimeList;
    if(dateList.isNotEmpty){
      for(int i = 0; i < dateList.length; i++){
        var map = {
          'letterId': letterId.toString(),
          'date':dateList[i].values.first.toString(),
          'additionalInformationTypeId':dateList[i].keys.first.toString(),
          'valueType' : 1
        };

        final result = await addAdditionalInfoUseCase(TokenAndDataParameters(token,map));
        result.fold(
                (l) => emit(LetterReplyErrorSend(l.errMessage)),
                (r) {});
      }
    }
  }

  void clearTools(){
    letterAboutController.clear();
    letterContentController.clear();
    letterNumberController.clear();
    sl<CommonDataCubit>().clearTools();
  }

}