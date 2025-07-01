import 'package:flutter/material.dart';

class ToolIconButton extends StatefulWidget {
  const ToolIconButton({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final void Function() onPressed;

  @override
  State<ToolIconButton> createState() => _ToolIconButtonState();
}

class _ToolIconButtonState extends State<ToolIconButton> {  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      // デザイン
      splashRadius: 100,
      // イベント
      onPressed: widget.onPressed, 
      // ウィジェット
      icon: Icon(widget.icon),
    );
  }
}