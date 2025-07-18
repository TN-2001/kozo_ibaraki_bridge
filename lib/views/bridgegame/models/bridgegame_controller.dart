import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../utils/my_calculator.dart';
import 'des_fem70x25.dart';

class BridgegameController extends ChangeNotifier {
  BridgegameController() {
    _init();
  }

  Color selectedColor = Colors.black;
  late List<Color> pixelColors;
  final List<List<Color>> undoStack = [];
  final List<List<Color>> redoStack = [];

  /*
    パラメータ
  */
  final int _gridWidth = 70; // グリッド幅
  final int _gridHeight = 25; // グリッド高さ
  int _toolIndex = 0; // ツール
  int _powerIndex = 0; // 荷重条件（0:3点曲げ、1:4点曲げ、2:自重）
  int _selectedElemIndex = -1; // 選択要素番号
  final List<Node> _nodeList = []; // 節点データ
  final List<Elem> _elemList = []; // 要素データ
  List<double> _selectedResultList = []; // 解析結果リスト
  double _resultPoint = 0; // 点数

  
  bool isCalculation = false; // 解析したかどうか

  double dispScale = 1.0; // 変位倍率

  double vvar = 0; // 荷重中央たわみ/体積（基準モデル）


  /*
    ゲッター
  */
  int get gridWidth => _gridWidth;
  int get gridHeight => _gridHeight;
  int get toolIndex => _toolIndex;
  int get powerIndex => _powerIndex;
  int get selectedElemIndex => _selectedElemIndex;
  double get resultPoint => _resultPoint;

  // 節点を取得
  Node getNode(int index) {
    return _nodeList[index];
  }
  // 節点数
  int get nodeListLength => _nodeList.length;

  // 要素を取得
  Elem getElem(int index) {
    return _elemList[index];
  }
  // 要素数
  int get elemListLength => _elemList.length;
  // 塗られた要素数
  int get onElemListLength {
    int elemCount = 0;
    for (int i = 0; i < _elemList.length; i++) {
      if (pixelColors[i].a != 0) {
        elemCount++;
      }
    }
    return elemCount;
  }

  // 解析結果を取得
  double getSelectedResult(int index) {
    if (index < 0 || index >= _selectedResultList.length) {
      return 0.0; // 範囲外のインデックスの場合は0を返す
    }
    return _selectedResultList[index];
  }
  // 解析結果の最小値
  double get selectedResultMin => _selectedResultList.reduce(min);
  // 解析結果の最大値
  double get selectedResultMax => _selectedResultList.reduce(max);

  // 節点の範囲座標
  Rect get nodeRect {
    List<Node> nodes = _nodeList;
    if (nodes.isEmpty) return Rect.zero; // 節点データがないとき終了

    double left = nodes[0].pos.dx;
    double right = nodes[0].pos.dx;
    double top = nodes[0].pos.dy;
    double bottom = nodes[0].pos.dy;

    if (nodes.length > 1) {
      for (int i = 1; i < nodes.length; i++) {
        left = min(left, nodes[i].pos.dx);
        right = max(right, nodes[i].pos.dx);
        top = min(top, nodes[i].pos.dy);
        bottom = max(bottom, nodes[i].pos.dy);
      }
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }


  /*
    関数
  */
  // 初期化
  void _init() {
    for (int i = 0; i <= _gridHeight; i++) {
      for (int j = 0; j <= _gridWidth; j++) {
        Node node = Node();
        node.pos = Offset(j.toDouble(), i.toDouble());
        _nodeList.add(node);
      }
    }
    for(int i = 0; i < gridHeight; i++){
      for(int j = 0; j < gridWidth; j++){
        Elem elem = Elem();
        elem.nodeList = [_nodeList[i*(gridWidth+1)+j],_nodeList[i*(gridWidth+1)+j+1],_nodeList[(i+1)*(gridWidth+1)+j+1],_nodeList[(i+1)*(gridWidth+1)+j]];
        _elemList.add(elem);
      }
    }

    // 2段確定
    for(int i = 0; i < gridWidth; i++){
      _elemList[i].isCanPaint = false;
      _elemList[i].e = 1;
      _elemList[gridWidth+i].isCanPaint = false;
      _elemList[gridWidth+i].e = 1;
    }

    _initCanvas();
  }

  // ツールの変更
  void changeToolIndex(int index) {
    _toolIndex = index;
    if (_toolIndex == 0) {
      selectedColor = const Color.fromARGB(255, 184, 25, 63); // ツールが選択モードのときは選択要素をクリア
    }
    else {
      selectedColor = const Color.fromARGB(0, 0, 0, 0); // ツールが選択モード以外のときは黒色に設定
    }
  }

  // 荷重条件の変更
  void changePowerIndex(int index) {
    _powerIndex = index;
  }

  void _initCanvas() {
    _initPixelColors();
    undoStack.clear();
    redoStack.clear();
    notifyListeners();
  }

  _initPixelColors() {
    pixelColors = List.generate(_gridWidth * _gridHeight, (_) => const Color.fromARGB(0, 255, 255, 255));
    for (int i = 0; i < elemListLength; i++) {
      if (!_elemList[i].isCanPaint) {
        pixelColors[i] = const Color.fromARGB(255, 106, 23, 43); // 塗れない要素は透明にする
      }
    }
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

  // 対称化
  void symmetrical() {
    saveToUndo();
    for (int y = 0; y < _gridHeight; y++) {
      for (int x = 0; x < _gridWidth / 2; x++) {
        if (_elemList[_gridWidth * y + _gridWidth - x - 1].isCanPaint) {
          // _elemList[_gridWidth * y + _gridWidth - x - 1].e = _elemList[_gridWidth * y + x].e;
          pixelColors[_gridWidth * y + _gridWidth - x - 1] = pixelColors[_gridWidth * y + x];
        }
      }
    }
    notifyListeners();
  }

  void clear() {
    saveToUndo();
    _initPixelColors();
    notifyListeners();
  }

  void paintPixel(Offset localPos) {
    selectElem(localPos);
    final index = _selectedElemIndex;

    if (index == -1) {
      return; // 選択要素がない場合は終了
    }

    if (pixelColors[index] != selectedColor && _elemList[index].isCanPaint == true) {
      pixelColors[index] = selectedColor;
      notifyListeners();
    }
  }



  void paintToElem() {
    for (int i = 0; i < _elemList.length; i++) {
      if (pixelColors[i].a != 0) {
        _elemList[i].e = 1; // 塗られた要素は1に設定
      } else {
        _elemList[i].e = 0; // 塗られていない要素は0に設定
      }
    }
  }
  // 解析
  static dynamic runDesFEM70x25(List<dynamic> args) {
    var zeroOneList = args[0];
    var powerIndex = args[1];
    return desFEM70x25(zeroOneList, powerIndex);
  }
  Future<void> calculation() async {
    paintToElem();

    const int npx1 = 70;
    const int npx2 = 25;
    const int nd = 2;

    List<List<int>> zeroOneList = List.generate(npx1, (_) => List.filled(npx2, 0));
    for (int n2 = 0; n2 < npx2; n2++) {
      for (int n1 = 0; n1 < npx1; n1++) {
        zeroOneList[n1][n2] = _elemList[npx1*(npx2-n2-1)+n1].e.toInt();
      }
    }

    // 解析実行
    final result = await compute(runDesFEM70x25, [zeroOneList, _powerIndex]);

    // 変位を入手
    for (int n2 = 0; n2 < npx2+1; n2++) {
      for (int n1 = 0; n1 < npx1+1; n1++) {
        _nodeList[(npx1+1)*(npx2-n2)+n1].becPos = Offset(result.$1[((npx1+1)*n2+n1)*nd], result.$1[((npx1+1)*n2+n1)*nd+1]);
      }
    }

    // 結果の入手
    for (int n2 = 0; n2 < npx2; n2++) {
      for (int n1 = 0; n1 < npx1; n1++) {
        _elemList[npx1*(npx2-n2-1)+n1].resultList[0] = result.$2[n1][n2][0];
        _elemList[npx1*(npx2-n2-1)+n1].resultList[1] = result.$2[n1][n2][1];
        _elemList[npx1*(npx2-n2-1)+n1].resultList[2] = result.$2[n1][n2][2];
        _elemList[npx1*(npx2-n2-1)+n1].resultList[3] = result.$3[n1][n2][0];
        _elemList[npx1*(npx2-n2-1)+n1].resultList[4] = result.$3[n1][n2][1];
        _elemList[npx1*(npx2-n2-1)+n1].resultList[5] = result.$3[n1][n2][2];
        _elemList[npx1*(npx2-n2-1)+n1].resultList[6] = result.$3[n1][n2][3];
        _elemList[npx1*(npx2-n2-1)+n1].resultList[7] = result.$3[n1][n2][4];
      }
    }

    // 最下層要素の変位の体積の1/2
    double he = 2.0; // 要素の幅高さ
    double ss = 0.0; // 面積
    for (int i = 0; i < 35-2; i++) {
      int h1 = 2 + i;
      int h2 = h1 + 1;
      double v1 = _nodeList[h1].becPos.dy.abs();
      double v2 = _nodeList[h2].becPos.dy.abs();
      double ds = (v1 + v2) * he / 2.0; // 台形の面積
      ss += ds;
    }
    // print(ss);


    // 点数
    double maxBecPos = _nodeList[35].becPos.dy.abs();
    // print(maxBecPos);
    int elemLength = onElemListLength;

    // シグモイド関数
    // vvar = 125446.5437*pow(elemLength,-3.4227461);

    double a = 3.25;
    // ニュートン補間
    double b0, b1, b2;
    if (powerIndex == 0) {
      // if (elemLength >= 70 && elemLength < 140) {
      //   b0 =  3.4159242117E+00;
      //   b1 = -4.9026406049E-02;
      //   b2 =  3.2743136695E-04;
      //   vvar = b0 + b1 * (elemLength - 70) + b2 * (elemLength - 70) * (elemLength - 105);
      // } else if (elemLength >= 140 && elemLength < 210) {
      //   b0 =  7.8628263731E-01;
      //   b1 = -9.3223610660E-03;
      //   b2 =  6.4502077503E-05;
      //   vvar = b0 + b1 * (elemLength - 140) + b2 * (elemLength - 140) * (elemLength - 175);
      // } else if (elemLength >= 210 && elemLength < 350) {
      //   b0 = 2.9174745257E-01;
      //   b1 = -2.0613303788E-03;
      //   b2 = 8.5850173811E-06;
      //   vvar = b0 + b1 * (elemLength - 210) + b2 * (elemLength - 210) * (elemLength - 280);
      // } else if (elemLength >= 350 && elemLength < 490) {
      //   b0 = 8.7294369877E-02;
      //   b1 = -4.4232646612E-04;
      //   b2 = 1.3426382928E-06;
      //   vvar = b0 + b1 * (elemLength - 350) + b2 * (elemLength - 350) * (elemLength - 420);
      // } else if (elemLength >= 490 && elemLength < 630) {
      //   b0 = 3.8526519889E-02;
      //   b1 = -1.5628977445E-04;
      //   b2 = 3.9630188412E-07;
      //   vvar = b0 + b1 * (elemLength - 490) + b2 * (elemLength - 490) * (elemLength - 560);
      // } else if (elemLength >= 630 && elemLength < 770) {
      //   b0 = 2.0529709931E-02;
      //   b1 = -6.7666021124E-05;
      //   b2 = 1.4764385486E-07;
      //   vvar = b0 + b1 * (elemLength - 630) + b2 * (elemLength - 630) * (elemLength - 700);
      // } else if (elemLength >= 770 && elemLength < 910) {
      //   b0 = 1.2503376751E-02;
      //   b1 = -3.3617200755E-05;
      //   b2 = 6.3902626225E-08;
      //   vvar = b0 + b1 * (elemLength - 770) + b2 * (elemLength - 770) * (elemLength - 840);
      // } else if (elemLength >= 910 && elemLength < 1050) {
      //   b0 = 8.4232143822E-03;
      //   b1 = -1.8513034220E-05;
      //   b2 = 3.1060716901E-08;
      //   vvar = b0 + b1 * (elemLength - 910) + b2 * (elemLength - 910) * (elemLength - 980);
      // }

      if (elemLength >= 70 && elemLength < 140) {
        b0 =  1.14352383677698E+02;
        b1 = -1.66721096221994E+00;
        b2 =  1.18542771682426E-02;
        vvar = b0 + b1 * (elemLength - 70) + b2 * (elemLength - 70) * (elemLength - 105);
      } else if (elemLength >= 140 && elemLength < 210) {
        b0 =  2.66905953844964E+01;
        b1 = -3.05445582414183E-01;
        b2 =  2.00394171633253E-03;
        vvar = b0 + b1 * (elemLength - 140) + b2 * (elemLength - 140) * (elemLength - 175);
      } else if (elemLength >= 210 && elemLength < 350) {
        b0 =  1.02190618205183E+01;
        b1 = -6.97691756490674E-02;
        b2 =  2.83641259924221E-04;
        vvar = b0 + b1 * (elemLength - 210) + b2 * (elemLength - 210) * (elemLength - 280);
      } else if (elemLength >= 350 && elemLength < 490) {
        b0 =  3.23106157690622E+00;
        b1 = -1.59895769550567E-02;
        b2 =  4.69488303935214E-05;
        vvar = b0 + b1 * (elemLength - 350) + b2 * (elemLength - 350) * (elemLength - 420);
      } else if (elemLength >= 490 && elemLength < 630) {
        b0 =  1.45261934105479E+00;
        b1 = -5.87671735944886E-03;
        b2 =  1.46286617935886E-05;
        vvar = b0 + b1 * (elemLength - 490) + b2 * (elemLength - 490) * (elemLength - 560);
      } else if (elemLength >= 630 && elemLength < 770) {
        b0 =  7.73239796309118E-01;
        b1 = -2.58705375400604E-03;
        b2 =  5.58703804795765E-06;
        vvar = b0 + b1 * (elemLength - 630) + b2 * (elemLength - 630) * (elemLength - 700);
      } else if (elemLength >= 770 && elemLength < 910) {
        b0 =  4.65805243618257E-01;
        b1 = -1.29507360226176E-03;
        b2 =  2.44723668462653E-06;
        vvar = b0 + b1 * (elemLength - 770) + b2 * (elemLength - 770) * (elemLength - 840);
      } else if (elemLength >= 910 && elemLength < 1050) {
        b0 =  3.08477858810951E-01;
        b1 = -7.15756135938629E-04;
        b2 =  1.19740054331377E-06;
        vvar = b0 + b1 * (elemLength - 910) + b2 * (elemLength - 910) * (elemLength - 980);
      }
      a = 2.79;
      maxBecPos = ss; // 体積を基準にする
    } else if (powerIndex == 1) { // 4点曲げ
      // print(nodeList[23].becPos.dy.abs());
      // maxBecPos = _nodeList[23].becPos.dy.abs();
      // if (elemLength >= 70 && elemLength < 140) {
      //   b0 =  3.83095784081963E+00;
      //   b1 = -5.80273668805609E-02;
      //   b2 =  4.53615168754680E-04;
      //   vvar = b0 + b1 * (elemLength - 70) + b2 * (elemLength - 70) * (elemLength - 105);
      // } else if (elemLength >= 140 && elemLength < 210) {
      //   b0 =  8.80399322629337E-01;
      //   b1 = -9.72569493226677E-03;
      //   b2 =  5.66108143337244E-05;
      //   vvar = b0 + b1 * (elemLength - 140) + b2 * (elemLength - 140) * (elemLength - 175);
      // } else if (elemLength >= 210 && elemLength < 350) {
      //   b0 =  3.38297172488288E-01;
      //   b1 = -2.29427110273659E-03;
      //   b2 =  9.29880951489469E-06;
      //   vvar = b0 + b1 * (elemLength - 210) + b2 * (elemLength - 210) * (elemLength - 280);
      // } else if (elemLength >= 350 && elemLength < 490) {
      //   b0 =  1.08227551351134E-01;
      //   b1 = -5.30257640222751E-04;
      //   b2 =  1.54965659068093E-06;
      //   vvar = b0 + b1 * (elemLength - 350) + b2 * (elemLength - 350) * (elemLength - 420);
      // } else if (elemLength >= 490 && elemLength < 630) {
      //   b0 =  4.91781163086219E-02;
      //   b1 = -1.95951437338516E-04;
      //   b2 =  4.86441085534530E-07;
      //   vvar = b0 + b1 * (elemLength - 490) + b2 * (elemLength - 490) * (elemLength - 560);
      // } else if (elemLength >= 630 && elemLength < 770) {
      //   b0 =  2.65120377194681E-02;
      //   b1 = -8.64750318306500E-05;
      //   b2 =  1.86445191479459E-07;
      //   vvar = b0 + b1 * (elemLength - 630) + b2 * (elemLength - 630) * (elemLength - 700);
      // } else if (elemLength >= 770 && elemLength < 910) {
      //   b0 =  1.62326961396758E-02;
      //   b1 = -4.33425084092314E-05;
      //   b2 =  8.18144201538573E-08;
      //   vvar = b0 + b1 * (elemLength - 770) + b2 * (elemLength - 770) * (elemLength - 840);
      // } else if (elemLength >= 910 && elemLength < 1050) {
      //   b0 =  1.09665262798912E-02;
      //   b1 = -2.39707508636930E-05;
      //   b2 =  4.00697386158101E-08;
      //   vvar = b0 + b1 * (elemLength - 910) + b2 * (elemLength - 910) * (elemLength - 980);
      // }
      // a = 4;
      if (elemLength >= 70 && elemLength < 140) {
        b0 =  1.77012667649855E+02;
        b1 = -2.57179050428157E+00;
        b2 =  1.79876703762735E-02;
        vvar = b0 + b1 * (elemLength - 70) + b2 * (elemLength - 70) * (elemLength - 105);
      } else if (elemLength >= 140 && elemLength < 210) {
        b0 =  4.10571247720151E+01;
        b1 = -4.73060707771860E-01;
        b2 =  3.28210701347351E-03;
        vvar = b0 + b1 * (elemLength - 140) + b2 * (elemLength - 140) * (elemLength - 175);
      } else if (elemLength >= 210 && elemLength < 350) {
        b0 =  1.59840374109950E+01;
        b1 = -1.06922562418232E-01;
        b2 =  4.28744990245488E-04;
        vvar = b0 + b1 * (elemLength - 210) + b2 * (elemLength - 210) * (elemLength - 280);
      } else if (elemLength >= 350 && elemLength < 490) {
        b0 =  5.21657957684830E+00;
        b1 = -2.53877094150193E-02;
        b2 =  7.32277971256143E-05;
        vvar = b0 + b1 * (elemLength - 350) + b2 * (elemLength - 350) * (elemLength - 420);
      } else if (elemLength >= 490 && elemLength < 630) {
        b0 =  2.37993267057662E+00;
        b1 = -9.51974619535257E-03;
        b2 =  2.34769465151367E-05;
        vvar = b0 + b1 * (elemLength - 490) + b2 * (elemLength - 490) * (elemLength - 560);
      } else if (elemLength >= 630 && elemLength < 770) {
        b0 =  1.27724227907560E+00;
        b1 = -4.22520224732538E-03;
        b2 =  9.08016272653367E-06;
        vvar = b0 + b1 * (elemLength - 630) + b2 * (elemLength - 630) * (elemLength - 700);
      } else if (elemLength >= 770 && elemLength < 910) {
        b0 =  7.74699559170076E-01;
        b1 = -2.12251913158403E-03;
        b2 =  4.00163708634797E-06;
        vvar = b0 + b1 * (elemLength - 770) + b2 * (elemLength - 770) * (elemLength - 840);
      } else if (elemLength >= 910 && elemLength < 1050) {
        b0 =  5.16762924194522E-01;
        b1 = -1.17448912543101E-03;
        b2 =  1.96469107672979E-06;
        vvar = b0 + b1 * (elemLength - 910) + b2 * (elemLength - 910) * (elemLength - 980);
      }
      a = 3.13;
      maxBecPos = ss; // 体積を基準にする
    } else { // 自重
      if (elemLength >= 70 && elemLength < 140) {
        b0 =  8.33226515366013E+01;
        b1 = -8.09218615331466E-01;
        b2 =  4.97838360573298E-03;
        vvar = b0 + b1 * (elemLength - 70) + b2 * (elemLength - 70) * (elemLength - 105);
      } else if (elemLength >= 140 && elemLength < 210) {
        b0 =  3.88743882974445E+01;
        b1 = -2.82125379926986E-01;
        b2 =  1.57740787186547E-03;
        vvar = b0 + b1 * (elemLength - 140) + b2 * (elemLength - 140) * (elemLength - 175);
      } else if (elemLength >= 210 && elemLength < 350) {
        b0 =  2.29902609886259E+01;
        b1 = -9.27268061060814E-02;
        b2 =  2.81100949420674E-04;
        vvar = b0 + b1 * (elemLength - 210) + b2 * (elemLength - 210) * (elemLength - 280);
      } else if (elemLength >= 350 && elemLength < 490) {
        b0 =  1.27632974380971E+01;
        b1 = -3.73390866924414E-02;
        b2 =  6.98389962465673E-05;
        vvar = b0 + b1 * (elemLength - 350) + b2 * (elemLength - 350) * (elemLength - 420);
      } else if (elemLength >= 490 && elemLength < 630) {
        b0 =  8.22024746437166E+00;
        b1 = -2.05701004427023E-02;
        b2 =  3.64498927922009E-05;
        vvar = b0 + b1 * (elemLength - 490) + b2 * (elemLength - 490) * (elemLength - 560);
      } else if (elemLength >= 630 && elemLength < 770) {
        b0 =  5.69764235175691E+00;
        b1 = -1.17497724276513E-02;
        b2 =  1.94089794928541E-05;
        vvar = b0 + b1 * (elemLength - 630) + b2 * (elemLength - 630) * (elemLength - 700);
      } else if (elemLength >= 770 && elemLength < 910) {
        b0 =  4.24288221091570E+00;
        b1 = -7.02637280466071E-03;
        b2 =  1.07265644494510E-05;
        vvar = b0 + b1 * (elemLength - 770) + b2 * (elemLength - 770) * (elemLength - 840);
      } else if (elemLength >= 910 && elemLength < 1050) {
        b0 =  3.36431034986782E+00;
        b1 = -4.38305983819901E-03;
        b2 =  6.29674005598068E-06;
        vvar = b0 + b1 * (elemLength - 910) + b2 * (elemLength - 910) * (elemLength - 980);
      }
      a = 2.27;
      maxBecPos = ss; // 自重のときは体積を基準にする
    }
    vvar = vvar/elemLength;

    double vvvar = maxBecPos/elemLength-vvar;
    // if(vvvar > 0){
    //   a = 0.5;
    // }
    _resultPoint = 100 * (1-1/(1+(pow(e, -a*(vvvar)/vvar))));
    selectResult(3);

    isCalculation = true;
    notifyListeners();
  }
  // 解析結果のリセット
  void resetCalculation() {
    for(int i = 0; i < _elemList.length; i++){
      for(int j = 0; j < _elemList[i].resultList.length; j++){
        _elemList[i].resultList[j] = 0;
      }
    }

    isCalculation = false;
    notifyListeners();
  }
  // 結果の選択
  void selectResult(int index) {
    _selectedResultList = List.filled(_elemList.length, 0);
    for (int i = 0; i < _elemList.length; i++) {
      _selectedResultList[i] = _elemList[i].resultList[index];
    }

    _selectedResultList = MyCalculator.normalizeArray(_selectedResultList);
  }

  // 要素の選択
  void initSelect() {
    _selectedElemIndex = -1; // 選択要素番号
  }
  // 要素の選択
  void selectElem(Offset pos) {
    initSelect();
    
    for (int i = 0; i < _elemList.length; i++) {
      List<Offset> nodePosList = List.empty(growable: true);
      for (int j = 0; j < 4; j++) {
        nodePosList.add(_elemList[i].nodeList[j].pos);
      }
      // 四角形のとき
      Offset p0 = _elemList[i].nodeList[0].pos;
      Offset p1 = _elemList[i].nodeList[1].pos;
      Offset p2 = _elemList[i].nodeList[2].pos;
      Offset p3 = _elemList[i].nodeList[3].pos;
      if (isCalculation) {
        p0 = _elemList[i].nodeList[0].pos + _elemList[i].nodeList[0].becPos*dispScale;
        p1 = _elemList[i].nodeList[1].pos + _elemList[i].nodeList[1].becPos*dispScale;
        p2 = _elemList[i].nodeList[2].pos + _elemList[i].nodeList[2].becPos*dispScale;
        p3 = _elemList[i].nodeList[3].pos + _elemList[i].nodeList[3].becPos*dispScale;
      }

      if (MyCalculator.isPointInRectangle(pos, p0, p1, p2, p3)) {
        _selectedElemIndex = i;
        notifyListeners();
        return;
      }
    }
  }
}

class Node {
  // パラメータ
  Offset pos = Offset.zero;
  Offset becPos = Offset.zero;
}

class Elem {
  // パラメータ
  double e = 0.0;
  List<Node> nodeList = [Node(), Node(), Node(), Node()];
  // 0:X方向ひずみ、1:Y方向ひずみ、2:せん断ひずみ
  // 3:X方向応力、4:Y方向応力、5:せん断応力、6:最大主応力、7:最小主応力、8:曲げモーメント左、9:曲げモーメント右
  List<double> resultList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  bool isCanPaint = true; // 色がかわるか
}
