
/*Definition of constants */
final int NUM_MONSTERS = 6;
final int NUM_GEMS = 2;
final int TIME_FORGEM = 9;

InteractiveObject player; /*the player object */
/*data structures for the monsters characters and the gems */
ArrayList<InteractiveObject> monsters;
ArrayList<TimeGem> timeGems;

/*image used as background */
PImage backgroundImg;
boolean playerInSafeMode = false; //boolean flag to indicate if the player is in safe mode (when on the borders of the level) 
GameManager gameManager; //object used to control the game mode/flow

//main init function
void setup()
{

  size(1024, 1024); //we define processing window
  backgroundImg = loadImage("animations/temple.jpg"); //we load the background imagea
  backgroundImg.resize(width, height); //resizing background image to fit the window
  
  /*we call a function to initialize the 
  player, the monsters and the gems data structures */
  
  initPlayer(); 
  initMonsters();
  initTimeGems();
  //initialization of the game manager, with 30 seconds of starting timer */
  gameManager = new GameManager(30);
  
 
  
}

//processing draw function, called one time for each frame (except when you call no loop
void draw()
{

  background(0); //clear the background
  imageMode(CORNERS); //the coordinates of the images are the upper left corner
  image(backgroundImg, 0, 0); //we draw the background image in the upper left corner : 0,0
  fill(0, 230); 
  stroke(0,230);
  rect(60, 60, width-120, height-120); //creation of an opaque rect at the center (so it seems like the level is an arena)
  updateMonstersAndDraw(); //update monsters action and draw, using this function
  updateGemsAndDraw(); //the same for gems
  updatePlayerAndDraw();  //and for the player
  gameManager.drawInfos(); //we update even the game manager and show the remaining timer and score
  if(gameManager.checkAndUpdateState() == GAME_STATE.GAME_OVER) //we show the gameover screen if the state of the game manager tells us it's gameover
  {
    gameManager.showGameOver();
  }
  
}

 
//processing function called when we press a key
void keyPressed()
{

  player.move(Integer.valueOf(keyCode)); //we pass the pressed key to the player class
  if (player.getLocation().x < 60 || player.getLocation().x > width -60 || player.getLocation().y < 60 || player.getLocation().y > height - 60) //we check if we are in safe area
    playerInSafeMode = true;
  else playerInSafeMode = false;
}
