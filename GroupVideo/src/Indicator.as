package {
	import flash.display.Sprite;
	import mx.controls.*;
	public class Indicator extends Sprite {
		
		private var _w:uint;
		private var _h:uint;
		private var _bColor:uint;
		private var _bgColor:uint;
		private var _fColor:uint;
		private var _current:Number;
		public function Indicator(w:uint=150,h:uint=15,borderColor:uint=0x000000,bgColor:uint=0xffffff,fillColor:uint=0x33ff00,current:Number=0.3):void {
			
			this._w=w;
			this._h=h;
			this._bColor=borderColor;
			this._bgColor=bgColor;
			this._fColor=fillColor;
			this._current=current;
			if (_current>=1) {
				_current=1;
			} else if (_current<=0) {
				_current=0;
			}
			init();
		}
		public function set Current(v:Number):void {			
			_current=v;
			if (_current>=1) {
				_current=1;
			} else if (_current<=0) {
				_current=0;
			}			
			init();
		}	
		public function get Current():Number {
			return (_current);
		}
		private function init():void {			
			graphics.clear();
			graphics.lineStyle(1,_bColor);
			//先画背景色
			graphics.beginFill(_bgColor);
			graphics.drawRect(-1*_w/2,-1*_h/2,_w,_h);
			graphics.endFill();
			//再画当前值
			graphics.lineStyle(1,_bColor,0);
			graphics.beginFill(_fColor);
			var _per:Number=_w*_current;
			graphics.drawRect(-1*_w/2 +0.5  ,-1*_h/2 +0.5,_per,_h-1);
			graphics.endFill();
		}
	}
}
