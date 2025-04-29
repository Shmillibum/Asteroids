public class startScreen {
  boolean gameStart = false;
  float buttonX, buttonY, buttonSize;
  color buttonColor = color(255);
  
  // Array to hold the frames of the title screen animation
  PImage[] titleFrames = new PImage[28]; // Assuming 28 frames
  int currentFrame = 0;
  int frameDelay = 5; 
  int frameCounter = 0; 

  // Button images for different states
  PImage startButton1; // Normal button image
  PImage startButton2; // Hovered button image
  
  // Constructor
  startScreen(float buttonX, float buttonY, float buttonSize, color buttonColor){
    this.buttonX = buttonX; 
    this.buttonY = buttonY + 50; // Move button down by 50 pixels
    this.buttonSize = buttonSize; 
    this.buttonColor = buttonColor;
    
    // Load the images
    for (int i = 0; i < 28; i++) {
      titleFrames[i] = loadImage("TitleScreen" + (i + 1) + ".png");
    }

    // Load the start button images
    startButton1 = loadImage("StartButton1.png"); // Normal button
    startButton2 = loadImage("StartButton2.png"); // Hovered button
  }
  
  // Reset animation to start from the first frame when the game restarts
  void resetAnimation() {
    currentFrame = 0;
    frameCounter = 0;
    gameStart = false; // Allow the animation to start again
  }
  
  // Method to render the title screen animation
  void render() {
    imageMode(CENTER);
    float scaleFactor = 5.0; 
    
    // Display the animation frames
    if (!gameStart) {
     
      if (frameCounter >= frameDelay) {
        // Increment frames normally until frame 28
        if (currentFrame < 27) {
          currentFrame++;
        } else {
          // After frame 28 loop through frames 25, 26, 27, and 28 
          currentFrame = 24 + (frameCounter / frameDelay) % 4; 
        }
        frameCounter = 0;  // Reset the frame counter after updating the frame
      }

      // Display the current frame with scaling
      float scaledWidth = titleFrames[currentFrame].width * scaleFactor;
      float scaledHeight = titleFrames[currentFrame].height * scaleFactor;
      image(titleFrames[currentFrame], 400, 200, scaledWidth, scaledHeight); // Display the current frame
      frameCounter++; // Increment the frame counter to keep track of time
    }
    
    // Check if the mouse is over the button
    if (isMouseOverButton(mouseX, mouseY)) {
      image(startButton2, buttonX, buttonY); // Display hovered image
    } else {
      image(startButton1, buttonX, buttonY); // Display normal image
    }
    
   
    
  }

  // Check if the mouse is over the button
  boolean isMouseOverButton(float mouseX, float mouseY) {
    float dist = dist(mouseX, mouseY, buttonX, buttonY);
    return dist <= buttonSize / 2;  
  }

  // Check if the button is clicked
  boolean isClicked(float mouseX, float mouseY){
    float dist = dist(mouseX, mouseY, buttonX, buttonY);
    return dist <= buttonSize / 2;  
  }

  // Start the game when the button is clicked
  void checkStartGame() {
    if (isClicked(mouseX, mouseY)) {
      gameStart = true;
      gameState++; // Move to the next game state
    }
  }
}
