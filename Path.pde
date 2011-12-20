public class Path {
  
  import toxi.geom.*;
  import toxi.processing.*;
  
  
  static private final color PATH_COLOR = #dc982c;
  static private final int PATH_WIDTH = 10;

  Spline2D path;
  
  
  /**
   * Constructor
   */
  Path() {
    path = new Spline2D();
    path.add(new Vec2D(0, 40));
    path.add(new Vec2D(15, 35));
    path.add(new Vec2D(50, 15));
    path.add(new Vec2D(72, 8));
  }
  
  /**
   * Draw the path.
   */
  public void draw(ToxiclibsSupport gfx) {
    // Draw the path with the full width.
    stroke(PATH_COLOR);
    strokeWeight(PATH_WIDTH);
    noFill();
    gfx.lineStrip2D(path.pointList);
  }
  
  /**
   * Get the list of points that make up this Path.
   */
  public List<Vec2D> getPointList() {
    return path.getPointList();
  }
  
  /**
   * Get the width of the path.
   */
  public int getWidth() {
    return PATH_WIDTH;
  }
  
}
