import 'package:flutter/material.dart';

class BaseDrawer extends StatelessWidget {
  const BaseDrawer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        // ウィジェットの形
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        
        // 要素
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}