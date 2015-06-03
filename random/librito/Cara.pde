class Cara extends Presentacion {
  PGraphics cara;

  void setup() {
    mousePos = true;
    mouseBut = false;
    
    graf = createGraphics(640, 400);
    graf.beginDraw();
    graf.background(204);
    graf.noStroke();
    graf.smooth();
    graf.endDraw();
    cara = createGraphics(640, 400, JAVA2D);
    cara.beginDraw();
    cara.smooth();
    cara.endDraw();
  }

  void draw() {
    float seg = constrain(map(mouseX, 0, graf.width, 20, 60),20,60);
    float varI = constrain(norm(mouseY, 0, graf.height-1),0,1);
    float variacion = 1-varI;
    cara.beginDraw();
    cara.resetMatrix();
    cara.strokeWeight(variacion*4+1);
    for (int i=0; i<varI*600; i++) {
      cara.stroke(255, 0, 0);
      cara.point(random(cara.width), random(cara.height));
    }
    cara.fill(0, variacion*variacion*215+40);
    cara.noStroke();
    cara.rect(0, 0, cara.width, cara.height);
    cara.translate(25*random(-varI, varI), 25*random(-varI, varI));
    cara.noFill();
    cara.stroke(255, variacion*150+105);
    cara.arc(320, 130, 300, 210, PI, 0);
    cara.arc(320, 130, 300, 450, 0, PI);
    cara.arc(320-100, 270, 300, 300, PI*1.48, PI*1.65);
    cara.arc(320+100, 270, 300, 300, PI*1.35, PI*1.52);
    cara.ellipse(320-80, 160, 90, 30);
    cara.ellipse(320+80, 160, 90, 30);
    cara.arc(320, 200, 50, 150, PI*1.65, PI*1.35);
    cara.arc(320, 380, 200, 150, PI*1.35, PI*1.65);
    cara.arc(320, 390, 100, 130, PI*1.40, PI*1.60);
    cara.endDraw();
    
    graf.beginDraw();
    graf.image(cara, 0, 0, graf.width, graf.height);
    for (int i=0; i<6; i++) {
      graf.fill(255-seg*i, 255, 0, 100*variacion);
      graf.ellipse(10+seg*i*2, 10+seg*i, seg*i, seg*i);
    }
    graf.endDraw();
  }
}
