package
{
  import org.flixel.*;
  import flash.geom.Point;
  
  public class PowerUp extends FlxSprite
  {
    [Embed(source="data/powerups.png")] private var ImgPowerUp:Class;
    [Embed(source="data/powerup1.mp3")] private var SndPowerUp1:Class;
    [Embed(source="data/powerup2.mp3")] private var SndPowerUp2:Class;
    [Embed(source="data/powerup3.mp3")] private var SndPowerUp3:Class;
    [Embed(source="data/powerup4.mp3")] private var SndPowerUp4:Class;            

    public static var UPGRADE_TYPE:String = "upgrade"
    public static var BOMB_TYPE:String = "bomb"
    public static var EXTRA_LIFE_TYPE:String = "1up"
    public static var INVINCIBLE_TYPE:String = "invincible"
        
    private var _powerType:String
    
    public function PowerUp()
    {
      super(0, 0);
      loadGraphic(ImgPowerUp, true, false, 18)
      kill()
      
      addAnimation(UPGRADE_TYPE, [0,1,2,3],5)
      addAnimation(BOMB_TYPE, [8,9,10,11], 15)
      addAnimation(EXTRA_LIFE_TYPE, [4,5,6,7], 10)
      addAnimation(INVINCIBLE_TYPE, [12,13,14,15], 10)      
    }
  
    public function get powerType():String {
      return _powerType
    }
  
	public function taken():void {
	  
	  switch(_powerType) {
	    case BOMB_TYPE:
		    FlxG.play(SndPowerUp1);
        FlxG.score += 25
		    break;
	    case UPGRADE_TYPE:
		    FlxG.play(SndPowerUp2);
        FlxG.score += 50		    
		    break;
	    case INVINCIBLE_TYPE:
		    FlxG.play(SndPowerUp3);
        FlxG.score += 25		    
		    break;
	    case EXTRA_LIFE_TYPE:
		    FlxG.play(SndPowerUp4);
        FlxG.score += 500		    
		    break;    		      		    		    
	  }

	}
	
    public function spawn(X:uint, Y:uint):void {
      
      var r:Number = Math.random()
      if (r < 0.3)
        _powerType = BOMB_TYPE
      else if (r < 0.6)
        _powerType = UPGRADE_TYPE
      else if (r < 0.9)
        _powerType = INVINCIBLE_TYPE
      else
        _powerType = EXTRA_LIFE_TYPE
      
        
      x = X
      y = Y
      exists = true
      dead = false
      velocity.x = -150
      play(_powerType)
    }
    
    override public function update():void {
      if (x < -10) {
        kill()
      }
      super.update()
    }
  }    
}