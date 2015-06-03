/**
 *    I have been working on a background generator for some of the pages. Try it out! <br />
*<link rel="stylesheet" type="text/css" href="http://itch.io/static/game.css?1432461564">
*<link rel="stylesheet" type="text/css" href="http://itch.io/static/icons/style.css?1432461564">
 *    <script type="text/javascript">
 *  window.onload = function () {
 *    tryFindSketch();
 *  }
 *  function tryFindSketch () {
 *    var sketch = Processing.getInstanceById(getProcessingSketchId());
 *    if ( sketch == undefined ) 
 *      return setTimeout(tryFindSketch, 200);
 *    botones = document.getElementsByTagName("button");
 *    for (var i=0; i<botones.length; i++) {
 *      botones[i].disabled = false;
 *    }
 *    inputs = document.getElementsByTagName("input");
 *    for (var i=0; i<inputs.length; i++) {
 *      inputs[i].disabled = false;
 *    }
 *  }
 *  </script>
 *    <style>
 *        body {
   color:white;
 *          background-color:black;
 *        }
       .button {
         line-height:22px;
         height : 25px;
         margin : 1px;
       }
 *    </style>
 *    <form>
 *    <button class="button" disabled type="button" onclick="Processing.getInstanceById(getProcessingSketchId()).usarFondo()">
 *    Use generated image for page background</button></br>
 *    <button class="button" disabled type="button" onclick="Processing.getInstanceById(getProcessingSketchId()).resetearImagen()">
 *    Reset generated image</button></br>
 *    <button class="button" disabled type="button" onclick="Processing.getInstanceById(getProcessingSketchId()).multiciclo(10)">
 *    Run 10 cicles</button>
 *    <button class="button" disabled type="button" onclick="Processing.getInstanceById(getProcessingSketchId()).multiciclo(50)">
 *    Run 50 cicles</button></br></br>
 <button class="button" disabled type="button" onclick="Processing.getInstanceById(getProcessingSketchId()).abrirImagen()">
 Open tile on new tab :D</button></br>
 </br>
 *    Direction variance chance : <input disabled onchange="Processing.getInstanceById(getProcessingSketchId()).actualizarChanceMove(this.value)" id="chance-move" type="range" min="0" max="1000" value="200" /></br>
 *    Size of small draw : <input disabled onchange="Processing.getInstanceById(getProcessingSketchId()).actualizarPeque(this.value)" id="chance-move" type="range" min="0" max="12" value="3" /></br>
 *    Size of big draw : <input disabled onchange="Processing.getInstanceById(getProcessingSketchId()).actualizarGrande(this.value)" id="chance-move" type="range" min="0" max="12" value="6" /></br>
 *    </form>
 */
PGraphics gr;
PImage fade;

PVector pos = new PVector();
PVector dir;
PVector[] dirs = new PVector[]
{
  new PVector(1, 0), new PVector(1, 1), new PVector(0, 1), 
  new PVector(-1, 1), new PVector(-1, 0), 
  new PVector(-1, 1), new PVector(0, 1), new PVector(1, 1), 
  /*new PVector(-1,-1),
   new PVector(0,-1),new PVector(1,-1)*/
};

boolean gordo;
float chanceMove = .2;
float chanceGordo = .05;
float chanceGordoCadena = .7;

int tamPeque = 3;
int tamGrande = 6;

void actualizarChanceMove(int val) {
  chanceMove = val/1000.;
}
void actualizarPeque(int val) {
  tamPeque = val;
}
void actualizarGrande(int val) {
  tamGrande = val;
}

void setup() {
  size(320, 320);
  int minGradiente = 20;//200;
  int factorGradiente = 70;//30;
  fade = createImage(5, 1, ALPHA);
  fade.loadPixels();
  for (int i=0; i<fade.pixels.length/2+1; i++) {
    fade.pixels[i] = color(0, min(minGradiente+i*factorGradiente, 255));
    fade.pixels[fade.pixels.length-i-1] = color(0, min(minGradiente+i*factorGradiente, 255));
  } 
  fade.updatePixels();
  gr = createGraphics(32, 64);
  gr.beginDraw();
  gr.background(0);
  gr.endDraw();
  dir = dirs[floor(random(dirs.length))];
}

void mousePressed() {
  document.body.style.background = "url("+fade.toDataURL()+")";
  document.body.style.backgroundSize = "100% 100%";
}

void usarFondo() {
  document.body.style.background = "url("+fade.toDataURL()+"),url("+get(0, 0, gr.width*2, gr.height).toDataURL()+")";
  document.body.style.backgroundSize = "100% 100%,auto auto";
}

void abrirImagen() {
  get(0, 0, gr.width*2, gr.height).save();
}

void resetearImagen() {
  gr = createGraphics(32, 64);
  gr.beginDraw();
  gr.background(0);
  gr.endDraw();
}

void multiciclo(int cant) {
  for (int i=0; i<cant; i++) {
    ciclo();
  }
}

void ciclo() {
  pos.add(dir);
  gordo = random(1) < ( gordo?chanceGordoCadena:chanceGordo );
  if (random(1) < chanceMove) {
    int i;
    for (i=0; i<dirs.length; i++) {
      if (dir == dirs[i]) break;
    }
    i += random(1) < .5 ? 1 : -1;
    i%=dirs.length;
    if (i < 0) i += dirs.length;
    dir = dirs[i];
  }
  if (pos.x < 0) pos.x += gr.width;
  if (pos.y < 0) pos.y += gr.height;
  gr.beginDraw();
  //mouseX /= 6;
  //mouseY /= 6;
  gr.fill(255, 70);
  gr.stroke(0, 150);
  //gr.noStroke();
  //gr.stroke(255,100);
  int tam = !gordo ? tamPeque : tamGrande;
  gr.ellipse(floor(pos.x)%gr.width, floor(pos.y)%gr.height, tam, tam);

  gr.ellipse(floor(pos.x)%gr.width+gr.width, floor(pos.y)%gr.height, tam, tam);
  gr.ellipse(floor(pos.x)%gr.width-gr.width, floor(pos.y)%gr.height, tam, tam);
  gr.ellipse(floor(pos.x)%gr.width, floor(pos.y)%gr.height+gr.height, tam, tam);
  gr.ellipse(floor(pos.x)%gr.width, floor(pos.y)%gr.height-gr.height, tam, tam);
  //gr.point(floor(pos.x)%gr.width,floor(pos.y)%gr.height);
  gr.endDraw();
}

void draw() {
  ciclo();
  //translate(width,0);rotate(HALF_PI);
  for (int y=0; y<=height+gr.height; y+= gr.height) {
    for (int x=0; x<=width+gr.width; x+= gr.width) {
      pushMatrix();
      translate(x, y);
      //tint(min(y/2,255));
      if ((x/gr.width)%2==1) {
        translate(gr.width, 0);
        scale(-1, 1);
      }
      image(gr, 0, 0);
      popMatrix();
    }
  }
  //noTint();
}

