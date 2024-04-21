import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../common/bibles.dart';
import '../../../common/enums.dart';
import '../../common/ui_helpers.dart';
import 'bibles_viewmodel.dart';

class BiblesView extends StackedView<BiblesViewModel> {
  const BiblesView({
    Key? key,
    required this.readerArea,
  }) : super(key: key);

  final Area readerArea;

  @override
  Widget builder(
    BuildContext context,
    BiblesViewModel viewModel,
    Widget? child,
  ) {
    bool isPortrait = isPortraitOrientation(context);
    return PopScope(
      canPop: false,
      onPopInvoked: viewModel.onPopInvoked,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          title: isPortrait
              ? null
              : Text(
                  viewModel.getTitle(),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: isPortrait ? 26.0 : 0.0, left: 10.0, right: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPortrait)
                Padding(
                  padding: const EdgeInsets.only(bottom: 36.0),
                  child: Text(
                    viewModel.getTitle(),
                    style: const TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              for (String bibleCode in bibleVersionsMapping.keys)
                ListTile(
                  onTap: () => readerArea == Area.primary
                      ? viewModel.setPrimaryAreaBible(bibleCode)
                      : viewModel.setSecondaryAreaBible(bibleCode),
                  title: Text(
                    bibleCode,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: bibleCode == viewModel.currentBibleCode() ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    bibleVersionsMapping[bibleCode]!,
                    style: const TextStyle(
                      fontSize: 11.0,
                    ),
                  ),
                  trailing: bibleCode == viewModel.currentBibleCode()
                      ? const Icon(
                          Icons.check,
                        )
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  BiblesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BiblesViewModel(readerArea: readerArea);
}
