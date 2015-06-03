class Cristales extends Presentacion {
  PGraphics fondo;

  void setup() {
    mousePos = false;
    mouseBut = false;
    i = 0;

    graf = fondo = createGraphics(640, 480);
    fondo.beginDraw();
    fondo.smooth();
    fondo.background(255);
    fondo.endDraw();
    i = fondo.height/2;
  }

  int i;

  void draw() {
    if (i >= 0) {
      i--;
      fondo.beginDraw();
      for (int j=fondo.width; j>=0; j--) {
        int c = i;
        while (random (100) < 93) c--;
        if (random(100) < 20) fondo.strokeWeight(2);
        else fondo.strokeWeight(1);
        fondo.noStroke();
        fondo.fill(c*c*.02, c, 0, 45);
        fondo.ellipse(j+random(-20, 20), i+random(-20, 20), 40+random(-5, 40), 20+random(-5, 5));
        fondo.stroke(90-c/5, 205-c/2, 90-c/5, 50);
        fondo.line(j-2, fondo.height-i+random(3, 8), j+random(6), fondo.height-i-random(3, 8));
      }
      cristalA(.5*(fondo.height/2-i), .2*(fondo.height/2-i), random(fondo.width), fondo.height-i, 2);
      fondo.endDraw();
    }
  }

  void cristalA(float w, float h, float pX, float pY, int n) {
    fondo.fill(150, 150, 255, 120);
    fondo.stroke(150, 150, 255, 150);  
    fondo.pushMatrix();
    fondo.translate(pX, pY);
    float x[] = new float[3];
    float y[] = new float[3];
    x[0] = -random(w);//append(x, -random(w));
    x[1] = random(w);//append(x, random(w));
    x[2] = random(-w*.5, w*.5);//append(x, random(-w*.5, w*.5));
    y[0] = random(10);//append(y, random(10));
    y[1] = random(10);//append(y, random(10));
    y[2] = -h+random(-20, 20);//append(y, -h+random(-20, 20));
    cristalB(x, y, n, .95, .6);
    fondo.popMatrix();
  }

  void cristalB(float[] x, float[] y, int niveles, float rel, float rel2) {
    float relA = 1-rel;
    float rel2A = (1-rel2)*1;
    fondo.beginShape();
    for (int i=0; i<x.length; i++) {
      fondo.vertex(x[i], y[i]);
    }
    fondo.endShape(CLOSE);
    if (niveles > 0) {
      float xx[] = new float[3];
      float yy[] = new float[3];
      xx[0] = x[0]*rel2+x[1]*rel2A;//append(xx, x[0]*rel2+x[1]*rel2A);
      xx[1] = x[1]*rel+x[2]*relA;//append(xx, x[1]*rel+x[2]*relA);
      xx[2] = x[2]*rel+x[1]*relA;//append(xx, x[2]*rel+x[1]*relA);
      yy[0] = y[1]*rel+y[2]*relA;//append(yy, y[1]*rel+y[2]*relA);
      yy[1] = y[1]*rel+y[2]*relA;//append(yy, y[1]*rel+y[2]*relA);
      yy[2] = y[2]*rel+y[1]*relA;//append(yy, y[2]*rel+y[1]*relA);
      cristalB(xx, yy, niveles-1, rel, rel2);
    }
  }
}
