import 'dart:ui';
import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/helpers/extensions.dart';
import 'package:foe_archiving/core/routing/routes.dart';
import 'package:iconly/iconly.dart';
import 'dart:ui' as ui;
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/strings_manager.dart';
import '../../../../core/theming/color_manager.dart';
import '../../../../core/theming/font_manager.dart';
import '../../../../core/theming/values_manager.dart';
import '../../../../core/widgets/default_button.dart';
import '../../../../core/widgets/default_text_field.dart';
import '../../../../core/widgets/show_toast.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context, state){
          if(state is LoginSuccessState){
            context.pushReplacementNamed(Routes.archiveHomeRoute);
          }
          if(state is LoginErrorState){
            showMToast(context, state.error??"",  TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontFamily: FontConstants.family,
                fontSize: AppSize.s20,
                fontWeight: FontWeightManager.bold), ColorManager.goldColor.withOpacity(0.4));
          }
        },
        builder: (context, state){
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: AppSize.s0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).primaryColorLight,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColorLight,
            //extendBodyBehindAppBar: true,
            body: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Form(
                key: formKey,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.asset(
                      "assets/images/final_back.png",
                      fit: BoxFit.fill,
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 64, left: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width *0.30,
                                decoration: BoxDecoration(
                                    color: Color(0xff6174A1).withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(Radius.circular(AppSize.s12))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: AppSize.s24, left: AppSize.s12, right: AppSize.s12, bottom: AppSize.s24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: AppSize.s32,),
                                      registerTextField(

                                          context: context,
                                          background: Colors.transparent,
                                          textInputType: TextInputType.text,
                                          hintText: AppStrings.userName.tr(),
                                          textInputAction: TextInputAction.next,
                                          suffixIcon: Icon(IconlyBold.profile, color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),),
                                          controller: cubit.nameController,
                                          validate: (value) {
                                            if(value!.isEmpty){
                                              return AppStrings.userNameRequired.tr();
                                            }
                                          }, onChanged: (String? value) {}),
                                      const SizedBox(height: AppSize.s32,),
                                      registerTextField(
                                        onSubmit: (value)async{
                                          if (formKey.currentState!.validate()) {
                                            await cubit.loginUser();
                                          }
                                        },
                                        context: context,
                                        background: Colors.transparent,
                                        textInputType: TextInputType.visiblePassword,
                                        hintText: AppStrings.userPassword.tr(),
                                        textInputAction: TextInputAction.done,
                                        suffixIcon: Icon(IconlyBold.password, color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),),
                                        controller: cubit.passwordController,
                                        validate: (value) {
                                          if(value!.isEmpty) {
                                            return AppStrings.userPasswordRequired.tr();
                                          }
                                        },
                                        prefixIcon: InkWell(
                                          onTap: (){
                                            cubit.changePasswordVisibility();
                                          },
                                          child: Icon(cubit.isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),),
                                        ),
                                        isPassword: cubit.isPassword, onChanged: (String? value) {},
                                      ),
                                      const SizedBox(height: AppSize.s32,),
                                      BuildCondition(
                                        condition: state is LoginLoadingState,
                                        builder: (context) => Center(child: CircularProgressIndicator(strokeWidth: AppSize.s0_8, color: Theme.of(context).primaryColorDark,),),
                                        fallback: (context) => Align(
                                          alignment: Alignment.bottomCenter,
                                          child: defaultButton(
                                            width: double.infinity,
                                              function: () {},
                                              text: AppStrings.login.tr(),
                                              radius: AppSize.s12,
                                              background: Colors.transparent,
                                              borderColor: Theme.of(context).primaryColorDark,
                                              textStyle: TextStyle(
                                                  color: Theme.of(context).primaryColorDark,
                                                  fontFamily: FontConstants.family,
                                                  fontSize: AppSize.s14)).ripple(() async{

                                            if (formKey.currentState!.validate()) {
                                              await cubit.loginUser();
                                            }
                                          }, borderRadius: const BorderRadius.all(Radius.circular(AppSize.s12)), overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
