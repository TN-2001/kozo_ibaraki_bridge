import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/views/main/main_page.dart';

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
      home: const MainPage(title: 'Flutter Demo Home Page'),
    );
  }
}