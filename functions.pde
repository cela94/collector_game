
//function used to initialize the player class
public void initPlayer()
{
  player = new PlayerCharacter(new PVector(width * 0.5, height * 0.5), new PVector(70, 100), INTERNAL_STATE.IDLE);
}

//used to initialize monsters data structure
public void initMonsters()
{
   monsters = new ArrayList<InteractiveObject>();
  for (int i = 0; i< NUM_MONSTERS; i++)
  {
    monsters.add( new MonsterCharacter(new PVector(60+random(width-60), random(60+height-60)), new PVector(100, 120), INTERNAL_STATE.IDLE));
  }
}

//used to initialize time gems data structures 
public void initTimeGems()
{
   timeGems = new ArrayList<TimeGem>();
  for (int i = 0; i< NUM_GEMS; i++)
  {
    timeGems.add( new TimeGem(new PVector(60+random(width-60), random(60+height-60)), new PVector(100, 120), INTERNAL_STATE.IDLE));
  }
}

//used to delete monsters if dead, or to draw them
//and to add score when a monster is killed
public void updateMonstersAndDraw()
{
  ArrayList<InteractiveObject> temp = new ArrayList<InteractiveObject>();
  for (int i = 0; i< NUM_MONSTERS; i++)
  {
    try
    {
      InteractiveObject monster = monsters.get(i);
      INTERNAL_STATE monsterInternalState = ((MonsterCharacter)monster).checkAndUpdateState(player);
      if (monsterInternalState != INTERNAL_STATE.DEAD)
      {
        monster.drawMe(); 
        ((MonsterCharacter)monster).tryToFollow(((PlayerCharacter)player).getLocation());
        temp.add(monster);
      } else
      {
        gameManager.addScore(1);
      }
    }
    catch(Exception ex) {
      break;
    }
  }
  monsters = temp;
  for (int i = 0; i< NUM_MONSTERS - monsters.size(); i++)
  {
    monsters.add( new MonsterCharacter(new PVector(60+random(width-60), random(60+height-60)), new PVector(100, 120), INTERNAL_STATE.IDLE));
  }
}

//used to call the player 's class methods to change its state and to draw it
public void updatePlayerAndDraw()
{
  player.checkAndUpdateState();
  player.drawMe();
}

//used to update gems state (if taken) and to draw them
//when taken the disappear and the timer is incremented
public void updateGemsAndDraw()
{
  ArrayList<TimeGem> temp = new ArrayList<TimeGem>();
  for (int i = 0; i< NUM_GEMS; i++)
  {
    try
    {
      TimeGem timeGem = timeGems.get(i);
      INTERNAL_STATE gemInternalState =  timeGem.checkAndUpdateState(player);
      if (gemInternalState != INTERNAL_STATE.TAKEN)
      {
        timeGem.drawMe();  
        temp.add(timeGem);
      } else
      {
        gameManager.addTime(TIME_FORGEM);
      }
    }
    catch(Exception ex) {
      break;
    }
  }
  timeGems = temp;
  
  for (int i = 0; i< NUM_GEMS - timeGems.size(); i++)
  {
    timeGems.add( new TimeGem(new PVector(60+random(width-60), random(60+height-60)), new PVector(100, 120), INTERNAL_STATE.IDLE));
  }
}
