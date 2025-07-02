import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/constants/dimens.dart';

class MainUILayout extends StatelessWidget {
  const MainUILayout({super.key, this.leftHeader, this.rightHeader});

  final List<Widget>? leftHeader;
  final List<Widget>? rightHeader;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(UIDimens.padding),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Row(
                    children: [
                      if (leftHeader != null && leftHeader!.isNotEmpty) ...{
                        leftHeader![0],
                        for (int i = 1; i < leftHeader!.length; i++)...{
                          SizedBox(width: ToolUIDimens.gapWidth,),
                          leftHeader![i],
                        }
                      },
                      if (leftHeader == null || leftHeader!.isEmpty) const SizedBox(),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Row(
                    children: [
                      if (rightHeader != null && rightHeader!.isNotEmpty) ...{
                        rightHeader![0],
                        for (int i = 1; i < rightHeader!.length; i++)...{
                          SizedBox(width: ToolUIDimens.gapWidth,),
                          rightHeader![i],
                        }
                      },
                      if (rightHeader == null || rightHeader!.isEmpty) const SizedBox(),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}