import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../common/themes.dart';
import 'side_navigation_drawer_model.dart';

class SideNavigationDrawer extends StackedView<SideNavigationDrawerModel> {
  const SideNavigationDrawer({
    super.key,
    required this.closeNavigation,
  });

  final Function() closeNavigation;

  @override
  Widget builder(
    BuildContext context,
    SideNavigationDrawerModel viewModel,
    Widget? child,
  ) {
    return Container(
      width: 270.0,
      padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      color: context.theme.appColors.appbarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 32.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  color: Colors.white,
                  height: 30.0,
                ),
              ),
              InkWell(
                onTap: closeNavigation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                  child: PhosphorIcon(
                    PhosphorIcons.x(PhosphorIconsStyle.bold),
                    color: context.theme.appColors.secondaryOnDark,
                    size: 20.0,
                    semanticLabel: 'Close',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 45.0),
          InkWell(
            onTap: () {
              closeNavigation();
              viewModel.onTapSearch();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
                    color: context.theme.appColors.primaryOnDark,
                    size: 24.0,
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    'Search',
                    style: TextStyle(
                      color: context.theme.appColors.primaryOnDark,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              closeNavigation();
              viewModel.onTapSettings();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.gear(PhosphorIconsStyle.regular),
                    color: context.theme.appColors.primaryOnDark,
                    size: 24.0,
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: context.theme.appColors.primaryOnDark,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  SideNavigationDrawerModel viewModelBuilder(
    BuildContext context,
  ) =>
      SideNavigationDrawerModel();
}
