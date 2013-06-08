import ddf.minim.*;
Minim minim;
AudioInput in;
AudioRecorder recorder;

import controlP5.*;
import processing.opengl.*;
import unlekker.util.*;
import unlekker.modelbuilder.*;
import unlekker.modelbuilder.filter.*;
import ec.util.*;

color bg = #f2f0e6;
color sh = #e9350b;
color st = #9c2206;

float data[][];
float maxDataVal = -1000;
float maxDataValVol = -1000;
int numRow = 100; 
int numCol;
float[] sound = new float[numRow];
boolean load = false;

UNav3D nav;

void setup() {
  size(800, 600, OPENGL);
  smooth();

  nav=new UNav3D(this);
  nav.setTranslation(width/2, height/2, 0);  
  nav.setRotation(radians(150), radians(30), 0);

  minim = new Minim(this);
  in = minim.getLineIn();
}

void draw() {
  background(bg);
  frameRate(24);
  lights();
  fill(sh);

  for (int i = 0; i < numRow; i++) {
    sound[i] = 0.02 + abs(in.right.get(i));
    if (i == numRow - 1) {
      if (load == false) {
        loadStockData();
      }
    }
  }
  pushMatrix();
  nav.doTransforms();
  geo.draw(this);
  popMatrix();
}

void loadStockData() {
  numCol= 5;
  data = new float[numCol][numRow];

  for (int i = 0; i < numRow; i++) {
    for (int j = 0; j < numCol; j++) {
      data[j][i] = sound[i]; //ici injection des valeurs
      //println(i+","+j+" "+data[j][i]);
    }
    maxDataVal = max(maxDataVal, data[3][i]);
    maxDataValVol= max(maxDataValVol, data[4][i]);
  } 
  for (int i=0; i<numRow; i++) {
    data[3][i] = data[3][i]/maxDataVal;
    data[4][i] = data[4][i]/maxDataValVol;
  }

  build();
}

public void keyPressed() {
  if (key=='e') {
    geo.writeSTL(this, "STL"+day()+month()+year()+hour()+minute()+second()+"_export.stl");
  }
  if (key=='s') {
    load = true;
  }
}

