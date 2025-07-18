import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/bridgegame_page.dart';

import 'configs/configure_nonweb.dart' if (dart.library.html) 'configs/configure_web.dart';


void main() {
  if (kIsWeb) {
    configureApp();
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kozo bridge | 茨城大学 構造・地震工学研究室',
      debugShowCheckedModeBanner: false, // デバッグ用の確認をOFF
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BridgegamePage(),
    );
  }
}