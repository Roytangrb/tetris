int blockW; 
int block_radius;
int cols = 10;
int rows = 22;
int yIndex;
int xIndex;
int pieceNum;
boolean[][] block = new boolean[cols][rows];
PImage bkg;
PImage welcomeBkg;
PImage start;
PImage menu;
PImage instruction;
PImage restart;
PImage exit;
PImage title;
int delay;
int last;
int delayTime;
int wakeUpTime;
int stageNum;
int score;
int level;
int gameOverCount;
boolean gamePause;
boolean [][][] arr = new boolean [20][4][4];
color [] colors = new color [7];

void setup() {
  stageNum = 0;
  background(255);
  size(297, 660);
  frameRate(60);
  gamePause = false;
  blockW = 30;
  block_radius = 5;
  xIndex = int(random(0, 6));
  yIndex = 0;
  pieceNum = int(random(1, 20));
  delay = 500;
  wakeUpTime = 0;
  delayTime = delay; 
  score = 0;
  level = 1;
  gameOverCount = 0;

  bkg = loadImage("PlayField.png");
  welcomeBkg = loadImage("WelcomePage.jpg");
  start = loadImage("start-button.png");
  menu  = loadImage("BacktoMenu_button.png");
  instruction = loadImage("Instructions_button.png");
  restart  = loadImage("Restart_button.png");
  exit  = loadImage("Exit_button.png");
  title = loadImage("title.png");

  colors[0] = color(54, 55, 58);
  colors[1] = color(255, 255, 3);
  colors[2] = color(255, 3, 255);
  colors[3] = color(3, 3, 255);
  colors[4] = color(3, 255, 3);
  colors[5] = color(255, 3, 3);
  colors[6] = color(3, 255, 255);

  clearPlayField();

  intlTetrominoes();
}

void clearPlayField() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      block[i][j] = false;
    }
  }
}

void draw() {
  if (stageNum == 0) {
    welcomePage();
  } else if (stageNum == 1) {
    gamePlayingDraw();
  } else if (stageNum == 2) {
    gameoverDraw();
  } else {
    instructionDraw();
  }
}

void welcomePage () {
  image(welcomeBkg, 0, 0, width, height);
  image(title, 0, 0, width, height);
  if (sq(mouseX - 208) + sq(mouseY -280) <= 1600) {
    image(instruction, 164, 236, 88, 88);
  } else {
    image(instruction, 168, 240, 80, 80); //center(124, 280)
  }
  if (sq(mouseX - 90) + sq(mouseY - 280) <= 1600) {
    image(start, 46, 236, 88, 88);
  } else {
    image(start, 50, 240, 80, 80);//center(90, 280)
  }
}

void gamePlayingDraw() {
  image(bkg, 0, 0, width, height);
  //display score
  fill(255);
  strokeWeight(2);
  stroke(0);
  textSize(20);
  textAlign(LEFT, BASELINE);
  text("Score: " + score, 5, 30);
  text("Level : ", 5, 50);
  text("         " + level, 13, 50);

  //draw playing field
  for (int i = 0; i < cols; i++) {
    for (int j = 2; j < rows; j++) {
      if (block[i][j] == false) {
        fill(255, 255, 255, 80);
        stroke(255);
        strokeWeight(2);
      } else {
        color fillColor;
        if (pieceNum < 5) {
          fillColor = colors[0];
        } else if (pieceNum < 5) {
          fillColor = colors[1];
        } else if (pieceNum < 9) {
          fillColor = colors[2];
        } else if (pieceNum < 13) {
          fillColor = colors[3];
        } else if (pieceNum < 17) {
          fillColor = colors[4];
        } else if (pieceNum < 19) {
          fillColor = colors[5];
        } else {
          fillColor = colors[6];
        }

        fill(fillColor);
        stroke(0);
        strokeWeight(2);
      }
      rect(i * blockW, j * blockW, blockW - 3, blockW - 3, block_radius, block_radius, block_radius, block_radius);
    }
  }
  //roof line
  strokeWeight(3);
  stroke(255, 0, 0);
  for (int i = 0; i < 60; i ++) {
    if (i % 3 == 0) {
      line(i*10 + 5, 60, i*10 + 15, 60);
    }
  }

  //display pause
  if (gamePause == true) {
    fill(255);
    textSize(50);
    textAlign(CENTER, BOTTOM);
    text("PAUSE", width/2, height/2);
    textAlign(CENTER, TOP);
    textSize(30);
    text("click 'c' to continue", width/2, height/2);
  }

  if (millis() >= wakeUpTime + last) {
    //clear the first two line
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < 2; j++) {
        block[i][j] = false;
      }
    }

    if (gamePause == false) {
      //move the tetro
      if (touchBottomCheck(pieceNum) == false) {
        currentPiece(pieceNum);
        yIndex ++;
        oldPiece(pieceNum);
        currentPiece(pieceNum);
      }
      //tetro touches bottom
      if (touchBottomCheck(pieceNum) == true) {
        if (roofCheck() == true) {
          stageNum = 2;
        } else {
          delay = 1;
          createNewPiece();
        }
      }
      gameLevelControl();
    }
    delayTime += delay;
    wakeUpTime += delay;
  }
}

void createNewPiece() {
  if (millis() >= delayTime + last) {
    elimination();
    xIndex = int(random(-1, 6));
    yIndex = 0;
    pieceNum = int(random(1, 20));
    currentPiece(pieceNum);
    delay = 500 - (level-1)*100;
    delayTime = wakeUpTime + delay;
  }
}

void gameLevelControl() {
  if (level < 6) {
    if (score > level*15) {
      level ++;
    }
  }
}

void instructionDraw() {
  image(welcomeBkg, 0, 0, width, height);
  if (sq(mouseX - 149) + sq(mouseY - 530) > 6400) {
    image(menu, 69, 450, 160, 160); //center(149, 530)
  } else {
    image(menu, 64, 445, 170, 170);
  }
  fill(255);
  textSize(40);
  textAlign(TOP, CENTER);
  text("Instructions", 35, 70);
  textSize(20);
  text("Press 'SPACE' to rotate", 25, 115);
  text("the Tetromemoes", 25, 155);
  text("Press 'p' to pause", 25, 215);
  text("Press 'c' to resume", 25, 255);
  text("Press 'DOWN' to drop", 25, 315);
  text("Press 'LEFT/RIGHT' to move", 25, 355);
}

void gameoverDraw() {
  if (gameOverCount < 230) {
    for (int i = 0; i < cols; i++) {
      for (int j = 2; j < rows; j++) {
        if (block[i][j] == false) {
          fill(50, 50, 50, 20);
          stroke(255);
          strokeWeight(2);
          rect(i * blockW, j * blockW, blockW - 3, blockW - 3, block_radius, block_radius, block_radius, block_radius);
          gameOverCount++;
        }
      }
    }
  }
  if (sq(mouseX - 208) + sq(mouseY -280) <= 1600) {
    image(exit, 168, 240, 80, 80);
  } else {
    image(exit, 164, 236, 88, 88); //center(124, 280)
  }
  if (sq(mouseX - 90) + sq(mouseY - 280) <= 1600) {
    image(restart, 50, 240, 80, 80);
  } else {
    image(restart, 46, 236, 88, 88);//center(90, 280)
  }
  fill(99, 239, 242);
  textSize(50);
  text("You lost!", 45, 200);
  textSize(30);
  text("Your Score: " + score + "!", 50, 380);
}

boolean roofCheck() {
  boolean touchRoof = false;
  for (int i = 0; i < 10; i ++) {
    if (block[i][2] == true) {
      touchRoof = true;
    }
  }
  return touchRoof;
}

boolean touchBottomCheck(int num) {
  int [] blockHeightCheck = new int [4];
  int blockHeightMax;
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if (arr[num][i][j] == true) {
        blockHeightCheck[i] = j;
      }
    }
  }

  blockHeightMax = max(blockHeightCheck);
  boolean touchBottom = false;
  if (yIndex + blockHeightMax == rows - 1) {
    touchBottom = true;
  } 
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if  (arr[num][i][j] == true) {
        if (touchBottom == false && block[xIndex+i][yIndex+blockHeightCheck[i]+1] == true) {
          touchBottom = true;
          break;
        }
      }
    }
  }
  return touchBottom;
}

boolean crashCheckBorderL(int num) {
  boolean crashBorder = false;
  int blockWidthMax = widthMax(num);
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if (arr[num][i][j] == true) {
        if (xIndex+i <= 0) {
          crashBorder = true;
        }
      }
    }
  }
  return crashBorder;
}

boolean crashCheckBorderR(int num) {
  boolean crashBorder = false;
  int blockWidthMax = widthMax(num);
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if (arr[num][i][j] == true) {
        if (xIndex + blockWidthMax >= 9) {
          crashBorder = true;
        }
      }
    }
  }
  return crashBorder;
}

int widthMax(int num) {
  int []blockWidthCheck = new int [4]; 
  int blockWidthMax;
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if (arr[num][i][j] == true) {
        blockWidthCheck[j] = i;
      }
    }
  }
  blockWidthMax = max(blockWidthCheck);
  return blockWidthMax;
}

boolean crashCheckL (int num) {
  boolean crashL = false;
  int []blockWidthCheck = new int [4];
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if (arr[num][i][j] == true) {
        blockWidthCheck[j] = i;
      }
    }
  }
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if  (arr[num][i][j] == true) {
        if (block[xIndex+i-1][yIndex+j] == true) {
          crashL = true;
          break;
        }
      }
    }
  }
  return crashL;
} 

boolean crashCheckR (int num) {
  boolean crashR = false;
  int []blockWidthCheck = new int [4];
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if (arr[num][i][j] == true) {
        blockWidthCheck[j] = i;
      }
    }
  }
  for (int i = 0; i < 4; i ++) {
    for (int j = 0; j < 4; j ++) {
      if  (arr[num][i][j] == true) {
        if (block[xIndex+blockWidthCheck[j]+1][yIndex+j] == true) {
          crashR = true;
          break;
        }
      }
    }
  }
  return crashR;
} 

void keyPressed() {
  if (stageNum == 0) {
  } else if (stageNum == 1) {
    gamePlayKeyPressed();
  } else if (stageNum == 2) {
  } else {
  }
}

void gamePlayKeyPressed() {
  if (gamePause == false) {
    if (keyCode == LEFT) {
      oldPieceLR(pieceNum);
      if (crashCheckBorderL(pieceNum) == false && crashCheckL(pieceNum) == false) {
        xIndex --;
      }
      currentPiece(pieceNum);
    }

    if (keyCode == RIGHT) {
      oldPieceLR(pieceNum);
      if (crashCheckBorderR(pieceNum) == false && crashCheckR(pieceNum) == false) {
        xIndex ++;
      }
      currentPiece(pieceNum);
    }
    if (keyCode == DOWN) {
      delay = 5;
      //drop lock
      delayTime = wakeUpTime;
    }

    tetroRotation();
  }
  //gamePauseControl
  if (key == 'p') {
    gamePause = true;
  } else if (key == 'c') {
    gamePause = false;
  }
  //for debug
  if (key == 'L') {
    stageNum = 2;
  }
}

void mousePressed() {
  if (stageNum == 0) {
    welMousePressed();
  } else if (stageNum == 1) {
  } else if (stageNum == 2) {
    gameoverMousePressed();
  } else {
    insMousePressed();
  }
}

void welMousePressed() {
  if (sq(mouseX - 90) + sq(mouseY - 280) <= 1600) {
    if (mouseButton == LEFT) {
      setup();
      last = millis();
      stageNum = 1;
    }
  }

  if (sq(mouseX - 208) + sq(mouseY -280) <= 1600) {
    if (mouseButton == LEFT) {
      stageNum = 3;
    }
  }
}

void insMousePressed() {
  if (sq(mouseX - 149) + sq(mouseY - 530) <= 6400) {  
    if (mouseButton == LEFT) {
      stageNum = 0;
    }
  }
}


void gameoverMousePressed() {
  if (sq(mouseX - 90) + sq(mouseY - 280) <= 1600) {
    if (mouseButton == LEFT) {
      stageNum = 0;
    }
  }
  if (sq(mouseX - 208) + sq(mouseY -280) <= 1600) {
    if (mouseButton == LEFT) {
      exit();
    }
  }
}


void intlTetrominoes() {
  //T
  //up1
  arr[1][0][0] = true;
  arr[1][1][0] = true;
  arr[1][2][0] = true;
  arr[1][1][1] = true;
  //right2
  arr[2][1][0] = true;
  arr[2][0][1] = true;
  arr[2][1][1] = true;
  arr[2][1][2] = true;
  //down3
  arr[3][1][1] = true;
  arr[3][0][2] = true;
  arr[3][1][2] = true;
  arr[3][2][2] = true;
  //left4
  arr[4][0][0] = true;
  arr[4][0][1] = true;
  arr[4][1][1] = true;
  arr[4][0][2] = true;

  //L
  //up5
  arr[5][0][0] = true;
  arr[5][1][0] = true;
  arr[5][2][0] = true;
  arr[5][0][1] = true;
  //right6
  arr[6][0][0] = true;
  arr[6][1][0] = true;
  arr[6][1][1] = true;
  arr[6][1][2] = true;
  //down7
  arr[7][2][1] = true;
  arr[7][0][2] = true;
  arr[7][1][2] = true;
  arr[7][2][2] = true;
  //left8
  arr[8][0][0] = true;
  arr[8][0][1] = true;
  arr[8][0][2] = true;
  arr[8][1][2] = true;

  //J
  //up9
  arr[9][0][1] = true;
  arr[9][0][2] = true;
  arr[9][1][2] = true;
  arr[9][2][2] = true;
  //right10
  arr[10][0][0] = true;
  arr[10][1][0] = true;
  arr[10][0][1] = true;
  arr[10][0][2] = true;
  //down11
  arr[11][0][1] = true;
  arr[11][1][1] = true;
  arr[11][2][1] = true;
  arr[11][2][2] = true;
  //left12
  arr[12][0][2] = true;
  arr[12][1][0] = true;
  arr[12][1][1] = true;
  arr[12][1][2] = true;

  //s
  //vertical13
  arr[13][1][0] = true;
  arr[13][2][0] = true;
  arr[13][0][1] = true;
  arr[13][1][1] = true;
  //horizontal14
  arr[14][0][0] = true;
  arr[14][0][1] = true;
  arr[14][1][1] = true;
  arr[14][1][2] = true;

  //z
  //vertical15
  arr[15][0][0] = true;
  arr[15][1][0] = true;
  arr[15][1][1] = true;
  arr[15][2][1] = true;
  //horizontal16
  arr[16][1][0] = true;
  arr[16][0][1] = true;
  arr[16][1][1] = true;
  arr[16][0][2] = true;

  //i
  //horizontal17
  arr[17][0][1] = true;
  arr[17][1][1] = true;
  arr[17][2][1] = true;
  arr[17][3][1] = true;
  //vertical18
  arr[18][0][0] = true;
  arr[18][0][1] = true;
  arr[18][0][2] = true;
  arr[18][0][3] = true;

  //o19
  arr[19][0][0] = true;
  arr[19][1][0] = true;
  arr[19][0][1] = true;
  arr[19][1][1] = true;
}

void currentPiece(int i) {
  int j = 0;
  int k = 0;
  for (j = 0; j < 4; j++) {
    for (k = 0; k < 4; k++) {
      if (arr[i][j][k] == true) {
        block[xIndex+j][yIndex+k] = true;
      }
    }
  }
}

void oldPiece(int i) {
  int j = 0;
  int k = 0;
  for (j = 0; j < 4; j++) {
    for (k = 0; k < 4; k++) {
      if (arr[i][j][k] == true) {
        block[xIndex+j][yIndex+k-1] = false;
      }
    }
  }
}

void oldPieceLR(int num) {
  int j = 0;
  int k = 0;
  for (j = 0; j < 4; j++) {
    for (k = 0; k < 4; k++) {
      if (arr[num][j][k] == true) {
        block[xIndex+j][yIndex+k] = false;
      }
    }
  }
}


void tetroRotation() {
  if (key == ' ') {
    if (touchBottomCheck(pieceNum) == false) {
      oldPieceLR(pieceNum);
      if (pieceNum < 5) {
        pieceNum ++;
        if (pieceNum == 5) {
          pieceNum = 1 ;
        }
        constrainRotation(pieceNum);
      } else if (pieceNum < 9) {
        pieceNum ++;
        if (pieceNum == 9) {
          pieceNum = 5 ;
        }
        constrainRotation(pieceNum);
      } else if (pieceNum < 13) {
        pieceNum ++;
        if (pieceNum == 13) {
          pieceNum = 9 ;
        }
        constrainRotation(pieceNum);
      } else if (pieceNum < 15) {
        pieceNum ++;
        if (pieceNum == 15) {
          pieceNum = 13 ;
        }
      } else if (pieceNum < 17) {
        pieceNum ++;
        if (pieceNum == 17) {
          pieceNum = 15 ;
        }
      } else if (pieceNum == 17) {
        pieceNum ++;
      } else if (pieceNum == 18) {
        if (xIndex+3 < 10) {
          pieceNum = 17;
        } else {
          xIndex = 5;
          pieceNum = 17;
        }
      } else if (pieceNum == 19) {
      } else {
        pieceNum = constrain(pieceNum, 0, 19);
      }
    }
  }
}

void constrainRotation(int num) {
  int widthMax = widthMax(num);
  xIndex = constrain(xIndex, -1, 9 - widthMax);
}

void elimination() {
  if (touchBottomCheck(pieceNum) == true) {
    int  []count = new int [22];
    for (int i = 0; i < cols; i++) {
      for (int j = 2; j < rows; j++) {
        if (block[i][j] == true) {
          count[j] ++;
        }
      }
    }
    for (int i = 2; i < rows; i++) {
      if (count[i] == 10) {
        for (int j = cols-1; j >= 0; j--) {
          for (int k = i; k >= 2; k--) {
            block[j][k] = block[j][k-1];
          }
        }
        score ++;
      }
      count[i] = 0;
    }
  }
}

