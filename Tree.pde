public class Tree {
  
  import toxi.geom.*;

  
  static private final color TREE_COLOR = #084813;
  static private final int TREE_DIAMETER = 50;
  
  private Vec2D position;
  
  
  /**
   * Make a tree at the given position.
   * 
   * @param pos  The position to place the tree.
   */
  Tree(Vec2D pos) {
    position = pos;
  }

  /**
   * Make a tree at a random position.
   * 
   * @param maxWidth  The width constraint of the random position.
   * @param maxHeight  The height constraint of the random position.
   */
  Tree(float maxWidth, float maxHeight) {
    position = new Vec2D(random(maxWidth), random(maxHeight));
  }

  /**
   * Make a tree at a random position, keeping off a path.
   * 
    * @param maxWidth  The width constraint of the random position.
    * @param maxHeight  The height constraint of the random position.
    * @param path  The path to keep off of.
    */
   Tree(float maxWidth, float maxHeight, Path path) {
     do {
       position = new Vec2D(random(maxWidth), random(maxHeight));
     } while (isOnPath(path));
   }
  
  
  /**
   * Draw the tree.
   */
  public void draw() {
    noStroke();
    fill(TREE_COLOR);
    ellipse(position.x, position.y, TREE_DIAMETER, TREE_DIAMETER);
  }
  
  
  /**
   * Determine whether we've place our tree on a path.
   *
   * @param path  The path we might be on.
   */
  private boolean isOnPath(Path path) {
    // Cycle through each path segment.
    List<Vec2D> points = path.getPointList();
    for (int i=0; i < points.size()-1; i++) {
      // Look at a line segment.
      Vec2D a = points.get(i);
      Vec2D b = points.get(i+1);
      
      // If we are within the radius of the path, we are on it.
      if (position.distanceTo(getNormalPoint(position, a, b)) <= path.getWidth()*0.5 + TREE_DIAMETER*0.5) {
        return true;
      }
    }
    
    // We haven't found any path segment we are too close to.
    return false;
  }
  
  /**
   * Get the normal point from a point to a line segment.
   * This function could be optimized to make fewer new Vector objects.
   *
   * @param pnt  The point from which to find the normal.
   * @param a  The point at one end of the line.
   * @param b  The point at the other end of the line.
   */
  private Vec2D getNormalPoint(Vec2D pnt, Vec2D a, Vec2D b) {
    // Vector from a to pnt.
    Vec2D ap = pnt.sub(a);
    // Vector from a to b
    Vec2D ab = b.sub(a);
    // Normalize the line.
    ab.normalize();
    // Project vector diff onto the line using the dot product.
    ab.scaleSelf(ap.dot(ab));
    return a.add(ab);
  }
}
