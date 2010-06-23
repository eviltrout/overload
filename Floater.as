package
{
  import org.flixel.*;
  import flash.geom.Point;
  
  public class Floater extends FlxSprite
  {
    [Embed(source="data/floaters.png")] private var ImgFloaters:Class;

    public function Floater(X:uint, i:uint)
    {
      super(X, 0);
      loadGraphic(ImgFloaters, true, false, 200)
      specificFrame(i % 4)
      randomize()
    }
  
    public function randomize():void {
      y = Math.floor(Math.random() * FlxG.height)
      velocity.x = -10
    }
    
    override public function update():void {
      if (x < -width) {
        x = FlxG.width
        randomize()
      }
      super.update()
    }
  }    
}