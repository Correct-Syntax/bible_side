import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:stacked/stacked.dart';

import '../../../common/enums.dart';
import '../../widgets/common/side_navigation_drawer/side_navigation_drawer.dart';
import 'reader_viewmodel.dart';

class ReaderView extends StackedView<ReaderViewModel> {
  const ReaderView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(ReaderViewModel viewModel) async {
    await viewModel.initilize();
    viewModel.topPagingController.addPageRequestListener((pageKey) {
      viewModel.fetchChapter(pageKey, AreaType.top);
    });
    viewModel.bottomPagingController.addPageRequestListener((pageKey) {
      viewModel.fetchChapter(pageKey, AreaType.bottom);
    });
    viewModel.updateInterface();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    ReaderViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const ReaderNavigation(),
            //     fullscreenDialog: true
            //   )
            // );
          },
          child: Text(
            viewModel.getcurrentNavigationString(
              viewModel.bookCode,
              viewModel.chapter,
            ),
          ),
        ),
        shadowColor: null,
      ),
      bottomSheet: viewModel.showBottomSheet == false
          ? null
          : BottomSheet(
              elevation: 4,
              constraints: const BoxConstraints(maxHeight: 250),
              showDragHandle: false,
              enableDrag: false,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 14.0, right: 14.0),
                  child: PagedListView<int, Map<String, dynamic>>(
                    scrollController: viewModel.bottomController,
                    pagingController: viewModel.bottomPagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<Map<String, dynamic>>(
                      itemBuilder: (context, item, index) {
                        return VisibilityDetector(
                          key: ValueKey('${item['chapter']}'),
                          onVisibilityChanged:
                              (VisibilityInfo visibilityInfo) =>
                                  viewModel.setChapter(item['chapter']),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 1.0),
                            child: RichText(
                                text: TextSpan(children: item['spans']),),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              onClosing: () {},
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: SafeArea(
          child: PagedListView<int, Map<String, dynamic>>(
            scrollController: viewModel.topController,
            pagingController: viewModel.topPagingController,
            builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
              itemBuilder: (context, item, index) {
                return VisibilityDetector(
                  key: ValueKey('${item['chapter']}'),
                  onVisibilityChanged: (VisibilityInfo visibilityInfo) =>
                      viewModel.setChapter(item['chapter']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 1.0),
                    child: RichText(text: TextSpan(children: item['spans']),),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.toggleBottomSheet,
        elevation: 0.0,
        tooltip: 'Toggle literal version',
        child: Icon(viewModel.showBottomSheet
            ? Symbols.expand_less
            : Symbols.expand_more),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            // IconButton(
            //   tooltip: 'Search',
            //   icon: const Icon(Icons.search),
            //   onPressed: () {
            //     readersVersionController.jumpTo(1500.0);
            //   },
            // ),
            IconButton(
              tooltip: 'Navigation',
              icon: const Icon(Icons.note_outlined),
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const ReaderNavigation(),
                //     fullscreenDialog: true
                //   )
                // );
              },
            ),
          ],
        ),
      ),
      drawer: SideNavigationDrawer(
        selectedIndex: viewModel.currentIndex,
        onViewChanged: viewModel.setCurrentIndex,
      ),
    );
  }

  @override
  ReaderViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderViewModel(context: context);
}
