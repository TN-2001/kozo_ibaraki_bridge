import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/bridgegame_page.dart';
import 'configs/configure_android.dart';
import 'configs/configure_nonweb.dart' if (dart.library.html) 'configs/configure_web.dart';


void main() {
  // FlutterフレームワークとFlutterエンジンを結びつける
  WidgetsFlutterBinding.ensureInitialized();

  // 各プラットフォームでの設定
  if (kIsWeb) {
    configureWeb();
  } else if (Platform.isAndroid) {
    configureAndroid();
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kozo App: 橋づくりゲーム',
      debugShowCheckedModeBanner: false, // デバッグ用の確認をOFF
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BridgegamePage(),
    );
  }
}