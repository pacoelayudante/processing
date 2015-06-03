class Asco extends Presentacion {
  float posFondoX, posFondoY;
  float[][] partX, partY;
  float[] lastPartX, lastPartY;
  int numPart = 50;
  float tamP = 7;
  float disP = 30, offsetP = 2, velP = 3;

  void setup() {   
    mousePos = true;
    mouseBut = false;
    
    graf = createGraphics(640, 480);
    graf.beginDraw();
    graf.background(204);
    graf.smooth();
    graf.ellipseMode(CENTER);
    graf.colorMode(HSB);
    graf.endDraw();
    //frameRate(20);
    posFondoX = graf.width/2.;
    posFondoY = graf.height*2/6.;
    partX = new float[2][numPart];
    partY = new float[2][numPart];
    lastPartX = new float[2];
    lastPartY = new float[2];
    lastPartX[0] = 95;
    lastPartX[1] = 310;
    lastPartY[0] = 285;
    lastPartY[1] = 410;
    for (int i=0; i<numPart; i++) {
      partX[0][i] = graf.width+random(graf.width);
      partY[0][i] = -random(graf.height);
      partX[1][i] = graf.width+random(graf.width);
      partY[1][i] = -random(graf.height);
    }
  }

  void fondo() {
    graf.noStroke();
    graf.pushMatrix();
    graf.translate(posFondoX, posFondoY);
    for (int i=0; i<5; i++) {
      graf.rotate(radians(frameCount));
      graf.pushMatrix();
      graf.translate(frameCount%((i+1)*5), 0);
      graf.fill(i*i*2+i*5, 220-i*11, 250-i*25*norm(mouseX, 0, width), 10);
      graf.ellipse(0, 0, i*150, i*150);
      graf.popMatrix();
    }
    graf.popMatrix();
  }

  void colina(float x, float y, float w, float h) {
    for (int i=0; i<10; i++) {
      graf.ellipse(x, y, w, h*cos(radians((i*9+frameCount*.5)%90)));
    }
  }

  void colinas() {
    colina(45, 460, 100, 100);
    colina(200, 430, 250, 120);
    colina(100, 400, 120, 300);
    colina(310, 480, 90, 200);
    colina(420, 425, 210, 150);
    colina(620, 430, 300, 500);
  }

  void nube(int n) {
    for (int i=0; i<numPart; i++) {
      graf.ellipse(partX[n][i], partY[n][i], tamP, tamP);
      float offsetX = random(-offsetP, offsetP);
      float offsetY = random(-offsetP, offsetP);
      float dir = atan2(lastPartY[n]-partY[n][i], lastPartX[n]-partX[n][i]);
      float velX = velP*cos(dir);
      float velY = velP*sin(dir);
      partX[n][i] += velX+offsetX;
      partY[n][i] += velY+offsetY;
      if (dist(partX[n][i], partY[n][i], lastPartX[n], lastPartY[n]) < disP) {
        partX[n][i] = graf.width+random(200, 400);
        partY[n][i] = -random(200, 400);
      }
    }
  }

  void draw() {
    graf.beginDraw();
    fondo();
    graf.fill(255);
    graf.scale(width/640.);
    nube(0);
    nube(1);
    graf.strokeWeight(5);
    float bri = map(mouseX, 0, width, 150, 255);
    graf.fill(200, bri-20, bri, 25);
    graf.stroke(220, bri-20, bri, 45);
    colinas();
    graf.endDraw();
  }
}
