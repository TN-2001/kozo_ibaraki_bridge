import 'package:flutter/material.dart';

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
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Row(
                    children: [
                      if (leftHeader != null && leftHeader!.isNotEmpty) ...leftHeader!,
                      if (leftHeader == null || leftHeader!.isEmpty) const SizedBox(),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Row(
                    children: [
                      if (rightHeader != null && rightHeader!.isNotEmpty) ...rightHeader!,
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