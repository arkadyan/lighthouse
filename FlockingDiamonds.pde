public class FlockingDiamonds implements SubSketch {
	
	private static final int FLOCK_SIZE = 200;
	
	private static final int MIN_LENGTH = 15;
	private static final int MAX_LENGTH = 120;
	

	// A flock of Diamonds.
	Flock flock;
	
	
	public FlockingDiamonds() {
		flock = new Flock();
		
	  // Add an initial set of diamonds into the flock.
	  for (int i=0; i < FLOCK_SIZE; i++) {
	    flock.addDiamond( new Diamond(new Vec2D(random(0, width), random(0, height)), width, height) );
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
