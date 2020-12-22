//class used to control the game flow

class GameManager
{
  private GAME_STATE gameState; //enum of the state
  private CountDown countDown; //object representing the timer
  private int playerScore; //player score
  private int internalGameOverCounter; //internal counter used to show the game over after some time (to let the player's animation of death show)


  public GameManager(int startingCountdown)
  {
    countDown = new CountDown(startingCountdown); //we create the timer
  }

  public GAME_STATE getGameState() {
    return this.gameState;
  }
  public void setGameState(GAME_STATE state) {
    this.gameState = state;
  }

  public void addTimeBonus(int timeBonus)
  {
    countDown.addTime(timeBonus);
  }
  public void addScore(int score)
  {
    playerScore +=score;
  }

  public long getRemainingTime()
  {
    return countDown.getRemainingTime();
  }  

  public void drawInfos() //we use processing functions to draw the score and the remaining time
  {
    pushMatrix();
    translate(width * 0.5 - 60, height - 130);
    stroke(0, 0, 255, 250);
    fill(0, 0, 255, 250);
    textMode(CENTER);
    textAlign(CENTER, CENTER);
    textSize(48);
    text(playerScore+"", 0, 0);
    popMatrix();

    pushMatrix();
    translate(width *0.5 + 60, height - 130);

    textMode(CENTER);
    textAlign(CENTER, CENTER);
    textSize(48);
    if (getRemainingTime() < 15 && getRemainingTime() > 5)
    {
      stroke(255, 255, 0, 250);
      fill(255, 255, 0, 250);
    } else if (getRemainingTime() <= 5)
    {
      stroke(255, 0, 0, 250);
      fill(255, 0, 0, 250);
    } else
    {
      stroke(0, 255, 0, 250);
      fill(0, 255, 0, 250);
    }
    text(getRemainingTime()+"", 0, 0);
    popMatrix();
  }
  
  public void addTime(int time)
  {
    countDown.addTime(time);
  }
  
  public GAME_STATE checkAndUpdateState() //if the internal timer of death animation is not started...
  {
    if (internalGameOverCounter == 0)
    {
      if (countDown.getRemainingTime() == 0 || player.getInternalState() == INTERNAL_STATE.DEAD) //...we start it only if the player is dead
      {
   
        internalGameOverCounter = 1; //this starts the death timer
      }
    }
    else if(internalGameOverCounter == 20) //when it reaches 20 it's gameover 
    {
       gameState = GAME_STATE.GAME_OVER; 
    }
    else 
      internalGameOverCounter++; //otherwise the timer is started but not finished yet, so we increment it

    //if we did not enter in any of the preceding blocks, we are just playing and the player was not hit
    
    return gameState;
  }

  public void showGameOver() //we use some processing functions here to show the game over screen
  {
    fill(0, 130);
    rect(0, 0, width, height);
    pushMatrix();
    translate(width * 0.5, height * 0.5);
    textSize(100);
    textMode(CENTER);
    textAlign(CENTER, CENTER);
    stroke(255, 0, 0);
    fill(255, 0, 0);
    text("GAME OVER", 0, 0);
    translate(0,100);
    fill(0,0,255);
    textSize(80);
    text("score: "+playerScore,0,0);
    popMatrix();
    noLoop();
  }


  class CountDown //as from the example snippet
  { 
    private int durationSeconds; 


    public CountDown(int duration) 
    { 
      this.durationSeconds = duration;
    } 
    public long getRemainingTime()  
    {  
      return max(0, durationSeconds - (millis()/1000) ) ;
    }
    public void addTime(int time) {
      this.durationSeconds+= time;
    }
  }
}
