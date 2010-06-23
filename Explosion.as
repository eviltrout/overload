package
{
  import org.flixel.*;
  import flash.geom.Point;
  
  public class Explosion extends FlxSprite
  {
    [Embed(source="data/explosion1.mp3")] private var SndExplosion1:Class;
    [Embed(source="data/explosion2.mp3")] private var SndExplosion2:Class;
    [Embed(source="data/explosion3.mp3")] private var SndExplosion3:Class;
    [Embed(source="data/explosion4.mp3")] private var SndExplosion4:Class;

    [Embed(source="data/explosion.png")] private var ImgExplosion:Class;

    public function Explosion()
    {
      super(0,0);      
      loadGraphic(ImgExplosion, true, false, 64)
      exists = false;
      
      addAnimation("splode1", [0,1,2,3,4,5,6,7], 20, false);
      addAnimationCallback(function (anim:String, frameNo:uint, frameIndex:uint):void {
        if (frameNo == 7) kill()
      })
    }
    
    public function explode(X:Number, Y:Number, sf:Number, silent:Boolean):void {
      x = X
      y = Y
      exists = true
    
      if (!silent) {
		switch(Math.floor(Math.random() * 4)) {
			case 0:
				FlxG.play(SndExplosion1);
				break;
			case 1:
				FlxG.play(SndExplosion2);
				break;
			case 2:
				FlxG.play(SndExplosion3);
				break;
			case 3:
				FlxG.play(SndExplosion4);
				break;									
		}
	  }
      
      play("splode1", true)
    }
    
  }
}