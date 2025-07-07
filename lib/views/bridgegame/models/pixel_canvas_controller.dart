import 'package:flutter/material.dart';

class PixelCanvasController extends ChangeNotifier {
  int _gridWidth = 16;
  int _gridHeight = 16;
  Color selectedColor = Colors.black;
  late List<Color> pixelColors;
  final List<List<Color>> undoStack = [];
  final List<List<Color>> redoStack = [];

  final TextEditingController widthController = TextEditingController(text: '16');
  final TextEditingController heightController = TextEditingController(text: '16');

  // geter
  int get gridWidth => _gridWidth;
  int get gridHeight => _gridHeight;


  PixelCanvasController() {
    _initCanvas();
  }

  void _initCanvas() {
    pixelColors = List.generate(_gridWidth * _gridHeight, (_) => const Color.fromARGB(0, 255, 255, 255));
    undoStack.clear();
    redoStack.clear();
    notifyListeners();
  }

  void saveToUndo() {
    undoStack.add(List<Color>.from(pixelColors));
    redoStack.clear();
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      redoStack.add(List<Color>.from(pixelColors));
      pixelColors = undoStack.removeLast();
      notifyListeners();
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      undoStack.add(List<Color>.from(pixelColors));
      pixelColors = redoStack.removeLast();
      notifyListeners();
    }
  }

  void clear() {
    saveToUndo();
    pixelColors = List.generate(_gridWidth * _gridHeight, (_) => const Color.fromARGB(0, 255, 255, 255));
    notifyListeners();
  }

  void resizeCanvas() {
    final newW = int.tryParse(widthController.text);
    final newH = int.tryParse(heightController.text);
    if (newW != null && newW > 0 && newH != null && newH > 0) {
      _gridWidth = newW;
      _gridHeight = newH;
      _initCanvas();
    }
  }
  void resizeCanvasTo(int width, int height) {
    if (width > 0 && height > 0) {
      _gridWidth = width;
      _gridHeight = height;
      _initCanvas();
    }
  }

  void setSelectedColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void paintPixel(Offset localPos, Size size) {
    final cellWidth = size.width / _gridWidth;
    final cellHeight = size.height / _gridHeight;

    final x = (localPos.dx ~/ cellWidth).clamp(0, _gridWidth - 1);
    final y = (localPos.dy ~/ cellHeight).clamp(0, _gridHeight - 1);
    final index = y * _gridWidth + x;

    if (pixelColors[index] != selectedColor) {
      pixelColors[index] = selectedColor;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }
}
