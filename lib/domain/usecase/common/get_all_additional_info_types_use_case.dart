import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/additional_information_type_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../repository/base_common_repository.dart';

class GetAllAdditionalInfoTypesUseCase extends BaseUseCase<List<AdditionalInformationTypeModel>, OnlyTokenParameters> {
  BaseCommonRepository commonRepository;
  GetAllAdditionalInfoTypesUseCase(this.commonRepository);

  @override
  Future<Either<Failure, List<AdditionalInformationTypeModel>>> call(OnlyTokenParameters parameters)async {
    return await commonRepository.getAllAdditionalInfoTypes(parameters);
  }
}

