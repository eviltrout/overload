package
{
  import org.flixel.*;
  import flash.utils.getTimer;
  import flash.geom.Point;
  
  public class Player extends FlxSprite
  {
    [Embed(source="data/player_body.png")] private var ImgShip:Class;
    [Embed(source="data/shot1.mp3")] private var SndShot1:Class;
    [Embed(source="data/shot2.mp3")] private var SndShot2:Class;
    [Embed(source="data/shot3.mp3")] private var SndShot3:Class;
    
    private static const FIRE_RATE:uint = 150
    private static const MARGIN:uint = 10
    
    private var _move_speed:int = 250;

    private var _shotCount:uint = 0
    private var _upgradeLevel:uint=0
    private var _canShootAt:uint=0;  
    private var _bullets:Array;
    private var _curBullet:Number=0;
    private var _wasShooting:Boolean = false
    private var _starting:Boolean = false
    
    public function Player(bullets:Array)
    {
      super();
      
      
      loadGraphic(ImgShip, true, false, 43)

      restart()

      _bullets = bullets;
      
      width = 40
      height = 40
            
      addAnimation("idle", [6],12);
      addAnimation("shooting", [0,1,2,1], 20)
      addAnimation("return", [5,4,3,4,6], 20, false)
      play("idle")
    }
  
    public function shootBullet(X:uint, Y:uint, bulletType:String):void {
      _bullets[_curBullet].shoot(X, Y, bulletType)
      _curBullet += 1
      if (_curBullet >= _bullets.length) _curBullet = 0      
    }
    
    public function shoot():void {
      var now:uint = getTimer()
      _wasShooting = true
      if (now >= _canShootAt) {
        play("shooting")
        _canShootAt = now + FIRE_RATE
        _shotCount++
        
        FlxG.play(SndShot1);
        shootBullet(x + (width/4), y + (height * (4/9)), "pulse")
        
        if (_upgradeLevel < 3) {
          // Slower shooting
          if (_upgradeLevel > 0 && ((_shotCount % 2) == 0) ) {
			      shootBullet(x + (width/2), y + (height * (4/9)), "drop")
        	  FlxG.play(SndShot3);
		      }
          if (_upgradeLevel > 1 && ((_shotCount % 3) == 0) ) {
            shootBullet(x + (width/2), y + (height * (4/9)), "pulseDiagBot")
            shootBullet(x + (width/2), y + (height * (4/9)), "pulseDiagTop")
        	  FlxG.play(SndShot2);
          }
        } else {
          shootBullet(x + (width/2), y + (height * (4/9)), "drop")
          shootBullet(x + (width/2), y + (height * (4/9)), "pulseDiagBot")
          shootBullet(x + (width/2), y + (height * (4/9)), "pulseDiagTop")
          FlxG.play(SndShot2);
          FlxG.play(SndShot3);          
        }
        
      }
    }

    public function restart():void {
      _starting = true
      _upgradeLevel = 0
      reset(-45, (FlxG.height / 2) - 20)
    }
    
    private function startingUpdate():void {
      velocity.x = (_move_speed * 2)
      velocity.y = 0
      
      if (x > 100)
        _starting = false
    }

    private function playUpdate():void {
 
      if(FlxG.keys.LEFT)
      {
        velocity.x = -_move_speed
      }
      else if(FlxG.keys.RIGHT)
      {
        velocity.x = _move_speed
      } else {
        velocity.x = 0
      }

      if(FlxG.keys.UP)
      {
         velocity.y = -_move_speed
      }
      else if(FlxG.keys.DOWN)
      {
         velocity.y = _move_speed
      } else {
        velocity.y = 0
      }

//      velocity = new Point((FlxG.mouse.x - x) * 8, (FlxG.mouse.y - y) * 8)
//      x = FlxG.mouse.x
//      y = FlxG.mouse.y
      
      
      if (FlxG.keys.X) {
        shoot()
      } else {
        if (_wasShooting)
          play("return")
      }
      
      if (x < MARGIN) x = MARGIN
      if (y < MARGIN) y = MARGIN
      if (x > (FlxG.width - MARGIN - width)) x = FlxG.width - MARGIN - width
      if (y > (FlxG.height - MARGIN - height)) y = FlxG.height - MARGIN - height 
    }
    
    public function powerUp(powerType:String):void {
      
      switch(powerType) {
        case PowerUp.UPGRADE_TYPE:
          _upgradeLevel++
          break;
      }
      
    }
    
    public function get upgradeLevel():uint {
      return _upgradeLevel
    }
    
    override public function update():void {
      super.update();
      
      if (_starting) {
        startingUpdate()
      } else {
        playUpdate()
      }
    }
  }  
}