import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/common/side_navigation_drawer/side_navigation_drawer.dart';
import 'reader_viewmodel.dart';

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
      appBar: AppBar(
        title: InkWell(
          onTap: viewModel.onNavigationBtn,
          borderRadius: BorderRadius.circular(12.0),
          child: Text(
            viewModel.getcurrentNavigationString(
              viewModel.bookCode,
              viewModel.chapter,
            ),
          ),
        ),
        shadowColor: null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Scrollable(
                controller: viewModel.topController,
                viewportBuilder: (BuildContext context, ViewportOffset position) {
                  return Viewport(
                    offset: position,
                    center: viewModel.downListKey,
                    slivers: [
                      PagedSliverList(
                        pagingController: viewModel.topPagingUpController,
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
                        ),
                      ),
                      PagedSliverList(
                        key: viewModel.downListKey,
                        pagingController: viewModel.topPagingDownController,
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
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (viewModel.showSecondaryArea)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0),
              child: Divider(),
            ),
          if (viewModel.showSecondaryArea)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Scrollable(
                  controller: viewModel.bottomController,
                  viewportBuilder: (BuildContext context, ViewportOffset position) {
                    return Viewport(
                      offset: position,
                      center: viewModel.downListKey,
                      slivers: [
                        PagedSliverList(
                          pagingController: viewModel.bottomPagingUpController,
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
                          ),
                        ),
                        PagedSliverList(
                          key: viewModel.downListKey,
                          pagingController: viewModel.bottomPagingDownController,
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
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.toggleSecondaryArea,
        elevation: 0.0,
        tooltip: 'Toggle literal version',
        child: Icon(viewModel.showSecondaryArea ? Symbols.expand_less : Symbols.expand_more),
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
