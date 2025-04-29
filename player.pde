

public class Player {
  float playerX, playerY, playerSize;
  float playerAngle = 0;  
  color playerColor = color(255); 
  boolean isAlive = true; 
  float velocityX = 0;
  float velocityY = 0;
  float acceleration = 0.2;
  float friction = 0.99;

  float rotationSpeed = 5;
  int currentFrame = 0;  
  int frameDelay = 10; 
  int frameCounter = 0;  

  PImage[] PlayerMove;  
  PImage playerStill;   

  
  Player(float playerX, float playerY, float playerSize, color playerColor){
    this.playerX = playerX; 
    this.playerY = playerY;
    this.playerSize = playerSize; 
    this.playerColor = playerColor;
    
    
    PlayerMove = new PImage[2];  
    PlayerMove[0] = loadImage("PlayerMove1.png");
    PlayerMove[1] = loadImage("PlayerMove2.png");
    playerStill = loadImage("PlayerBase.png");
  }

  
  void render(){
    imageMode(CENTER); 
    noStroke();
    push();
    translate(playerX, playerY);
    rotate(radians(playerAngle));  

   
    if (keysHeld.contains('w')) {  
      frameCounter++;
      
      
      if (frameCounter >= frameDelay) {
        currentFrame = (currentFrame + 1) % PlayerMove.length;
        frameCounter = 0;  
      }

    
      image(PlayerMove[currentFrame], 0, 0, playerSize, playerSize);
    } else{
      
      image(playerStill, 0, 0, playerSize, playerSize);
    }

    pop();
  }

  // Update the player's position
  void update(){
    playerX += velocityX;
    playerY += velocityY;

    velocityX *= friction;
    velocityY *= friction;

    // Wrap around screen boundaries
    if (playerX < 0) playerX = width;
    if (playerX > width) playerX = 0;
    if (playerY < 0) playerY = height;
    if (playerY > height) playerY = 0;
  }

  // Accelerate player in the direction they are facing
  void accelerate(){
    float angleRad = radians(playerAngle - 90);
    velocityX += cos(angleRad) * acceleration;
    velocityY += sin(angleRad) * acceleration;
  }

  // Rotate player to the left (counter-clockwise)
  void rotateLeft(){
    playerAngle -= rotationSpeed;
    if (playerAngle < 0) playerAngle += 360;
  }

  // Rotate player to the right (clockwise)
  void rotateRight(){
    playerAngle += rotationSpeed;
    if (playerAngle >= 360) playerAngle -= 360;
  }
  void die(){
  isAlive = false; 
  
  }
}
