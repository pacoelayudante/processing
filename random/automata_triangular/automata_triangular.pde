Automata automata;
 
void setup() {
  size(552,479);
  textAlign(CENTER);
  //smooth();
  colorMode(HSB);
  automata = new Automata(0, 0, 45, 24);
  background(255);
}
 
void draw() {
  automata.ciclar();
  automata.dibujar();
}
 
void iniciarEstadoDeCelula(Celula c) {
  c.estado = random(TWO_PI);
  c.estadoFuturo = c.estado;
}
 
void calcularDeEstadoDeCelula(Celula c) {
  float fuerzaDeGiro = 0;
  for (int i=0; i<c.vecinas.length; i++) {
    fuerzaDeGiro += menorDistAngulos(c.estado,c.vecinas[i].estado);
  }
  fuerzaDeGiro /= c.vecinas.length;
  c.estadoFuturo = anguloRangoPI(c.estadoFuturo+fuerzaDeGiro);
}
 
float menorDistAngulos( float origen , float destino ){
  float distancia = destino - origen;
  return anguloRangoPI( distancia );
}
 
float anguloRangoPI( float angulo ){
  float este = angulo;
  for( int i=0 ; i<100 ; i++ ){
    if( este > PI ){
      este -= TWO_PI;
    }
    else if( este <= -PI ){
      este += TWO_PI;
    }
    if( este >= -PI && este <= PI ){
      break;
    }
  }
  return este;
}

