package
{
  import org.flixel.*;
  import flash.geom.Point;
  
  public class Star extends FlxSprite
  {
    [Embed(source="data/stars.png")] private var ImgStar:Class;

    private static const STAR_SPEED:Number = 20
    
    public function Star()
    {
      super(Math.floor(Math.random() * FlxG.width), 0);
      loadGraphic(ImgStar, true, false, 7)
      
      randomize()
    }
  
    public function randomize():void {
      y = Math.floor(Math.random() * FlxG.height)
      velocity.x = (STAR_SPEED * -1) * (Math.random() * 0.8)
      
      randomFrame()
    }
    
    override public function update():void {
      if (x < -10) {
        x = FlxG.width
        randomize()
      }
      super.update()
    }
  }    
}