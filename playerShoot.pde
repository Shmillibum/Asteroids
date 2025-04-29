public class PlayerShoot {
  float x, y;
  int d = 20; 
  float speed = 15; 
  float angle;  
  int weaponType; 
  int lifeSpan = 60; 
  int lifeTimer = 0; 
  int currentFrame = 0; 
  int frameDelay = 10; 
  int frameCounter = 0; 
  
  PImage[] bulletImage; 
  
  PlayerShoot(float startingX, float startingY, float playerAngle) {
    x = startingX;
    y = startingY;
    angle = playerAngle;
    bulletImage = new PImage[4]; // 4 frames for animation
    bulletImage[0] = loadImage("BulletFrame1.png"); 
    bulletImage[1] = loadImage("BulletFrame2.png"); 
    bulletImage[2] = loadImage("BulletFrame3.png"); 
    bulletImage[3] = loadImage("BulletFrame1.png"); 
  }

  void render() {
    imageMode(CENTER);
    // Draw the bullet with the current animation frame
    image(bulletImage[currentFrame], x, y, d, d);
  }

  void move() {
    frameCounter++; 
    if (frameCounter >= frameDelay) {
      // Cycle through the frames
      currentFrame = (currentFrame + 1) % bulletImage.length;
      frameCounter = 0; // Reset frame counter after each frame delay
    }
    // Move the bullet based on the angle and speed
    x += cos(radians(angle - 90)) * speed; 
    y += sin(radians(angle - 90)) * speed; 
    lifeTimer++;
  }

  boolean isDead(){
    return lifeTimer > lifeSpan; 
  }
}
