package
{
    import com.test.TestExample;
	import flash.display.Sprite;
    import starling.core.Starling;
	
	/**
	 * ...
	 * @author Ding Ding
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			var starling:Starling = new Starling(TestExample, stage);
            starling.showStats = true;
            starling.start();
		}
		
	}
	
}