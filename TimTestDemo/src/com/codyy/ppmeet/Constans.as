package com.codyy.ppmeet
{
    import flash.media.*;
    import flash.net.*;

    public class Constans extends Object
    {
        public static var RTMFP_SERVER:String = "rtmfp://stratus.adobe.com/";
        public static var RTMFP_DEVKEY:String = "c50af1426e2afbd7d1147903-e331e5f149d2";
        public static var RTMP_SERVER:String = "rtmp://rtmp.codyy.net/oflaDemo";
        public static var RTMP_USER:String = "codyy";
        public static var DEBUG:Boolean = false;
        public static var FILE_DEBUG:Boolean = false;
        public static var NETWORD_TRAFFIC:Boolean = false;
        public static var P2P:Boolean = false;
        public static var MSG_COUNT:Number = 10;
        public static var RTMP_LINE:Number = 0;
        public static var RTMP_VIDEO:String = "";
        public static var params:Object = "";
        public static var E_CODE:Object = "";
        public static var CONNECTIONS:Array = new Array();
        public static var NET_STREAMS:Array = new Array();
        public static var IS_CLOSE:Boolean = false;
        public static var PUBLIC_MIC:Microphone = null;
        public static var IS_CAMERA_CHECK:Boolean = false;
        public static var LOOKBACK:Boolean = true;
        public static var HAS_CAMEAR:Boolean = true;
        public static var MEET_TYPE:int = 1;
        public static var MEET_MODEL:int = 1;
        public static var HOST_IMG:String = "";
        public static var MIX_VIDEO:Boolean = false;
        public static var MIC_VOLUME:Number;
        public static var MIC_GAIN:Number = 60;
        public static var IS_AEC:Number = 0;
        public static var GROUP_ID:String = "";

        public function Constans()
        {
            return;
        }// end function

        public static function pushConnection(param1:NetConnection)
        {
            CONNECTIONS.push(param1);
            return;
        }// end function

        public static function pushNetStream(param1:NetStream)
        {
            NET_STREAMS.push(param1);
            return;
        }// end function

        public static function setMic(param1:Microphone)
        {
            PUBLIC_MIC = param1;
            return;
        }// end function

    }
}
