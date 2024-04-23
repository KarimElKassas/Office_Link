import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/domain/usecase/files_and_contracts/get_all_contracts_use_case.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/all_files_and_contracts/bloc/all_file_and_contracts_states.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/prefs_helper.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../../../data/models/user_model.dart';

class AllFilesAndContractsCubit extends Cubit<AllFilesAndContractsStates>{
  AllFilesAndContractsCubit() : super(AllFilesAndContractsInitial());

  static AllFilesAndContractsCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken')!;

  GetAllContractsUseCase getAllContractsUseCase = sl<GetAllContractsUseCase>();

  List<LetterModel> _lettersList = [];
  List<LetterModel> _filteredLettersList = [];

  List<LetterModel> get lettersList => _lettersList; // Getter for letters list
  List<LetterModel> get filteredList => _filteredLettersList; // Getter for filtered list

  //pagination functionality
  int pageNumber = 1;
  int pageSize = 20;

  ScrollController controller = ScrollController();


  int totalPages = 1;

  void setupScrollController(context) {
    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          loadContracts();
        }
      }
    });
  }
  void loadContracts() async {
    // Check if the cubit is already loading to avoid redundant requests
    if (state is AllFilesAndContractsLoading) return;

    final currentState = state;
    var oldLetters = <LetterModel>[];

    if (currentState is AllFilesAndContractsSuccess) {
      oldLetters = currentState.lettersList;
    }

    if (pageNumber > totalPages) {
      // If current page exceeds total pages, return without making a request
      return;
    }

    emit(AllFilesAndContractsLoading(oldLetters, pageNumber == 1));

    Map<String, dynamic> map = {
      'Page': pageNumber,
      'Size': pageSize,
    };

    final result = await getAllContractsUseCase(TokenAndDataParameters(myToken, map));

    result.fold(
          (l) {emit(AllFilesAndContractsError(l.errMessage));},
          (r) {
        if (pageNumber == 1) {
          // If it's the first time, update totalPages
          Guid departmentId = myDepartmentID();
          totalPages = Preference.prefs.getInt("Department $departmentId Contracts Total Pages")!;
        }

        if (pageNumber > totalPages) {
          // If current page exceeds total pages after updating, return without making a request
          return;
        }
        pageNumber++;
        _lettersList = (state as AllFilesAndContractsLoading).oldLetters;
        _lettersList.addAll(r);
        _lettersList.sort((b, a) => a.letterDate.toString().compareTo(b.letterDate.toString()));
        _filteredLettersList = _lettersList;
        emit(AllFilesAndContractsSuccess(_lettersList));
      },
    );
  }


  void searchLetters(String value) {
    if (state is AllFilesAndContractsSuccess) {
      if (value.isEmpty) {
        // If search query is empty, emit the original list
        emit(AllFilesAndContractsSuccess(_lettersList));
      } else {
        // Filter the letters list based on the search query
        _filteredLettersList = _lettersList.where((element) => element.letterNumber.contains(value) || element.letterAbout.contains(value) || element.letterContent.contains(value)).toList();
        emit(AllFilesAndContractsSuccess(_filteredLettersList));
      }
    }
  }

  Guid myDepartmentID(){
    UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
    return model.departmentId;
  }

}