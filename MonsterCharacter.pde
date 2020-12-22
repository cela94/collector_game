/*class used to represent the monster character
 It extends InteractiveObject because it can be moved and drawn with an animation */
class MonsterCharacter extends InteractiveObject
{

  /*here we have the animation, who uses the animator class -1 for each animation-
   used in the object, according to the internal state */
  private Animator walkingAnimation; 
  private Animator idleAnimation; 
  private Animator dyingAnimation; 

  private PVector spawnLocation; //vector representing where the monster spawns
  private boolean returnToSpawnLocation; //boolean flag used to represent if the monster is trying to return to it's original location (or if it's chasing the player )
  int countsToSwitchFollowMode = 100 + (int)random(400); /*random integer used, with a module, to decide where the monster starts/stops chasing the player and try to reach it's original spawn position */
  int deathTimer; /*timer used to let the monster 's dying animation to show, before deleting it */


  public MonsterCharacter(PVector startingLocation, PVector playerBoxSize, INTERNAL_STATE internalState)
  {
    super(startingLocation, playerBoxSize, internalState);
    this.spawnLocation = startingLocation.get();
    walkingAnimation =   new Animator("animations/Monster-Walk/Monster_", 2, "png", 5, 4); 
    idleAnimation =   new Animator("animations/Monster-Idle/Monster_", 2, "png", 1, 2);
    dyingAnimation =   new Animator("animations/Monster-Death/Monster_", 2, "png", 4, 8);
  }

  public void drawMe()
  {
    imageMode(CENTER);
    pushMatrix();
    translate(actualLocation.x, actualLocation.y); 

    PImage animationFrame = null;
    switch(internalState) //we get the correct frame animation based on the internal status, and we reset the others 
    {
    case IDLE:
      animationFrame = idleAnimation.getAnimationFrame();
      walkingAnimation.resetAnimation(); 
      dyingAnimation.resetAnimation(); 
      break;
    case WALKING:
      animationFrame = walkingAnimation.getAnimationFrame();
      idleAnimation.resetAnimation(); 
      dyingAnimation.resetAnimation(); 
      break;
    case DYING:
      animationFrame = dyingAnimation.getAnimationFrame();
      idleAnimation.resetAnimation(); 
      walkingAnimation.resetAnimation(); 
      break;
    }

    if (null != animationFrame) //we show the frame
    {

      animationFrame.resize((int)(objectBox.x), (int)(objectBox.y)); 
      if (flipFrame) //if we are going left we flip the image
        scale(-1, 1);
      tint(255, 255, 255, playerInSafeMode ? 20 : 255);
      image(animationFrame, 0, 0);
    }

    popMatrix();
  }



  public void move( Object param) //method uset to set where the monsters wants to go
  {
    PVector where = (PVector) param; 
    this.goToLocation =   (where);
    internalState = INTERNAL_STATE.WALKING;

    if (goToLocation.x - actualLocation.x > 20) //if we are moving left we set the internal flag to indicate the image has to be flipped
      this.flipFrame = true;
    else this.flipFrame = false;
  }

  
  public INTERNAL_STATE checkAndUpdateState()
  {

    if (internalState == INTERNAL_STATE.DYING   ) //if the monster is dying
    {
      if (this.deathTimer < 20)
      {
        deathTimer++; //we increment the internal timer for the death if it still < 20
        return internalState;
      } else //otherwise the monster is dead
      {
        internalState = INTERNAL_STATE.DEAD;

        return internalState;
      }
    }

    //if we reach here, the monster is not dying or dead
    //so we move
    //we calculate the movement as the vectorial difference between the goto location and the actual positio
    //this delta vector is multiplid for 0.004, so the movement will be just a small percentage of the path
    PVector movementDelta = goToLocation.get().sub(actualLocation).mult(0.004);

    actualLocation.add(movementDelta);
    if (internalState == INTERNAL_STATE.WALKING) //if the monster is still walking , 
    {
      if (movementDelta.mag() < 0.1) //when the magnitude of the vector is small, the monster is arrived in its target destination
      {
        internalState = INTERNAL_STATE.IDLE;
      }
    } 
    internalCounter++;

    //simple math to alternate between going from chasing the player to trying to reach the original
    //spawn position
    if (internalCounter == countsToSwitchFollowMode)
      returnToSpawnLocation = true;
    else if (internalCounter == 2*countsToSwitchFollowMode)
    {
      internalCounter = 0;
      returnToSpawnLocation = false;
    }
    return internalState;
  }
  
  //overloaded method to check if there is intersection with the player bounding box (so the player has to die)
  //or if the player is attacking and we are hit
  public INTERNAL_STATE checkAndUpdateState(InteractiveObject player)
  {
    this.checkAndUpdateState();
    if (player.getInternalState() == INTERNAL_STATE.ATTACK)
    {
      if (checkIntersection(player.getLocation(), ((PlayerCharacter)player).getAttackBoxSize()))
      {
        kill(); //we are hit
      }
    } else
    {
      if (internalState != INTERNAL_STATE.DEAD && internalState != INTERNAL_STATE.DYING && checkIntersection(player.getLocation(), player.getObjectBox()))
      {
        ((PlayerCharacter)player).kill(); //the player has to die!
      }
    }

    return this.internalState;
  }

  public void tryToFollow(PVector followWhat) //used , to follow the player or to try to reach original position, according to the internal flag
  {

    if (internalState != INTERNAL_STATE.IDLE && internalState != INTERNAL_STATE.WALKING)
    {
      return;
    }
    PVector goTo = null;
    if (returnToSpawnLocation || playerInSafeMode)
    {
      goTo = this.spawnLocation.get();
    } else
    {
      goTo = followWhat.get();
    }

    move(goTo);
  }

  public void kill() //if we are killed, our state become dying
  {
    this.internalState = INTERNAL_STATE.DYING;
  }
  
  
}
