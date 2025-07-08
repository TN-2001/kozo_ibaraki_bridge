import 'package:flutter/material.dart';

class PixelCanvasController extends ChangeNotifier {

  // パラメータ
  int _gridWidth = 16;
  int _gridHeight = 16;
  Color _selectedColor = Colors.black;
  late List<Color> _pixelColors;
  final List<List<Color>> _undoStack = [];
  final List<List<Color>> _redoStack = [];

  final TextEditingController widthController = TextEditingController(text: '16');
  final TextEditingController heightController = TextEditingController(text: '16');

  // ゲッター
  int get gridWidth => _gridWidth;
  int get gridHeight => _gridHeight;
  Color get selectedColor => _selectedColor;
  Color getPixelColor(int index) {
    if (index < 0 || index >= _pixelColors.length) {
      // エラーで一時停止
      throw RangeError('Index out of bounds: $index');
    }
    return _pixelColors[index];
  }


  PixelCanvasController() {
    _initCanvas();
  }

  void _initCanvas() {
    _pixelColors = List.generate(_gridWidth * _gridHeight, (_) => const Color.fromARGB(0, 255, 255, 255));
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }

  void saveToUndo() {
    _undoStack.add(List<Color>.from(_pixelColors));
    _redoStack.clear();
  }

  void undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(List<Color>.from(_pixelColors));
      _pixelColors = _undoStack.removeLast();
      notifyListeners();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(List<Color>.from(_pixelColors));
      _pixelColors = _redoStack.removeLast();
      notifyListeners();
    }
  }

  void clear() {
    saveToUndo();
    _pixelColors = List.generate(_gridWidth * _gridHeight, (_) => const Color.fromARGB(0, 255, 255, 255));
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
    _selectedColor = color;
    notifyListeners();
  }

  void paintPixel(Offset localPos, Size size) {
    final cellWidth = size.width / _gridWidth;
    final cellHeight = size.height / _gridHeight;

    final x = (localPos.dx ~/ cellWidth).clamp(0, _gridWidth - 1);
    final y = (localPos.dy ~/ cellHeight).clamp(0, _gridHeight - 1);
    final index = y * _gridWidth + x;

    if (_pixelColors[index] != _selectedColor) {
      _pixelColors[index] = _selectedColor;
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
