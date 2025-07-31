import 'package:flutter/material.dart';
import '/constants/constant.dart';

class BaseDivider extends StatelessWidget {
  const BaseDivider({
    super.key, 
    this.isVertivcal = false,
  });

  final bool isVertivcal;

  @override
  Widget build(BuildContext context) {
    if (isVertivcal) {
      return const SizedBox(
        height: double.infinity,
        child: VerticalDivider(
          width: MyDimens.baseDividerWidth,
          thickness: MyDimens.baseDividerWidth,
          indent: 0.0,
          endIndent: 0.0,
          color: MyColors.baseDivider,
        ),
      );
    }
    else {
      return const SizedBox(
        width: double.infinity,
        child: Divider(
          height: MyDimens.baseDividerWidth,
          thickness: MyDimens.baseDividerWidth,
          indent: 0.0,
          endIndent: 0.0,
          color: MyColors.baseDivider,
        ),
      );
    }
  }
}