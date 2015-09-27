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

