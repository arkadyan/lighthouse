import toxi.processing.*;


public class PathOverhead implements SubSketch {
	
	private static final int MIN_LENGTH = 15;
	private static final int MAX_LENGTH = 120;
	
	private static final color GRASS_COLOR = #017f16;
	private static final int NUM_TREES = 12;
	
	// Size of the world.
	private int worldWidth;
	private int worldHeight;
	
	private int timeOfLastPerson;
	
	private Path path;
	private Tree[] trees = new Tree[NUM_TREES];
	private ArrayList<Person> people;
	
	
	public PathOverhead(int ww, int wh) {
		worldWidth = ww;
		worldHeight = wh;
		
	  path = new Path();
  
	  placeTrees();
		
	  people = new ArrayList();
	  addPerson();
	}
	
	public void draw(ToxiclibsSupport gfx) {
  	background(GRASS_COLOR);
		
		// Draw the path
		path.draw(gfx);
		
	  // Draw all the trees
	  for (int i=0; i<trees.length; i++) {
	    trees[i].draw();
	  }
  	
	  // Update and draw each person.
	  ArrayList<Person> personReapList = new ArrayList();
	  for (Person person : people) {
	    person.follow(path);
	    person.avoid(people);
	    person.update();
	    if (person.getPosition().x+15 < 0 || person.getPosition().x-15 > worldWidth) {
	      // Mark for removal if off the canvas.
	      personReapList.add(person);
	    } else {
	      person.draw(gfx);
	    }
	  }
	  // Remove all people who have been marked.
	  for (Person person : personReapList) {
	    people.remove(person);
	  }
  	
	  // Potentially create a new person
	  if (random(millis()-timeOfLastPerson) > 10000) {
	    addPerson();
	  }
	}
	
	public int minLength() {
		return MIN_LENGTH;
	}
	
	public int maxLength() {
		return MAX_LENGTH;
	}
	

	/**
	 * Place trees randomly around the grounds.
	 */
	private void placeTrees() {
	  for (int i=0; i<trees.length; i++) {
	    trees[i] = new Tree(worldWidth, worldHeight, path);
	  }
	}

	/**
	 * Add a new person at one end or the other of the path.
	 */
	private void addPerson() {
	  if (random(1) < 0.5) {
	    // Start the person at the left end of the path.
	    people.add(new Person(new Vec2D(0, 38), random(0.2), +1));
	  } else {
	    // Start the person at the right end of the path.
	    people.add(new Person(new Vec2D(worldWidth, 9), random(0.2), -1));
	  }
	  timeOfLastPerson = millis();
	}
}
