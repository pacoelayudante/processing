class BlueWave extends Presentacion {
  float i, 
  delta = 7;

  void setup() {
    mousePos = true;
    mouseBut = false;
    i = 0;
    
    graf = createGraphics(640, 400);
    graf.beginDraw();
    graf.background(204);
    graf.endDraw();
  }

  void draw() {
    graf.beginDraw();
    graf.resetMatrix();
    graf.rectMode(CORNER);
    float iter = mouseY;
    float rad = graf.height*.5/iter;
    i++;
    if (i > iter) i = 0;
    graf.noStroke();
    graf.fill(68,136,0, 5);
    graf.rect(0, 0, graf.width, graf.height);
    graf.strokeWeight(3);
    graf.stroke(255,0,0, map(mouseX, 0, graf.width, 30, 200));
    graf.fill(0,0,255, 20);
    graf.translate(graf.width*.5, graf.height*.5);
    graf.triangle(rad*i*cos(radians(i*delta)), rad*i*sin(radians(i*delta)), rad*i*cos(radians(i*delta+120)), rad*i*sin(radians(i*delta+120)), rad*i*cos(radians(i*delta+240)), rad*i*sin(radians(i*delta+240)));
    graf.endDraw();
  }
}
