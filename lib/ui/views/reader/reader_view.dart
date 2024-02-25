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
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        shadowColor: null,
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(40.0),
            onTap: viewModel.onBiblesBtn,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.book_2,
                    color: Theme.of(context).iconTheme.color,
                    size: 18.0,
                  ),
                  const SizedBox(width: 3.0),
                  Text(
                    viewModel.primaryAreaBible,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14.0),
        ],
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
        mini: true,
        onPressed: viewModel.toggleSecondaryArea,
        elevation: 0.0,
        tooltip: 'Toggle literal version',
        child: Icon(viewModel.showSecondaryArea ? Icons.library_books : Icons.library_books_outlined),
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
