import codeanticode.gsvideo.*;


public class FerryMoviePlayer implements SubSketch {
	
	private static final int MIN_LENGTH = 15;
	private static final int MAX_LENGTH = 120;
	
	GSMovie movie;
	
	
	public FerryMoviePlayer(PApplet parent) {
		// Load and play the video in a loop
		movie = new GSMovie(parent, "ferry_ride_tiny_sna.mov");
		movie.loop();
	}
	
	
	public void draw(ToxiclibsSupport gfx) {
	  image(movie, 0, 0);
	}
	
	public int minLength() {
		return MIN_LENGTH;
	}
	
	public int maxLength() {
		return MAX_LENGTH;
	}
	
	
	public void movieEvent(GSMovie movie) {
		movie.read();
	}
	
}
