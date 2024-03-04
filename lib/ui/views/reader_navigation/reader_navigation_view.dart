import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../../../common/enums.dart';
import '../../../models/text_item.dart';
import 'reader_navigation_viewmodel.dart';

class ReaderNavigationView extends StackedView<ReaderNavigationViewModel> {
  const ReaderNavigationView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(ReaderNavigationViewModel viewModel) =>
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) => viewModel.initilize());

  @override
  Widget builder(
    BuildContext context,
    ReaderNavigationViewModel viewModel,
    Widget? child,
  ) {
    return _ReaderNavigationView();
  }

  @override
  ReaderNavigationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderNavigationViewModel();
}

class _ReaderNavigationView extends StackedHookView<ReaderNavigationViewModel> {
  @override
  Widget builder(BuildContext context, ReaderNavigationViewModel viewModel) {
    final TickerProvider tickerProvider = useSingleTickerProvider();

    viewModel.tabController = useTabController(
        initialIndex: viewModel.viewBy == ViewBy.chapter ? 0 : 1, initialLength: 2, vsync: tickerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Navigation',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 30.0,
          ),
          child: Column(
            children: [
              Visibility(
                visible: viewModel.showBooksNavigation,
                child: Expanded(
                  child: GridView.builder(
                    itemCount: viewModel.booksMapping.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 120,
                      childAspectRatio: 4 / 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: () => viewModel.onTapBookItem(index),
                        child: Center(
                          child: Text(
                            viewModel.booksMapping.values.elementAt(index),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: viewModel.showSectionNavigation,
                child: Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TabBar(
                          controller: viewModel.tabController,
                          tabs: const [
                            Tab(text: 'By Section'),
                            Tab(text: 'By Chapter'),
                          ],
                        ),
                        const SizedBox(height: 22.0),
                        Expanded(
                          child: TabBarView(
                            controller: viewModel.tabController,
                            children: [
                              // By section
                              ListView.builder(
                                itemCount: viewModel.sections.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.0),
                                      onTap: () => viewModel.onTapSectionItem(index),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            viewModel.getFirstSectionHeading(index),
                                            style: TextItemStyles.sectionHeading(context),
                                          ),
                                          for (String altSection in viewModel.getAlternativeSectionHeadings(index))
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12.0),
                                              child: Text(
                                                altSection,
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // By chapter
                              GridView.builder(
                                itemCount: viewModel.bookChapters.length,
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 100,
                                  childAspectRatio: 4 / 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 18,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(12.0),
                                    onTap: () => viewModel.onTapChapterItem(index),
                                    child: Center(
                                      child: Text(
                                        viewModel.bookChapters[index],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'RobotoSerif'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
