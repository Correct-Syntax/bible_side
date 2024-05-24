import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:stacked/stacked.dart';

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
  void onViewModelReady(ReaderViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initilize();
  }

  @override
  Widget builder(
    BuildContext context,
    ReaderViewModel viewModel,
    Widget? child,
  ) {
    // Color the statusbar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: context.theme.appColors.appbarBackground,
    ));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.theme.appColors.background,
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
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                visible: viewModel.showSecondaryArea,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Scrollable(
                      controller: viewModel.secondaryAreaController,
                      viewportBuilder: (BuildContext context, ViewportOffset position) {
                        return Viewport(
                          offset: position,
                          center: viewModel.downListKey,
                          slivers: [
                            PagedSliverList(
                              pagingController: viewModel.secondaryPagingUpController,
                              builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                                animateTransitions: true,
                                transitionDuration: const Duration(milliseconds: 250),
                                itemBuilder: (context, item, index) => VisibilityDetector(
                                  key: ValueKey('${item['page']}'),
                                  onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                                      viewModel.setChapter(item['page']),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 1.0),
                                    child: SelectableText.rich(
                                      TextSpan(children: item['spans']),
                                      textScaler: TextScaler.linear(viewModel.textScaling),
                                    ),
                                  ),
                                ),
                                firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
                                newPageProgressIndicatorBuilder: (_) => const SizedBox(),
                                noItemsFoundIndicatorBuilder: (_) => const SizedBox(),
                                noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
                              ),
                            ),
                            PagedSliverList(
                              key: viewModel.downListKey,
                              pagingController: viewModel.secondaryPagingDownController,
                              builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                                animateTransitions: true,
                                transitionDuration: const Duration(milliseconds: 250),
                                itemBuilder: (context, item, index) => VisibilityDetector(
                                  key: ValueKey('${item['page']}'),
                                  onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                                      viewModel.setChapter(item['page']),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 1.0),
                                    child: SelectableText.rich(
                                      TextSpan(children: item['spans']),
                                      textScaler: TextScaler.linear(viewModel.textScaling),
                                    ),
                                  ),
                                ),
                                firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
                                newPageProgressIndicatorBuilder: (_) => const SizedBox(),
                                noItemsFoundIndicatorBuilder: (_) => const SizedBox(),
                                noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (viewModel.showSecondaryArea)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Divider(
                    color: context.theme.appColors.divider,
                  ),
                ),
              if (!viewModel.showSecondaryArea)
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Scrollable(
                    controller: viewModel.primaryAreaController,
                    viewportBuilder: (BuildContext context, ViewportOffset position) {
                      return Viewport(
                        offset: position,
                        center: viewModel.downListKey,
                        slivers: [
                          PagedSliverList(
                            pagingController: viewModel.primaryPagingUpController,
                            builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                              animateTransitions: true,
                              transitionDuration: const Duration(milliseconds: 250),
                              itemBuilder: (context, item, index) => VisibilityDetector(
                                key: ValueKey('${item['page']}'),
                                onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                                    viewModel.setChapter(item['chapter']),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: SelectableText.rich(
                                    TextSpan(children: item['spans']),
                                    textScaler: TextScaler.linear(viewModel.textScaling),
                                  ),
                                ),
                              ),
                              firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
                              newPageProgressIndicatorBuilder: (_) => const SizedBox(),
                              noItemsFoundIndicatorBuilder: (_) => const SizedBox(),
                              noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
                            ),
                          ),
                          PagedSliverList(
                            key: viewModel.downListKey,
                            pagingController: viewModel.primaryPagingDownController,
                            builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                              animateTransitions: true,
                              transitionDuration: const Duration(milliseconds: 250),
                              itemBuilder: (context, item, index) => VisibilityDetector(
                                key: ValueKey('${item['page']}'),
                                onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                                    viewModel.setChapter(item['chapter']),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: SelectableText.rich(
                                    TextSpan(children: item['spans']),
                                    textScaler: TextScaler.linear(viewModel.textScaling),
                                  ),
                                ),
                              ),
                              firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
                              newPageProgressIndicatorBuilder: (_) => const SizedBox(),
                              noItemsFoundIndicatorBuilder: (_) => const SizedBox(),
                              noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              if (viewModel.primaryAreaBible != 'KJV' || viewModel.secondaryAreaBible != 'KJV')
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                  child: Text(
                    'This is still a very early look into the unfinished text of the Open English Translation of the Bible. Please double-check the text in advance before using in public.',
                    style: TextStyle(
                      fontSize: 8.0,
                      color: context.theme.appColors.readerText,
                    ),
                  ),
                ),
            ],
          ),
          if (viewModel.isSecondaryReaderAreaPopupActive)
            const Align(
              alignment: Alignment.topCenter,
              child: ReaderAreaPopup(
                readerArea: Area.secondary,
              ),
            ),
          if (viewModel.isPrimaryReaderAreaPopupActive)
            const Align(
              alignment: Alignment.bottomCenter,
              child: ReaderAreaPopup(
                readerArea: Area.primary,
              ),
            ),
        ],
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
    );
  }

  @override
  ReaderViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderViewModel(context: context);
}
