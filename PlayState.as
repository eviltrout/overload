package
{
  import org.flixel.*;
  import flash.net.*;
  import flash.events.*;
  import flash.utils.*;
  import flash.display.BitmapData;
  import flash.geom.Point;
  
  public class PlayState extends FlxState
  {
    [Embed(source = 'data/pipes.png')] private var ImgTiles:Class;
    [Embed(source = 'data/map.txt', mimeType = "application/octet-stream")] private var DataMap:Class;
    [Embed(source = 'data/small_pipes.png')] private var ImgTilesSmall:Class;
    [Embed(source = 'data/map_small.txt', mimeType = "application/octet-stream")] private var DataMapSmall:Class;
    [Embed(source = "data/wave_bonus.mp3")] private var SndWaveBonus:Class;
    
    private static const MAX_BULLETS:uint = 50
    private static const MAX_FLOATERS:uint = 4
    private static const MAX_EXPLOSIONS:uint = 30
    private static const MAX_ENEMIES:uint = 250
    
    private static const MAX_LIVES:uint = 10
    private static const DEFAULT_LIVES:uint = 2
    private static const INVINCIBLE_SECS:uint = 5
    private static const LONG_INVINCIBLE_SECS:uint = 15
    
    private static const FIRST_SPAWN_AT:uint = 4000
    
    private static const COLORS:Array = [0xffffffff, 0xff3333, 0xffff33, 0xffff00, 0xff0000, 0xff00ff00]
        
    private var _player:Player;
    private var _playerFeet:PlayerFeet;
    private var _playerBullets:Array;
    private var _explosions:Array;
    private var _map:FlxTilemap;
    private var _mapSmall:FlxTilemap;
    
    private var _enemies:Array;
    private var _currentEnemy:Number = 0;
    private var _spawnTime:Number=6000
    private var _spawnAt:uint
    private var _currentExplosion:Number=0


    private var _lives:Array;
    
    private var _powerUp:PowerUp;
        
    // Layers
    private var _sprites:FlxLayer;
    private var _hudLayer:FlxLayer;
    private var _pipesLayer:FlxLayer;
    private var _smallPipesLayer:FlxLayer;
    private var _floatersLayer:FlxLayer;
    
    private var _livesLeft:Number;
    private var _score:FlxText;
    private var _bonus:FlxText;

    private var _wave:Number;
    
    public function PlayState()
    {
      super();

      FlxG.score = 0
      _wave = 0

      var i:Number;
      
      // Create background layer        
      this.add(new StarsLayer())

      // Create pipes layer 
      _floatersLayer = new FlxLayer();
      for(i=0; i<MAX_FLOATERS; i++)
        _floatersLayer.add(new Floater(i * 200, i))
      this.add(_floatersLayer)
            
      _smallPipesLayer = new FlxLayer();
      _mapSmall = new FlxTilemap();
      _mapSmall.loadMap(new DataMapSmall(), ImgTilesSmall)
      _smallPipesLayer.add(_mapSmall)
      _mapSmall.x = 0
      this.add(_smallPipesLayer)

      _pipesLayer = new FlxLayer();
      _map = new FlxTilemap();
      _map.loadMap(new DataMap(), ImgTiles)
      _pipesLayer.add(_map)
      _map.x = 0
      this.add(_pipesLayer)


          
      // Create sprites layer
      _sprites = new FlxLayer();
      _enemies = new Array();
      _playerBullets = new Array();
      _explosions = new Array()

      for(i=0; i<MAX_EXPLOSIONS; i++)
        _explosions.push(_sprites.add(new Explosion()))
        
      for(i=0; i<MAX_ENEMIES; i++)
        _enemies.push(_sprites.add(new Enemy()))
        _player = new Player(_playerBullets)
      _sprites.add(_player);
      
      _playerFeet = new PlayerFeet(_player)
      _sprites.add(_playerFeet)
      
      for(i=0; i<MAX_BULLETS; i++)
        _playerBullets.push(_sprites.add(new PlayerBullet()));
        
      _powerUp = new PowerUp()
      _sprites.add(_powerUp)
      
      this.add(_sprites)
      
      FlxState.bgColor = 0;
      
      // Create HUD layer
      _hudLayer = new FlxLayer();
      _score = new FlxText(3,3,300,"0")
      _score.setFormat("system",16,0xfffff00)
      _hudLayer.add(_score)
      showScore()
      
      _bonus = new FlxText(320,3,300,"Wave Bonus!")
      _bonus.setFormat("system",12,0xffff00)
      _bonus.visible = false
      _hudLayer.add(_bonus)
      
      
      _livesLeft = DEFAULT_LIVES
      _lives = new Array()
      for(i=0; i<MAX_LIVES; i++)
        _lives.push(_hudLayer.add(new Life(i)))
      this.add(_hudLayer)
      showLives()
      
      _spawnAt = getTimer() + FIRST_SPAWN_AT      
      spawnEnemy()
    }
        
    override public function update():void
    {
      super.update();

      _map.x -= 1
      if (_map.x < -1850) _map.x = FlxG.width
      _mapSmall.x -= 0.5
      if (_mapSmall.x < -1280) _mapSmall.x = FlxG.width
      
      FlxG.overlapArray(_enemies,_player,enemyHitPlayer);
      FlxG.overlapArrays(_enemies,_playerBullets,bulletHitEnemy);
      
      if (_bonus.visible) {
        _bonus.alpha -= 0.01
        if (_bonus.alpha <= 0) _bonus.visible = false 
      }
      
      if (!_powerUp.dead && _powerUp.overlaps(_player)) {
	
		    _powerUp.taken()
        _player.powerUp(_powerUp.powerType)
        
        switch (_powerUp.powerType) {
          case PowerUp.BOMB_TYPE: 
            bombAll()
            break;
          case PowerUp.EXTRA_LIFE_TYPE:
            _livesLeft++
            if (_livesLeft >= MAX_LIVES) _livesLeft = MAX_LIVES
            showLives()
            break;
          case PowerUp.INVINCIBLE_TYPE:
            if (!_player.flickering()) flickerPlayer(LONG_INVINCIBLE_SECS);
            break;
        }
          
        _powerUp.kill()
      }
      
      var now:uint = getTimer()
      if (now >= _spawnAt) {
        spawnEnemy()
        _spawnAt = now + _spawnTime
      }

    }
    
    public function bombAll():void {
      for each (var e:FlxSprite in _enemies) {
        if (!e.dead && e.exists)
          killEnemy(Enemy(e), true)
      }
      FlxG.flash(0xffffffff, 0.4);
    }
    
    private function newExplosion(X:Number, Y:Number, silent:Boolean=false):void {
      var sf:Number = (Math.random() * 0.5) + 0.5
      var halfSize:Number = (32 * sf)
      _explosions[_currentExplosion].explode(X - halfSize, Y - halfSize, sf, silent)
      _currentExplosion += 1
      if (_currentExplosion >= _explosions.length)
        _currentExplosion = 0
    }
    
    private function killEnemy(enemy:Enemy, silent:Boolean = false):void {
      
      if (enemy.wordDown() == 0) {
        _bonus.visible = true
        _bonus.alpha = 1
        _bonus.x = _player.x - 25
        _bonus.y = _player.y - 30
        _bonus.velocity.y = -10
        FlxG.play(SndWaveBonus)
        FlxG.score += 500
      }
      newExplosion(enemy.x + (enemy.width / 2), enemy.y + (enemy.height / 2), silent)
      newExplosion(enemy.x + enemy.width, enemy.y + (enemy.height / 2), silent)
      
      enemy.kill()
      var score:Number = (100 - enemy.width)
      if (score < 5) score = 5;
      FlxG.score += score
      showScore()
    }
    
    private function bulletHitEnemy(spr:FlxSprite,bullet:FlxSprite):void {
      bullet.kill()

      var enemy:Enemy = Enemy(spr)
      if (enemy.vunerable() && enemy.hit() ) {
        killEnemy(enemy)            
        if (_powerUp.dead && (Math.random() < 0.02)) {
          _powerUp.spawn(enemy.x + (enemy.width / 2) - 9, enemy.y + (enemy.height / 2) - 9)
        }
      }
      
    }

    private function flickerPlayer(l:uint=INVINCIBLE_SECS):void {
      _player.flicker(l)
      _playerFeet.flicker(l)
    }
    
    private function enemyHitPlayer(enemy:FlxSprite,player:FlxSprite):void {
      
      if (_player.flickering()) return
      
      newExplosion(player.x + (player.width / 2), player.y + (player.height / 2))

      player.kill()
      _playerFeet.kill()
      _livesLeft--
      
      _wave = Math.floor(_wave / 4)
      
      if (_livesLeft < 0) {
        FlxG.switchState(GameOverState);
      } else {
        setTimeout(function():void {
          showLives()
          _playerFeet.reset(0,0)
          _player.restart()
          flickerPlayer()
        }, 1000)
      }
    }
        
    private function createEnemy(sentence:String):void {
    
      var x:Number = 450
      var y:Number = 200
      
      var maxStrength:Number
      if (_wave < 4) {
        maxStrength = 1
      } else if (_wave < 8) {
        maxStrength = 2
      } else if (_wave < 16) {
        maxStrength = 3
      } else if (_wave < 25) {
        maxStrength = 4
      } else if (_wave < 32) {
        maxStrength = 5
      }

      var strength:Number = Math.floor(Math.random() * maxStrength)
      var col:uint = COLORS[Math.min(strength, COLORS.length-1)]
      var split_tokens:Array = sentence.split(/ +/)
      var split_up:Array = new Array();
      
      for each (var w1:String in split_tokens) {
        if (w1 != null && (w1.length > 0))
          split_up.push(w1) 
      }
            
      var words:Number = split_up.length
      
      var i:Number = 0;
      var randomY:Number = (Math.random() * 400) + 40;
      var divided:Number = (480 / words)
      var offset:Number = (240 - ((words - 1) * divided / 2)) - 10
      
      // Some possibilities for the wave left up to random chance
      var home:Boolean = Math.random() > 0.5;      
      var explodeRight:Boolean = Math.random() > 0.5;
      var explodeLeft:Boolean = Math.random() > 0.5;      

      var enemyShared:Object = {wordsLeft:words}
      
      if (_wave < 8) home = false;
            
      for each (var w:String in split_up) {
        
        var e:Enemy = _enemies[_currentEnemy]
        _currentEnemy +=1 
        if (_currentEnemy >= _enemies.length) _currentEnemy = 0
        
        var path:Array = new Array();
        
        // Can either come from one point, or directly sideways
        var destY:Number = explodeRight ? randomY : offset + (i*divided)
        path.push({type:"start", dest:[640, destY]})
        
        path.push({type:"goto", dest:[480, offset + (i*divided)], speed:1})
        
        // Delay increases with difficulty
        var d:Number=0;
        if (_wave < 6) {
          d = 3
        } else if (_wave < 12) {
          d = 2
        } else if (_wave < 18) {
          d = 1
        }
        
        path.push({type:"delay", secs:2})
        
        // Two strategies. Home in or go straight
        if (home) {
          path.push({type:"home", player:_player})
        } else {
          destY = explodeLeft ? (Math.random() * 400) + 40 : offset + (i*divided)
          path.push({type:"goto", dest:[-50, destY], speed:d})          
        }
        
        e.spawn(path, w, col, strength, enemyShared)
        i += 1
      }        
      
      _spawnTime -= 125
      if (_spawnTime < 3000) _spawnTime = 3000
      _wave++
    }
    
    private function spawnEnemy():void {
      var title:String = FlxG.levels[_wave % FlxG.levels.length]
      
      // If we can't spawn something, try again soon.
      if (title != null && title.length > 2) {
        createEnemy(title)
      } else {
        _spawnAt = getTimer() + 50
      }
    }
    
    private function showScore():void {
      _score.text = "Score: " + FlxG.score.toString()
    }
    
    private function showLives():void {
      for (var i:uint=0; i<MAX_LIVES; i++)
        _lives[i].visible = (i < _livesLeft)
    }
    
  }
}