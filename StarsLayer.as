package
{
  import org.flixel.*;
  import flash.geom.Point;
  
  public class StarsLayer extends FlxLayer {
    private static const MAX_STARS:uint = 50
    private var _stars:Array;
    
    public function StarsLayer() {
      for(var i:Number=0; i<MAX_STARS; i++)
        this.add(new Star())
    }
  }
  
}

