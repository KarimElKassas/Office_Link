import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_states.dart';
import 'package:iconly/iconly.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/strings_manager.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/font_manager.dart';
import '../../../core/theming/values_manager.dart';
import '../../../core/widgets/default_text_field.dart';
import '../../../data/models/tag_model.dart';

class SelectTagsComponent extends StatelessWidget {
  SelectTagsComponent({Key? key}) : super(key: key);
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommonDataCubit, CommonDataStates>(
      bloc: sl<CommonDataCubit>(),
      listener: (context, state){},
      builder: (context, state){
        var cubit = sl<CommonDataCubit>();
        return DropdownButtonHideUnderline(
          child: DropdownButton2<TagModel>(
            isExpanded: true,
            hint: Text(
              AppStrings.selectTags.tr(),
              style: TextStyle(
                fontSize: AppSize.s14,
                fontFamily: FontConstants.family,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: cubit.tagsList
                .map((item) => DropdownMenuItem(
              enabled: false,
              value: item,
              child: StatefulBuilder(
                builder: (context, menuSetState){
                  return InkWell(
                    onTap: (){
                      cubit.addOrRemoveTag(item);
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          if (cubit.selectedTagsList.contains(item))
                            const Icon(Icons.check_box_outlined)
                          else
                            const Icon(Icons.check_box_outline_blank),
                          const SizedBox(width: AppSize.s16),
                          Expanded(
                            child: Text(
                              item.tagName,
                              style: const TextStyle(
                                fontSize: AppSize.s14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )).toList(),
            value: cubit.selectedTagsList.isEmpty ? null : cubit.selectedTagsList.last,
            onChanged: (value) {},
            selectedItemBuilder: (context) {
              return cubit.tagsList.map(
                    (item) {
                  return Container(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      cubit.selectedTagsList.map((model) => model.tagName).join(', '),
                      style: const TextStyle(
                        fontSize: AppSize.s14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  );
                },
              ).toList();
            },
            buttonStyleData: ButtonStyleData(
                height: 40,
                width: 220,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                  borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                )
            ),
            dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                )
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            style: TextStyle(color: ColorManager.darkSecondColor),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: registerTextField(
                    context: context,
                    background: Colors.transparent,
                    borderColor: ColorManager.darkSecondColor,
                    cursorColor: ColorManager.darkSecondColor,
                    textInputType: TextInputType.text,
                    hintText: AppStrings.searchForDirection.tr(),
                    textStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                    hintStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                    textInputAction: TextInputAction.next,
                    suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                    controller: textEditingController,
                    validate: (value) {}, onChanged: (String? value) {}),
              ),
              searchMatchFn: (item, searchValue) {
                return (item.value.toString().contains(searchValue));
              },
            ),
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        );
      },
    );
  }
}
