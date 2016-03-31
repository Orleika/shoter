import java.awt.event.KeyEvent;

static final int NBALL = 10;
static final int NSHOT = 50;
static final int SPT = 5;
Ball ball[] = new Ball[NBALL];
Ball shot[] = new Ball[NSHOT];
float meX, meY, smeX, meLen1, mLen2;
int score;
int hScore = 0;
int nShot;
PFont font;
long time, spt;
int t, spcount, shotcount;
boolean spflag, pressShift, pshot;

void setup() {
  size(640, 480);
  colorMode(HSB, 359, 99, 99);
  frameRate(60);
  smooth();
  noStroke();
  initGame();
}
void initGame() {
  background(0);
  font = loadFont("Jokerman-Regular-48.vlw");
  textFont(font, 18);
  score = 0;
  nShot = 0;
  spcount = 1;
  smeX = 0;
  spflag = true;
  pressShift = false;
  shotcount = 0;
  initBall();
  initShot();
  initMe();
  time = System.currentTimeMillis();
}

void initBall() {
  for (int i = 0; i < NBALL; i++) {
    ball[i] = new Ball(30 + random(width * 0.8), 30 + random(height * 0.8), 5-random(10), 5-random(10), 20, color(60+random(299), 50, 99));
  }
}

void initShot() {
  for (int i = 0; i < NSHOT; i++)
    shot[i] = new Ball(-50, -50, 0, 0, 10, color(0, 99, 99));
}

void initMe() {
  meX = width/2;
  meY = height - 50;
}

void drawMe() {
  if (pressShift)
    meX += smeX/2;
  else
    meX += smeX;
  if (meX-10 < 0)
    meX = 10; else if (width < meX+10)
    meX = width-10;
  fill(170, 99, 99);
  quad(meX, meY-30, meX-10, meY, meX+10, meY, meX, meY-30);
  if (pressShift)
    fill(60, 99, 99);
  ellipse(meX, meY-10, 4, 4);
}

void shoot() {
  shotcount++;
  if (pshot && (shotcount % 20 == 0 || shotcount == 0)) {
    nShot++;
    if (NSHOT < nShot)
      nShot = 1;
    shot[nShot-1].x = meX;
    shot[nShot-1].y = meY-30;
    shot[nShot-1].vy = -30;
  }
}

void spShot() {
  spflag = false;
  spt = System.currentTimeMillis();
}

void spEnd() {
  double elt = System.currentTimeMillis() - spt;
  if (SPT <= (int)(elt/1000)) {
    fill(359, 99, 90);
    text("0.00", width/2-30, height/2);
    spcount--;
    spflag = true;
    t -= SPT;
  }
  fill(359, 99, 90);
  int melt = (int)(1000-elt);
  while (melt < 0)
    melt+=1000;
  text(((SPT-(int)(elt/1000)) +"."+(melt/10)), width/2-30, height/2);
}

void damage() {
  fill(359, 99, 70);
  quad(meX, meY-30, meX-10, meY, meX+10, meY, meX, meY-30);
  delay(500);
}

void runScore() {
  for (int k = 0; k < NSHOT; k++) {
    if (0 < shot[k].x-shot[k].r/2 && shot[k].x+shot[k].r/2 < width && 0 < shot[k].y-shot[k].r/2 && shot[k].y+shot[k].r/2 < height && shot[k].vy == 0)
      shot[k].vy = -30;
  }
  if (spflag) {
    for (int i = 0; i < NBALL; i++) {
      if (pow(ball[i].x - meX, 2) + pow(ball[i].y - (meY-10), 2) <= pow(ball[i].r/2+2, 2)) {
        damage();
        ball[i].x = -100;
        ball[i].y = -100;
        ball[i].vx = 0;
        ball[i].vy = 0;
        score -= 10;
      }
      for (int k = 0; k < NSHOT; k++) {
        if (pow(ball[i].x - shot[k].x, 2) + pow(ball[i].y - shot[k].y, 2) <= pow(ball[i].r/2 + shot[k].r/2, 2)) {
          ball[i].x = -100;
          ball[i].y = -100;
          ball[i].vx = 0;
          ball[i].vy = 0;
          shot[k].x = -20;
          shot[k].y = -20;
          shot[k].vy = 0;
          score += 10;
        }
      }
    }
  } else {
    for (int i = 0; i < NBALL; i++) {
      for (int k = 0; k < NSHOT; k++) {
        if (pow(ball[i].x - shot[k].x, 2) + pow(ball[i].y - shot[k].y, 2) <= pow(ball[i].r/2 + shot[k].r/2, 2)) {
          shot[k].vy = 0;
        }
      }
    }
  }
}

void gameEnd() {
  for (int i = 0; i < NBALL; i++) {
    if (ball[i].x != -100)
      return;
  }
  fill(0, 0, 99);
  rect(0, 0, width, height);
  fill(0, 0, 0);
  rect(0, 0, width, height/3);
  rect(0, height/3*2, width, height);
  if (hScore < score)
    hScore = score;
  textFont(font, 32);
  text("Your Score :" + score, width/2, height/2);
  textFont(font, 12);
  text("High Score :" + hScore, width/2, height/2 + 50);
  textFont(font, 24);
  text("rank", width/9, height/2+20);
  int rank;
  String rs;
  if (t < 3 && hScore == score)
    rank = 4; else if (t < 7)
    rank = 3; else if (t < 10)
    rank = 2; else if (t < 15)
    rank = 1;
  else
    rank = 0;
  if (hScore == score)
    rank++;
  switch(rank) {
  case 0:
    rs = "F";
    break;
  case 1:
    rs = "C";
    break;
  case 2:
    rs = "B";
    break;
  case 3:
    rs = "A";
    break;
  default:
    rs = "S";
    break;
  }
  textFont(font, 48);
  text(rs, width/4, height/2+15);
  noLoop();
}

void draw() {
  if (spflag) {
    fill(0, 0, 0, 30);
    rect(0, 0, width, height);
    t = (int)(System.currentTimeMillis() - time)/1000;
  } else {
    fill(0, 0, 60);
    rect(0, 0, width, height);
    spEnd();
  }
  fill(0, 0, 99);
  text("score : " + score, 20, 40);
  text("time : " + t, 150, 40);
  drawMe();
  for (int i = 0; i < NBALL; i++)
    ball[i].update();
  for (int i = 0; i < NSHOT; i++)
    shot[i].update();
  shoot();
  runScore();
  gameEnd();
}

class Ball {
  float x, y, vx, vy, r;
  color c;

  Ball(float x, float y, float vx, float vy, float r, color c) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.r = r;
    this.c = c;
  }

  void update() {
    if (spflag || (vx == 0 && vy == -30)) {
      x += vx;
      y += vy;
      reflect();
    }
    paint();
  }

  void reflect() {
    if (vx == 0 && vy == -30)
      return;
    if (x < r/2)
      vx *= -1; else if (width-r/2 < x)
      vx *= -1;
    if (y < r/2)
      vy *= -1; else if (height-r/2 < y)
      vy *= -1;
  }

  void paint() {
    fill(c);
    ellipse(x, y, r, r);
  }
}

void keyPressed() {
  switch (keyCode) {
  case KeyEvent.VK_SHIFT:
    pressShift = true;
    break;
  case KeyEvent.VK_LEFT:
    smeX = -10;
    break;
  case KeyEvent.VK_RIGHT:
    smeX = 10;
    break;
  case KeyEvent.VK_SPACE:
    pshot = true;
    break;
  case KeyEvent.VK_S:
    if (0 < spcount)
      spShot();
    break;
  case KeyEvent.VK_F1:
    loop();
    initGame();
    break;
  case KeyEvent.VK_F7:
    for (int i = 0; i < NBALL; i++)
      ball[i].x = -100;
    gameEnd();
    break;
  case KeyEvent.VK_F12:
    for (int i = 0; i < NBALL; i++)
      ball[i].x = -100;
    gameEnd();
    break;
  default:
    break;
  }
}

void keyReleased() {
  switch(keyCode) {
  case KeyEvent.VK_SHIFT:
    pressShift = false;
    break;
  case KeyEvent.VK_LEFT:
    smeX = 0;
    break;
  case KeyEvent.VK_RIGHT:
    smeX = 0;
    break;
  case KeyEvent.VK_SPACE:
    pshot = false;
    shotcount = 0;
    break;
  default:
    break;
  }
}

