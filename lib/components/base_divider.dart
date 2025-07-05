import 'package:flutter/material.dart';
import '/constants/colors.dart';
import '/constants/dimens.dart';

class BaseDivider extends StatelessWidget {
  const BaseDivider({
    super.key, 
    this.isVertivcal = false,
  });

  final bool isVertivcal;

  @override
  Widget build(BuildContext context) {
    if (isVertivcal) {
      return SizedBox(
        height: double.infinity,
        child: VerticalDivider(
          width: BaseDimens.dividerWidth,
          thickness: BaseDimens.dividerWidth,
          indent: 0.0,
          endIndent: 0.0,
          color: ToolBarColors.dividerClor,
        ),
      );
    }
    else {
      return SizedBox(
        width: double.infinity,
        child: Divider(
          height: BaseDimens.dividerWidth,
          thickness: BaseDimens.dividerWidth,
          indent: 0.0,
          endIndent: 0.0,
          color: ToolBarColors.dividerClor,
        ),
      );
    }
  }
}