package
{
  import org.flixel.*;
  import flash.geom.Point;
  
  public class Life extends FlxSprite
  {
    [Embed(source="data/lives.png")] private var ImgLife:Class;

    public function Life(i:uint)
    {
      loadGraphic(ImgLife, true, false, 18)
      x = (FlxG.width - ((width + 3) * (i + 1)))
      y = 3      
    }
  
  }    
}