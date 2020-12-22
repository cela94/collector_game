
//abstract class used as "Parent" for interactive object, 
//here we define some common behaviours and some abstract method
abstract class InteractiveObject
{

  INTERNAL_STATE internalState; 
  protected PVector objectBox;//this vector represents the bounding box of the object
  protected PVector actualLocation; //this the actual location x,y
  protected PVector goToLocation; //this the location this object wants to go
  protected int internalCounter = 0; //internal counter used to alter the internal state
  protected boolean flipFrame; //used to flip the animation image when we are moving left or right

  public InteractiveObject(PVector startingLocation, PVector objectBox, INTERNAL_STATE internalState)
  {
    this.internalState = internalState;
    this.objectBox = objectBox;
    this.actualLocation = startingLocation;
    this.goToLocation = startingLocation;
  }

  public PVector getLocation() { 
    return this.actualLocation;
  }
  public PVector getObjectBox()
  {
    return this.objectBox;
  }
  public INTERNAL_STATE getInternalState() { 
    return this.internalState;
  }

  /*This method is used to check if there is an intersection between this object and an object whose box
  is of size boxSize, and location given in input */
  public boolean checkIntersection(PVector location, PVector boxSize) 
  {

  
    boolean intersect = false;
    if (this.actualLocation.x >  location.x - 0.5 * boxSize.x
      && this.actualLocation.x < location.x + 0.5 * boxSize.x
      && this.actualLocation.y >  location.y - 0.5 * boxSize.y
      && this.actualLocation.y < location.y + 0.5 * boxSize.y)
    {
      intersect = true;
    }

    return intersect;
  }

  public abstract void drawMe(); //abstract method, to be defined in the extending class, to draw the object

  public abstract void move( Object param); //method to be defined in the extending class to move the object, using some sort of params
  public abstract INTERNAL_STATE checkAndUpdateState(); //method to be defined in the extending class , used to update the internal status 
}
