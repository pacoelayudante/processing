class Chimeneas extends Presentacion {
  color colFondo = color(30, 20, 20);

  float velPan = .025;
  float hMin, hMax;
  float wMin = 10, wMax = 15;
  color colorBase = color(120);
  color colorMugre = color(0, 30);
  float hMinMugre = 4, hMaxMugre = 60;
  int minMugre = 4, maxMugre = 8;

  Chimenea chimeneas[];

  void setup() {
    mousePos = false;
    mouseBut = false;
    
    graf = createGraphics(640, 400);
    graf.beginDraw();
    graf.stroke(255);
    graf.smooth();
    graf.background(204);
    graf.endDraw();
    
    //frameRate(30);
    hMax = graf.height/2.;
    hMin = graf.height/8.;    
    chimeneas = new Chimenea[20];
    for (int i=0; i<chimeneas.length; i++) {
      chimeneas[i] = new Chimenea(i);
    }
  }

  void draw() {
    graf.beginDraw();
    graf.background(colFondo);
    for (int i=0; i<chimeneas.length; i++) {
      chimeneas[i].ciclo();
    }
    for (int i=0; i<chimeneas.length; i++) {
      graf.pushMatrix();
      if (chimeneas[i].x > graf.width*1.5) graf.translate(-graf.width*1.5, 0);
      graf.translate(chimeneas[i].x+chimeneas[i].ancho/2, chimeneas[i].y);
      graf.popMatrix();
    }
    graf.endDraw();
  }

  class Chimenea {
    float x, y;
    int alto, ancho;
    float fuego = 0;
    boolean encendida;
    PImage textura;
    Humo humo;

    Chimenea (int sombra) {
      humo = new Humo();
      alto = ceil(random(hMin, hMax));
      ancho = ceil(random(wMin, wMax));
      x = ceil(random(graf.width*1.5));
      y = graf.height-alto;
      encendida = random(100) < 85;
      PGraphics buffer = createGraphics(ancho, alto, JAVA2D);
      buffer.beginDraw();
      buffer.background(colorBase);
      buffer.stroke(colorMugre);
      for (int i=ceil (random (minMugre, maxMugre))*ancho; i > 0; i--) {
        buffer.line(i%ancho, 0, i%ancho, random(hMinMugre, hMaxMugre));
      }
      buffer.fill(0, 200-sombra*10);
      buffer.rect(0, 0, ancho, alto);
      buffer.endDraw();
      textura = buffer.get();
    }

    void ciclo() {
      graf.pushMatrix();
      x += velPan;
      if (x > graf.width+ancho) x -= graf.width*1.5;
      if (x > graf.width*1.5) graf.translate(-graf.width*1.5, 0);
      graf.translate(x+ancho/2, y);
      humo.ciclo();
      graf.popMatrix();
      graf.image(textura, x, y);
    }
  }

  class Humo {
    PVector[] pos;
    float delta, deltaVel;

    Humo() {
      PVector temp = new PVector();
      pos = new PVector[0];
      delta = random(TWO_PI*100);
      deltaVel = radians(random(1, 2));
      suma(0, 0, HALF_PI+PI);
      temp.set(pos[0]);
      while (temp.x < graf.width*1.5) {
        temp.z = temp.z*.99 + TWO_PI*.01;
        temp.add(12*cos(temp.z), 4*sin(temp.z), 0);
        suma(temp.x, temp.y, temp.z);
      }
    }

    void ciclo() {
      delta += deltaVel;
      if (pos.length > 1) {
        for (int i=pos.length-1; i>0; i--) {
          float r0 = i*cos(radians(i*20+delta)), r1 = (i-1)*sin(radians((i-1)*20+delta));
          graf.stroke(i, i*.5, i*.5, 100);
          graf.strokeWeight((pos.length-i)*.1);
          graf.line(pos[i].x+i*sin(r0)-graf.width*1.5, pos[i].y+i*cos(r0), pos[i-1].x+(i-1)*sin(r1)-graf.width*1.5, pos[i-1].y+(i-1)*cos(r1));
          graf.line(pos[i].x+i*sin(r0), pos[i].y+i*cos(r0), pos[i-1].x+(i-1)*sin(r1), pos[i-1].y+(i-1)*cos(r1));
        }
      }
    }

    void suma(float x, float y, float dir) {
      pos = (PVector[]) append(pos, new PVector(x, y, dir));
    }
  }
}
