package
{
  import org.flixel.*;

  public class PlayerBullet extends FlxSprite
  {
    [Embed(source="data/bullets.png")] private var ImgBullet:Class;

    private static const BULLET_SPEED:Number = 500
    private static const BULLET_SPEED_VERT:Number = 350
    

    private var _bulletType:String

    public function PlayerBullet()
    {
      super(0,0);
      loadGraphic(ImgBullet, true, false, 10)
      
      exists = false;
      width = 10
      height = 10
      
      addAnimation("pulse", [7,8], 10)
      addAnimation("pulseDiagTop", [9,10], 10)
      addAnimation("pulseDiagBot", [13], 10)
      addAnimation("drop", [3,4,5,6], 20)
    }
    
    public function shoot(X:Number, Y:Number, bulletType:String):void {
      x = X
      y = Y
      exists = true
      dead = false
      _bulletType = bulletType
      play(_bulletType)
      
      switch (_bulletType) {
        case "pulse":
          velocity.x = BULLET_SPEED
          velocity.y = 0
          break;
        case "pulseDiagTop":
          velocity.x = BULLET_SPEED
          velocity.y = -BULLET_SPEED_VERT
          break;
        case "pulseDiagBot":
          velocity.x = BULLET_SPEED
          velocity.y = BULLET_SPEED_VERT
          break;
        case "drop":
          velocity.x = 0
          velocity.y = BULLET_SPEED_VERT
          break;
      }
    }
    
    override public function update():void {
      if (x > FlxG.width) 
        kill()
        
      super.update()
    }
  }  
}