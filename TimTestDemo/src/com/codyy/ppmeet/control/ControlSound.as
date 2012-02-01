package com.codyy.ppmeet.control
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.util.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.utils.*;

    public class ControlSound extends Object
    {
        private var sv:SpeakerVideo = null;
        public var currentVolume:Number;
        public var currentMicVolume:Number;

        public function ControlSound(param1:SpeakerVideo)
        {
            this.currentVolume = SoundMixer.soundTransform.volume;
            this.sv = param1;
            return;
        }// end function

        public function init()
        {
            this.sv.mc.stop();
            this.sv.controlBtn.buttonMode = true;
            this.sv.controlMicBtn.buttonMode = true;
            this.sv.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.MDOWN);
            this.sv.stage.addEventListener(MouseEvent.MOUSE_UP, this.MUP);
            setInterval(function ()
            {
                var _loc_1:Number = NaN;
                var _loc_2:SoundTransform = null;
                WebHelp.evalJSDebug("document.title = \'" + Constans.PUBLIC_MIC.activityLevel + " - " + Constans.IS_AEC + "\';");
                if (Constans.params["server"] == "1" && Constans.PUBLIC_MIC.activityLevel < 0)
                {
                    WebHelp.info("麦克风声音过低，重新进行检测麦克风");
                    Constans.PUBLIC_MIC.setLoopBack(true);
                    Constans.LOOKBACK = true;
                    if (Constans.IS_AEC > 100)
                    {
                        WebUtil.getMic();
                        Constans.IS_AEC = 0;
                        WebHelp.salert("声音不激活");
                    }
                    else
                    {
                        var _loc_3:* = Constans;
                        var _loc_4:* = Constans.IS_AEC + 1;
                        _loc_3.IS_AEC = _loc_4;
                    }
                }
                if (Constans.PUBLIC_MIC)
                {
                    _loc_1 = Math.ceil(Constans.PUBLIC_MIC.activityLevel);
                    if (Constans.LOOKBACK && _loc_1 > 3)
                    {
                        WebUtil.info("OK:" + _loc_1);
                        _loc_2 = new SoundTransform(0);
                        Constans.PUBLIC_MIC.soundTransform = _loc_2;
                    }
                    sv.mc.gotoAndStop(_loc_1);
                }
                return;
            }// end function
            , 200);
            return;
        }// end function

        private function MDOWN(event:MouseEvent) : void
        {
            var _loc_2:Rectangle = null;
            var _loc_3:Rectangle = null;
            event.updateAfterEvent();
            if (Constans.MIX_VIDEO)
            {
                return;
            }
            if (this.sv.mouseX > 108 && this.sv.mouseY > 160)
            {
                _loc_2 = new Rectangle(this.sv.soundBar.x, this.sv.soundBar.y + 4, this.sv.soundBar.x + this.sv.soundBar.width - this.sv.soundBar.x - this.sv.controlBtn.width, 0);
                this.sv.controlBtn.startDrag(false, _loc_2);
            }
            else if (this.sv.mouseX < 108 && this.sv.mouseY > 160)
            {
                _loc_3 = new Rectangle(this.sv.soundMicBar.x, this.sv.soundMicBar.y + 4, this.sv.soundMicBar.x + this.sv.soundMicBar.width - this.sv.soundMicBar.x - this.sv.controlMicBtn.width, 0);
                this.sv.controlMicBtn.startDrag(false, _loc_3);
            }
            return;
        }// end function

        private function MUP(event:MouseEvent) : void
        {
            var transForm:SoundTransform;
            var evt:* = event;
            if (Constans.MIX_VIDEO)
            {
                return;
            }
            if (this.sv.mouseX > 108 && this.sv.mouseY > 160)
            {
                this.sv.controlBtn.stopDrag();
                this.currentVolume = (this.sv.controlBtn.x - this.sv.soundBar.x) / this.sv.soundBar.width;
                transForm = new SoundTransform(this.currentVolume, 0);
                SoundMixer.soundTransform = transForm;
                Constans.MIC_VOLUME = this.currentVolume;
            }
            else if (this.sv.mouseX < 108 && this.sv.mouseY > 160)
            {
                this.sv.controlMicBtn.stopDrag();
                this.currentMicVolume = (this.sv.controlMicBtn.x - this.sv.soundMicBar.x) / this.sv.soundMicBar.width * 100;
                this.sv.mic = WebUtil.getMic();
                this.sv.mic.gain = this.currentMicVolume;
                Constans.MIC_GAIN = this.currentMicVolume;
                this.sv.mic.setLoopBack(true);
                setTimeout(function ()
            {
                if (Constans.LOOKBACK)
                {
                    Constans.LOOKBACK = false;
                    Constans.PUBLIC_MIC.setLoopBack(false);
                }
                return;
            }// end function
            , 1000);
                WebUtil.info("" + this.sv.mic.gain);
            }
            return;
        }// end function

    }
}
