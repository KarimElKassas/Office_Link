import 'package:foe_archiving/data/datasource/remote/auth_remote_data_source.dart';
import 'package:foe_archiving/data/datasource/remote/common_remote_data_source.dart';
import 'package:foe_archiving/data/datasource/remote/contract_remote_data_source.dart';
import 'package:foe_archiving/data/datasource/remote/letters_remote_data_source.dart';
import 'package:foe_archiving/data/repository/auth_repository.dart';
import 'package:foe_archiving/data/repository/common_repository.dart';
import 'package:foe_archiving/data/repository/contract_repository.dart';
import 'package:foe_archiving/data/repository/letter_repository.dart';
import 'package:foe_archiving/domain/repository/base_auth_repository.dart';
import 'package:foe_archiving/domain/repository/base_common_repository.dart';
import 'package:foe_archiving/domain/repository/base_contract_repository.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';
import 'package:foe_archiving/domain/usecase/additional_information/add_additional_info_use_case.dart';
import 'package:foe_archiving/domain/usecase/archived_letter/create_archived_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/archived_letter/get_archived_letters_use_case.dart';
import 'package:foe_archiving/domain/usecase/archived_letter/get_archived_outgoing_letters_use_case.dart';
import 'package:foe_archiving/domain/usecase/auth/change_password_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/add_department_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/add_direction_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/add_tag_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_additional_info_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_additional_info_type_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_all_additional_info_by_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_all_additional_info_types_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_department_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_departments_by_sector_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_direction_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_directions_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_sectors_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_tags_use_case.dart';
import 'package:foe_archiving/domain/usecase/files_and_contracts/create_contract_use_case.dart';
import 'package:foe_archiving/domain/usecase/files_and_contracts/get_all_contracts_use_case.dart';
import 'package:foe_archiving/domain/usecase/files_and_contracts/get_contract_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/create_external_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/create_internal_default_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/delete_internal_default_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/get_all_external_letters_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/get_all_outgoing_default_letters_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/get_external_letter_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/get_internal_default_letter_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_consumer/create_letter_consumer_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_consumer/get_letter_consumers_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_files/create_letter_files_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_files/get_letter_files_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_tags/create_letter_tags_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_tags/get_letter_tags_use_case.dart';
import 'package:foe_archiving/presentation/features/archived_letters/incoming/bloc/incoming_archived_letters_cubit.dart';
import 'package:foe_archiving/presentation/features/archived_letters/outgoing/bloc/outgoing_archived_letters_cubit.dart';
import 'package:foe_archiving/presentation/features/external_letter_details/bloc/external_letter_details_cubit.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/all_files_and_contracts/bloc/all_files_and_contracts_cubit.dart';
import 'package:foe_archiving/presentation/features/files_and_contracts/file_and_contract_details/bloc/file_and_contract_details_cubit.dart';
import 'package:foe_archiving/presentation/features/income_letters/external/bloc/income_external_letters_cubit.dart';
import 'package:foe_archiving/presentation/features/letter_details/bloc/letter_details_cubit.dart';
import 'package:foe_archiving/presentation/features/letter_reply/bloc/letter_reply_cubit.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/external/bloc/outgoing_external_letters_cubit.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/internal/bloc/outgoing_internal_letters_cubit.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../domain/usecase/archived_letter/get_archived_letter_by_id_use_case.dart';
import '../../domain/usecase/auth/get_user_use_case.dart';
import '../../domain/usecase/auth/login_user_use_case.dart';
import '../../domain/usecase/common/create_additional_info_use_case.dart';
import '../../domain/usecase/letter/get_all_internal_default_letters_use_case.dart';
import '../../presentation/features/archived_letters/archived_letter_details/bloc/archived_letter_details_cubit.dart';
import '../../presentation/features/files_and_contracts/new_file_and_contract/bloc/new_file_and_contract_cubit.dart';
import '../../presentation/features/income_letters/internal/bloc/income_internal_letters_cubit.dart';
import '../../presentation/features/login/bloc/login_cubit.dart';
import '../../presentation/features/new_letter/bloc/new_letter_cubit.dart';


final sl = GetIt.instance;

class ServiceLocator {
  void setup() {

    /// Blocs
    sl.registerFactory<LoginCubit>(() => LoginCubit());
    sl.registerLazySingleton<CommonDataCubit>(() => CommonDataCubit());
    sl.registerFactory<NewLetterCubit>(() => NewLetterCubit());
    sl.registerFactory<NewFileAndContractCubit>(() => NewFileAndContractCubit());
    sl.registerFactory<IncomeInternalLettersCubit>(() => IncomeInternalLettersCubit());
    sl.registerFactory<LetterDetailsCubit>(() => LetterDetailsCubit());
    sl.registerFactory<IncomingArchivedLettersCubit>(() => IncomingArchivedLettersCubit());
    sl.registerFactory<OutgoingArchivedLettersCubit>(() => OutgoingArchivedLettersCubit());
    sl.registerFactory<ArchivedLetterDetailsCubit>(() => ArchivedLetterDetailsCubit());
    sl.registerFactory<OutgoingInternalLettersCubit>(() => OutgoingInternalLettersCubit());
    sl.registerFactory<AllFilesAndContractsCubit>(() => AllFilesAndContractsCubit());
    sl.registerFactory<FileAndContractDetailsCubit>(() => FileAndContractDetailsCubit());
    sl.registerFactory<LetterReplyCubit>(() => LetterReplyCubit());
    sl.registerFactory<IncomeExternalLettersCubit>(() => IncomeExternalLettersCubit());
    sl.registerFactory<OutgoingExternalLettersCubit>(() => OutgoingExternalLettersCubit());
    sl.registerFactory<ExternalLetterDetailsCubit>(() => ExternalLetterDetailsCubit());


    /// Remote Data Source
    sl.registerLazySingleton<BaseAuthRemoteDataSource>(() => AuthRemoteDataSource());
    sl.registerLazySingleton<BaseCommonRemoteDataSource>(() => CommonRemoteDataSource());
    sl.registerLazySingleton<BaseLetterRemoteDataSource>(() => LetterRemoteDataSource());
    sl.registerLazySingleton<BaseContractRemoteDataSource>(() => ContractRemoteDataSource());

    /// Base Archive Repository
    sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(sl()));
    sl.registerLazySingleton<BaseCommonRepository>(() => CommonRepository(sl()));
    sl.registerLazySingleton<BaseLetterRepository>(() => LetterRepository(sl()));
    sl.registerLazySingleton<BaseContractRepository>(() => ContractRepository(sl()));

    ///Use Cases
    sl.registerLazySingleton<LoginUserUseCase>(() => LoginUserUseCase(sl()));
    sl.registerLazySingleton<ChangePasswordUseCase>(() => ChangePasswordUseCase(sl()));
    sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(sl()));
    sl.registerLazySingleton<GetDirectionsUseCase>(() => GetDirectionsUseCase(sl()));
    sl.registerLazySingleton<GetTagsUseCase>(() => GetTagsUseCase(sl()));
    sl.registerLazySingleton<GetDepartmentsBySectorUseCase>(() => GetDepartmentsBySectorUseCase(sl()));
    sl.registerLazySingleton<GetSectorsUseCase>(() => GetSectorsUseCase(sl()));
    sl.registerLazySingleton<GetDepartmentByIdUseCase>(() => GetDepartmentByIdUseCase(sl()));
    sl.registerLazySingleton<GetAllAdditionalInfoByLetterUseCase>(() => GetAllAdditionalInfoByLetterUseCase(sl()));
    sl.registerLazySingleton<GetAllAdditionalInfoTypesUseCase>(() => GetAllAdditionalInfoTypesUseCase(sl()));
    sl.registerLazySingleton<GetAdditionalInfoByIdUseCase>(() => GetAdditionalInfoByIdUseCase(sl()));
    sl.registerLazySingleton<GetAdditionalInfoTypeByIdUseCase>(() => GetAdditionalInfoTypeByIdUseCase(sl()));
    sl.registerLazySingleton<CreateAdditionalInfoUseCase>(() => CreateAdditionalInfoUseCase(sl()));
    sl.registerLazySingleton<CreateInternalDefaultLetterUseCase>(() => CreateInternalDefaultLetterUseCase(sl()));
    sl.registerLazySingleton<CreateArchivedLetterUseCase>(() => CreateArchivedLetterUseCase(sl()));
    sl.registerLazySingleton<CreateLetterTagUseCase>(() => CreateLetterTagUseCase(sl()));
    sl.registerLazySingleton<CreateLetterFileUseCase>(() => CreateLetterFileUseCase(sl()));
    sl.registerLazySingleton<GetLetterFilesUseCase>(() => GetLetterFilesUseCase(sl()));
    sl.registerLazySingleton<CreateLetterConsumerUseCase>(() => CreateLetterConsumerUseCase(sl()));
    sl.registerLazySingleton<AddAdditionalInfoUseCase>(() => AddAdditionalInfoUseCase(sl()));
    sl.registerLazySingleton<GetAllInternalDefaultLettersUseCase>(() => GetAllInternalDefaultLettersUseCase(sl()));
    sl.registerLazySingleton<GetArchivedLettersUseCase>(() => GetArchivedLettersUseCase(sl()));
    sl.registerLazySingleton<GetArchivedOutgoingLettersUseCase>(() => GetArchivedOutgoingLettersUseCase(sl()));
    sl.registerLazySingleton<GetInternalDefaultLetterByIdUseCase>(() => GetInternalDefaultLetterByIdUseCase(sl()));
    sl.registerLazySingleton<GetLetterConsumersUseCase>(() => GetLetterConsumersUseCase(sl()));
    sl.registerLazySingleton<DeleteInternalDefaultLetterUseCase>(() => DeleteInternalDefaultLetterUseCase(sl()));
    sl.registerLazySingleton<GetArchivedLetterByIdUseCase>(() => GetArchivedLetterByIdUseCase(sl()));
    sl.registerLazySingleton<CreateExternalLetterUseCase>(() => CreateExternalLetterUseCase(sl()));
    sl.registerLazySingleton<GetAllExternalLettersUseCase>(() => GetAllExternalLettersUseCase(sl()));
    sl.registerLazySingleton<GetExternalLetterByIdUseCase>(() => GetExternalLetterByIdUseCase(sl()));
    sl.registerLazySingleton<GetAllOutgoingDefaultLettersUseCase>(() => GetAllOutgoingDefaultLettersUseCase(sl()));
    sl.registerLazySingleton<CreateContractUseCase>(() => CreateContractUseCase(sl()));
    sl.registerLazySingleton<GetAllContractsUseCase>(() => GetAllContractsUseCase(sl()));
    sl.registerLazySingleton<GetContractByIdUseCase>(() => GetContractByIdUseCase(sl()));
    sl.registerLazySingleton<GetLetterTagsUseCase>(() => GetLetterTagsUseCase(sl()));
    sl.registerLazySingleton<AddDepartmentUseCase>(() => AddDepartmentUseCase(sl()));
    sl.registerLazySingleton<AddDirectionUseCase>(() => AddDirectionUseCase(sl()));
    sl.registerLazySingleton<AddTagUseCase>(() => AddTagUseCase(sl()));
    sl.registerLazySingleton<GetDirectionByIdUseCase>(() => GetDirectionByIdUseCase(sl()));

  }
}