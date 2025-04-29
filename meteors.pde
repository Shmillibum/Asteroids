
class Meteor {
  float x, y, d; 
  float speedX, speedY; 
  boolean toRemove = false; 
  PImage meteorImage; 

  
  Meteor(float startingX, float startingY, float newSize) {
    x = startingX;
    y = startingY;
    d = newSize;

   
    float maxSpeed = map(d, 30, 150, 1, 3); 
    speedX = random(-maxSpeed, maxSpeed);  
    speedY = random(-maxSpeed, maxSpeed);  

    meteorImage = loadImage("Meteor.png"); 
  }

  void render() {
    imageMode(CENTER);
    image(meteorImage, x, y, d, d); 
  }

  void move() {
    x += speedX;  
    y += speedY;

    
    if (x < 0) x = width;
    if (x > width) x = 0;
    if (y < 0) y = height;
    if (y > height) y = 0;
  }

  boolean checkCollision(PlayerShoot bullet) {
    float distance = dist(x, y, bullet.x, bullet.y); 
    return distance < (d / 2) + (bullet.d / 2);  // Collision detection
  }

  ArrayList<Meteor> split() {
    ArrayList<Meteor> pieces = new ArrayList<Meteor>();
    if (d > 50) { // Only split if the meteor is large enough
      float newSize = d / 2;
      pieces.add(new Meteor(x + 5, y + 5, newSize));
      pieces.add(new Meteor(x - 5, y - 5, newSize));
    }
    return pieces;
  }

  void checkBounce(Meteor other) {
    float dx = other.x - x;
    float dy = other.y - y;
    float distance = dist(x, y, other.x, other.y);
    float minDist = (d / 2) + (other.d / 2);

    if (distance < minDist && distance != 0) {
      float overlap = minDist - distance;
      float angle = atan2(dy, dx);
      float moveX = cos(angle) * overlap / 2;
      float moveY = sin(angle) * overlap / 2;

      x -= moveX;
      y -= moveY;
      other.x += moveX;
      other.y += moveY;

      // Swap speeds to simulate a bounce
      float tempX = speedX;
      float tempY = speedY;
      speedX = other.speedX;
      speedY = other.speedY;
      other.speedX = tempX;
      other.speedY = tempY;
    }
  }
}
