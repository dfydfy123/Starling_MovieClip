package com.test 
{
    import com.ding.display.MovieClip;
    import starling.core.Starling;
	import starling.display.Sprite;
    import starling.textures.TextureAtlas;
    import starling.utils.AssetManager;
	
	/**
     * ...
     * @author Ding Ding
     */
    public class TestExample extends Sprite 
    {
        private var _assets:AssetManager;
        
        public function TestExample() 
        {
            _assets = new AssetManager();
            
            _assets.enqueue("init.xml");
            _assets.enqueue("movies.xml");
            _assets.enqueue("texture.png");
            _assets.loadQueue(onProgress);
        }
        
        private function onProgress(ratio:Number):void 
        {
            if (ratio >= 1.0)
            {
                init();
            }
        }
        
        private function init():void 
        {
            var xml:XML;
            var boyXml:XML;
            var girlXml:XML;
            var labaXml:XML;
            var atlas:TextureAtlas;
            
            atlas = _assets.getTextureAtlas("texture");
            xml = _assets.getXml("movies");
            
            boyXml = xml.movie[0];
            girlXml = xml.movie[1];
            labaXml = xml.movie[2];
            
            var mc:MovieClip;
            
            mc = new MovieClip();
            mc.create(atlas, girlXml);
            addChild(mc);
            Starling.juggler.add(mc);
            
            mc = new MovieClip();
            mc.create(atlas, boyXml);
            mc.x = 200;
            addChild(mc);
            Starling.juggler.add(mc);
            
            mc = new MovieClip();
            mc.create(atlas, labaXml);
            mc.x = 200;
            mc.y = 200;
            addChild(mc);
            Starling.juggler.add(mc);
        }
        
    }

}