import processing.sound.*;
import java.util.HashSet;
int gameOverTime = 0; 
final int GAME_OVER_DELAY = 3000; 
final int START_SCREEN = 0;
final int GAME_PLAY = 1;
final int GAME_OVER = 2; 

int wave = 1;
int score = 0; 
int gameState = START_SCREEN;
boolean waitingForNextWave = false; 
boolean showWaveWarning = false; 
int nextWaveTime = 0; 
int waveWarningStartTime = 0; 
int waveWarningDuration = 2000; 
HashSet<Character> keysHeld = new HashSet<Character>();
SoundFile pewSound;
SoundFile backGround;

Player player;
ArrayList<PlayerShoot> bulletList;
ArrayList<Meteor> meteorList;
startScreen startButton;
boolean gameStarted = false;
PFont font; 
void setup() {
  size(800, 800);
  player = new Player(400, 400, 40, color(255));
  bulletList = new ArrayList<PlayerShoot>();
  meteorList = new ArrayList<Meteor>();

  pewSound = new SoundFile(this, "data/pewSound.mp3");
  backGround = new SoundFile(this, "data/Music.mp3");

  startButton = new startScreen(width / 2, height / 2, 200, color(255, 0, 0));

  font = createFont("Ariel", 16, true); 
  textFont(font); 
  spawnWave(wave); 
  backGround.loop();
}

void draw() {
  background(40); 

  switch (gameState) {
    case START_SCREEN:
      runStartScreen();
      break;
    case GAME_PLAY:
      runGamePlay();
      break;
    case GAME_OVER: 
      runGameOver(); 
    break; 
  }
}

void runStartScreen() {
  startButton.render();
}

void runGamePlay() {
  handleInput();

  player.update();
  player.render();

  // Update meteors
  for (int i = meteorList.size() - 1; i >= 0; i--) {
    Meteor m1 = meteorList.get(i);
    m1.move();
    m1.render();

    for (int j = i - 1; j >= 0; j--) {
      Meteor m2 = meteorList.get(j);
      m1.checkBounce(m2);
    }
  }

  // Update bullets and check collisions
  for (int i = bulletList.size() - 1; i >= 0; i--) {
    PlayerShoot aBullet = bulletList.get(i);
    aBullet.move();
    aBullet.render();

    if (aBullet.isDead()) {
      bulletList.remove(i);
      continue;
    }

    for (int j = meteorList.size() - 1; j >= 0; j--) {
      Meteor aMeteor = meteorList.get(j);
      if (aMeteor.checkCollision(aBullet)) {
        bulletList.remove(i);
        ArrayList<Meteor> newMeteors = aMeteor.split();
        meteorList.addAll(newMeteors);
        meteorList.remove(j);
        score += 10;
        break;
      }
    }
  }

  // Check collision with player
  if (!player.isAlive) {
    gameState = GAME_OVER;
    gameOverTime = millis();
    return;
  }

  for (Meteor m : meteorList) {
    float distance = dist(player.playerX, player.playerY, m.x, m.y);
    if (distance < (player.playerSize / 2) + (m.d / 2)) {
      player.die();
      break;
    }
  }

  // Check wave clear
  if (meteorList.isEmpty() && !waitingForNextWave) {
    waitingForNextWave = true;
    nextWaveTime = millis() + 5000;
    showWaveWarning = true;
    waveWarningStartTime = millis();
  }

  // Show warning
  if (showWaveWarning) {
    if (millis() - waveWarningStartTime < waveWarningDuration) {
      fill(255, 100, 100);
      textAlign(CENTER);
      textSize(32);
      text("Wave " + (wave + 1) + " Incoming!", width / 2, height / 2);
    } else {
      showWaveWarning = false;
    }
  }

  // Start next wave
  if (waitingForNextWave && millis() >= nextWaveTime) {
    wave++;
    spawnWave(wave);
    waitingForNextWave = false;
  }

  // Draw score
  fill(255);
  textAlign(RIGHT);
  textSize(50);
  text("Score: " + score, width - 10, 50);
}

void runGameOver() {
  textAlign(CENTER, CENTER);
  textSize(48);
  fill(255, 0, 0);
  text("GAME OVER", width / 2, height / 2);

  // Check if it's been 3 seconds since the game over screen appeared
  if (gameOverTime > 0 && millis() - gameOverTime >= GAME_OVER_DELAY) {
    gameState = START_SCREEN; // Reset to start screen after 3 seconds
    
    resetGame();  // Reset game elements (e.g., player, meteor list)
  }
}


void handleInput() {
  if (keysHeld.contains('w')) {
    player.accelerate();
  }
  if (keysHeld.contains('a')) {
    player.rotateLeft();
  }
  if (keysHeld.contains('d')) {
    player.rotateRight();
  }
}

void mousePressed() {
  if (gameState == START_SCREEN) {
    startButton.checkStartGame();
    if (startButton.gameStart) {
      gameState = GAME_PLAY;
    }
  }
}

void keyPressed() {
  keysHeld.add(Character.toLowerCase(key));

  if (key == ' ' && gameState == GAME_PLAY) {
    pewSound.play();
    bulletList.add(new PlayerShoot(player.playerX, player.playerY, player.playerAngle));
  }
}

void keyReleased() {
  keysHeld.remove(Character.toLowerCase(key));
}

void spawnWave(int waveNumber) {
  // Increase meteor count as waves progress
  int numMeteors = 5 + (waveNumber * 2); // Start with 5 meteors, and add 2 more per wave
  for (int i = 0; i < numMeteors; i++) {
    // Random size for the meteors, varying between 30 and 150
    float meteorSize = random(30, 150);
    float spawnX, spawnY;

    int corner = int(random(4)); // Spawning from random corners
    if (corner == 0) {
      spawnX = 0;
      spawnY = 0;
    } else if (corner == 1) {
      spawnX = width;
      spawnY = 0;
    } else if (corner == 2) {
      spawnX = width;
      spawnY = height;
    } else {
      spawnX = 0;
      spawnY = height;
    }
    // Add meteor with random size
    meteorList.add(new Meteor(spawnX, spawnY, meteorSize));
  }
}


void resetGame(){
player = new Player(400,400,40, color(255));
bulletList.clear(); 
meteorList.clear(); 
wave = 1; 
score = 0; 
spawnWave(wave);
startButton.resetAnimation(); 
}
