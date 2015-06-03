/* @pjs pauseOnBlur=true; 
 */

Presentacion actual;
ArrayList<Presentacion> presentaciones = new ArrayList();
ArrayList<PImage> icos = new ArrayList();

float[] alfa;
float velFadeActivo = 5;
float velFadeInactivo = 20;
float blanco;
float velFadeBlanco = 70;

void setup() {
  size(640, 720, P2D);
  rectMode(CENTER);
  stroke(255);
  strokeWeight(3);

  presentaciones.add( new AdelanteAtras() );
  icos.add( requestImage("adelanteatras.png") );
  presentaciones.add( new Asco() );
  icos.add( requestImage("asco.png") );
  presentaciones.add( new BlueWave() );
  icos.add( requestImage("bluewave.png") );
  presentaciones.add( new Cara() );
  icos.add( requestImage("cara.png") );
  presentaciones.add( new Chimeneas() );
  icos.add( requestImage("chimeneas.png") );
  presentaciones.add( new Circaritas() );
  icos.add( requestImage("circaritas.png") );
  presentaciones.add( new Circulos() );
  icos.add( requestImage("circulos.png") );
  presentaciones.add( new Cristales() );
  icos.add( requestImage("cristales.png") );

  actual = presentaciones.get( 0 );
  actual.setup();

  alfa = new float[icos.size()];
  for (int i=0; i<alfa.length; i++) {
    alfa[i] = 255;
  }
}

void draw() {
  background(0);

  if (mouseY < 60) {
    for (int i=0; i<alfa.length; i++) {
      if (alfa[i] < 255) {
        alfa[i] = min( alfa[i] + (actual==presentaciones.get(i)?velFadeInactivo:velFadeActivo), 255);
      }
    }
  } else {
    for (int i=0; i<alfa.length; i++) {
      if (alfa[i] > 0) {
        alfa[i] = max( alfa[i] - (actual==presentaciones.get(i)?velFadeActivo:velFadeInactivo), 0);
      }
    }
  }
  imageMode(CENTER);
  float difX = width / float(icos.size()+1); 
  for (int i=0; i<alfa.length; i++) {
    tint(255, alfa[i]);
    image( icos.get(i), difX * (i+1), 40, 30, 30 );
    if (mouseX > difX * (i+.5) && mouseX < difX * (i+1.5) && mouseY < 60) {
      fill(255, blanco);
      stroke(alfa[i]);
      rect(difX * (i+1)-1, 40-1, 35, 35 );
    }
  }
  noTint();
  imageMode(CORNER);
  if (blanco > 0) {
    blanco = max( blanco - velFadeBlanco, 0);
  }
  //MENU
  int offx = (width-actual.graf.width)/2;
  int offy = 80;
  mouseX -= offx;
  mouseY -= offy;
  actual.draw();
  mouseX += offx;
  mouseY += offy;
  fill(102);
  String texto = "No interaction";
  if (actual.mousePos || actual.mouseBut) {
    texto = "Use "+(actual.mousePos?"mouse position":"mouse button");
    if (actual.mouseBut && actual.mousePos) texto += " and mouse button";
  }
  text(texto, 20, 75);
  image(actual.graf, offx, offy);
}

void keyPressed() {
  int cua = key-49;
  if (cua >= 0 && cua < presentaciones.size()) { 
    actual = presentaciones.get(cua);
    actual.setup();
  }
}

void mousePressed() {
  if (mouseY < 60) {
    float difX = width / float(icos.size()+1); 
    for (int i=0; i<alfa.length; i++) {
      if (mouseX > difX * (i+.5) && mouseX < difX * (i+1.5)) {
        actual = presentaciones.get(i);
        actual.setup();
        blanco = 255;
        break;
      }
    }
  } else {
    mouseY -= 80;
    actual.mousePressed();
    mouseY += 80;
  }
}

class Presentacion {
  boolean mousePos, mouseBut;
  PGraphics graf;
  void setup() {
    graf = createGraphics(100,100);
  }
  void draw() {
  }
  void mousePressed() {
  }
}

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
class Circaritas extends Presentacion {
  PImage simbolos[];
  float cargado[];
  int vari = 3;
  float circuloCarga = 25;
  boolean cargo = false, listop = false;

  void icono(PImage imagen, float radio) {
    graf.tint(255);
    graf.image(imagen, -vari, radio);
    graf.tint(0);
    graf.image(imagen, vari, radio);
    graf.tint(200, 0, 200);
    graf.image(imagen, 0, radio);
  }

  void circulo(float cantidad, float radio) {
    graf.pushMatrix();
    for (int i=0; i<cantidad; i++) {
      graf.rotate(TWO_PI/cantidad);
      icono(simbolos[floor(random(simbolos.length))], radio);
    }
    graf.popMatrix();
  }

  void circulo(boolean la, int variacion, int rad, int fase) {
    graf.pushMatrix();
    for (int i=0; i<variacion; i++) {
      graf.rotate((TWO_PI/variacion)*i+PI/fase);
      graf.translate(0, -rad);
      icono(simbolos[floor(random(simbolos.length))], rad);
    }
    graf.popMatrix();
  }

  void setup() {
    mousePos = false;
    mouseBut = false;
    listop = false;

    graf = createGraphics(640, 640);
    graf.beginDraw();
    graf.background(100, 0, 100);
    graf.strokeWeight(3);
    graf.imageMode(CENTER);
    graf.endDraw();

    if (simbolos == null) {
      simbolos = new PImage[16];
      cargado = new float[simbolos.length];
      for (int i=0; i<simbolos.length; i++) {
        simbolos[i] = requestImage("icono"+i+".png");
      }
    }
  }

  void dibujaCirculos() {
    graf.resetMatrix();
    graf.smooth();
    graf.scale(graf.width/640.);
    graf.background(0, 255, 0);
    graf.translate(160, 160);
    circulo(8, 60);
    circulo(12, 100);
    circulo(16, 140);
    graf.translate(320, 0);
    circulo(8, 60);
    circulo(12, 100);
    circulo(16, 140);
    graf.translate(-320, 320);
    circulo(8, 60);
    circulo(12, 100);
    circulo(16, 140);
    graf.translate(320, 0);
    circulo(8, 60);
    circulo(12, 100);
    circulo(16, 140);
    listop = true;
  }

  void cargaImagenes() {
    cargo = true;
    graf.pushMatrix();
    graf.translate(graf.width/2, graf.height/2);
    for (int i=0; i<simbolos.length; i++) {
      boolean cargoEste = simbolos[i].width > 0;
      cargo = cargo && cargoEste;
      if (cargoEste) cargado[i] = 1;
      else cargado[i] = cargado[i]*.95+.05;
      graf.rotate(TWO_PI*i/simbolos.length);
      graf.noStroke();
      graf.fill(0, 255, 0);
      graf.ellipse(width/3, 0, 50*cargado[i], 50*cargado[i]);
      graf.noFill();
      graf.stroke(255);
      graf.arc(width/3, 0, 50, 50, 0, PI);
      graf.stroke(0);
      graf.arc(width/3, 0, 50, 50, PI, TWO_PI);
    }
    graf.popMatrix();
  }

  void draw() {
    if (listop) return;

    graf.beginDraw();
    if (cargo) {
      dibujaCirculos();
    } else {
      cargaImagenes();
    }
    graf.endDraw();
  }
}
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

