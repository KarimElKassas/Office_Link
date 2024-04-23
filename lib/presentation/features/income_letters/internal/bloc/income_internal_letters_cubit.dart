import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/domain/usecase/archived_letter/get_archived_letters_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/get_all_internal_default_letters_use_case.dart';
import 'package:foe_archiving/presentation/features/income_letters/internal/bloc/income_internal_letters_states.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/prefs_helper.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../../../data/models/user_model.dart';

class IncomeInternalLettersCubit extends Cubit<IncomeInternalLettersStates>{
  IncomeInternalLettersCubit() : super(IncomeInternalLettersInitial());

  static IncomeInternalLettersCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken')!;

  GetAllInternalDefaultLettersUseCase getInternalDefaultLettersUseCase = sl<GetAllInternalDefaultLettersUseCase>();
  GetArchivedLettersUseCase getArchivedLettersUseCase = sl<GetArchivedLettersUseCase>();

  List<LetterModel> _originalList = [];
  List<LetterModel> _lettersList = [];
  List<LetterModel> _filteredLettersList = [];

  List<LetterModel> get originalList => _originalList; // Getter for original list
  List<LetterModel> get lettersList => _lettersList; // Getter for letters list
  List<LetterModel> get filteredList => _filteredLettersList; // Getter for filtered list

  //pagination functionality
  int defaultLetterPageNumber = 1;
  int defaultLetterPageSize = 20;
  bool defaultLetterIsLoadingFirsTime = false;
  bool defaultLetterIsLoadingMoreData = false;
  bool defaultLetterHasNextPage = true;

  ScrollController controller = ScrollController();
  TextEditingController searchController = TextEditingController();

  bool defaultLetterHasReachedMax = false;
  int totalPages = 1;

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
    if (state is IncomeInternalLettersLoading) return;

    final currentState = state;
    var oldLetters = <LetterModel>[];

    if (currentState is IncomeInternalLettersSuccess) {
      oldLetters = currentState.lettersList;
    }

    if (defaultLetterPageNumber > totalPages) {
      // If current page exceeds total pages, return without making a request
      return;
    }

    emit(IncomeInternalLettersLoading(oldLetters, defaultLetterPageNumber == 1));

    Map<String, dynamic> map = {
      'IsIncoming': true,
      'Page': defaultLetterPageNumber,
      'Size': defaultLetterPageSize,
    };

    final result = await getInternalDefaultLettersUseCase(TokenAndDataParameters(myToken, map));

    result.fold(
          (l) {
        defaultLetterIsLoadingFirsTime = false;
        emit(IncomeInternalLettersError(l.errMessage));
      },
          (r) {
            print("DATA : $r");
            if (defaultLetterPageNumber == 1) {
              // If it's the first time, update totalPages
              Guid departmentId = myDepartmentID();
              totalPages = Preference.prefs.getInt("Department $departmentId Internal Default Total Pages")!;
            }
            print("TOTAL PAGES : $totalPages");

            if (defaultLetterPageNumber > totalPages) {
              // If current page exceeds total pages after updating, return without making a request
              return;
            }
            defaultLetterPageNumber++;
        _lettersList = (state as IncomeInternalLettersLoading).oldLetters;
        _lettersList.addAll(r);
        _lettersList.sort((b, a) => a.letterDate.toString().compareTo(b.letterDate.toString()));
        _originalList = _lettersList;
        _filteredLettersList = _lettersList;
        emit(IncomeInternalLettersSuccess(_lettersList));
      },
    );
  }

  void searchLetters(String value) {
    if (state is IncomeInternalLettersSuccess) {
      if (value.isEmpty) {
        // If search query is empty, emit the original list
        emit(IncomeInternalLettersSuccess(_lettersList));
      } else {
        // Filter the letters list based on the search query
        _filteredLettersList = _lettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
        emit(IncomeInternalLettersSuccess(_filteredLettersList));
      }
    }
  }
  Guid myDepartmentID(){
    UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
    return model.departmentId;
  }

}