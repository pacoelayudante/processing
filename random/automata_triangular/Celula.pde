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
    triangle(0, 0, tam, 0, tam/2, tam*hDeTri);
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

