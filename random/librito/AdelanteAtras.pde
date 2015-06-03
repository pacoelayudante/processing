class AdelanteAtras extends Presentacion {
  int cambia;
  float cambiaRad;
  int vel;
  int tam;
  boolean dir;

  void figura(float giro) {
    graf.triangle(graf.width/2+tam*cos(giro), graf.height/2+tam*sin(giro), graf.width/2+tam*cos(giro+PI*2/3), graf.height/2+tam*sin(giro+PI*2/3), graf.width/2+tam*cos(giro+PI*4/3), graf.height/2+tam*sin(giro+PI*4/3));
    graf.triangle(graf.width/2+tam*cos(2*PI-giro)/6, graf.height/2+tam*sin(2*PI-giro)/6, graf.width/2+tam*cos(2*PI-giro-PI*2/3)/6, graf.height/2+tam*sin(2*PI-giro-PI*2/3)/6, graf.width/2+tam*cos(2*PI-giro-PI*4/3)/6, graf.height/2+tam*sin(2*PI-giro-PI*4/3)/6);
  }

  void setup() {
    mousePos = false;
    mouseBut = true;
    cambia = 0;
    cambiaRad = 0;
    dir = false;

    graf = createGraphics(500, 400);
    graf.beginDraw();
    graf.background(204);
    graf.colorMode(HSB, 360);
    graf.endDraw();
    vel = 5;
    tam = 90*2;
  }

  void mousePressed() {
    dir = (dir == false);
  }

  void draw() {
    graf.beginDraw();
    cambia++;
    cambia %= 360;
    cambiaRad = radians(cambia);
    //println(cambia);
    graf.noStroke();
    graf.fill(0, 1);
    //background(0);
    graf.rect(-30, -30, graf.width+30, graf.height+30);
    graf.stroke(360-cambia, 255, 255);
    graf.fill(cambia, 255, 255, 15);
    figura(cambiaRad);
    if (dir == true) graf.copy(graf, 0, 0, graf.width, graf.height, vel, vel, graf.width-vel*2, graf.height-vel*2);
    else graf.copy(graf, vel, vel, graf.width-vel*2, graf.height-vel*2, 0, 0, graf.width, graf.height);
    graf.endDraw();
  }
}
