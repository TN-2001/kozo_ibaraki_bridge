import 'package:flutter/material.dart';

class Camera {

  // プロパティ
  double _scale; // 拡大率
  Offset _worldPos; // ワールド上のカメラの位置
  Offset _screenPos; // スクリーンの上のカメラの位置

  // ゲッター
  double get scale => _scale; // 拡大率
  Offset get worldPos => _worldPos; // ワールド上のカメラの位置
  Offset get screenPos => _screenPos; // スクリーンの上のカメラの位置


  // コンストラクタ
  Camera(this._scale, this._worldPos, this._screenPos);

  // カメラの初期化
  void init(double scale, Offset worldPos, Offset screenPos) {
    _scale = scale;
    _worldPos = worldPos;
    _screenPos = screenPos;
  }

  // ワールド座標をスクリーン座標に変換
  Offset worldToScreen(Offset pos) {
    Offset newPos = Offset(pos.dx - worldPos.dx, pos.dy - worldPos.dy);
    newPos = Offset(newPos.dx * scale, newPos.dy * scale);
    newPos = Offset(newPos.dx + screenPos.dx, - newPos.dy + screenPos.dy);
    return newPos;
  }

  // スクリーン座標をワールド座標に変換
  Offset screenToWorld(Offset pos) {
    // print(pos);
    Offset newPos = Offset(pos.dx - screenPos.dx, -(pos.dy - screenPos.dy));
    // print(newPos);
    newPos = Offset(newPos.dx / scale, newPos.dy / scale);
    // print(scale);
    newPos = Offset(newPos.dx + worldPos.dx, newPos.dy + worldPos.dy);
    return newPos;
  }
}