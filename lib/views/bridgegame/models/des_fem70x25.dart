import 'dart:math';

// 橋の解析
(List<double>, List<List<List<double>>>, List<List<List<double>>>) desFEM70x25(List<List<int>> zeroOneList, int powerType) {
  // zeroOneList=要素の有無、powerType=荷重条件（0:集中荷重、1:分布荷重、2:自重）
  int npx1 = zeroOneList.length; // 横の要素数
  int npx2 = zeroOneList[0].length; // 縦の要素数
  const int nd = 2; // 2次元
  const int node = 4; // 要素節点数
  int nx = (npx1 + 1) * (npx2 + 1); // 節点数
  int neq = nx * nd; // 節点数x次元数(xとy方向あるから)

  List<List<int>> mpxl = zeroOneList;
  List<List<List<int>>> ijke = List.generate(npx1, (_) => List.generate(npx2, (_) => List.filled(4, 0)));
  List<int> mdof = List.filled(neq, 0); // 節点拘束（0:拘束、1:拘束でない、荷重がかかっているかは関係ない）
  List<double> fext = List.filled(neq, 0.0); // 節点荷重
  List<double> disp = List.filled(neq, 0.0);
  List<List<List<double>>> stn = List.generate(npx1, (_) => List.generate(npx2, (_) => List.filled(9, 0.0)));
  List<List<List<double>>> sts = List.generate(npx1, (_) => List.generate(npx2, (_) => List.filled(9, 0.0)));
  List<List<List<List<double>>>> vske = List.generate(npx1, (_) => List.generate(npx2, (_) => List.generate(8, (_) => List.filled(8, 0.0))));
  List<double> diag = List.filled(neq, 0.0);
  List<double> cgw1 = List.filled(neq, 0.0);
  List<double> cgw2 = List.filled(neq, 0.0);
  List<double> cgw3 = List.filled(neq, 0.0);

  List<List<double>> ccc = List.generate(3, (_) => List.filled(3, 0.0));
  List<List<double>> bbb = List.generate(3, (_) => List.filled(8, 0.0));
  List<double> ue = List.filled(8, 0.0);

  for (int n2 = 0; n2 < npx2; n2++) {
    for (int n1 = 0; n1 < npx1; n1++) {
      ijke[n1][n2][0] = (npx1 + 1) * (n2 + 1) + n1;
      ijke[n1][n2][1] = (npx1 + 1) * (n2 + 1) + n1 + 1;
      ijke[n1][n2][2] = (npx1 + 1) * n2 + n1 + 1;
      ijke[n1][n2][3] = (npx1 + 1) * n2 + n1;
    }
  }

  const double e1 = 10000.0;
  const double v1 = 0.2;
  const double e0 = 1.0;
  const double v0 = 0.0;

  vske = List.generate(npx1, (_) => List.generate(npx2, (_) => List.generate(8, (_) => List.filled(8, 0.0))));

  for (int n2 = 0; n2 < npx2; n2++) {
    for (int n1 = 0; n1 < npx1; n1++) {
      if (mpxl[n1][n2] == 1) {
        ccc[0][0] = e1 * (1.0 - v1) / (1.0 + v1) / (1.0 - 2.0 * v1);
        ccc[1][1] = e1 * (1.0 - v1) / (1.0 + v1) / (1.0 - 2.0 * v1);
        ccc[0][1] = e1 * v1 / (1.0 + v1) / (1.0 - 2.0 * v1);
        ccc[1][0] = e1 * v1 / (1.0 + v1) / (1.0 - 2.0 * v1);
        ccc[2][2] = e1 / 2.0 / (1.0 + v1);
      } else {
        ccc[0][0] = e0 * (1.0 - v0) / (1.0 + v0) / (1.0 - 2.0 * v0);
        ccc[1][1] = e0 * (1.0 - v0) / (1.0 + v0) / (1.0 - 2.0 * v0);
        ccc[0][1] = e0 * v0 / (1.0 + v0) / (1.0 - 2.0 * v0);
        ccc[1][0] = e0 * v0 / (1.0 + v0) / (1.0 - 2.0 * v0);
        ccc[2][2] = e0 / 2.0 / (1.0 + v0);
      }

      for (int ig = 0; ig < 4; ig++) {
        double xl = -1.0 / sqrt(3.0);
        double yl = -1.0 / sqrt(3.0);
        if (ig == 1) xl = 1.0 / sqrt(3.0);
        if (ig == 1) yl = -1.0 / sqrt(3.0);
        if (ig == 2) xl = -1.0 / sqrt(3.0);
        if (ig == 2) yl = 1.0 / sqrt(3.0);
        if (ig == 3) xl = 1.0 / sqrt(3.0);
        if (ig == 3) yl = 1.0 / sqrt(3.0);

        bbb[0][0] = (yl - 1.0) / 4.0;
        bbb[1][1] = (xl - 1.0) / 4.0;
        bbb[0][2] = (-yl + 1.0) / 4.0;
        bbb[1][3] = (-xl - 1.0) / 4.0;
        bbb[0][4] = (yl + 1.0) / 4.0;
        bbb[1][5] = (xl + 1.0) / 4.0;
        bbb[0][6] = (-yl - 1.0) / 4.0;
        bbb[1][7] = (-xl + 1.0) / 4.0;
        bbb[2][0] = bbb[1][1];
        bbb[2][1] = bbb[0][0];
        bbb[2][2] = bbb[1][3];
        bbb[2][3] = bbb[0][2];
        bbb[2][4] = bbb[1][5];
        bbb[2][5] = bbb[0][4];
        bbb[2][6] = bbb[1][7];
        bbb[2][7] = bbb[0][6];

        double detw = 1.0;

        for (int i1 = 0; i1 < nd*node; i1++) {
          for (int i2 = 0; i2 < nd*node; i2++) {
            for (int k = 0; k < 3; k++) {
              for (int l = 0; l < 3; l++) {
                vske[n1][n2][i1][i2] += bbb[k][i1] * ccc[k][l] * bbb[l][i2] * detw;
              }
            }
          }
        }
      }
    }
  }

  // Force vector (p = 1) 外力ベクトル（荷重）の設定
  if(powerType == 0){ // 3点曲げ
    int n1 = (npx1 + 1) * npx2 + (npx1 / 2).round() - 1;
    int n2 = (npx1 + 1) * npx2 + (npx1 / 2).round();
    int n3 = (npx1 + 1) * npx2 + (npx1 / 2).round() + 1;
    fext[nd * n1 + 1] = -1.0;
    fext[nd * n2 + 1] = -2.0;
    fext[nd * n3 + 1] = -1.0;
  }else if(powerType == 1){ // 4点曲げ
    int n1 = (npx1 + 1) * npx2 + 22;
    int n2 = (npx1 + 1) * npx2 + 23;
    int n3 = (npx1 + 1) * npx2 + 24;
    fext[nd * n1 + 1] = -1.0;
    fext[nd * n2 + 1] = -2.0;
    fext[nd * n3 + 1] = -1.0;
    n1 = (npx1 + 1) * npx2 + 46;
    n2 = (npx1 + 1) * npx2 + 47;
    n3 = (npx1 + 1) * npx2 + 48;
    fext[nd * n1 + 1] = -1.0;
    fext[nd * n2 + 1] = -2.0;
    fext[nd * n3 + 1] = -1.0;
  }else if(powerType == 2){ // 自重
    for(int n2 = 0; n2 < npx2; n2++){
      for(int n1 = 0; n1 < npx1; n1++){
        if(mpxl[n1][n2] == 1){
          for(int i = 0; i < 4; i++){
            int ni = ijke[n1][n2][i];
            int nj = nd*ni + 1;
            if (n2 == 0 || n2 == 1) {
              fext[nj] -= 0.06;
            } else {
              fext[nj] -= 0.02;
            }
          }
        }
      }
    }
  }

  // DOF table (0:fix, 1:free) 拘束の設定
  for (int i = 0; i < neq; i++) {
    mdof[i] = 1;
  }
  int n1 = (npx1+1)*npx2 + 1;
  int n2 = (npx1+1)*npx2 + 2;
  int n3 = (npx1+1)*npx2 + 3;
  int n4 = (npx1+1)*npx2 + npx1 - 1;
  int n5 = (npx1+1)*npx2 + npx1;
  int n6 = (npx1+1)*npx2 + npx1 + 1;
  for (int k = 0; k < nd; k++) {
    mdof[nd*(n1-1)+k] = 0;
    mdof[nd*(n2-1)+k] = 0;
    mdof[nd*(n3-1)+k] = 0;
    mdof[nd*(n4-1)+k] = 0;
    mdof[nd*(n5-1)+k] = 0;
    mdof[nd*(n6-1)+k] = 0;
  }

  // Diagonal component
  for (int n2 = 0; n2 < npx2; n2++) {
    for (int n1 = 0; n1 < npx1; n1++) {
      for (int io = 0; io < node; io++) {
        int ic = ijke[n1][n2][io];
        for (int id = 0; id < nd; id++) {
          int ii = nd*io + id;
          int ig = nd*ic + id;
          diag[ig] += vske[n1][n2][ii][ii];
        }
      }
    }
  }

  // Diagonal scaling
  for (int i = 0; i < neq; i++) {
    double dv = diag[i].abs();
    if (dv > 1e-9) {
      diag[i] = 1.0 / sqrt(dv);
    } else {
      diag[i] = 1.0;
    }
  }

  // Applying diagonal scaling
  for (int i = 0; i < neq; i++) {
    if (mdof[i] >= 1) {
      cgw1[i] = fext[i] * diag[i];
      cgw2[i] = cgw1[i];
    }
  }

  // Dot product
  double r0r0 = dotProduct(cgw1, cgw1);

  for (int kcg = 1; kcg <= neq; kcg++) {
    // Matrix-vector multiplication
    for (int i = 0; i < neq; i++) {
      cgw3[i] = 0.0;
    }

    for (int n2 = 0; n2 < npx2; n2++) {
      for (int n1 = 0; n1 < npx1; n1++) {
        for (int io = 0; io < node; io++) {
          int ic = ijke[n1][n2][io];
          for (int id = 0; id < nd; id++) {
            int ii = nd * io + id;
            int ig = nd * ic + id;
            double di = diag[ig];
            if (mdof[ig] >= 1) {
              for (int ko = 0; ko < node; ko++) {
                int kc = ijke[n1][n2][ko];
                for (int kd = 0; kd < nd; kd++) {
                  int kk = nd * ko + kd;
                  int kg = nd * kc + kd;
                  double dk = diag[kg];
                  cgw3[ig] += di * dk * vske[n1][n2][ii][kk] * cgw2[kg];
                }
              }
            }
          }
        }
      }
    }

    // Dot product
    double app = dotProduct(cgw3, cgw2);
    double rr = dotProduct(cgw1, cgw1);
    double alph = rr / app;

    // Update vectors
    for (int i = 0; i < neq; i++) {
      disp[i] += alph * cgw2[i];
      cgw1[i] -= alph * cgw3[i];
    }
    double r1r1 = dotProduct(cgw1, cgw1);

    // Check convergence
    if (sqrt(rr / r0r0) < 1e-9) {
      for (int i = 0; i < neq; i++) {
        disp[i] *= diag[i];
      }
      // print('Convergence achieved at iteration $kcg');
      break;
    } else {
      double beta = r1r1 / rr;
      for (int i = 0; i < neq; i++) {
        cgw2[i] = cgw1[i] + beta * cgw2[i];
      }
    }
  }

  for (int n2 = 0; n2 < npx2; n2++) {
    for (int n1 = 0; n1 < npx1; n1++) {
      // 要素変位
      for (int ind = 0; ind < node; ind++) {
        int icnc = ijke[n1][n2][ind];
        for (int idf = 0; idf < nd; idf++) {
          int ig = nd * icnc + idf;
          int ie = nd * ind + idf;
          ue[ie] = disp[ig];
        }
      }

      // C行列
      ccc[0][0] = e1 * (1.0 - v1) / (1.0 + v1) / (1.0 - 2.0 * v1);
      ccc[1][1] = e1 * (1.0 - v1) / (1.0 + v1) / (1.0 - 2.0 * v1);
      ccc[0][1] = e1 * v1 / (1.0 + v1) / (1.0 - 2.0 * v1);
      ccc[1][0] = e1 * v1 / (1.0 + v1) / (1.0 - 2.0 * v1);
      ccc[2][2] = e1 / 2.0 / (1.0 + v1);

      // B行列
      bbb[0][0] = -1.0 / 4.0;
      bbb[1][1] = -1.0 / 4.0;
      bbb[0][2] = 1.0 / 4.0;
      bbb[1][3] = -1.0 / 4.0;
      bbb[0][4] = 1.0 / 4.0;
      bbb[1][5] = 1.0 / 4.0;
      bbb[0][6] = -1.0 / 4.0;
      bbb[1][7] = 1.0 / 4.0;
      bbb[2][0] = bbb[1][1];
      bbb[2][1] = bbb[0][0];
      bbb[2][2] = bbb[1][3];
      bbb[2][3] = bbb[0][2];
      bbb[2][4] = bbb[1][5];
      bbb[2][5] = bbb[0][4];
      bbb[2][6] = bbb[1][7];
      bbb[2][7] = bbb[0][6];

      // ひずみ
      double exx = 0.0;
      double eyy = 0.0;
      double rxy = 0.0;

      if (mpxl[n1][n2] == 1) {
        for (int k = 0; k < nd * node; k++) {
          exx += bbb[0][k] * ue[k];
          eyy += bbb[1][k] * ue[k];
          rxy += bbb[2][k] * ue[k];
        }
      }

      // 応力
      double sxx = 0.0;
      double syy = 0.0;
      double txy = 0.0;

      if (mpxl[n1][n2] == 1) {
        sxx += ccc[0][0] * exx + ccc[0][1] * eyy + ccc[0][2] * rxy;
        syy += ccc[1][0] * exx + ccc[1][1] * eyy + ccc[1][2] * rxy;
        txy += ccc[2][0] * exx + ccc[2][1] * eyy + ccc[2][2] * rxy;
      }

      double smax = (sxx + syy) / 2.0 + sqrt(pow((sxx - syy) / 2.0, 2) + pow(txy, 2));
      double smin = (sxx + syy) / 2.0 - sqrt(pow((sxx - syy) / 2.0, 2) + pow(txy, 2));

      // 保存
      stn[n1][n2][0] = exx; // X方向ひずみ
      stn[n1][n2][1] = eyy; // y方向ひずみ
      stn[n1][n2][2] = rxy; // せん断ひずみ

      sts[n1][n2][0] = sxx; // X方向応力
      sts[n1][n2][1] = syy; // y方向応力
      sts[n1][n2][2] = txy; // せん断応力
      sts[n1][n2][3] = smax; // 最大主応力
      sts[n1][n2][4] = smin; // 最小主応力
    }
  }

  return (disp, stn, sts);
}

// Dot product function
double dotProduct(List<double> a, List<double> b) {
  double sum = 0.0;
  for (int i = 0; i < a.length; i++) {
    sum += a[i] * b[i];
  }
  return sum;
}