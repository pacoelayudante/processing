class Poligono {
  ArrayList<PVector> puntos;
  
  Poligono(PVector[] pts) {
    puntos = new ArrayList();
    for (PVector p : pts) {
      puntos.add(p);
    }
  }
}
