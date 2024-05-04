import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/domain/usecase/archived_letter/get_archived_letters_use_case.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/prefs_helper.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../../../data/models/user_model.dart';
import 'incoming_archived_letters_states.dart';

class IncomingArchivedLettersCubit extends Cubit<IncomingArchivedLettersStates>{
  IncomingArchivedLettersCubit() : super(IncomingArchivedLettersInitial());

  static IncomingArchivedLettersCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken')!;

  GetArchivedLettersUseCase getArchivedLettersUseCase = sl<GetArchivedLettersUseCase>();

  List<LetterModel> _originalList = [];
  List<LetterModel> _lettersList = [];
  List<LetterModel> _filteredLettersList = [];

  List<LetterModel> get originalList => _originalList; // Getter for original list
  List<LetterModel> get lettersList => _lettersList; // Getter for letters list
  List<LetterModel> get filteredList => _filteredLettersList; // Getter for filtered list

  //pagination functionality
  int pageNumber = 1;
  int pageSize = 20;
  bool isLoadingFirsTime = false;
  bool isLoadingMoreData = false;


  ScrollController controller = ScrollController();
  TextEditingController searchController = TextEditingController();

  int totalPages = 1;

  void resetValues(){
    pageNumber = 1;
    isLoadingFirsTime = false;
    isLoadingMoreData = false;
    _lettersList.clear();
    _originalList.clear();
    _filteredLettersList.clear();
  }

  void setupScrollController(context) {
    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          loadArchivedLetters();
          //loadArchivedLetters();
        }
      }
    });
  }
  Future<void> loadArchivedLetters() async {
    // Check if the cubit is already loading to avoid redundant requests
    if (state is IncomingArchivedLettersLoading) return;

    final currentState = state;
    var oldLetters = <LetterModel>[];

    if (currentState is IncomingArchivedLettersSuccess) {
      oldLetters = currentState.lettersList;
    }

    if (pageNumber > totalPages) {
      print("TRUE");
      // If current page exceeds total pages, return without making a request
      return;
    }

    emit(IncomingArchivedLettersLoading(oldLetters, pageNumber == 1));

    Map<String, dynamic> map = {
      'Page': pageNumber,
      'Size': pageSize,
      'IsIncoming' : true
    };

    final result = await getArchivedLettersUseCase(TokenAndDataParameters(myToken, map));

    result.fold(
          (l) {emit(IncomingArchivedLettersError(l.errMessage));},
          (r) {
            if (pageNumber == 1) {
              // If it's the first time, update totalPages
              Guid departmentId = myDepartmentID();
              totalPages = Preference.prefs.getInt("Department $departmentId Archived Letter Total Pages")!;
            }
            print("TOTAL PAGES : $totalPages");

            if (pageNumber > totalPages) {
              // If current page exceeds total pages after updating, return without making a request
              return;
            }
            pageNumber++;
        _lettersList = (state as IncomingArchivedLettersLoading).oldLetters;
        _lettersList.addAll(r);
        _lettersList.sort((b, a) => a.letterDate.toString().compareTo(b.letterDate.toString()));
        _originalList = _lettersList;
        _filteredLettersList = _lettersList;
        emit(IncomingArchivedLettersSuccess(_lettersList));
      },
    );
  }
  void searchLetters(String value) {
    if (state is IncomingArchivedLettersSuccess) {
      if (value.isEmpty) {
        // If search query is empty, emit the original list
        emit(IncomingArchivedLettersSuccess(_lettersList));
      } else {
        // Filter the letters list based on the search query
        _filteredLettersList = _lettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
        emit(IncomingArchivedLettersSuccess(_filteredLettersList));
      }
    }
  }
  Guid myDepartmentID(){
    UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
    return model.departmentId;
  }

  void removeLetterFromListById(Guid letterId){
    print("BEFORE : ${_lettersList.length}");
    _lettersList.removeWhere((element) => element.letterId == letterId);
    _lettersList.sort((b, a) => a.letterDate.toString().compareTo(b.letterDate.toString()));
    _originalList = _lettersList;
    _filteredLettersList = _lettersList;
    print("AFTER : ${_lettersList.length}");
    emit(IncomingArchivedLettersSuccess(_lettersList));
  }

}