package com.ivequest
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	
	/**
	 * Kickoff class for the Game.
	 * @author Liam Westby
	 */
	[SWF(width="800", height="600")]
	public class Main extends Sprite
	{
		private var starling:Starling;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			starling = new Starling(Game, stage);
			starling.start();
		}
		
	}
	
}