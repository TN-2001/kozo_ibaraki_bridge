import 'package:flutter/material.dart';
import '../../constants/constant.dart';

class ToolIconButton extends StatelessWidget {
  const ToolIconButton({
    super.key, 
    required this.onPressed, 
    required this.icon, 
    this.message = "",
  });

  final void Function() onPressed;
  final Widget icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      // デザイン
      width: MyDimens.toolButtonWidth,
      height: MyDimens.toolButtonHeight,
      color: MyColors.toolButtonBackground,

      child: Tooltip(
        message: message,
        child: IconButton(
          // デザイン
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MyDimens.toolButtonBorderRadius),
              side: const BorderSide(
                color: MyColors.toolButtonBorder, // ここで色を指定
                width: MyDimens.toolButtonBorderWidth // 線の太さも指定可能
              ),
            ),
          ),
          // イベント
          onPressed: onPressed, 
          // ウィジェット
          icon: icon,
        ),
      ),
    );
  }
}