Poligono poli;//
ArrayList<PVector> polisCortados;
PVector corteA, corteB;

void setup() {
  size(456, 456);
  makePoli();
}

void makePoli() {
  PVector p[] = new PVector[16];
  for (int i=0; i<p.length; i++) {
    float a = (TWO_PI/p.length)*i;
    float r = random(40, 150);
    p[i] = new PVector(cos(a)*r + width/2, sin(a)*r+height/2);
  }
  poli = new Poligono(p);
}

void keyPressed() {
  makePoli();
}

void mousePressed() {
  corteA = new PVector(mouseX, mouseY);
  corteB = null;
}
void mouseReleased() {
  corteB = new PVector(mouseX, mouseY);
  PVector med = PVector.add(corteA, corteB);
  med.mult(.5);
  corteB.sub(med);
  corteB.mult(10);
  corteB.add(med);
  corteA.sub(med);
  corteA.mult(10);
  corteA.add(med);
}

void draw() {
  background(144);
  stroke(0);
  beginShape();
  for (PVector p : poli.puntos) {
    vertex(p.x, p.y);
  }
  endShape(CLOSE);
  if (corteA != null && corteB != null) {
    stroke(255, 0, 0);
    line(corteA.x, corteA.y, corteB.x, corteB.y);
  } else if (mousePressed) {
    stroke(255, 255, 0);
    line(corteA.x, corteA.y, mouseX, mouseY);
  }
}

