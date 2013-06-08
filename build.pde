UGeometry geo;
float buildH;
int res;

void build() {
  geo = new UGeometry();
  res = numRow;
  
  UVertexList vl1 = new UVertexList();
  for (int i=0; i < res; i++) {
    float a = map(i, 0, res, 0, -TWO_PI);
    vl1.add(cos(a), data[3][i], sin(a));
  }

  UVertexList vlVol=new UVertexList();
  for (int i=0; i < res; i++) {
    float a = map(i, 0, res, 0, -TWO_PI);
    vlVol.add(i, data[4][i], 0);
  }

  vlVol.scale(1, 0.0001, 1);
  UVertexList vlVol2=new UVertexList(vlVol).scale(1, 0, 1);

  geo.quadStrip(vlVol, vlVol2);

  vl1.scale(300, 300, 300);

  UVertexList vv[]=UVertexList.getVertexLists(4);
  vv[0].set(vl1).scale(1, 0, 1); //largeur base
  vv[1].set(vl1);
  vv[2].set(vl1).scale(100.0/300.0, 1, 100.0/300.0); //épaisseur contour
  vv[3].set(vl1).scale(100.0/300.0, 0, 100.0/300.0); //épaisseur contour

  geo.quadStrip(vv);
  geo.quadStrip(vv[vv.length-1], vv[0]);

  UVertexList startFan = new UVertexList();
  UVertexList endFan = new UVertexList();
  
  for (int i = 0; i < vv.length; i++) {
    startFan.add(vv[i].first());
    endFan.add(vv[i].last());
  }

  geo.triangleFan(startFan.close(), true, true);
  geo.triangleFan(endFan.close(), true, false);
  geo.center();
  geo.calcBounds();
  geo.translate(0, -geo.bb.min.y, 0);
}

