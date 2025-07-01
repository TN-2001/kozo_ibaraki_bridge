import 'package:flutter/material.dart';

class MainUIPowerdropdown extends StatefulWidget {
  const MainUIPowerdropdown({super.key, required this.onPressed});

  final void Function(int index) onPressed;

  @override
  State<MainUIPowerdropdown> createState() => _MainUIPowerdropdownState();
}

class _MainUIPowerdropdownState extends State<MainUIPowerdropdown> {

  static final List<String> _items = ["3点曲げ", "4点曲げ", "自重"];

  late final void Function(int index) onPressed;

  String _currentItem = _items.first;


  @override
  void initState() {
    super.initState();
    onPressed = widget.onPressed;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _currentItem,
      items: _items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        for (int i = 0; i < _items.length; i++) {
          if (value == _items[i]) {
            setState(() {
              _currentItem = _items[i];
            });
            onPressed(i);
            break;
          }
        }
      },
    );
  }
}