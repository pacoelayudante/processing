class Circulos  extends Presentacion {
  PVector[] luma, lemo, lante;
  color[] lumaC, lemoC, lanteC;
  PVector camP, camR, camV;
  boolean edita = false;

  float zOffset = 450, zCam = 900;
  float tam = 100, borde = 20;
  float relTam = .6;
  float grav = 2;

  void setup() {
    mousePos = true;
    mouseBut = true;
    camP = new PVector(0, 0, 0);
    camV = new PVector();
    camR = new PVector();

    graf = createGraphics(640, 480, P3D);
    graf.beginDraw();
    graf.background(204);
    graf.noStroke();
    graf.endDraw();

    //frameRate(20);

    lante = new PVector[] {
      new PVector(64, 415, 0+zOffset), 
      new PVector(140, 11, -120), 
      new PVector(-85, 3, 110)
      };
    lanteC = new color[] {
      color(#FFFF00), color(#FFC800), color(#FF6F00)
    };

    luma = new PVector[] {
      new PVector(-118, -217, -428+zOffset), 
      new PVector(-242, -62, -543+zOffset), 
      new PVector(-126, 87, -578+zOffset)
      };
    lumaC = new color[] {
      color(#FF40F6), color(#CB40FF), color(#9570D6), color(#9C83E8)
    };

    lemo = new PVector[] {
      new PVector(690, 244, -534+zOffset), 
      new PVector(646, 422, -531+zOffset), 
      new PVector(535, 617, -589+zOffset),
    };
    lemoC = new color[] {
      color(#00B0FF), color(#00FFD2), color(#00FF63), color(#A5FF00)
    };
  }

  void astor(PVector[] pos, color[] colores) {
    graf.pushMatrix();
    graf.fill(colores[0]);
    for (int i=0; i<pos.length; i++) {
      graf.pushMatrix();
      graf.translate(pos[i].x, pos[i].y, pos[i].z);
      graf.sphere(tam*pos.length-i*tam+borde);
      graf.fill(colores[i+1]);
      graf.sphere(tam*pos.length-i*tam);
      graf.popMatrix();
    }
    graf.popMatrix();
  }

  void planor(PVector[] pos, color[] colores) {
    graf.hint(ENABLE_DEPTH_TEST);
    graf.pushMatrix();
    graf.translate(pos[0].x, pos[0].y, pos[0].z);
    graf.fill(colores[0]);
    graf.sphere(-tam);
    graf.translate(-tam, -tam, -tam);
    anila(pos, colores, tam*relTam, 1);
    graf.popMatrix();
    graf.hint(DISABLE_DEPTH_TEST);
  }

  void anila(PVector[] pos, color[] colores, float tam, int nivel) {
    graf.pushMatrix();
    graf.rotateX(radians(pos[nivel].z));
    graf.rotateZ(radians(pos[nivel].z));
    float rotPaso = TWO_PI/pos[nivel].y;
    for (int i=0; i<pos[nivel].y; i++) {
      graf.fill(colores[nivel], 200);
      graf.sphere(-tam);
      if (nivel+1<pos.length) anila(pos, colores, tam*relTam, nivel+1);
      graf.translate(pos[nivel].x, 0, 0);
      graf.rotate(rotPaso);
    }
    graf.popMatrix();
  }

  int sel = 0;
  void mousePressed() {
    if (edita) {
      if (mouseButton == RIGHT) sel = (sel+1)%lante.length;
    }
  }

  void draw() {
    graf.beginDraw();
    graf.resetMatrix();
    graf.hint(ENABLE_DEPTH_TEST);
    graf.background(0);
    graf.hint(DISABLE_DEPTH_TEST);
    if (edita) {
      println("LUMA:");
      for (int i=0; i<luma.length; i++) {
        println("X"+i+": "+luma[i].x+"\t"+"Y"+i+": "+luma[i].y+"\t"+"Z"+i+": "+luma[i].z+"\t");
      }
      println("LEMO:");
      for (int i=0; i<lemo.length; i++) {
        println("X"+i+": "+lemo[i].x+"\t"+"Y"+i+": "+lemo[i].y+"\t"+"Z"+i+": "+lemo[i].z+"\t");
      }
      println("LANTE:");
      for (int i=0; i<lante.length; i++) {
        println("X"+i+": "+lante[i].x+"\t"+"Y"+i+": "+lante[i].y+"\t"+"Z"+i+": "+lante[i].z+"\t");
      }
      println("---------------------------------------------------------------");

      if (mousePressed) {
        if (mouseButton == LEFT) {
          lante[sel].x += (mouseX-pmouseX)/10;
          lante[sel].y += (mouseY-pmouseY)/10;
        }
        if (mouseButton == CENTER) {
          lante[sel].z += (mouseX-pmouseX)/10;
        }
      }
      if (keyPressed) {
        if (key == 'a') {
          camP.x -= 30;
        }
        if (key == 'd') {
          camP.x += 30;
        }
        if (key == 'w') {
          camP.y -= 30;
        }
        if (key == 's') {
          camP.y += 30;
        }
        if (keyCode == LEFT) {
          camR.y += radians(3);
        }
        if (keyCode == RIGHT) {
          camR.y -= radians(3);
        }
      }
    }
    camP.mult(.95);
    if (mousePressed) camP.z += .05*-zCam;
    else camP.z += .05*zCam;
    camP.x += (mouseX-graf.width/2)*.15;
    camP.y += (mouseY-graf.height/2)*.15;
    camR.y = atan2(camP.x, camP.z+(graf.height/2.0) / tan(PI*60.0 / 360.0));
    camR.x = atan2(-camP.y, abs(camP.z)+(graf.height/2.0) / tan(PI*60.0 / 360.0));
    graf.camera();
    graf.beginCamera();
    graf.translate(camP.x, camP.y, camP.z);
    graf.rotateY(camR.y);
    graf.rotateX(camR.x);
    graf.endCamera();
    if (camP.dist(luma[0]) > camP.dist(lemo[0])) {
      astor(luma, lumaC);
      astor(lemo, lemoC);
    } else {
      astor(lemo, lemoC);
      astor(luma, lumaC);
    }
    planor(lante, lanteC);
    graf.endDraw();
  }
}
