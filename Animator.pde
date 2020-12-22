/*class used to animate a sequence of images,
this snippet is a rework of the example found in Processing documentations for animated gif (because Processing
doesn't support native animations) <--- You shold reference this  */

 class Animator
{
  private PImage[] images; //array of images
  private int imagesCount; //how many
  private int lastFrameIdx; //last shown image
  private int stopFactor; //used to slow down the animation

  public Animator(String startingImagePath, int numFormat,String imagesFormat, int imagesCount, int stopFactor)
  {
    this.stopFactor = stopFactor;
    this.imagesCount = imagesCount;
    this.images = new PImage[imagesCount];
    for (int imgIdx = 0; imgIdx < imagesCount; imgIdx++)
    {
      String fullImagePath = startingImagePath+nf(imgIdx, numFormat)+"."+imagesFormat; //we load the images
      images[imgIdx] = loadImage(fullImagePath);
    }
  }

  //last image in the array
  public PImage getAnimationFrame()
  {
    return this.images[(int)(lastFrameIdx++/stopFactor) % imagesCount];
  }
  public void resetAnimation()
  {
    this.lastFrameIdx = 0;
  }
  
  
}  
