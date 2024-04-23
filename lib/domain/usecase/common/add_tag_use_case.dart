import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/tag_model.dart';
import '../../repository/base_common_repository.dart';

class AddTagUseCase extends BaseUseCase<TagModel, TokenAndDataParameters> {
  BaseCommonRepository commonRepository;
  AddTagUseCase(this.commonRepository);

  @override
  Future<Either<Failure, TagModel>> call(TokenAndDataParameters parameters)async {
    return await commonRepository.createTag(parameters);
  }
}

