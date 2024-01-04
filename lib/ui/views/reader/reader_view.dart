import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/common/side_navigation_drawer/side_navigation_drawer.dart';
import 'reader_viewmodel.dart';

// https://stackoverflow.com/questions/22274033/how-do-i-split-or-chunk-a-list-into-equal-parts-with-dart
// https://www.scaler.com/topics/pagination-in-flutter/

class ReaderView extends StackedView<ReaderViewModel> {
  const ReaderView({Key? key}) : super(key: key);

  final bool hideLiteralVersion = false;

  @override
  void onViewModelReady(ReaderViewModel viewModel) async {
    await viewModel.initilize();
    viewModel.pagingController.addPageRequestListener((pageKey) {
      fetchChapter(pageKey, viewModel);
      //viewModel.updateInterface();
    });
    viewModel.updateInterface();
    super.onViewModelReady(viewModel);
  }

  Future<void> fetchChapter(int pageKey, ReaderViewModel viewModel) async {
    List<Map<String, dynamic>> newPage = viewModel.getPaginatedVerses(pageKey);

    final bool isLastPage = newPage.isEmpty;

    if (isLastPage) {
      viewModel.pagingController.appendLastPage(newPage);
    } else {
      final int nextPageKey = pageKey + 1;
      viewModel.pagingController.appendPage(newPage, nextPageKey);
    }
    viewModel.updateInterface();
    log('Fetched chapter');
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
                viewModel.bookCode, viewModel.chapter),
          ),
        ),
        shadowColor: null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: SafeArea(
          child: PagedListView<int, Map<String, dynamic>>(
            pagingController: viewModel.pagingController,
            builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                itemBuilder: (context, item, index) {
              return VisibilityDetector(
                key: ValueKey('${item['chapter']}'),
                onVisibilityChanged: (VisibilityInfo visibilityInfo) => viewModel.setChapter(item['chapter']),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 1.0),
                  child: RichText(text: TextSpan(children: item['spans'])),
                ),
              );
            },),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // setState(() {
          //   hideLiteralVersion = !hideLiteralVersion;
          // });
        },
        elevation: 0.0,
        tooltip: 'Toggle literal version',
        child: Icon(
            hideLiteralVersion ? Symbols.expand_less : Symbols.expand_more),
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
