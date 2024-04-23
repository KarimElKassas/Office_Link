import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/get_all_outgoing_default_letters_use_case.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/prefs_helper.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../../../data/models/user_model.dart';
import 'outgoing_internal_letters_states.dart';

class OutgoingInternalLettersCubit extends Cubit<OutgoingInternalLettersStates>{
  OutgoingInternalLettersCubit() : super(OutgoingInternalLettersInitial());

  static OutgoingInternalLettersCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken');

  GetAllOutgoingDefaultLettersUseCase getAllOutgoingDefaultLettersUseCase = sl<GetAllOutgoingDefaultLettersUseCase>();

  List<LetterModel> _lettersList = [];
  List<LetterModel> _filteredLettersList = [];

  List<LetterModel> get lettersList => _lettersList; // Getter for letters list
  List<LetterModel> get filteredList => _filteredLettersList; // Getter for filtered list

  //pagination functionality
  int pageNumber = 1;
  int pageSize = 20;
  bool isLoadingFirsTime = false;
  bool isLoadingMoreData = false;

  ScrollController controller = ScrollController();


  int totalPages = 1;
  void checkToken(){
    if(myToken == null){
      sl<CommonDataCubit>().logOut();
    }
  }
  void setupScrollController(context) {
    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          loadDefaultLetters();
          //loadArchivedLetters();
        }
      }
    });
  }
  void loadDefaultLetters() async {
    // Check if the cubit is already loading to avoid redundant requests
    if (state is OutgoingInternalLettersLoading) return;

    final currentState = state;
    var oldLetters = <LetterModel>[];

    if (currentState is OutgoingInternalLettersSuccess) {
      oldLetters = currentState.lettersList;
    }

    if (pageNumber > totalPages) {
      // If current page exceeds total pages, return without making a request
      return;
    }

    emit(OutgoingInternalLettersLoading(oldLetters, pageNumber == 1));

    Map<String, dynamic> map = {
      'IsIncoming': false,
      'Page': pageNumber,
      'Size': pageSize,
    };

    final result = await getAllOutgoingDefaultLettersUseCase(TokenAndDataParameters(myToken!, map));

    result.fold(
          (l) {
        isLoadingFirsTime = false;
        emit(OutgoingInternalLettersError(l.errMessage));
      },
          (r) {
        if (pageNumber == 1) {
          // If it's the first time, update totalPages
          Guid departmentId = myDepartmentID();
          totalPages = Preference.prefs.getInt("Department $departmentId Outgoing Default Total Pages")!;
        }

        if (pageNumber > totalPages) {
          // If current page exceeds total pages after updating, return without making a request
          return;
        }
        pageNumber++;
        _lettersList = (state as OutgoingInternalLettersLoading).oldLetters;
        _lettersList.addAll(r);
        _lettersList.sort((b, a) => a.letterDate.toString().compareTo(b.letterDate.toString()));
        _filteredLettersList = _lettersList;
        emit(OutgoingInternalLettersSuccess(_lettersList));
      },
    );
  }


  void searchLetters(String value) {
    if (state is OutgoingInternalLettersSuccess) {
      if (value.isEmpty) {
        // If search query is empty, emit the original list
        emit(OutgoingInternalLettersSuccess(_lettersList));
      } else {
        // Filter the letters list based on the search query
        _filteredLettersList = _lettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
        emit(OutgoingInternalLettersSuccess(_filteredLettersList));
      }
    }
  }


  Guid myDepartmentID(){
    UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
    return model.departmentId;
  }


}