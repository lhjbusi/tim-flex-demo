package com.codyy.ppmeet.net
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.util.*;
    import flash.net.*;
    import flash.utils.*;

    public class NetworkTraffic extends Object
    {
        public var ns:NetStream = null;
        public var s:String = "";
        public static var nt:Array = new Array();
        public static var upload:Object = {};
        public static var download:Object = {};

        public function NetworkTraffic(param1:String, param2:NetStream)
        {
            this.s = param1;
            this.ns = param2;
            return;
        }// end function

        public function processUpload() : void
        {
            WebHelp.info("processUpload");
            if (!Constans.NETWORD_TRAFFIC)
            {
                return;
            }
            setInterval(function ()
            {
                var _loc_1:* = ns.info;
                NetworkTraffic.upload[s] = _loc_1.currentBytesPerSecond;
                return;
            }// end function
            , 1000);
            return;
        }// end function

        public function processDownload() : void
        {
            WebHelp.info("processDownload");
            if (!Constans.NETWORD_TRAFFIC)
            {
                return;
            }
            setInterval(function ()
            {
                var _loc_1:* = ns.info;
                NetworkTraffic.download[s] = _loc_1.currentBytesPerSecond;
                return;
            }// end function
            , 1000);
            return;
        }// end function

        public static function display() : void
        {
            WebHelp.info("processDisplay");
            if (!Constans.NETWORD_TRAFFIC)
            {
                return;
            }
            setInterval(function ()
            {
                NetworkTraffic.processDisplay();
                return;
            }// end function
            , 1000);
            return;
        }// end function

        public static function processDisplay() : void
        {
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            if (!Constans.NETWORD_TRAFFIC)
            {
                return;
            }
            var _loc_1:Number = 0;
            var _loc_2:Number = 0;
            var _loc_3:* = "";
            for (_loc_4 in NetworkTraffic.upload)
            {
                
                _loc_1 = _loc_1 + NetworkTraffic.upload[_loc_4];
                _loc_3 = _loc_3 + (_loc_4 + ",");
            }
            for (_loc_5 in NetworkTraffic.download)
            {
                
                _loc_2 = _loc_2 + NetworkTraffic.download[_loc_5];
                _loc_3 = _loc_3 + (_loc_5 + ",");
            }
            WebHelp.evalJS("netstat(\"" + _loc_3 + "\",[" + Math.ceil(_loc_1 / 1024) + " ," + Math.ceil(_loc_2 / 1024) + "])");
            return;
        }// end function

    }
}
