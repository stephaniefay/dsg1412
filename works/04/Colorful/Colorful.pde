import processing.sound.*;

Control control;
Keyboard keyboard;
Score score;
Music music;
Special special;

int numOfBalls = 3;
boolean validGame = true;
boolean timerFlag = true;

ArrayList<Ball> balls = new ArrayList<Ball>();

void setup() {
  size(600, 400);
  
  control = new Control();
  keyboard = new Keyboard();
  score = new Score();
  music = new Music();
  special = new Special();

  balls.add(new Ball(100, 100, 20, true, 0));
  balls.add(new Ball(700, 400, (int)(10 + (Math.random()*40)), false, 1));
  balls.add(new Ball(300, 600, (int)(10 + (Math.random()*40)), false, 2)); 
  balls.add(new Ball(200, 200, (int)(10 + (Math.random()*40)), false, 3));
  
  music.sample = new SoundFile(this, "BeatDoctor_ShotInTheDark.mp3");
  music.sample.loop();

  music.rms = new Amplitude(this);
  music.rms.input(music.sample);
}

void draw() {
  if (validGame) {

    background(51);
    music.drawBackground();
    special.showSpecial();

    for (Ball b : balls) {
      b.update();
      b.display();
      b.checkBoundaryCollision();
      score.updateScore(numOfBalls);

      for (int i = 0; i < numOfBalls; i++) {
        b.checkCollision(balls.get(i), score);
      }
    }

    boolean test = balls.get(0).colorBall.checkColors(balls, score);
    if (test)
      validGame = !validGame;
  } else {
    background(0);
    textSize(32);
    music.sample.stop();
    text("You Won", mouseX, mouseY);
  }

  int t = score.timer();
  special.isSpecialReady();

  if ((t%10 == 0) && (t>=10) && timerFlag) {
    balls.add(new Ball((int)(0 + (Math.random()*800)), (int)(0 + (Math.random()*600)), (int)(10 + (Math.random()*40)), false, (balls.size())));
    numOfBalls++;
    timerFlag = !timerFlag;
  } else if (!timerFlag) {
    if (t%10 != 0)
      timerFlag = !timerFlag;
  }

  score.calculatePoints(numOfBalls);
  
}

// Use class Control instead
void keyPressed() {  
  if (keyboard.isKeyDown(key) == false) {
    balls.get(0).velocity = control.keyDown(balls.get(0).velocity);
    keyboard.setKeyDown(key, true);
  }
}

// Use class Control instead
void keyReleased() {
  balls.get(0).velocity = control.keyUp(balls.get(0).velocity);
  keyboard.setKeyDown(key, false);
}