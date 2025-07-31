import 'package:flutter/material.dart';
import '../../constants/constant.dart';

class ToolBarDivider extends StatelessWidget {
  const ToolBarDivider({
    super.key, 
    this.isVertivcal = false,
  });

  final bool isVertivcal;

  @override
  Widget build(BuildContext context) {
    if (isVertivcal) {
      return const SizedBox(
        height: MyDimens.toolBarHeight,
        width: MyDimens.toolBarGapWidth * 2,
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
      return const SizedBox(
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