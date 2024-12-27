import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/themes.dart';
import '../../../common/enums.dart';
import '../../widgets/common/side_navigation_drawer/side_navigation_drawer.dart';
import 'reader_viewmodel.dart';
import 'widgets/primary_reader_appbar/primary_reader_appbar.dart';
import 'widgets/reader_area_popup/reader_area_popup.dart';
import 'widgets/secondary_reader_appbar/secondary_reader_appbar.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ReaderView extends StackedView<ReaderViewModel> {
  const ReaderView({super.key});

  @override
  void onViewModelReady(ReaderViewModel viewModel) async {
    super.onViewModelReady(viewModel);
    await viewModel.initilize();
  }

  @override
  Widget builder(
    BuildContext context,
    ReaderViewModel viewModel,
    Widget? child,
  ) {
    // Color the statusbar based on the active theme.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: context.theme.appColors.appbarBackground,
    ));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.theme.appColors.appbarBackground,
      appBar: viewModel.showSecondaryArea
          ? PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: SafeArea(
                child: SecondaryReaderAppbar(
                  isReaderAreaPopupActive: viewModel.isSecondaryReaderAreaPopupActive,
                  onTapBook: () => viewModel.onTapBook(Area.secondary),
                  onTapBibleVersion: () => viewModel.onTapBibleVersion(Area.secondary),
                  onTapClose: viewModel.onTapCloseSecondaryArea,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: context.theme.appColors.background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: WebViewWidget(
                      controller: viewModel.webviewController,
                    ),
                  ),
                  if (viewModel.primaryAreaBible != 'KJV' || viewModel.secondaryAreaBible != 'KJV')
                    Container(
                      color: context.theme.appColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                      child: Text(
                        'This is still a very early look into the unfinished text of the Open English Translation of the Bible. Please double-check the text in advance before using in public. Found a mistake or have questions about the translation? Please visit www.openenglishtranslation.bible.',
                        style: TextStyle(
                          fontSize: 8.0,
                          color: context.theme.appColors.readerText,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (viewModel.isSecondaryReaderAreaPopupActive)
              Align(
                alignment: Alignment.topCenter,
                child: ReaderAreaPopup(
                  readerArea: Area.secondary,
                  onToggleSecondaryArea: viewModel.onToggleSecondaryArea,
                  onToggleLinkedScrolling: viewModel.onToggleLinkedScrolling,
                ),
              ),
            if (viewModel.isPrimaryReaderAreaPopupActive)
              Align(
                alignment: Alignment.bottomCenter,
                child: ReaderAreaPopup(
                  readerArea: Area.primary,
                  onToggleSecondaryArea: viewModel.onToggleSecondaryArea,
                  onToggleLinkedScrolling: viewModel.onToggleLinkedScrolling,
                ),
              ),
          ],
        ),
      ),
      endDrawer: SideNavigationDrawer(
        closeNavigation: () => _scaffoldKey.currentState?.closeEndDrawer(),
      ),
      bottomNavigationBar: PrimaryReaderAppbar(
        isReaderAreaPopupActive: viewModel.isPrimaryReaderAreaPopupActive,
        onTapSearch: viewModel.onTapSearch,
        onTapBook: () => viewModel.onTapBook(Area.primary),
        onTapBibleVersion: () => viewModel.onTapBibleVersion(Area.primary),
        onTapMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton.small(
              backgroundColor: context.theme.appColors.appbarBackground,
              onPressed: viewModel.onRefreshDebug,
            )
          : null,
    );
  }

  @override
  ReaderViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderViewModel(context: context);
}
