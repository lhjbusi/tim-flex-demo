package com.realeyes.net.util
{
	import flash.events.Event;
	
	public class NetStreamDataEvent extends Event
	{
		public static const DATA_RECEIVED:String = 'dataReceived';
		
		public var data:Object;
	
		public function NetStreamDataEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}