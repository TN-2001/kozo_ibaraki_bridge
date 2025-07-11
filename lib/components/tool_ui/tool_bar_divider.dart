import 'package:flutter/material.dart';
import '/constants/colors.dart';
import '/constants/dimens.dart';

class ToolBarDivider extends StatelessWidget {
  const ToolBarDivider({
    super.key, 
    this.isVertivcal = false,
  });

  final bool isVertivcal;

  @override
  Widget build(BuildContext context) {
    if (isVertivcal) {
      return SizedBox(
        height: ToolBarDimens.height,
        child: VerticalDivider(
          width: ToolBarDimens.dividerWidth,
          thickness: ToolBarDimens.dividerWidth,
          indent: ToolBarDimens.dividerIndent,
          endIndent: ToolBarDimens.dividerIndent,
          color: ToolBarColors.dividerClor,
        ),
      );
    }
    else {
      return SizedBox(
        width: ToolUIDimens.width,
        child: Divider(
          height: ToolBarDimens.dividerWidth,
          thickness: ToolBarDimens.dividerWidth,
          indent: ToolBarDimens.dividerIndent,
          endIndent: ToolBarDimens.dividerIndent,
          color: ToolBarColors.dividerClor,
        ),
      );
    }
  }
}