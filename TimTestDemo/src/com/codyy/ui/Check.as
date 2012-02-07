package com.codyy.ui {
	import com.codyy.ppmeet.*;
	import com.codyy.ppmeet.util.*;
	import fl.controls.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	public class Check extends Object {
		private var tout:uint = 0;
		private var mic:Microphone = null;
		private var AV:Number = 0;
		public static var btn:Button = new Button();

		public function Check() {
            return;
        }// end function

        public function sampling(param1:SpeakerVideo)
        {
            var sv:* = param1;
            var loader:* = new Loader();
            loader.load(new URLRequest("/public/img/meet/sampling.png"));
            try
            {
                sv.removeChild(btn);
            }
            catch (e)
            {
                WebUtil.info("btn:" + e);
            }
            btn.label = "";
            btn.width = 215;
            btn.height = 175;
            btn.useHandCursor = true;
            btn.addChild(loader);
            btn.alpha = 0.9;
            btn.addEventListener(MouseEvent.CLICK, function ()
            {
                Security.showSettings(SecurityPanel.MICROPHONE);
                sv.removeChild(btn);
                return;
            }// end function
            );
            sv.addChild(btn);
            return;
        }// end function

        public function privacyCheck():void
        {
            if (Capabilities.avHardwareDisable)
            {
                WebHelp.callJS("Codyy.checkHardware", "");
                return;
            }
            this.tout = setTimeout(function ()
            {
                var _loc_2:* = AV + 1;
                AV = _loc_2;
                if (mic && mic.muted)
                {
                    if (AV >= 0)
                    {
                        Security.showSettings(SecurityPanel.PRIVACY);
                    }
                    privacyCheck();
                }
                return;
            }// end function
            , 3000);
            return;
        }// end function

        public function checkPrivary():void
        {
            if (Microphone.names.length < 1)
            {
                return;
            }
            this.mic = Microphone.getMicrophone();
            this.mic.setUseEchoSuppression(true);
            this.mic.setLoopBack(false);
            WebUtil.info("mic status:" + this.mic.muted);
            if (this.mic.muted)
            {
                this.privacyCheck();
            }
            this.mic.addEventListener(StatusEvent.STATUS, function (event:StatusEvent):void
            {
                WebUtil.info("״̬�л���" + mic.muted);
                if (mic.muted)
                {
                    privacyCheck();
                }
                else
                {
                    clearTimeout(tout);
                }
                return;
            }// end function
            );
            return;
        }// end function

    }
}
