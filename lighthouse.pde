import processing.video.*;
import toxi.processing.*;


ToxiclibsSupport gfx;

ArrayList<SubSketch> subSketches;


void setup() {
	size(68, 50);
  smooth();
  noCursor();
	
	gfx = new ToxiclibsSupport(this);
	
	initializeSubSketches();
}

void draw() {
	background(0);
	
	for (SubSketch sketch : subSketches) {
		sketch.draw(gfx);
	}
	
}


private void initializeSubSketches() {
	subSketches = new ArrayList<SubSketch>();
	subSketches.add(new FlockingDiamonds());
}
