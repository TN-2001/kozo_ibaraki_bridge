import 'package:flutter/material.dart';
import '../../components/component.dart';
import '../../utils/status_bar.dart';
import 'canvas/bridgegame_canvas.dart';
import 'models/bridgegame_controller.dart';
import 'ui/bridgegame_bar.dart';

class BridgegamePage extends StatefulWidget {
  const BridgegamePage({super.key});

  @override
  State<BridgegamePage> createState() => _BridgegamePageState();
}

class _BridgegamePageState extends State<BridgegamePage> {
  late BridgegameController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _update() => setState(() {});


  @override
  void initState() {
    super.initState();

    controller = BridgegameController();
    controller.addListener(_update);

    StatusBar.setStyle(isDarkBackground: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    StatusBar.setModeByOrientation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,

      body: SafeArea(
        child: ClipRect(
          child: Column(
            children: [
              BridgegameBar(controller: controller, scaffoldKey: _scaffoldKey,),

              const BaseDivider(),

              Expanded(
                child: Stack(
                  children: [
                    BridgegameCanvas(controller: controller,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}