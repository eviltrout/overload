package
{
  import org.flixel.*;

  public class PlayerFeet extends FlxSprite
  {
    [Embed(source="data/feet.png")] private var ImgFeet:Class;
    
    private var _player:Player;
    
    private static const LEFT_FRAME:uint = 2
    private static const RIGHT_FRAME:uint = 0
    private static const UP_FRAME:uint = 1
    private static const DOWN_FRAME:uint = 3
    
    public function PlayerFeet(player:Player)
    {
      super(0,0);
      _player = player
      loadGraphic(ImgFeet, true, false, 28)
    }
    
    override public function update():void {
      
      if (_player.velocity.x < 0) {
        specificFrame(LEFT_FRAME)
        x = _player.x + 8
        y = _player.y + _player.height
      } else if (_player.velocity.x > 0) {
        specificFrame(RIGHT_FRAME)
        x = _player.x
        y = _player.y + _player.height
      } else if (_player.velocity.y < 0) {
        specificFrame(UP_FRAME) 
        x = _player.x + 5
        y = _player.y + _player.height
      } else if (_player.velocity.y > 0) {
        specificFrame(DOWN_FRAME) 
        x = _player.x + 7
        y = _player.y + (_player.height - 4)
      } else {
        specificFrame(RIGHT_FRAME) 
        x = _player.x
        y = _player.y + _player.height
      }
    }
    
  }
}