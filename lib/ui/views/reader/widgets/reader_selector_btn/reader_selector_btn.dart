import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/enums.dart';
import 'reader_selector_btn_model.dart';

class ReaderSelectorBtn extends StackedView<ReaderSelectorBtnModel> {
  const ReaderSelectorBtn({
    super.key,
    required this.areaType,
    required this.isActive,
    required this.currentBook,
    required this.currentBibleVersion,
    required this.onTapBook,
    required this.onTapBibleVersion,
  });

  final Area areaType;
  final bool isActive;
  final String currentBook;
  final String currentBibleVersion;
  final Function() onTapBook;
  final Function() onTapBibleVersion;

  @override
  Widget builder(
    BuildContext context,
    ReaderSelectorBtnModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Color(0xff1F2123),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onTapBook,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 13.0),
                      child: Container(
                        width: 7.0,
                        height: 7.0,
                        decoration: BoxDecoration(
                          color: Color(0xff074DFF),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      currentBook,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xffE8E8E9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onTapBibleVersion,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      currentBibleVersion,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xffE8E8E9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (areaType == Area.primary)
                    PhosphorIcon(
                      isActive == true
                          ? PhosphorIcons.caretDown(PhosphorIconsStyle.bold)
                          : PhosphorIcons.caretUp(PhosphorIconsStyle.bold),
                      color: Color(0xffE8E8E9),
                      size: 16.0,
                      semanticLabel: isActive == true ? 'Caret down' : 'Caret up',
                    ),
                  if (areaType == Area.secondary)
                    PhosphorIcon(
                      isActive == true
                          ? PhosphorIcons.caretUp(PhosphorIconsStyle.bold)
                          : PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
                      color: Color(0xffE8E8E9),
                      size: 16.0,
                      semanticLabel: isActive == true ? 'Caret up' : 'Caret down',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ReaderSelectorBtnModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderSelectorBtnModel();
}
