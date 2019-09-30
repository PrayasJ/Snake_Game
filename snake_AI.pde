/*

                                          
   ▄███████▄    ▄████████    ▄████████  ▄████████ ▄██   ▄   ▀████    ▐████▀ 
  ███    ███   ███    ███   ███    ███ ███    ███ ███   ██▄   ███▌   ████▀  
  ███    ███   ███    █▀    ███    ███ ███    █▀  ███▄▄▄███    ███  ▐███    
  ███    ███  ▄███▄▄▄      ▄███▄▄▄▄██▀ ███        ▀▀▀▀▀▀███    ▀███▄███▀    
▀█████████▀  ▀▀███▀▀▀     ▀▀███▀▀▀▀▀   ███        ▄██   ███    ████▀██▄     
  ███          ███    █▄  ▀███████████ ███    █▄  ███   ███   ▐███  ▀███    
  ███          ███    ███   ███    ███ ███    ███ ███   ███  ▄███     ███▄  
 ▄████▀        ██████████   ███    ███ ████████▀   ▀█████▀  ████       ███▄ 
                            ███    ███                                      
*/
//This is a basic Snake game which I made for reasons unkown.
//Please do make the snake bite its own tail, it ain't aesthetic in nature.


/*

VARIABLES FOR SNAKE MECHANISM

*/

//X and Y coordinates of a joint on a snake.

float[] snakeNodeX=new float[10000];
float[] snakeNodeY=new float[10000];

//Direction of motion of the snake.

int dirX=0;
int dirY=1;

//Number of joints on the snakes body.

int nodeCount=2;

//The Thickness of the snake.

int snakeSize=20;

//The Dynamic speed at which the snake moves. Initially set to 2 pixels per frame.

float speedMod=2;
float tempSpeed=0;

//A temporary variable just to increase the length of the snake by making both ends move at different speeds. ( I WAS PRETTY LAZY AT THIS POINT, PARDON THIS METHOD)

int counter=0;

//Self Explanatory,but, it basically sets the color for the snake.

color snakeColor;

//X and Y coordinates for the GREEN SLIMEY point which the snake LUBS.

float pX;
float pY;

//A counter to the number of GREEN SLIMEY points the snake has engulfed.

int gamePoints;

//flag to determine endgame state.

boolean gameOver=false;

/*

VARIABLES FOR AI MECHANISM.

*/

//Switching mechanism to select manual play=1, AI play=2, AI Train=3.

int option;

//Possible options after deciding

char[] possibleActions={'w','s','a','d'};

//chosen option to move into.
char selectedAction;

//Action counter to provide delay between actions.

int actionCounter=0;

//Obstacle detector {up, down, left, right}

boolean[] obstacle=new boolean[4];

//Obstacles distances

float[] obstacleDist=new float[4];

//Function to initiate normal playing mechanism.

void manualPlay(){
  background(0);
  drawSnake();
  dispPoints();
  pointCheck();
  drawPoint();
  checkCollide();
  if(gameOver==false)
    snakeMove();
}

//Function to let the AI play.

void AIPlay(){
  background(0);
  detectObstacle();
  if(actionCounter==0){
    directionDecide();
    actionCounter=5;  
}
  else{
    actionCounter--;
  }
  drawSnake();
  dispPoints();
  pointCheck();
  drawPoint();
  checkCollide();
  if(gameOver==false)
    AIsnakeMove(selectedAction);
}

//Function to set the obstacle detection.

void detectObstacle(){
  obstacle[0]=false;
  obstacle[1]=false;
  obstacle[2]=false;
  obstacle[3]=false;
  obstacleDist[0]=height;
  obstacleDist[1]=height;
  obstacleDist[2]=width;
  obstacleDist[3]=width;
  if(snakeNodeX[nodeCount-1]<snakeSize*2){
    obstacle[2]=true;    
    obstacleDist[2]=snakeNodeX[nodeCount-1];  
}
  if(snakeNodeX[nodeCount-1]>width-snakeSize*2){
    obstacle[3]=true;
    obstacleDist[3]=width-snakeNodeX[nodeCount-1];  
}
  if(snakeNodeY[nodeCount-1]<snakeSize*2){
    obstacle[0]=true;
    obstacleDist[0]=snakeNodeY[nodeCount-1];
  }
  if(snakeNodeY[nodeCount-1]>height-snakeSize*2){
    obstacle[1]=true;
    obstacleDist[1]=height-snakeNodeY[nodeCount-1];
  }
  if(nodeCount>3){ 
    for(int i=0;i<nodeCount-3;i++){
      if(snakeNodeX[i]==snakeNodeX[i+1]){
        if(snakeNodeX[nodeCount-1]-snakeNodeX[i]>0&&snakeNodeX[nodeCount-1]-snakeNodeX[i]<snakeSize*2){
            obstacle[2]=true;
            obstacleDist[2]=abs(snakeNodeX[nodeCount-1]-snakeNodeX[i]);
        }
        if(snakeNodeX[nodeCount-1]-snakeNodeX[i]<0&&snakeNodeX[nodeCount-1]-snakeNodeX[i]>snakeSize*(-2)){
            obstacle[3]=true;
            obstacleDist[3]=abs(snakeNodeX[nodeCount-1]-snakeNodeX[i]);  
      }
      }
      if(snakeNodeY[i]==snakeNodeY[i+1]){
        if(snakeNodeY[nodeCount-1]-snakeNodeY[i]>0&&snakeNodeY[nodeCount-1]-snakeNodeY[i]<snakeSize*2){
            obstacle[0]=true;
            obstacleDist[0]=abs(snakeNodeX[nodeCount-1]-snakeNodeX[i]);
        }
        if(snakeNodeY[nodeCount-1]-snakeNodeY[i]<0&&snakeNodeY[nodeCount-1]-snakeNodeY[i]>snakeSize*(-2)){
            obstacle[1]=true;
            obstacleDist[1]=abs(snakeNodeX[nodeCount-1]-snakeNodeX[i]);
        }
      }
    }
  }
}

//Method-2 direction decide.

void directionDecide(){
  
  if(abs(pX-snakeNodeX[nodeCount-1])<2*snakeSize/3){
   if(pY>snakeNodeY[nodeCount-1]&&obstacle[1]==false){
      selectedAction='s';
    }
    if(pY<=snakeNodeY[nodeCount-1]&&obstacle[0]==false){
        selectedAction='w';
    }
 }
 if(abs(pY-snakeNodeY[nodeCount-1])<2*snakeSize/3){
   if(pX>snakeNodeX[nodeCount-1]&&obstacle[3]==false){
      selectedAction='d';
    }
    if(pX<=snakeNodeX[nodeCount-1]&&obstacle[2]==false){
        selectedAction='a';
    }
 }/*
 if(obstacle[0]==true){
   if(obstacle[1]==true){
     if(obstacle[2]==true){
       if(obstacle[3]==true){
           
       }
       else{
         selectedAction='d';
       }
     }
     else{
       if(obstacle[3]==true){
         selectedAction='a';
       }
       else{
         if(obstacleDist[2]>obstacleDist[3]){
           selectedAction='a';
         }
         else{
           selectedAction='d';
         }
       }
     }
   }
   else{
     if(obstacle[2]==true){
       if(obstacle[3]==true){
         selectedAction='s';
       }
       else{
         if(dirX==0){
           selectedAction='s';
         }
         if(dirY==0){
           selectedAction='d';
         }
       }
     }
     else{
       if(obstacle[3]==true){
         if(dirX==0){
           selectedAction='s';
         }
         if(dirY==0){
           selectedAction='a';
         }
       }
       else{
         
       }
     }
   }
 }
 else{
   if(obstacle[1]==true){
     if(obstacle[2]==true){
       if(obstacle[3]==true){
       
       }
       else{
       
       }
     }
     else{
       if(obstacle[3]==true){
       
       }
       else{
       
       }
     }
   }
   else{
     if(obstacle[2]==true){
       if(obstacle[3]==true){
       
       }
       else{
       
       }
     }
     else{
       if(obstacle[3]==true){
       
       }
       else{
       
       }
     }
   }
 }*/

  int temp=1;
  if(obstacle[0]==true&&dirX==0&&temp==1){
    if(obstacleDist[2]>obstacleDist[3]){
      selectedAction='a';
    }
    else{
      selectedAction='d';
    }
    temp=0;
  }
  if(obstacle[1]==true&&dirX==0&&temp==1){
    if(obstacleDist[2]>obstacleDist[3]){
      selectedAction='a';
    }
    else{
      selectedAction='d';
    }
    temp=0;
  }
  if(obstacle[2]==true&&dirY==0&&temp==1){
    if(obstacleDist[0]>obstacleDist[1]){
      selectedAction='w';
    }
    else{
      selectedAction='s';
    }
    temp=0;
  }
  if(obstacle[3]==true&&dirY==0&&temp==1){
    if(obstacleDist[0]>obstacleDist[1]){
      selectedAction='w';
    }
    else{
      selectedAction='s';
    }
    temp=0;
  }
  /*
  if(obstacle[0]==true&&obstacle[1]==true){
    if(dirX==1){
    selectedAction='d';
    }
    if(dirX==-1){
      selectedAction='a';
    }
  }
  if(obstacle[2]==true&&obstacle[3]==true){
    if(dirY==1){
    selectedAction='w';
    }
    if(dirY==-1){
      selectedAction='s';
    }
  }*/
}


//Function to let the AI move the snake while learning.

void AIsnakeMove(char opt){
  if(counter==0){
  if(snakeNodeX[0]>snakeNodeX[1]){
    snakeNodeX[0]-=2*speedMod;
  }
  if(snakeNodeX[0]<snakeNodeX[1]){
    snakeNodeX[0]+=2*speedMod;
  }
  if(snakeNodeY[0]>snakeNodeY[1]){
    snakeNodeY[0]-=2*speedMod;
  }
  if(snakeNodeY[0]<snakeNodeY[1]){
    snakeNodeY[0]+=2*speedMod;
  }
  }
  else{
      if(snakeNodeX[0]>snakeNodeX[1]){
    snakeNodeX[0]-=1*speedMod;
  }
  if(snakeNodeX[0]<snakeNodeX[1]){
    snakeNodeX[0]+=1*speedMod;
  }
  if(snakeNodeY[0]>snakeNodeY[1]){
    snakeNodeY[0]-=1*speedMod;
  }
  if(snakeNodeY[0]<snakeNodeY[1]){
    snakeNodeY[0]+=1*speedMod;
  }
  counter--;
  }
  if(dist(snakeNodeX[0],snakeNodeY[0],snakeNodeX[1],snakeNodeY[1])<=2*speedMod){
    deleteNode();
  }
    if(opt=='s'&&dirY!=1&&dirY!=-1&&speedMod!=0){
    dirY=1;
    dirX=0;
    nodeCount++;
    snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
    snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];
  }
  
  if(opt=='w'&&dirY!=1&&dirY!=-1&&speedMod!=0){
    dirY=-1;
    dirX=0;
    nodeCount++;
    snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
    snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];  
  }    
  if(opt=='a'&&dirX!=1&&dirX!=-1&&speedMod!=0){
    dirY=0;
    dirX=-1;
    nodeCount++;
    snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
    snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];
  }
    
  if(opt=='d'&&dirX!=1&&dirX!=-1&&speedMod!=0){
    dirY=0;
    dirX=1;
    nodeCount++;
    snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
    snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];  
  }
  snakeNodeX[nodeCount-1]+=dirX*2*speedMod;
  snakeNodeY[nodeCount-1]+=dirY*2*speedMod;

  }

//Funciton to randomly choose point on the screen.

void createPoint(){
  int flag=1;
  while(flag==1){
    flag=1;
    pX=random(width*0.8)+width/10;
    pY=random(height*0.8)+height/10;
    for(int i=0;i<nodeCount-1;i++){
      if(abs(dist(snakeNodeX[i],snakeNodeY[i],pX,pY)+dist(snakeNodeX[i+1],snakeNodeY[i+1],pX,pY)-(dist(snakeNodeX[i+1],snakeNodeY[i+1],snakeNodeX[i],snakeNodeY[i])))<2*snakeSize){
      }
      else if(i+2==nodeCount){
        flag=0;
      }
    }
  }
}

//Function called to end the game.

void gameOver(){
  //exit();
  speedMod=0;
  gameOver=true;
  fill(color(255,0,0));
  textSize(height/10);
  textAlign(CENTER,CENTER);
  text("GAME OVER!!",width/2,height/2);
}

//Function which checks whether the snake has hit the boundary walls or has bitten itself (out of fun).

void checkCollide(){
  if(snakeNodeX[nodeCount-1]<0||snakeNodeX[nodeCount-1]>width||snakeNodeY[nodeCount-1]<0||snakeNodeY[nodeCount-1]>height){
    gameOver();
  }
  if(nodeCount>3){
    for(int i=0;i<nodeCount-3;i++){
      if(abs(dist(snakeNodeX[i],snakeNodeY[i],snakeNodeX[nodeCount-1],snakeNodeY[nodeCount-1])+dist(snakeNodeX[i+1],snakeNodeY[i+1],snakeNodeX[nodeCount-1],snakeNodeY[nodeCount-1])-(dist(snakeNodeX[i+1],snakeNodeY[i+1],snakeNodeX[i],snakeNodeY[i])))<=2*speedMod){
        gameOver();
      }
    }
  }
}

//Function to check whether the snake has eaten the GREEN SLIMEY point or not.

void pointCheck(){
  if(dist(snakeNodeX[nodeCount-1],snakeNodeY[nodeCount-1],pX,pY)<snakeSize){
    createPoint();
    snakeColor=color(random(255),random(255),random(255));
    speedMod*=1.01;
    incLen();
    gamePoints++;
  }
}

//Function to increase length of the snake.
//The higher you set counter the larger the snake would get.

void incLen(){
  counter=60;
}

//Function to draw the GREEN SLIMEY point.

void drawPoint(){
  fill(color(0,255,0));
  ellipse(pX,pY,snakeSize,snakeSize);
}

//Funciton to display the number of game points our snake has eaten during the current playthrough.

void dispPoints(){
  fill(color(0,255,0));
  textAlign(CENTER,CENTER);
  textSize(height/20);
  text("Points - ",width/2-height/13,height*0.9);
  text((gamePoints),width/2+height/13,height*0.9);
  text("Press Enter to Pause",width/2,height*0.95);
}

//function to pause the game
void gamePause(){
  tempSpeed=speedMod;
  speedMod=0;
}

//function to resume the game
void gameResume(){
speedMod=tempSpeed;
}


//Main function which is called during start of our program.

void draw(){
switch(option){
  case 1:
    manualPlay();
    break;
  case 2:
    AIPlay();
    break;
  }
}

//Function to move the first and last nodes of the snake to simulate motion.

void snakeMove(){
  if(counter==0){
  if(snakeNodeX[0]>snakeNodeX[1]){
    snakeNodeX[0]-=2*speedMod;
  }
  if(snakeNodeX[0]<snakeNodeX[1]){
    snakeNodeX[0]+=2*speedMod;
  }
  if(snakeNodeY[0]>snakeNodeY[1]){
    snakeNodeY[0]-=2*speedMod;
  }
  if(snakeNodeY[0]<snakeNodeY[1]){
    snakeNodeY[0]+=2*speedMod;
  }
  }
  else{
      if(snakeNodeX[0]>snakeNodeX[1]){
    snakeNodeX[0]-=1*speedMod;
  }
  if(snakeNodeX[0]<snakeNodeX[1]){
    snakeNodeX[0]+=1*speedMod;
  }
  if(snakeNodeY[0]>snakeNodeY[1]){
    snakeNodeY[0]-=1*speedMod;
  }
  if(snakeNodeY[0]<snakeNodeY[1]){
    snakeNodeY[0]+=1*speedMod;
  }
  counter--;
  }
  if(dist(snakeNodeX[0],snakeNodeY[0],snakeNodeX[1],snakeNodeY[1])<=2*speedMod){
    deleteNode();
  }
  if(speedMod==0){
    fill(color(0,0,255));
    textAlign(CENTER,CENTER);
    text("Game Paused\nPress Space to continue...",width/2,height/2);
  }
  if(keyPressed){
    if(key=='\n'&&speedMod!=0){
      gamePause();
    }
    if(key==' '&&speedMod==0){
      gameResume();
    }
    if(key=='s'&&dirY!=1&&dirY!=-1&&speedMod!=0){
      dirY=1;
      dirX=0;
      nodeCount++;
      snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
      snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];
    }
    
    if(key=='w'&&dirY!=1&&dirY!=-1&&speedMod!=0){
      dirY=-1;
      dirX=0;
      nodeCount++;
      snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
      snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];  
  }
    
    if(key=='a'&&dirX!=1&&dirX!=-1&&speedMod!=0){
      dirY=0;
      dirX=-1;
      nodeCount++;
      snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
      snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];
    }
    
    if(key=='d'&&dirX!=1&&dirX!=-1&&speedMod!=0){
      dirY=0;
      dirX=1;
      nodeCount++;
      snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
      snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];  
  }
  }
  snakeNodeX[nodeCount-1]+=dirX*2*speedMod;
  snakeNodeY[nodeCount-1]+=dirY*2*speedMod;

  }
  
//Function to draw the (young and dashing) snake (or snaek?).
  
void drawSnake(){
  fill(snakeColor);
  for(int i=0;i<nodeCount-1;i++){
    rectMode(CENTER);
    if(snakeNodeX[i]==snakeNodeX[i+1]){

      rect((snakeNodeX[i]+snakeNodeX[i+1])/2,(snakeNodeY[i]+snakeNodeY[i+1])/2,snakeSize,abs(snakeNodeY[i]-snakeNodeY[i+1])+snakeSize);
      ellipse(snakeNodeX[i],snakeNodeY[i],snakeSize*1.25,snakeSize*1.25);
    }
    if(snakeNodeY[i]==snakeNodeY[i+1]){

      rect((snakeNodeX[i]+snakeNodeX[i+1])/2,(snakeNodeY[i]+snakeNodeY[i+1])/2,abs(snakeNodeX[i]-snakeNodeX[i+1])+snakeSize,snakeSize);
      ellipse(snakeNodeX[i],snakeNodeY[i],snakeSize*1.25,snakeSize*1.25);
    }
  }
  ellipse(snakeNodeX[nodeCount-1],snakeNodeY[nodeCount-1],snakeSize*(1.25+abs(dirX)),snakeSize*(1.25+abs(dirY)));
}

//Function to delete the end node of the snake.

void deleteNode(){
  for(int i=0;i<nodeCount;i++){
    snakeNodeX[i]=snakeNodeX[i+1];
    snakeNodeY[i]=snakeNodeY[i+1];
  }
  nodeCount--;
}

//Function to set up the environment conditions for the snake game.

void setup(){
size(1000,800);

  snakeNodeX[0]=width/2;
  snakeNodeY[0]=height/4;
  snakeNodeX[1]=width/2;
  snakeNodeY[1]=height/2;
  pX=random(width*0.8)+width/10;
  pY=random(height*0.8)+height/10;
  snakeColor=color(random(255),random(255),random(255));
  gamePoints=0;
  option=2;
}
