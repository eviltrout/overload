package
{
  import org.flixel.*;
  import flash.geom.Point;
  import flash.utils.getTimer;

  public class Enemy extends FlxText
  {
    [Embed(source="data/hit.mp3")] private var SndHit:Class;
    
    private static const ENEMY_SPEED:Number = 100
    
    private var _path:Array;    
    private var _pathOffset:Number;
    private var _vunerable:Boolean;
    private var _pathCallback:Function;
    private var _strength:Number;
    private var _deathAt:uint;
    private var _enemyShared:Object;
    
    public function Enemy()
    {
      super(0,0,FlxG.width,"test")
      exists = false
      dead = true
    }

    public function wordDown():Number {
      _enemyShared.wordsLeft--
      return _enemyShared.wordsLeft
    }
    
    public function hit():Boolean {
      _strength--
      if (_strength < 0) return true;
      
      FlxG.play(SndHit);
      return false;
    }
    
    public function moveTo(px:Number, py:Number, speed:Number):void {
      var to:Point = new Point(px, py)
      velocity = new Point((to.x - x) / speed, (to.y - y) / speed)
      _pathCallback = function():Boolean {
        return (Point.distance(to, new Point(x, y)) < 5)
      }
    }

    public function home(player:Player, speed:Number):void {
      _pathCallback = function():Boolean {
        velocity = new Point((player.x - x) / speed, (player.y - y) / speed)
        return (Point.distance(new Point(player.x, player.y), new Point(x, y)) < 5)
      }
    }
    
    public function processPath():void {
      
      if (!_path) return;
      
      var i:Object = _path.shift()
      _pathCallback = null;
      
      switch(i.type) {
        case "start":
          x = i.dest[0]
          y = i.dest[1]
          processPath()
          break;
        case "home":
          home(i.player, 1)
          break;
        case "goto":
          moveTo(i.dest[0], i.dest[1], (i.speed || 2))
          break;    
        case "delay":
          velocity = new Point(0, 0)
          var t2:uint = getTimer()  + (i.secs * 1000);          
          _pathCallback = function():Boolean {
            return (getTimer() > t2);
          }
          break;
        case "vunerable":
          _vunerable = true
          processPath();
          break;
        default:
          _path = null;
          kill()
      }
    }
    
    public function spawn(path:Array, Text:String, color:uint, strength:Number, enemyShared:Object):void {
      width = 16 * Text.length
      text = Text
      size = 16
      _path = path
      _pathOffset = 0
      _strength = strength
      _enemyShared = enemyShared
      
      setFormat("system",16,color)
      
      width = _tf.textWidth
      _pathCallback = null;
      _vunerable = true;
      _deathAt = getTimer() + 12000
            
      exists = true
      dead = false
      processPath()
    }
  
    public function vunerable():Boolean {
      return _vunerable;
    }
    
    override public function update():void {
      super.update();
      if ((_pathCallback != null) && _pathCallback()) processPath()
      
      if (getTimer() > _deathAt) kill();
    }
  }    
}