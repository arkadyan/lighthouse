import toxi.processing.*;

/**
 * Manages a collection of flocking Diamonds.
 */
class Flock3D {
  
  ArrayList<Diamond3D> diamonds;
  
  Flock3D() {
    diamonds = new ArrayList<Diamond3D>();
  }
  
  public void run() {
    for (Diamond3D d : diamonds) {
      d.run(diamonds);
    }
  }
  
  public void draw(ToxiclibsSupport gfx, boolean debug) {
    for (Diamond3D d : diamonds) {
      d.draw(gfx, debug);
    }
  }
  
  /**
   * Add a new Diamond to the flock.
   *
   * @param d  The Diamond to be added.
   */
  public void addDiamond(Diamond3D d) {
    diamonds.add(d);
  }
}
