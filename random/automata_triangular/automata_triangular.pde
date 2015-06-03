Automata automata;

boolean dibujarDirecciones;
boolean pausa;

PVector botDibujarDirecciones = new PVector(80,270,20);
void mousePressed(){
  if (dist(mouseX,mouseY,botDibujarDirecciones.x,botDibujarDirecciones.y) < botDibujarDirecciones.z) {
    dibujarDirecciones = !dibujarDirecciones;
  }
}

void setup() {
  size(552, 479);
  textAlign(CENTER);
  noSmooth();//smooth();
  colorMode(HSB);
  automata = new Automata(0, 0, 45, 24);
  background(255);
}

void draw() {
  background(255);
  if (!pausa){
    automata.ciclar();
  }
  automata.dibujar(new PVector(mouseX,mouseY),mousePressed,dibujarDirecciones);
  
  noFill();
  stroke(0);
  ellipse(botDibujarDirecciones.x,botDibujarDirecciones.y,botDibujarDirecciones.z*2,botDibujarDirecciones.z*2);
  noStroke();
  fill(0);
  text("Dibujar direcciones",botDibujarDirecciones.x,botDibujarDirecciones.y+botDibujarDirecciones.z+23);
  if (dibujarDirecciones) {
     ellipse(botDibujarDirecciones.x,botDibujarDirecciones.y,botDibujarDirecciones.z*2-5,botDibujarDirecciones.z*2-5);
  }
  
}

void iniciarEstadoDeCelula(Celula c) {
  c.estado = random(TWO_PI);
  c.estadoFuturo = c.estado;
}

void calcularDeEstadoDeCelula(Celula c) {
  float fuerzaDeGiro = 0;
  for (int i=0; i<c.vecinas.length; i++) {
    fuerzaDeGiro += menorDistAngulos(c.estado, c.vecinas[i].estado);
  }
  fuerzaDeGiro /= c.vecinas.length;
  c.estadoFuturo = anguloRangoPI(c.estadoFuturo+fuerzaDeGiro);
}

float menorDistAngulos( float origen, float destino ) {
  float distancia = destino - origen;
  return anguloRangoPI( distancia );
}

float anguloRangoPI( float angulo ) {
  float este = angulo;
  for ( int i=0; i<100; i++ ) {
    if ( este > PI ) {
      este -= TWO_PI;
    } else if ( este <= -PI ) {
      este += TWO_PI;
    }
    if ( este >= -PI && este <= PI ) {
      break;
    }
  }
  return este;
}

