package com.codyy.ppmeet.util
{
    import com.codyy.ppmeet.*;
    import flash.events.*;
    import flash.external.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class WebUtil extends Object
    {
        private var sv:SpeakerVideo = null;

        public function WebUtil(param1:SpeakerVideo)
        {
            this.sv = param1;
            setTimeout(this.MicVolume, 100);
            return;
        }// end function

        public function MicVolume()
        {
            var mic:*;
            var activity:Function;
            activity = function (param1)
            {
                var _loc_2:* = mic.activityLevel;
                sv.mc.gotoAndStop(_loc_2);
                return;
            }// end function
            ;
            mic = getMic(true);
            mic.addEventListener(ActivityEvent.ACTIVITY, activity);
            return;
        }// end function

        public static function setCamH264Setting(param1:NetStream) : NetStream
        {
            return param1;
        }// end function

        public static function getMic(param1:Boolean = false, param2:SpeakerVideo = null) : Microphone
        {
            var _loc_3:Microphone = null;
            _loc_3 = Microphone.getMicrophone();
            _loc_3.setUseEchoSuppression(true);
            _loc_3.setLoopBack(true);
            _loc_3.rate = 44;
            _loc_3.gain = 60;
            try
            {
                _loc_3.noiseSuppressionLevel = -10;
            }
            catch (e)
            {
            }
            _loc_3.setSilenceLevel(1, 1000);
            Constans.LOOKBACK = true;
            Constans.setMic(_loc_3);
            return _loc_3;
        }// end function

        public static function DMT(param1) : void
        {
            return;
        }// end function

        public static function info(param1) : void
        {
            if (Constans.DEBUG)
            {
                trace(param1);
                callJS("DM", param1 + "");
            }
            return;
        }// end function

        public static function addCallBack(param1:String, param2:Function) : void
        {
            ExternalInterface.addCallback(param1, param2);
            return;
        }// end function

        public static function callJS(param1:String, param2) : Object
        {
            return ExternalInterface.call(param1, param2);
        }// end function

        public static function sendMsg(param1:Object) : void
        {
            callJS("flash_call", "<root from =\'" + (param1.from || "sys") + "\' c=\'" + (param1.act || "sys") + "\' to=\'" + (param1.to || "*") + "\' type=\'" + (param1.type || "group") + "\' say=\'" + encodeURI(param1.say || "") + "\' time=\'" + new Date().toString() + "\' />");
            return;
        }// end function

        public static function openUrl(param1:String, param2:String) : void
        {
            if (param2 == null || param2.length < 1)
            {
                param2 = "_blank";
            }
            navigateToURL(new URLRequest(param1), param2);
            return;
        }// end function

        public static function alert(param1)
        {
            if (!Constans.DEBUG)
            {
                return;
            }
            ExternalInterface.call("alert", param1 + "");
            return;
        }// end function

        public static function salert(param1)
        {
            ExternalInterface.call("alert", param1 + "");
            return;
        }// end function

        public static function _logMsg(param1:String) : void
        {
            return;
        }// end function

        public static function ajaxCall(param1:String, param2:Object, param3)
        {
            var i:*;
            var loader:URLLoader;
            var loader_complete:Function;
            var loader_security:Function;
            var loader_ioError:Function;
            var url:* = param1;
            var postData:* = param2;
            var callBack:* = param3;
            loader_complete = function (event:Event) : void
            {
                if (callBack)
                {
                    callBack(loader.data.nearID);
                    ;
                }
                return;
            }// end function
            ;
            var loader_httpStatus:* = function (param1) : void
            {
                alert("HTTPStatusEvent.HTTP_STATUS");
                alert("HTTP ×´Ì¬´úÂë : " + param1.state);
                return;
            }// end function
            ;
            loader_security = function (param1) : void
            {
                alert("SecurityErrorEvent.SECURITY_ERROR");
                return;
            }// end function
            ;
            loader_ioError = function (param1) : void
            {
                alert("IOErrorEvent.IO_ERROR");
                return;
            }// end function
            ;
            var request:* = new URLRequest(url);
            var vars:* = new URLVariables();
            var _loc_5:int = 0;
            var _loc_6:* = postData;
            while (_loc_6 in _loc_5)
            {
                
                i = _loc_6[_loc_5];
                vars[i] = postData[i];
            }
            request.data = vars;
            request.method = URLRequestMethod.POST;
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            loader.addEventListener(Event.COMPLETE, loader_complete);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_security);
            loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError);
            loader.load(request);
            return;
        }// end function

    }
}
