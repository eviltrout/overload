package 
{
  import org.flixel.*;
  import caurina.transitions.Tweener;
    
  public class IntroState extends FlxState
  {
    [Embed(source = "data/start.mp3")] private var SndStart:Class;
    
    private var _txtArray:Array = new Array()
    private var _started:Boolean;
    
    override public function IntroState():void
    {      
      _started = false
      
      this.add(new StarsLayer())

      addText("Every Minute:", 0x99999999)      
      addText("36,000 tweets are made on Twitter.", 0xFF9900FF)
      addText("24 hours of footage is uploaded to YouTube.", 0xFF9900FF)
      addText("2,000,000 million searches are done on Google.", 0xFF9900FF)
      addText("")
      addText("More information is created in a single MINUTE", 0x99999999)
      addText("than you could consume in your entire LIFE.", 0x99999999)
      addText("")
      addText("Use the arrows to navigate the series of tubes.")
      addText("Press X to shoot.")
      addText("")      
      addText("Don't let the information overload you!", 0x99999999)      
      
      fadeFirst()

            
      var txt:FlxText = new FlxText(0, FlxG.height-24, FlxG.width, "PRESS X TO PLAY")
      txt.setFormat(null, 12, 0xFFFFFFFF, "right");
      this.add(txt);
      
      txt = new FlxText(0, 10, FlxG.width, "INFORMATION OVERLOAD")
      txt.setFormat(null,35,0xFFFFFF00,"center")
      this.add(txt);
      
    }
  
    override public function update():void
    {
      
      if (!_started && FlxG.keys.X)
      {
        _started = true
        FlxG.play(SndStart)
        FlxG.fade(0xff000000, 0.5, onFade);
      }
      super.update();
    }
    
    private function fadeFirst():void {
      if (_txtArray == null || _txtArray.size == 0) return;
      Tweener.addTween(_txtArray.shift(), {alpha:1.0, time:1.0, transition:"easeOutSine", onComplete:fadeFirst});
    }
  
    private function addText(txt:String, col:uint=0xFFFFFFFF):void {
      var f:FlxText = new FlxText(0, 80 + (_txtArray.length * 28), FlxG.width, txt);
      f.setFormat(null,16,col,"center")
      f.alpha = 0
      this.add(f);
      _txtArray.push(f)
    }
    private function onFade():void
    {
      FlxG.switchState(PlayState);
    }
  
  }
}