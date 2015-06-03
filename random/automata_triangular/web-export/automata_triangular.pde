Automata automata;

boolean dibujarDirecciones;
boolean pausa;

PVector botDibujarDirecciones = new PVector(80,270,20);
PVector botReset = new PVector(100,340,20);
PVector botFoto = new PVector(120,410,20);
void mousePressed(){
  if (dist(mouseX,mouseY,botDibujarDirecciones.x,botDibujarDirecciones.y) < botDibujarDirecciones.z) {
    dibujarDirecciones = !dibujarDirecciones;
  }
  else if (dist(mouseX,mouseY,botReset.x,botReset.y) < botReset.z) {
    automata = new Automata(0, 0, 45, 24);
  } 
  else if (dist(mouseX,mouseY,botFoto.x,botFoto.y) < botFoto.z) {
    background(255);
    automata.dibujar(new PVector(mouseX,mouseY),mousePressed,dibujarDirecciones);
    save();
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
  
  noFill();
  stroke(0);
  rectMode(CENTER);
  ellipse(botReset.x,botReset.y,botReset.z*2,botReset.z*2);
  rectMode(CORNER);
  noStroke();
  fill(0);
  text("Reiniciar",botReset.x,botReset.y+botReset.z+23);
  
  noFill();
  stroke(0);
  rectMode(CENTER);
  ellipse(botFoto.x,botFoto.y,botFoto.z*2,botFoto.z*2);
  rectMode(CORNER);
  noStroke();
  fill(0);
  text("Exportar Imagen",botFoto.x,botFoto.y+botFoto.z+23);
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

class Automata {
  Celula[] celulas;

  Automata(float origenX, float origenY, int niveles, float tam) {
    ArrayList total = new ArrayList();
    Celula[][] grilla = new Celula[niveles][niveles];
    for (int y=0; y<niveles; y++) {
      boolean orientacion = false;
      float offsetX = y%2==0?tam/2:0;
      for (int x=y; x<niveles-y; x++) {
        grilla[x][y] = new Celula(origenX+x*tam/2, origenY+y*tam*hDeTri, tam, orientacion);
        total.add(grilla[x][y]);
        orientacion = !orientacion;
      }
    }

    /*//De 3
     for (int y=0; y<niveles; y++) {
     for (int x=0; x<niveles; x++) {
     if (grilla[x][y]!=null) {
     if (x>0) grilla[x][y].vincular(grilla[x-1][y]);
     if (x<niveles-1) grilla[x][y].vincular(grilla[x+1][y]);
     if (grilla[x][y].orientacion) {
     if (y<niveles-1) grilla[x][y].vincular(grilla[x][y+1]);
     }
     else {
     if (y>0) grilla[x][y].vincular(grilla[x][y-1]);
     }
     }
     }*/
    //De 12
    for (int y=0; y<niveles; y++) {
      for (int x=0; x<niveles; x++) {
        if (grilla[x][y]!=null) {
          if (x>0) grilla[x][y].vincular(grilla[x-1][y]);
          if (x<niveles-1) grilla[x][y].vincular(grilla[x+1][y]);
          if (x>1) grilla[x][y].vincular(grilla[x-2][y]);
          if (x<niveles-2) grilla[x][y].vincular(grilla[x+2][y]);
          if (y<niveles-1) {
            grilla[x][y].vincular(grilla[x][y+1]);
            if (x > 0) {
              grilla[x][y].vincular(grilla[x-1][y+1]);
              if (x > 1 && grilla[x][y].orientacion) grilla[x][y].vincular(grilla[x-2][y+1]);
            }
            if (x < niveles-1) {
              grilla[x][y].vincular(grilla[x+1][y+1]);
              if (x < niveles-2 && grilla[x][y].orientacion) grilla[x][y].vincular(grilla[x+2][y+1]);
            }
          }
          if (y>0) {
            grilla[x][y].vincular(grilla[x][y-1]);
            if (x > 0) {
              grilla[x][y].vincular(grilla[x-1][y+1]);
              if (x > 1 && grilla[x][y].orientacion) grilla[x][y].vincular(grilla[x-2][y+1]);
            }
            if (x < niveles-1) {
              grilla[x][y].vincular(grilla[x+1][y+1]);
              if (x < niveles-2 && grilla[x][y].orientacion) grilla[x][y].vincular(grilla[x+2][y+1]);
            }
          }
        }
      }
    }

    celulas = (Celula[])total.toArray(new Celula[0]);
  }

  void ciclar() {
    for (int i=0; i<celulas.length; i++) {
      celulas[i].calcularProximoEstado();
    }
    for (int i=0; i<celulas.length; i++) {
      celulas[i].actualizarEstado();
    }
  }

  void dibujar(PVector posMouse, boolean estadoMouse, boolean dibujarDireccion) {
    for (int i=0; i<celulas.length; i++) {
      noStroke();
      celulas[i].dibujar(dibujarDireccion);
    }
    noFill();
    stroke(255);
    for (int i=0; i<celulas.length; i++) {
      if (celulas[i].encima(posMouse)) {
        for (int j=0; j<celulas[i].vecinas.length; j++) {
          celulas[i].vecinas[j].dibujarSoloTriangulo();
          if (estadoMouse) celulas[i].vecinas[j].estado = radians(frameCount);
        }
        celulas[i].dibujarSoloTriangulo();
        if (estadoMouse) celulas[i].estado = celulas[i].estado = radians(frameCount);
        break;
      }
    }
  }
}

float hDeTri = sqrt(3)/2;//cos(radians(30));//sqrt(sq(1)-sq(.5));
class Celula {
  Celula[] vecinas;
  float x, y;
  float tam;
  float estado, estadoFuturo;
  boolean orientacion;

  Celula(float x, float y, float tam, boolean orientacion) {
    this.x = x;
    this.y = y;
    this.tam = tam;
    this.orientacion = orientacion;   
    vecinas = new Celula[0];
    iniciarEstadoDeCelula(this);
  }

  void dibujar(boolean dibujarDireccion) {
    pushMatrix();
    translate(x, y);
    pushMatrix();
    if (orientacion) {
      translate(0, tam*hDeTri);
      scale(1, -1);
    }
    fill(map(estado, -PI, PI, 0, 255), 255, 255);
    triangle(-.5, -.5, tam+.5, -.5, tam/2, tam*hDeTri+.5);
    popMatrix();
    if (dibujarDireccion) {
      pushStyle();
      translate(tam/2, tam/2);
      rotate(estado);
      stroke(0);
      fill(0);
      ellipse(0, 0, 3, 3);
      line(0, 0, tam/3, 0);
      popStyle();
    }
    popMatrix();
  }
  void dibujarSoloTriangulo() {
    pushMatrix();
    translate(x, y);
    if (orientacion) {
      translate(0, tam*hDeTri);
      scale(1, -1);
    }
    triangle(0, 0, tam, 0, tam/2, tam*hDeTri);
    popMatrix();
  }

  void calcularProximoEstado() {
    calcularDeEstadoDeCelula(this);
  }

  void actualizarEstado() {
    estado = estadoFuturo;
  }

  void vincular(Celula otra) {
    if (otra != null) {
      boolean noEsta = true;
      for (int i=0; i<vecinas.length; i++) {
        noEsta = noEsta && vecinas[i] != otra;
      }
      if (noEsta) vecinas = (Celula[]) append(vecinas, otra);
      noEsta = true;
      for (int i=0; i<otra.vecinas.length; i++) {
        noEsta = noEsta && otra.vecinas[i] != this;
      }
      if (noEsta) otra.vecinas = (Celula[]) append(otra.vecinas, this);
    }
  }

  boolean encima(PVector punto) {
    return (punto.x-x)*(punto.x-x)+(punto.y-y)*(punto.y-y) < (tam/2)*(tam/2);//dist(punto.x, punto.y, x, y)<tam/3;
  }
}


