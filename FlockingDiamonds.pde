import toxi.processing.*;


public class FlockingDiamonds implements SubSketch {
	
	private static final int FLOCK_SIZE = 200;
	
	private static final int MIN_LENGTH = 15;
	private static final int MAX_LENGTH = 120;
	
	
	// Size of the world.
	private int worldWidth;
	private int worldHeight;
	// Screen offset
	private int xOffset;
	private int yOffset;

	// A flock of Diamonds.
	Flock flock;
	
	
	public FlockingDiamonds(int ww, int wh, int xo, int yo) {
		worldWidth = ww;
		worldHeight = wh;
		xOffset = xo;
		yOffset = yo;
		
		flock = new Flock();
		
	  // Add an initial set of diamonds into the flock.
	  for (int i=0; i < FLOCK_SIZE; i++) {
	    flock.addDiamond( new Diamond(new Vec2D(random(0, worldWidth), random(0, worldHeight)), worldWidth, worldHeight, xOffset, yOffset) );
	  }
	}
	

	public void draw(ToxiclibsSupport gfx) {
	  flock.run();
	  flock.draw(gfx);
	}
	
	
	public int minLength() {
		return MIN_LENGTH;
	}
	
	public int maxLength() {
		return MAX_LENGTH;
	}
	
}
