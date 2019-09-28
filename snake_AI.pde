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

//A temporary variable just to increase the length of the snake by making both ends move at different speeds. ( I WAS PRETTY LAZY AT THIS POINT, PARDON THIS METHOD)

int counter=0;

//Self Explanatory,but, it basically sets the color for the snake.

color snakeColor;

//X and Y coordinates for the GREEN SLIMEY point which the snake LUBS.

float pX;
float pY;

//A counter to the number of GREEN SLIMEY points the snake has engulfed.

int gamePoints;

//Funciton to randomly choose point on the screen.

void createPoint(){
  int flag=1;
  while(flag==1){
    flag=1;
    pX=random(width*0.8)+width/10;
    pY=random(height*0.8)+height/10;
    for(int i=0;i<nodeCount-1;i++){
      if(dist(snakeNodeX[i],snakeNodeY[i],pX,pY)+dist(snakeNodeX[i+1],snakeNodeY[i+1],pX,pY)-(dist(snakeNodeX[i+1],snakeNodeY[i+1],snakeNodeX[i],snakeNodeY[i]))<2*snakeSize){
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
      if(dist(snakeNodeX[i],snakeNodeY[i],snakeNodeX[nodeCount-1],snakeNodeY[nodeCount-1])+dist(snakeNodeX[i+1],snakeNodeY[i+1],snakeNodeX[nodeCount-1],snakeNodeY[nodeCount-1])-(dist(snakeNodeX[i+1],snakeNodeY[i+1],snakeNodeX[i],snakeNodeY[i]))<snakeSize/4){
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
  text((gamePoints),width/2,height*0.9);
}

//Main function which is called during start of our program.

void draw(){
background(0);
drawSnake();
dispPoints();
pointCheck();
drawPoint();
checkCollide();
snakeMove();
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
  if(dist(snakeNodeX[0],snakeNodeY[0],snakeNodeX[1],snakeNodeY[1])<snakeSize/4){
    deleteNode();
  }
  if(keyPressed){
    if(key=='s'&&dirY!=1&&dirY!=-1){
      dirY=1;
      dirX=0;
      nodeCount++;
      snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
      snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];
    }
    
    if(key=='w'&&dirY!=1&&dirY!=-1){
      dirY=-1;
      dirX=0;
      nodeCount++;
      snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
      snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];  
  }
    
    if(key=='a'&&dirX!=1&&dirX!=-1){
      dirY=0;
      dirX=-1;
      nodeCount++;
      snakeNodeX[nodeCount-1]=snakeNodeX[nodeCount-2];
      snakeNodeY[nodeCount-1]=snakeNodeY[nodeCount-2];
    }
    
    if(key=='d'&&dirX!=1&&dirX!=-1){
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
  snakeNodeX[1]=width/2;
  snakeNodeY[0]=height/4;
  snakeNodeY[1]=3*height/4;
  snakeNodeX[2]=3*width/4;
  snakeNodeY[2]=3*height/4;
  pX=random(width*0.8)+width/10;
  pY=random(height*0.8)+height/10;
  snakeColor=color(random(255),random(255),random(255));
  gamePoints=0;
}
