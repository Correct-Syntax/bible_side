import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../common/bibles.dart';
import 'bibles_viewmodel.dart';

class BiblesView extends StackedView<BiblesViewModel> {
  const BiblesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BiblesViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      onPopInvoked: viewModel.onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Bibles',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
          ),
          shadowColor: null,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 16.0, bottom: 10.0),
                child: Text(
                  'Primary',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              for (String bibleCode in bibleVersionsMapping.keys)
                ListTile(
                  onTap: () => viewModel.setPrimaryAreaBible(bibleCode),
                  title: Text(
                    bibleCode,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: bibleCode == viewModel.primaryAreaBible ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    bibleVersionsMapping[bibleCode]!,
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                  trailing: bibleCode == viewModel.primaryAreaBible
                      ? const Icon(
                          Icons.check,
                        )
                      : null,
                ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: const Divider(),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 10.0),
                child: Text(
                  'Secondary',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              for (String bibleCode in bibleVersionsMapping.keys)
                ListTile(
                  onTap: () => viewModel.setSecondaryAreaBible(bibleCode),
                  title: Text(
                    bibleCode,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: bibleCode == viewModel.secondaryAreaBible ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    bibleVersionsMapping[bibleCode]!,
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                  trailing: bibleCode == viewModel.secondaryAreaBible
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
      BiblesViewModel();
}
