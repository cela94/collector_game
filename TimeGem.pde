class TimeGem extends InteractiveObject
{



  private Animator idleAnimation;  
  private PVector spawnLocation;



  public TimeGem(PVector startingLocation, PVector playerBoxSize, INTERNAL_STATE internalState)
  {
    super(startingLocation, playerBoxSize, internalState);
    this.spawnLocation = startingLocation.get();

    idleAnimation =   new Animator("animations/Gem-Idle/standard_gem_", 2, "png", 1, 2);
  }

  public void drawMe()
  {
    imageMode(CENTER);
    pushMatrix();
    translate(actualLocation.x, actualLocation.y); 

    PImage animationFrame = null;
    switch(internalState)
    {
    case IDLE:
      animationFrame = idleAnimation.getAnimationFrame(); 
      break;
    }

    if (null != animationFrame)
    {

      animationFrame.resize((int)(objectBox.x/2), (int)(objectBox.y/2));  
      tint(255, 255, 255,  200);
      image(animationFrame, 0, 0);
    }

    popMatrix();
  }



  public INTERNAL_STATE checkAndUpdateState(InteractiveObject player)
  {
    this.checkAndUpdateState();

    if (checkIntersection(player.getLocation(), player.getObjectBox()))
    {
      takeGem();
    }


    return this.internalState;
  }


  public void takeGem()
  {
    this.internalState = INTERNAL_STATE.TAKEN;
  }

  public void move( Object param)
  {
    /*do nothing*/
  }
  
  public  INTERNAL_STATE checkAndUpdateState() {
    return internalState;
  }
}
