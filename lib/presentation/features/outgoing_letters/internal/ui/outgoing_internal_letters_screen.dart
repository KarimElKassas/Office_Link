import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/internal/bloc/outgoing_internal_letters_cubit.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/internal/bloc/outgoing_internal_letters_states.dart';
import 'package:foe_archiving/presentation/features/outgoing_letters/internal/ui/default_outgoing_letters_list.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/functions/date_time_helpers.dart';
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/theming/font_manager.dart';
import '../../../../../core/theming/values_manager.dart';
import '../../../../../core/widgets/default_text_field.dart';
import '../../../../../data/models/letter_model.dart';
import '../../../letter_details/helper/letter_details_args.dart';

class OutgoingInternalLettersScreen extends StatelessWidget {
  const OutgoingInternalLettersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OutgoingInternalLettersCubit>()..checkToken()..setupScrollController(context)..loadDefaultLetters(),
      child: BlocConsumer<OutgoingInternalLettersCubit,OutgoingInternalLettersStates>(
        listener: (context, state){},
        builder: (context, state){
          var cubit = OutgoingInternalLettersCubit.get(context);
          var commonDataCubit = sl<CommonDataCubit>();

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppStrings.outgoingInternalLetters.tr(),
                style: TextStyle(color: Theme.of(context).primaryColorDark,
                    fontFamily: FontConstants.family,
                    fontSize: AppSize.s18,
                    fontWeight: FontWeight.bold),),
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Theme.of(context).primaryColorLight,
            body: FadeIn(
                duration: const Duration(milliseconds: 1500),
                child: Column(
                  children: [
                    searchAndFilterWidget(context, cubit),
                    const SizedBox(height:  AppSize.s16,),
                    Expanded(
                      child: DefaultOutgoingLettersListView(letterCubit: cubit,),
                    ),
                  ],
                ),
            ),
          );
        },
      ),
    );
  }
}

Widget searchAndFilterWidget(BuildContext context, OutgoingInternalLettersCubit cubit){
  return Container(
    decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(color: Colors.transparent,width: 0),
        borderRadius: BorderRadius.circular(AppSize.s16)
    ),
    margin: const EdgeInsets.all(AppSize.s8),
    padding: const EdgeInsets.all(AppSize.s12),
    child: Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: registerTextField(
                  context: context,
                  background: Colors.transparent,
                  borderStyle: BorderStyle.none,
                  textInputType: TextInputType.text,
                  hintText: AppStrings.searchLetters.tr(),
                  textInputAction: TextInputAction.next,
                  suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorDark,),
                  borderColor: Theme.of(context).primaryColorDark,
                  validate: (value) {},
                  onChanged: (String? value) {
                    cubit.searchLetters(value!);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s12,),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s12),
          //child:
        ),

      ],
    ),
  );
}
