import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../common/colors.dart';
import '../../../common/themes.dart';
import '../../common/ui_helpers.dart';
import 'bookmarks_viewmodel.dart';

class BookmarksView extends StackedView<BookmarksViewModel> {
  const BookmarksView({super.key});

  @override
  Widget builder(
    BuildContext context,
    BookmarksViewModel viewModel,
    Widget? child,
  ) {
    bool isPortrait = isPortraitOrientation(context);
    return PopScope(
      canPop: false,
      onPopInvoked: viewModel.onPopInvoked,
      child: Scaffold(
        backgroundColor: context.theme.appColors.background,
        appBar: AppBar(
          backgroundColor: context.theme.appColors.background,
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          title: isPortrait
              ? null
              : Text(
                  'Your Bookmarks',
                  style: TextStyle(
                    color: context.theme.appColors.primary,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: isPortrait ? 26.0 : 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPortrait)
                Padding(
                  padding: const EdgeInsets.only(bottom: 36.0),
                  child: Text(
                    'Your Bookmarks',
                    style: TextStyle(
                      color: context.theme.appColors.primary,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              viewModel.bookmarks.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
                          child: Text(
                            'No bookmarks yet.',
                            style: TextStyle(
                              color: context.theme.appColors.primary,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.bookmarks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () => {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      PhosphorIcon(
                                        PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.bold),
                                        color: viewModel.bookmarks[index].textToColor(),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: 12.0),
                                      Text(
                                        viewModel.bookmarks[index],
                                        style: TextStyle(
                                          color: context.theme.appColors.primary,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  PhosphorIcon(
                                    PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                                    color: context.theme.appColors.primary,
                                    size: 18.0,
                                    semanticLabel: 'Caret right',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  BookmarksViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BookmarksViewModel();
}
