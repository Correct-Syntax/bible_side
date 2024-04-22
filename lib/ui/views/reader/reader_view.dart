import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:stacked/stacked.dart';

import '../../../common/enums.dart';
import '../../widgets/common/side_navigation_drawer/side_navigation_drawer.dart';
import 'reader_viewmodel.dart';
import 'widgets/primary_reader_appbar/primary_reader_appbar.dart';
import 'widgets/reader_area_popup/reader_area_popup.dart';
import 'widgets/secondary_reader_appbar/secondary_reader_appbar.dart';

class ReaderView extends StackedView<ReaderViewModel> {
  const ReaderView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(ReaderViewModel viewModel) async {
    await viewModel.initilize();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    ReaderViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
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
                                  itemBuilder: (context, item, index) => VisibilityDetector(
                                    key: ValueKey('${item['page']}'),
                                    onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                                        viewModel.setChapter(item['page']),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 1.0),
                                      child: RichText(
                                        text: TextSpan(children: item['spans']),
                                      ),
                                    ),
                                  ),
                                  noItemsFoundIndicatorBuilder: (_) {
                                    return const SizedBox();
                                  },
                                  noMoreItemsIndicatorBuilder: (_) {
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              PagedSliverList(
                                key: viewModel.downListKey,
                                pagingController: viewModel.secondaryPagingDownController,
                                builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                                  itemBuilder: (context, item, index) => VisibilityDetector(
                                    key: ValueKey('${item['page']}'),
                                    onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                                        viewModel.setChapter(item['page']),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 1.0),
                                      child: RichText(
                                        text: TextSpan(children: item['spans']),
                                      ),
                                    ),
                                  ),
                                  noItemsFoundIndicatorBuilder: (_) {
                                    return const SizedBox();
                                  },
                                  noMoreItemsIndicatorBuilder: (_) {
                                    return const SizedBox();
                                  },
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0),
                  child: Divider(),
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
                              itemBuilder: (context, item, index) => VisibilityDetector(
                                key: ValueKey('${item['page']}'),
                                onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                                    viewModel.setChapter(item['chapter']),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: RichText(
                                    text: TextSpan(children: item['spans']),
                                  ),
                                ),
                              ),
                              noItemsFoundIndicatorBuilder: (_) {
                                return const SizedBox();
                              },
                              noMoreItemsIndicatorBuilder: (_) {
                                return const SizedBox();
                              },
                            ),
                          ),
                          PagedSliverList(
                            key: viewModel.downListKey,
                            pagingController: viewModel.primaryPagingDownController,
                            builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                              itemBuilder: (context, item, index) => VisibilityDetector(
                                key: ValueKey('${item['page']}'),
                                onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                                    viewModel.setChapter(item['chapter']),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: RichText(
                                    text: TextSpan(children: item['spans']),
                                  ),
                                ),
                              ),
                              noItemsFoundIndicatorBuilder: (_) {
                                return const SizedBox();
                              },
                              noMoreItemsIndicatorBuilder: (_) {
                                return const SizedBox();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (viewModel.isSecondaryReaderAreaPopupActive)
            Align(
              alignment: Alignment.topCenter,
              child: ReaderAreaPopup(
                readerArea: Area.secondary,
              ),
            ),
          if (viewModel.isPrimaryReaderAreaPopupActive)
            Align(
              alignment: Alignment.bottomCenter,
              child: ReaderAreaPopup(
                readerArea: Area.primary,
              ),
            ),
        ],
      ),
      drawer: SideNavigationDrawer(
        selectedIndex: viewModel.currentIndex,
        onViewChanged: viewModel.setCurrentIndex,
      ),
      bottomNavigationBar: PrimaryReaderAppbar(
        isReaderAreaPopupActive: viewModel.isPrimaryReaderAreaPopupActive,
        onTapSearch: viewModel.onTapSearch,
        onTapBook: () => viewModel.onTapBook(Area.primary),
        onTapBibleVersion: () => viewModel.onTapBibleVersion(Area.primary),
        onTapMenu: () {},
      ),
    );
  }

  @override
  ReaderViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderViewModel(context: context);
}
