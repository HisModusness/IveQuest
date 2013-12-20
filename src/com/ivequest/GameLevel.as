package com.ivequest 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.Event;
	import starling.events.EnterFrameEvent;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	/**
	 * The superclass of all levels. Maintains some values such as when the level is over, what its background is, and how big the stage is for reference.
	 * @author Liam Westby
	 */
	public class GameLevel extends Sprite
	{
		protected const TILE_WIDTH:int = 64;
		protected const TILE_HEIGHT:int = 64;
		protected const TILES_WIDE:int = 20;
		protected const TILES_HIGH:int = 20;
		protected const VIEW_WIDTH:int = 800;
		protected const VIEW_HEIGHT:int = 600;
		
		protected var camera:Camera;
		protected var tiles:Array;
		protected var map:Array = [
				[1, 2, 2, 2, 3, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[4, 5, 5, 5, 6, 10, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3],
				[4, 5, 5, 5, 6, 10, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9],
				[4, 5, 5, 5, 6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[4, 5, 5, 5, 6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[7, 8, 8, 8, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[1, 2, 2, 2, 2, 2, 2, 3, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[4, 5, 5, 5, 5, 5, 5, 6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[4, 5, 5, 5, 5, 5, 5, 6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[4, 5, 5, 5, 5, 5, 5, 6, 1, 2, 3, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[4, 5, 5, 5, 5, 5, 5, 6, 4, 5, 6, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[7, 8, 8, 8, 8, 8, 8, 9, 7, 8, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
				[10, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3],
				[10, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6],
				[10, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6],
				[10, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6],
				[10, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6],
				[10, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9],
				[10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
			];
		protected var tileSize:int;
		protected var halfTileSize:int;
		protected var tileMapped:Boolean = false;
		
		protected var background:Image;
		
		protected var canvas:RenderTexture;
		protected var clear:Quad;
		protected var entities:Vector.<GameEntity>;
		
		protected const stageWidth:int = TILE_WIDTH * TILES_WIDE;
		protected const stageHeight:int = TILE_HEIGHT * TILES_HIGH;
		
		protected var done:Boolean = false;
		protected var over:Boolean = false;
		
		// Adapted from TileMap demo by R Middleton
		public function GameLevel(tileset:String, worldCamera:Camera) 
		{
			super();
			if (tileset != null && worldCamera != null)
			{
				tileMapped = true;
				buildTileSet(tileset);
				camera = worldCamera;

				addEventListener(Event.ADDED_TO_STAGE, initTiles);
			}
			
		}
		
		public function initTiles(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initTiles);

				
			
			clear        = new Quad(camera.screenSize.width, camera.screenSize.height);
			canvas       = new RenderTexture(camera.screenSize.width, camera.screenSize.height);
			tileSize     = (tiles[1] as Image).width;
			halfTileSize = tileSize / 2;

			// addEventListener(Event.ENTER_FRAME, drawFrame);
				
			//Add the rendertexture to displaylist - all rendering of tile map is done on the rendertexture
			addChildAt(new Image(canvas), 0);
		}
		
		public function tick():void
		{
			for each (var entity:GameEntity in entities)
			{
				entity.tick();
			}
			checkCollisions();
			
			//Redraw the map to the rendertexture in a "bundled" render so 
			//that only one batch render is made to the GPU
			if (tileMapped) canvas.drawBundled(drawMap);
		}
		
		public function checkCollisions():void
		{
			var bounds:Rectangle, otherBounds:Rectangle;
			
			for each (var entity:GameEntity in entities)
			{
				for each (var other:GameEntity in entities)
				{
					if (entity == other) continue;
					
					bounds = entity.getWorldBounds();
					otherBounds = other.getWorldBounds();
					
					if (bounds.intersects(otherBounds))
					{
						entity.handleCollision(other);
					}
				}
			}
		}
		
		public function keyPressed(event:KeyboardEvent):void
		{
			
		}
		
		public function keyReleased(event:KeyboardEvent):void
		{
			
		}
		
		public function handleTouch(touch:Touch):void
		{
			
		}
		
		public function isDone():Boolean
		{
			return done;
		}
		
		public function isOver():Boolean
		{
			return over;
		}
		
		
		// Adapted from TileMap demo by R Middleton
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
			
			// And now for entities
			for each(var e:GameEntity in entities)
			{
				//if (!camera.screenSize.bounds.intersects(e.getWorldBounds())) continue;
				
				var entityPoint:Point = worldToScreen(e.getWorldPosition());
				e.x = entityPoint.x;
				e.y = entityPoint.y;
				canvas.draw(e);
			}
		}
	}

}