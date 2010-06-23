package 
{
  import org.flixel.*;
  import caurina.transitions.Tweener;
  import flash.events.*;
  import flash.utils.*;    
  
  public class GameOverState extends FlxState
  {
    [Embed(source = "data/game_over.mp3")] private var SndGameOver:Class;
    [Embed(source = "data/start.mp3")] private var SndStart:Class;
    
    private var _txtArray:Array = new Array()
    private var _started:Boolean;
    private var _sawScreen:uint;
    
    override public function GameOverState():void
    {
      
      _started = false
      _sawScreen = getTimer()
      
      var txt:FlxText = new FlxText(0, FlxG.height-24, FlxG.width, "PRESS X TO PLAY AGAIN")
      txt.setFormat(null, 12, 0xFFFFFFFF, "right");
      this.add(txt);
      
      txt = new FlxText(0, 10, FlxG.width, "GAME OVER!")
      txt.setFormat(null,60,0xFFFFFF00,"center")
      this.add(txt);

      txt = new FlxText(0, 200, FlxG.width, "You scored " + FlxG.score + "!")
      txt.setFormat(null,20,0xFF9900FF,"center")
      this.add(txt);
      
      FlxG.play(SndGameOver)
      
      // Submit the high score to Kongregate
      if(FlxG.kong) {
        FlxG.kong.API.stats.submit("HighScore",FlxG.score);
      }
    }
  
    override public function update():void
    {
      if (getTimer() > (_sawScreen + 2000)) {
        if (!_started && FlxG.keys.X)
        {
          _started = true
          FlxG.play(SndStart)
          FlxG.fade(0xff000000, 0.5, onFade);
        }
      }
      
      super.update();
    }
    
    private function onFade():void
    {
      FlxG.switchState(PlayState);
    }
  
  }
}