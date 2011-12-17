import processing.video.*;
import toxi.processing.*;


ToxiclibsSupport gfx;


void setup() {
	size(68, 50);
  smooth();
  noCursor();
	
	gfx = new ToxiclibsSupport(this);
}

void draw() {
	background(0);
}
