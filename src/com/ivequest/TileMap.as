package com.ivequest 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EnterFrameEvent;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	public class TileMap extends Sprite
	{
		private var camera:Camera;
		private var tiles:Array;
		private var map:Array;
		private var tileSize:int;
		private var halfTileSize:int;
		
		private var canvas:RenderTexture;
		private var clear:Quad;

		public function TileMap(tileset:String, mapData:Array, worldCamera:Camera)
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void {

				removeEventListener(Event.ADDED_TO_STAGE, init);

				buildTileSet(tileset);
				map    = mapData;
				camera = worldCamera;
			
				clear        = new Quad(camera.screenSize.width, camera.screenSize.height);
				canvas       = new RenderTexture(camera.screenSize.width, camera.screenSize.height);
				tileSize     = (tiles[1] as Image).width;
				halfTileSize = tileSize / 2;

				addEventListener(Event.ENTER_FRAME, drawFrame);
				
				//Add the rendertexture to displaylist - all rendering of tile map is done on the rendertexture
				addChild(new Image(canvas));
			});
		}

		public function buildTileSet(tileset:String):void
		{

			var textures:Vector.<Texture> = AssetManager.getTextureAtlas(tileset).getTextures();
			tiles = new Array();
			tiles.push(null);     //Index 0 is not used
			for each (var texture:Texture in textures)
			{
				tiles.push(new Image(texture));
			}
		}
		
		protected function mapToWorld(mapPoint:Point):Point
		{
			return new Point(mapPoint.x * tileSize, mapPoint.y * tileSize);
		}
		
		protected function worldToMap(worldPoint:Point):Point
		{
			return new Point(worldPoint.x / tileSize, worldPoint.y / tileSize);
		}
		
		
		protected function worldToScreen(worldPoint:Point):Point
		{
			return worldPoint.subtract(camera.worldPos).add(camera.screenOffset);
		}
		
		protected function screenToWorld(screenPoint:Point):Point
		{
			return screenPoint.add(camera.worldPos).subtract(camera.screenOffset);
		}

		/**
		 * Rendering methods
		 */
		protected function drawFrame(event:EnterFrameEvent):void
		{
			//Redraw the map to the rendertexture in a "bundled" render so 
			//that only one batch render is made to the GPU
			canvas.drawBundled(drawMap);
		}

		protected function drawMap():void
		{
			var tileBounds:Rectangle;
			
			if (map == null) return;
			
			//Clear the texture by rendering the 'clear' quad
			canvas.draw(clear);
			
			//Loop through each tile at map-space coordinate (i,j)
			for (var j:int = 0; j < map.length; j++)
			{
				for (var i:int = 0; i < map[0].length; i++)
				{
					var screenPoint:Point;

					//Transform map-space to world-space (orthographic or isometric) to screen-space
					screenPoint = worldToScreen(mapToWorld(new Point(i, j)));

					//Ignore non-visible tiles
					tileBounds = new Rectangle(screenPoint.x - tileSize, screenPoint.y - tileSize, tileSize*2, tileSize*2);
					if (camera.screenSize.bounds.intersects(tileBounds) == false) continue;
					
					var tile:Image = tiles[map[j][i]];
					tile.x = screenPoint.x;
					tile.y = screenPoint.y;					
					canvas.draw(tile);
				}
			}
		}
	}

}