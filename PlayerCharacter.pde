class PlayerCharacter extends InteractiveObject
{


  private Animator walkingAnimation;
  private Animator deathAnimation;
  private Animator idleAnimation; 
  private Animator attackAnimation; 
  private PVector playerAttackBoxSize;


  public PlayerCharacter(PVector startingLocation, PVector playerBoxSize, INTERNAL_STATE internalState)
  {
    super(startingLocation, playerBoxSize, internalState);
    
    this.playerAttackBoxSize = new PVector(playerBoxSize.x * 2.5, playerBoxSize.y);
    
    walkingAnimation =   new Animator("animations/Walk/GreekBasic_Walk_", 2, "png", 12, 2);
    deathAnimation =   new Animator("animations/Die/GreekBasic_Die_", 2, "png", 12, 4);
    idleAnimation =   new Animator("animations/Idle/GreekBasic_Idle_", 2, "png", 1, 1);
    attackAnimation =   new Animator("animations/Attack/GreekBasic_Attack_", 1, "png", 8, 2);
  }


  public PVector getAttackBoxSize()
  {
     return this.playerAttackBoxSize; 
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
      walkingAnimation.resetAnimation();
      deathAnimation.resetAnimation(); 
      attackAnimation.resetAnimation();
      break;
    case WALKING:
      animationFrame = walkingAnimation.getAnimationFrame();
      idleAnimation.resetAnimation();
      deathAnimation.resetAnimation(); 
      attackAnimation.resetAnimation();
      break;
    case DEAD:
      animationFrame = deathAnimation.getAnimationFrame();
      idleAnimation.resetAnimation();
      walkingAnimation.resetAnimation();
      attackAnimation.resetAnimation();
      break;
    case ATTACK:
      animationFrame = attackAnimation.getAnimationFrame();
      idleAnimation.resetAnimation();
      walkingAnimation.resetAnimation();
      deathAnimation.resetAnimation();
      break;
    }

    if (null != animationFrame)
    {
      if (internalState == INTERNAL_STATE.DEAD)
      {
        animationFrame.resize((int)(objectBox.x*1.6), (int)(objectBox.y*1.6));
        translate(-15,15);
      } else if (internalState != INTERNAL_STATE.ATTACK )
      {
        animationFrame.resize((int)(objectBox.x), (int)(objectBox.y));
      } else
      {
        animationFrame.resize((int)(objectBox.x*2.5), (int)(objectBox.y));
      }

      if (flipFrame)
        scale(-1, 1);

      tint(255, 255, 255, 255);
      image(animationFrame, 0, 0);
    }

    popMatrix();
  }



  public void move( Object param)
  {
    int _keyCode = (Integer)param;
    PVector where = new PVector(0, 0);
    switch(_keyCode)
    {
    case UP :
      this.internalState = INTERNAL_STATE.WALKING;
      where = new PVector(0, -40); 
      break;    
    case DOWN :
      this.internalState = INTERNAL_STATE.WALKING;
      where = new PVector(0, 40); 
      break;
    case RIGHT: 
      this.flipFrame = false;
      
      this.internalState = INTERNAL_STATE.WALKING;
      where = new PVector(40, 0);  
      break;
    case LEFT: 
      this.internalState = INTERNAL_STATE.WALKING;
      where = new PVector(-40, 0); 
      this.flipFrame = true;
      break;
    case SHIFT: 
      this.internalState = INTERNAL_STATE.ATTACK;
      internalCounter = 30;
      break;
    }


    this.goToLocation =  this.actualLocation.get().add(where);
  }

  public INTERNAL_STATE checkAndUpdateState()
  {
    PVector movementDelta = goToLocation.get().sub(actualLocation).mult(0.1);
    actualLocation.add(movementDelta);
    if (internalState == INTERNAL_STATE.WALKING)
    {
      if (movementDelta.mag() < 0.1)
      {
        internalState = INTERNAL_STATE.IDLE;
      }
    } else if (internalState == INTERNAL_STATE.ATTACK)
    {  
      internalCounter--;
      if (internalCounter == 0)
      {
        internalState = INTERNAL_STATE.IDLE;
      }
    }



    return internalState;
  }

  public void kill()
  {
    this.internalState = INTERNAL_STATE.DEAD;
  }
}
