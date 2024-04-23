import 'package:animate_do/animate_do.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foe_archiving/presentation/features/archived_letters/outgoing/ui/outgoing_archived_letters_screen.dart';
import '../../../../../core/localization/strings_manager.dart';
import '../../../../../core/theming/color_manager.dart';
import '../../../../../core/theming/font_manager.dart';
import '../../../../../core/theming/values_manager.dart';
import '../../incoming/ui/incoming_archived_letters_screen.dart';

class AllArchivedLettersScreen extends StatefulWidget {
  const AllArchivedLettersScreen({super.key});

  @override
  State<AllArchivedLettersScreen> createState() => _AllArchivedLettersScreenState();
}

class _AllArchivedLettersScreenState extends State<AllArchivedLettersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Define the number of tabs

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.archivedLetters.tr(),
          style: TextStyle(color: Theme.of(context).primaryColorDark,
              fontFamily: FontConstants.family,
              fontSize: AppSize.s18,
              fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
      ),

      backgroundColor: Theme.of(context).primaryColorLight,
      body: FadeIn(
          duration: const Duration(milliseconds: 1500),
          child: ContainedTabBarView(
            tabs: const [
              Text('الوارد'),
              Text('الصادر'),
            ],
            tabBarProperties: TabBarProperties(indicatorColor: ColorManager.goldColor,indicatorSize: TabBarIndicatorSize.tab,
              labelColor: ColorManager.goldColor, unselectedLabelColor: Theme.of(context).primaryColorDark,
              labelStyle: TextStyle(color: ColorManager.goldColor,fontFamily: FontConstants.family,fontSize: FontSize.s18),
              unselectedLabelStyle: TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: FontSize.s18),
            ),
            views: const [
              IncomingArchivedLettersScreen(),
              OutgoingArchivedLettersScreen(),
            ],
            onChange: (index) => print(index),
          )
      ),
    );
  }
}