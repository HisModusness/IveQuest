package com.ivequest
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starling.events.Event;

	// Adapted from TileMap demo by R Middleton
	public class Camera 
	{
		public var worldPos:Point;
		public var bounds:Rectangle;
		public var screenSize:Quad;
		public var tileSize:int;
		public var screenOffset:Point;
		
		public function Camera(x:int, y:int, width:int, height:int, tileSize:int)
		{
			worldPos      = new Point(x, y);
			bounds        = new Rectangle(x - width / 2, y - height / 2, width, height);
			screenSize    = new Quad(width, height);
			screenOffset  = new Point(width / 2, height / 2);
			this.tileSize = tileSize;	
		}

		public function getResolution():Quad { return screenSize; }
		public function moveX(xoff:int):void { worldPos.x += xoff; }
		public function moveY(yoff:int):void { worldPos.y += yoff; }
		public function setPosition(pos:Point):void 
		{ 
			worldPos = pos;
			if (worldPos.x < screenOffset.x) worldPos.x = screenOffset.x;
			else if (worldPos.x > tileSize * 20 - screenOffset.x) worldPos.x = tileSize * 20 - screenOffset.x;
			
			if (worldPos.y < screenOffset.y) worldPos.y = screenOffset.y;
			else if (worldPos.y > tileSize * 20 - screenOffset.y) worldPos.y = tileSize * 20 - screenOffset.y;
		}
	}
}