import processing.video.*;
import toxi.processing.*;


ToxiclibsSupport gfx;

private ArrayList<SubSketch> subSketches;
private int activeSketch;

private int timeOfLastSketchSwitch;


void setup() {
	size(68, 50);
	smooth();
	noCursor();
	
	gfx = new ToxiclibsSupport(this);
	
	initializeSubSketches();
}

void draw() {
	background(0);
	
	// Potentially switch active sketches
	if (random(millis()-timeOfLastSketchSwitch) > 10000) {
		switchActiveSketch();
	}

	// Draw the active sketch
	subSketches.get(activeSketch).draw(gfx);
}


private void initializeSubSketches() {
	subSketches = new ArrayList<SubSketch>();
	subSketches.add(new FlockingDiamonds());
	subSketches.add(new PathOverhead());
	
	activeSketch = 0;
	timeOfLastSketchSwitch = millis();
}

private void switchActiveSketch() {
	activeSketch = floor(random(subSketches.size()));
	timeOfLastSketchSwitch = millis();
}
