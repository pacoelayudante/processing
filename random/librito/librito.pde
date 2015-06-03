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

