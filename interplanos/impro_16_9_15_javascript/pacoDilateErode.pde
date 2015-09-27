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

