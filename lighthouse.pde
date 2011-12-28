import toxi.processing.*;


ToxiclibsSupport gfx;

private static final int WORLD_WIDTH = 68;
private static final int WORLD_HEIGHT = 50;

private static final int X_OFFSET = 1100;
private static final int Y_OFFSET = 685;

private ArrayList<SubSketch> subSketches;
private int activeSketch;

private int timeOfLastSketchSwitch;


void setup() {
	// size(WORLD_WIDTH, WORLD_HEIGHT);
	size(screen.width, screen.height);
	smooth();
	noCursor();
	
	gfx = new ToxiclibsSupport(this);
	
	initializeSubSketches();
}

void draw() {
	background(0);
	
	// Apply the offsets to position the drawing.
	gfx.translate(new Vec2D(X_OFFSET, Y_OFFSET));
	
	// Potentially switch active sketches
	// if (random(millis()-timeOfLastSketchSwitch) > 10000) {
		// switchActiveSketch();
	// }

	// Draw the active sketch
	subSketches.get(activeSketch).draw(gfx);
}


private void initializeSubSketches() {
	subSketches = new ArrayList<SubSketch>();
	subSketches.add(new FlockingDiamonds(WORLD_WIDTH, WORLD_HEIGHT));
	// subSketches.add(new PathOverhead(WORLD_WIDTH, WORLD_HEIGHT));
	// subSketches.add(new FerryMoviePlayer(this, WORLD_WIDTH, WORLD_HEIGHT));
	
	activeSketch = 0;
	timeOfLastSketchSwitch = millis();
}

private void switchActiveSketch() {
	activeSketch = floor(random(subSketches.size()));
	timeOfLastSketchSwitch = millis();
}
