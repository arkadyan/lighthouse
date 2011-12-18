import toxi.processing.*;

/**
 * Manages a collection of flocking Diamonds.
 */
class Flock {
  
  ArrayList<Diamond> diamonds;
  
  Flock() {
    diamonds = new ArrayList<Diamond>();
  }
  
  public void run() {
    for (Diamond d : diamonds) {
      d.run(diamonds);
    }
  }
  
  public void draw(ToxiclibsSupport gfx) {
    for (Diamond d : diamonds) {
      d.draw(gfx);
    }
  }
  
  /**
   * Add a new Diamond to the flock.
   *
   * @param d  The Diamond to be added.
   */
  public void addDiamond(Diamond d) {
    diamonds.add(d);
  }
}
