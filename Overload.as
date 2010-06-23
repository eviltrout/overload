package {
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width="640", height="480", backgroundColor="#000000")] //Set the size and color of the Flash file
  [Frame(factoryClass="Preloader")]

	public class Overload extends FlxGame
	{
		public function Overload()
		{	  
		  super(640,480,LoadState,1); 
//		  showLogo = false;
		}
	}
}
