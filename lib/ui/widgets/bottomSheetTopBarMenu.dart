import 'package:eschool_teacher/ui/widgets/customCloseButton.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class BottomSheetTopBarMenu extends StatelessWidget {
  final String title;
  final Function onTapCloseButton;
  final EdgeInsetsGeometry? padding;
  const BottomSheetTopBarMenu({
    super.key,
    required this.onTapCloseButton,
    required this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.all(UiUtils.bottomSheetHorizontalContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              CustomCloseButton(
                onTapCloseButton: () {
                  onTapCloseButton();
                },
              ),
            ],
          ),
          Divider(
            height: 20,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
