import toxi.geom.*;
import toxi.processing.*;

class Diamond extends Mover {
  
  private static final int LENGTH = 5;
  private static final int WIDTH = 3;
  
  private static final float SEPARATION_FORCE_WEIGHT = 1.5;
  private static final float ALIGNING_FORCE_WEIGHT = 1.0;
  private static final float COHESION_FORCE_WEIGHT = 1.0;
  
  private static final float DESIRED_SEPARATION = 3.0;
  private static final float NEIGHBOR_DISTANCE = 5.0;
  
  private Polygon2D shape;
  private color fillColor;
  
	// Size of the world.
  private int worldWidth;
  private int worldHeight;
	// Screen offset
	private int xOffset;
	private int yOffset;
  
  // Properties shown while debugging
  private Vec2D separationForce;   // Force wanting to separate from all other diamonds
  private Vec2D aligningForce;   // Force wanting to align with the same direction of all nearby diamonds
  private Vec2D cohesionForce;   // Force wanting to stay between all nearby diamonds
  
  
  Diamond(Vec2D pos, int ww, int wh, int xo, int yo) {
    position = pos;
    worldWidth = ww;
    worldHeight = wh;
		xOffset = xo;
		yOffset = yo;
    fillColor = color(random(256), random(256), random(256), random(150, 256));
    velocity = new Vec2D(random(-maxSpeed, maxSpeed), random(-maxSpeed, maxSpeed));
    acceleration = new Vec2D(0, 0);
    maxSpeed = 0.3;
    maxForce = 0.05;
  }
  
  
  public void run(ArrayList<Diamond> diamonds) {
    flock(diamonds);
    update();
    wrapAroundBorders();
  }
  
  /**
   * Draw our diamond at its current position.
   *
   * @param gfx  A ToxiclibsSupport object to use for drawing.
   */
  public void draw(ToxiclibsSupport gfx) {
    // Draw a diamond rotated in the direction of velocity.
    float theta = velocity.heading() + PI*0.5;
    
    noStroke();
    fill(fillColor);
    
    pushMatrix();
    translate(position.x+xOffset, position.y+yOffset);
    rotate(theta);
    
    // Define the shape.
    shape = new Polygon2D();
    shape.add(new Vec2D(0, +0.5*LENGTH));  // Top
    shape.add(new Vec2D(+0.5*WIDTH, 0));  // Right
    shape.add(new Vec2D(0, -0.5*LENGTH));  // Bottom
    shape.add(new Vec2D(-0.5*WIDTH, 0));  // Left
    
    gfx.polygon2D(shape);
    popMatrix();
  }
  
  /**
   * Get the diamond's position.
   */
  public Vec2D getPosition() {
    return position;
  }
  
  /**
   * Get the diamond's velocity.
   */
  public Vec2D getVelocity() {
    return velocity;
  }
  
  
  /**
   * Figure out a new acceleration based on three rules.
   */
  private void flock(ArrayList<Diamond> diamonds) {
    separationForce = determineSeparationForce(diamonds);
    aligningForce = determineAligningForce(diamonds);
    cohesionForce = determineCohesionForce(diamonds);
    
    // Weight these forces.
    separationForce.scaleSelf(SEPARATION_FORCE_WEIGHT);
    aligningForce.scaleSelf(ALIGNING_FORCE_WEIGHT);
    cohesionForce.scaleSelf(COHESION_FORCE_WEIGHT);
    
    // Add the force vectors to our acceleration
    applyForce(separationForce);
    applyForce(aligningForce);
    applyForce(cohesionForce);
  }
  
  /**
   * Check for nearby diamonds and separate from them.
   */
  private Vec2D determineSeparationForce(ArrayList<Diamond> diamonds) {
    Vec2D sepForce = new Vec2D(0, 0);
    
    // For every diamond in the flock, check if it's too close.
    for (Diamond other : diamonds) {
      Vec2D otherPosition = other.getPosition();
      float distance = position.distanceTo(otherPosition);
      if (distance > 0 && distance < DESIRED_SEPARATION) {
        // Calculate vector pointing away from the other.
        Vec2D diff = position.sub(otherPosition);
        diff.normalize();
        diff.scaleSelf(1/distance);   // Weight by distance.
        sepForce.addSelf(diff);
      }
    }
    
    if (sepForce.magnitude() > 0) {
      sepForce.normalize();
      sepForce.scaleSelf(maxSpeed);
      sepForce.subSelf(velocity);
      sepForce.limit(maxForce);
    }

    return sepForce;
  }
  
  /**
   * Align velocity with the average of the nearby diamonds.
   */
  private Vec2D determineAligningForce(ArrayList<Diamond> diamonds) {
    Vec2D algnForce = new Vec2D(0, 0);
    
    for (Diamond other : diamonds) {
      if (isCloseTo(other)) {
        algnForce.addSelf(other.getVelocity());
      }
    }
    
    if (algnForce.magnitude() > 0) {
      algnForce.normalize();
      algnForce.scaleSelf(maxSpeed);
      algnForce.subSelf(velocity);
      algnForce.limit(maxForce);
    }
    
    return algnForce;
  }
  
  /**
   * Steer towards the average position of all nearby diamonds.
   */
  private Vec2D determineCohesionForce(ArrayList<Diamond> diamonds) {
    Vec2D cohForce = new Vec2D(0, 0);
    
    for (Diamond other : diamonds) {
      if (isCloseTo(other)) {
        cohForce.addSelf(other.getPosition());
      }
    }
    
    if (cohForce.magnitude() > 0) {
      cohForce.normalize();
      cohForce.scaleSelf(maxSpeed);
      cohForce.subSelf(velocity);
      cohForce.limit(maxForce);
    }
    
    return cohForce;
  }
  
  /**
   * Check whether the distance between us and another Diamond,
   * including wrap-around-borders, is closer than NEIGHBOR_DISTANCE.
   * 
   * @param other  The other Diamond to compare ourselves with.
   */
  private boolean isCloseTo(Diamond other) {
    Vec2D otherPosition = other.getPosition().copy();
    float distance = position.distanceTo(otherPosition);
    
    // If the distance is 0, it's most likely us and we should bail.
    if (distance == 0) {
      return false;
    }
    
    // Nearby without wrapping borders is the easy case.
    if (distance < NEIGHBOR_DISTANCE) {
      return true;
    }
    
    // Get a revised distance taking into account border wrapping.
    if (position.x > worldWidth-NEIGHBOR_DISTANCE && otherPosition.x < NEIGHBOR_DISTANCE) {
      // If we are close to the right edge and the other is close to the left,
      // move them as if they are over to the right.
      otherPosition.addSelf(new Vec2D(worldWidth, 0));
    } else if (position.x < NEIGHBOR_DISTANCE && otherPosition.x > worldWidth-NEIGHBOR_DISTANCE) {
      // If we are close to the left edge and the other is close to the right,
      // move them as if they are over to the left.
      otherPosition.subSelf(new Vec2D(worldWidth, 0));
    }
    if (position.y > worldHeight-NEIGHBOR_DISTANCE && otherPosition.y < NEIGHBOR_DISTANCE) {
      // If we are close to the bottom edge and the other is close to the top,
      // move them as if they are below us.
      otherPosition.addSelf(new Vec2D(0, worldHeight));
    } else if (position.y < NEIGHBOR_DISTANCE && otherPosition.y > worldHeight-NEIGHBOR_DISTANCE) {
      // If we are close to the top edge and the other is close to the bottom,
      // move them as if they are above us.
      otherPosition.subSelf(new Vec2D(0, worldHeight));
    }
    
    // Compare the distance again.
    distance = position.distanceTo(otherPosition);
    
    if (distance < NEIGHBOR_DISTANCE) {
      return true;
    } else {
      return false;
    }
  }
  
  /**
   * Make all borders wrap-around so we return to the other side of the canvas.
   */
  private void wrapAroundBorders() {
    if (position.x < -LENGTH) position.x = worldWidth + LENGTH;
    if (position.y < -LENGTH) position.y = worldHeight + LENGTH;
    if (position.x > (worldWidth+LENGTH)) position.x = -LENGTH;
    if (position.y > (worldHeight+LENGTH)) position.y = -LENGTH;
  }
}
