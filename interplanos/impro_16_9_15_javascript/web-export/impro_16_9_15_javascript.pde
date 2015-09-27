ArrayList<Drawable> cosas = new ArrayList();
boolean efecto = true, invertir = false;

void setup() {
  size(512, 512);
  //size(displayWidth,displayHeight);
  filtroSetUp(width, height);
  loadPixels();
  noCursor();
}

void mousePressed() {
  if (mouseButton == LEFT)
    cosas.add(new Coso(mouseX, mouseY));
}

void setEfecto(boolean actual){
  efecto = actual;
}
void setInvertir(boolean actual){
  invertir = actual;
}

int velG=3;
void keyPressed() {
  velG = constrain(key-48, 0, 9);
}

long lt;
float dt;
void draw() {
  if (efecto) {
    loadPixels();
    if (mousePressed ^ invertir) pixels=erode(pixels, width, height);
    else pixels=dilate(pixels, width, height);
    updatePixels();
  }

  dt = (millis()-lt)/1000.;
  lt = millis();
  colorMode(HSB);

  noStroke();
  int c = (frameCount/10)%255;
  fill(c, 255, 255, 1);
  document.body.style.backgroundColor = "hsl("+(255-c)+",30%,75%)";
  rect(0, 0, width, height);

  fill(0);
  stroke(0);
  float t = dist(mouseX, mouseY, pmouseX, pmouseY);
  strokeWeight( min(t, 5) );
  line(mouseX, mouseY, pmouseX, pmouseY);//ellipse(mouseX,mouseY,t,t);

  for (int i=cosas.size ()-1; i>=0; i--) {
    cosas.get(i).draw();
    if (cosas.get(i).borrar()) cosas.remove(i);
  }
}
class Drawable {
  void draw() {
  }
  boolean borrar() {
    return true;
  }
}
class Coso extends Drawable {
  PVector pos;
  float dir;
  float vel;
  float vida;
  Coso(float x, float y) {
    pos = new PVector(x, y);
    vel = 200 * velG/5.;
    vida = 60;
    dir = random(TWO_PI);
  }

  void draw() {
    float px = pos.x;
    float py = pos.y;
    dir += random( cos (frameCount*.1) )*2./velG;
    pos.x += vel*cos(dir)*dt;
    pos.y += vel*sin(dir)*dt;
    vida-=dt;
    strokeWeight(10);//vel/30);
    line(px, py, pos.x, pos.y);
    //ellipse(px,py,100,100);
  } 
  boolean borrar() {
    return vida < 0;
  }
}

int x, minLum;
int maxIndiceY, maxIndiceX;
int[] salida, lum;

void filtroSetUp(int ancho, int alto) {
  salida = new int[ancho*alto];
  lum = new int[ancho*alto];
  maxIndiceY = ancho*alto-ancho;
  maxIndiceX = ancho-1;
}

int[] dilate(int[] pixeles, int ancho, int alto) {// Rectangular, no diagonal
  //int[] salida = new int[pixeles.length];
  //int[] lum = new int[pixeles.length];
  x=0;//int x = 0;
  minLum = 0;//int minLum = 0;
  //int i=0;

  //int maxIndiceY = pixeles.length-ancho;
  //int maxIndiceX = ancho-1;

  for (int i=0; i<pixeles.length; i++) {
    //while(i<pixeles.length){
    x = i%ancho;

    if (i==0) {//Unico caso que no es calculado por alguien anterior
      lum[i] = 77*(pixeles[i]>>16&0xff) + 151*(pixeles[i]>>8&0xff) + 28*(pixeles[i]&0xff);
    }
    minLum = lum[i];
    salida[i] = pixeles[i];

    if (x<maxIndiceX) {// i+1 , primera vez que calculo
      lum[i+1] = 77*(pixeles[i+1]>>16&0xff) + 151*(pixeles[i+1]>>8&0xff) + 28*(pixeles[i+1]&0xff);
      if (minLum < lum[i+1]) {
        salida[i] = pixeles[i+1];
        minLum = lum[i+1];
      }
    }
    if (i<maxIndiceY/*y<alto-1*/) {// i+ancho, primera vez que calculo
      lum[i+ancho] = 77*(pixeles[i+ancho]>>16&0xff) + 151*(pixeles[i+ancho]>>8&0xff) + 28*(pixeles[i+ancho]&0xff);
      if (minLum < lum[i+ancho]) {
        salida[i] = pixeles[i+ancho];
        minLum = lum[i+ancho];
      }
    }
    if (x>0) {// i-1
      if (minLum < lum[i-1]) {
        salida[i] = pixeles[i-1];
        minLum = lum[i-1];
      }
    }
    if (i>ancho) {// i-ancho
      if (minLum < lum[i-ancho]) {
        salida[i] = pixeles[i-ancho];
        minLum = lum[i-ancho];
      }
    }

    //i++;
  }

  return salida;
}
int[] erode(int[] pixeles, int ancho, int alto) {// Rectangular, no diagonal
  //int[] salida = new int[pixeles.length];
  //int[] lum = new int[pixeles.length];
  x=0;//int x = 0;
  minLum = 0;//int minLum = 0;
  //int i=0;

  //int maxIndiceY = pixeles.length-ancho;
  //int maxIndiceX = ancho-1;

  for (int i=0; i<pixeles.length; i++) {
    //while(i<pixeles.length){
    x = i%ancho;

    if (i==0) {//Unico caso que no es calculado por alguien anterior
      lum[i] = 77*(pixeles[i]>>16&0xff) + 151*(pixeles[i]>>8&0xff) + 28*(pixeles[i]&0xff);
    }
    minLum = lum[i];
    salida[i] = pixeles[i];

    if (x<maxIndiceX) {// i+1 , primera vez que calculo
      lum[i+1] = 77*(pixeles[i+1]>>16&0xff) + 151*(pixeles[i+1]>>8&0xff) + 28*(pixeles[i+1]&0xff);
      if (minLum > lum[i+1]) {
        salida[i] = pixeles[i+1];
        minLum = lum[i+1];
      }
    }
    if (i<maxIndiceY/*y<alto-1*/) {// i+ancho, primera vez que calculo
      lum[i+ancho] = 77*(pixeles[i+ancho]>>16&0xff) + 151*(pixeles[i+ancho]>>8&0xff) + 28*(pixeles[i+ancho]&0xff);
      if (minLum > lum[i+ancho]) {
        salida[i] = pixeles[i+ancho];
        minLum = lum[i+ancho];
      }
    }
    if (x>0) {// i-1
      if (minLum > lum[i-1]) {
        salida[i] = pixeles[i-1];
        minLum = lum[i-1];
      }
    }
    if (i>ancho) {// i-ancho
      if (minLum > lum[i-ancho]) {
        salida[i] = pixeles[i-ancho];
        minLum = lum[i-ancho];
      }
    }

    //i++;
  }

  return salida;
}


