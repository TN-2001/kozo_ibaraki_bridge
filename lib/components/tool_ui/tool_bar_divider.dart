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
        height: MyDimens.toolBarHeight,
        child: VerticalDivider(
          width: MyDimens.toolBarDividerWidth,
          thickness: MyDimens.toolBarDividerWidth,
          indent: MyDimens.toolBarDividerIndent,
          endIndent: MyDimens.toolBarDividerIndent,
          color: MyColors.toolBarDivider,
        ),
      );
    }
    else {
      return SizedBox(
        width: MyDimens.toolBarWidth,
        child: Divider(
          height: MyDimens.toolBarDividerWidth,
          thickness: MyDimens.toolBarDividerWidth,
          indent: MyDimens.toolBarDividerIndent,
          endIndent: MyDimens.toolBarDividerIndent,
          color: MyColors.toolBarDivider,
        ),
      );
    }
  }
}