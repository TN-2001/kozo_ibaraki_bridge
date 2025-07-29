import 'package:flutter/material.dart';
import '../../constants/constant.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MyDimens.toolBarHeight,
      color: MyColors.toolBarBackground,
      child: Row(
        children: [
          const SizedBox(width: MyDimens.toolBarGapWidth,),
          
          for(int i = 0; i < children.length; i++)...{
            children[i],
          },

          const SizedBox(width: MyDimens.toolBarGapWidth,),
        ],
      )
    );
  }
}