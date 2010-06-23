package
{
  import org.flixel.*;
  import org.flixel.data.FlxKong;
  
  import flash.net.*;
  import flash.events.*;
  import flash.utils.*;
  import flash.display.BitmapData;
  
  public class LoadState extends FlxState
  {
    
    private static const EVENTS_URL:String = "http://overload.crotchzombie.com/hot.xml"
    
    public function LoadState()
    {
      super();
      
      add(new FlxText(0,0,100,"Loading Events..."));
      
      var loader:URLLoader = new URLLoader(); 
      loader.addEventListener(Event.COMPLETE, loadedXML); 
      loader.load(new URLRequest(EVENTS_URL)); 
    }

    private function loadedXML(e:Event):void {
      var xml:XML = new XML(e.target.data);
      
      for each (var t:XML in xml.title) {
        FlxG.levels.push(t.toString())
      }
      
      FlxG.switchState(IntroState)
    }
    
    override public function update():void
    {
      if(!FlxG.kong) (FlxG.kong = parent.addChild(new FlxKong()) as FlxKong).init();
      super.update();
    }
  }
  
}