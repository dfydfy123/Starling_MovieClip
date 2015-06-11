package com.ding.display 
{
    import starling.animation.IAnimatable;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
	
	/**
     * ...
     * @author Ding Ding
     */
    public class MovieClip extends DisplayObjectContainer implements IAnimatable
    {
        private var _frames:Vector.<Frame>;
        private var _images:Vector.<Image>;
        private var _currentFrame:uint;
        private var _isPlaying:Boolean;
        private var _loop:Boolean;
        private var _currentTime:Number;
        private var _atlas:TextureAtlas;
        private var _empty:Texture;
        
        public function MovieClip() 
        {
            _loop = true;
            _isPlaying = true;
            _currentTime = 0.0;
            _empty = Texture.empty(2, 2);
            
            _frames = new Vector.<Frame>();
            _images = new Vector.<Image>();
        }
        
        public function play():void
        {
            _isPlaying = true;
        }
        
        public function stop():void
        {
            _isPlaying = false;
        }
        
        public function gotoAndPlay(frame:Object):void
        {
            checkFrame(frame, true);
        }
        
        public function gotoAndStop(frame:Object):void
        {
            checkFrame(frame, false);
        }
        
        private function checkFrame(frame:Object, isBool:Boolean):void
        {
            var name:String;
            
            if (frame is int || frame is String)
            {
                name = String(frame);
            }
            
            if (!name) return;
            
            for (var i:int = 0; i < _frames.length; i++)
            {
                if (_frames[i].name == name)
                {
                    _isPlaying = isBool;
                    _currentFrame = i;
                    updateDisplay();
                    break;
                }
            }
        }
        
        public function addFrame(frame:Frame):void
        {
            if (!frame) return;
            _frames.push(frame);
        }
        
        public function create(atlas:TextureAtlas, xml:XML):void
        {
            if (!atlas) return;
            if (!xml) return;
            
            var list:XMLList;
            var imgs:XMLList;
            var frame:Frame;
            var item:XML;
            var img:XML;
            var label:String;
            var duration:String;
            var script:String;
            var i:int;
            var x:Number, y:Number;
            var value:String;
            
            _atlas = atlas;
            
            label = xml.@name;
            name = label.length > 0 ? label : null;
            _loop = xml.@loop == "true" ? true : false;
            
            list = xml.frame;
            for (i = 0; i < list.length(); i++)
            {
                item = list[i];
                label = item.@name;
                duration = item.@duration;
                
                frame = new Frame();
                frame.name = label.length > 0 ? label : String(i);
                frame.duration = duration.length > 0 ?
                    (Number(duration) / 1000.0) : frame.duration;
                
                script = item.script;
                if (script.length > 0)
                    frame.script = trim(script);
                
                frame.addImages(item.image);
                _frames.push(frame);
            }
            
            updateDisplay();
        }
        
        private function updateDisplay():void
        {
            if (_frames.length <= 0) return;
            
            var i:int;
            var obj:Object;
            var frame:Frame;
            var image:Image;
            var texture:Texture;
            
            frame = _frames[_currentFrame];
            
            for (i = 0; i < _images.length; i++)
            {
                _images[i].visible = false;
                _images[i].x = 0;
                _images[i].y = 0;
            }
            
            for (i = 0; i < frame.images.length; i++)
            {
                obj = frame.images[i];
                texture = _atlas.getTexture(obj.value);
                
                if (i >= _images.length)
                {
                    image = new Image(texture);
                    _images.push(image);
                    addChild(image);
                }
                else
                {
                    image = _images[i];
                    image.texture = texture;
                }
                
                image.visible = true;
                image.x = obj.x;
                image.y = obj.y;
            }
        }
        
        private function trim(str:String):String
        {
            var pattern:RegExp = /^\s*|\s*$/g;
            return str.replace(pattern, "");
        }
        
        public function advanceTime(passedTime:Number):void
        {
            if (_frames.length <= 0) return;
            if (!_isPlaying) return;
            
            var frame:Frame;
            var index:uint;
            
            frame = _frames[_currentFrame];
            
            _currentTime+= passedTime;
            if (_currentTime >= frame.duration)
            {
                _currentTime = 0.0;
                
                if (frame.script)
                {
                    runScript(frame.script);
                }
                else
                {
                    index = _currentFrame;
                    index++;
                    if (index < _frames.length)
                    {
                        _currentFrame = index;
                        updateDisplay();
                    }
                    else
                    {
                        if (_loop)
                        {
                            gotoAndPlay(0);
                        }
                        else
                        {
                            _isPlaying = false;
                        }
                    }
                }
            }
        }
        
        private function runScript(script:String):void 
        {
            var cmd:String;
            var cmds:Array;
            var arg:String;
            
            cmds = script.split(";");
            
            for (var i:int = 0; i < cmds.length; i++)
            {
                cmd = cmds[i];
                if (cmd.length > 0)
                {
                    if (cmd.indexOf("stop") != -1)
                        stop();
                    
                    if (cmd.indexOf("play") != -1)
                        play();
                        
                    if (cmd.indexOf("gotoAndPlay") != -1)
                    {
                        arg = cmd.substr(cmd.indexOf("(") + 1, 
                            cmd.indexOf(")") - cmd.indexOf("(") - 1);
                        arg = trim(arg);
                        gotoAndPlay(arg);
                    }
                    
                    if (cmd.indexOf("gotoAndStop") != -1)
                    {
                        arg = cmd.substr(cmd.indexOf("(") + 1, 
                            cmd.indexOf(")") - cmd.indexOf("(") - 1);
                        arg = trim(arg);
                        gotoAndStop(arg);
                    }
                }
            }
        }
        
        public function get currentFrame():uint 
        {
            return _currentFrame;
        }
        
        public function get currentFrameLabel():String 
        {
            var label:String;
            var frame:Frame;
            
            if (_frames.length > 0)
                label = _frames[_currentFrame].name;
            
            return label;
        }
        
        public function get totalFrames():uint 
        {
            return _frames.length;
        }
        
        public function get isPlaying():Boolean 
        {
            return _isPlaying;
        }
        
        public function get loop():Boolean 
        {
            return _loop;
        }
        
        public function set loop(value:Boolean):void 
        {
            _loop = value;
        }
        
    }

}
