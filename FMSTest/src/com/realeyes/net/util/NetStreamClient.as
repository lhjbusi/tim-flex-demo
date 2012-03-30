package com.realeyes.net.util
{
	import flash.events.EventDispatcher;

	// this class is used as a net stream client
	// the purpose of this class is to provide callbacks
	// for the net stream to invoke.
	public class NetStreamClient extends EventDispatcher
	{
		public function NetStreamClient()
		{
		}
		
		public function onNetStreamReceive( data:Object ):void
		{
			//trace( ObjectUtil.toString( data ) );
			
			// let's dispatch the data to whoever is listening
			dispatchEvent( new NetStreamDataEvent( NetStreamDataEvent.DATA_RECEIVED, data ) );
		}
	}
}