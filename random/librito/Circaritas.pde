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
