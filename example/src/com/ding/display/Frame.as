package com.ding.display 
{
	/**
     * ...
     * @author Ding Ding
     */
    public class Frame
    {
        private var _name:String;
        private var _duration:Number;
        private var _script:String;
        private var _images:Array;
        
        public function Frame() 
        {
            _duration = 1.0 / 12;
            _images = [];
        }
        
        public function addImage(x:Number, y:Number, value:String):void
        {
            _images.push( { x:x, y:y, value:value } );
        }
        
        public function addImages(list:XMLList):void
        {
            var i:int;
            var value:String;
            var xml:XML;
            var x:Number, y:Number;
            
            for (i = 0; i < list.length(); i++)
            {
                xml = list[i];
                x = Number(xml.@x);
                y = Number(xml.@y);
                value = xml;
                addImage(x, y, value);
            }
        }
        
        public function get duration():Number 
        {
            return _duration;
        }
        
        public function set duration(value:Number):void 
        {
            _duration = value;
        }
        
        public function get script():String 
        {
            return _script;
        }
        
        public function set script(value:String):void 
        {
            _script = value;
        }
        
        public function get name():String 
        {
            return _name;
        }
        
        public function set name(value:String):void 
        {
            _name = value;
        }
        
        public function get images():Array
        {
            return _images;
        }
        
    }

}