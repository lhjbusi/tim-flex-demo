package com.codyy.ppmeet.ui
{
    import com.codyy.ppmeet.*;
    import flash.events.*;

    public class FullScreen extends Object
    {
        private var sv:SpeakerVideo = null;
        private var fb:Object = null;
        private var isFull:Boolean = false;

        public function FullScreen(param1:SpeakerVideo)
        {
            this.sv = param1;
            this.fb = param1.fullScreenB;
            param1.stage.addEventListener(Event.ENTER_FRAME, this.onenterframe);
            return;
        }// end function

        public function init() : void
        {
            this.fb.addEventListener(MouseEvent.MOUSE_OVER, this.MOVER);
            this.fb.addEventListener(MouseEvent.MOUSE_OUT, this.MOUT);
            this.fb.topmc2.fullscreenbtn.buttonMode = true;
            this.fb.topmc2.fullscreenbtn.addEventListener(MouseEvent.CLICK, this.fullClick);
            this.sv.Container.doubleClickEnabled = true;
            this.sv.Container.addEventListener(MouseEvent.DOUBLE_CLICK, this.DOUBLEMC);
            return;
        }// end function

        private function fullClick(event:MouseEvent)
        {
            if (this.isFull == false)
            {
                this.sv.stage.scaleMode = "showAll";
                this.sv.stage.displayState = "fullScreen";
                this.isFull = true;
                this.visFalse();
                this.sv.stage.addEventListener(Event.ENTER_FRAME, this.onenterframe);
            }
            else if (this.isFull == true)
            {
                this.sv.stage.displayState = "normal";
                this.isFull = false;
                this.visTrue();
            }
            return;
        }// end function

        private function onenterframe(param1) : void
        {
            if (this.sv.stage.displayState == "normal")
            {
                this.visTrue();
                this.isFull = false;
                this.sv.stage.removeEventListener(Event.ENTER_FRAME, this.onenterframe);
            }
            return;
        }// end function

        private function visFalse()
        {
            this.sv.bg_mc.visible = false;
            this.sv.Mic.visible = false;
            this.sv.controlMicBtn.visible = false;
            this.sv.mc.visible = false;
            this.sv.soundMicBar.visible = false;
            this.sv.speaker.visible = false;
            this.sv.controlBtn.visible = false;
            this.sv.soundBar.visible = false;
            this.sv.videoShow.height = this.sv.stage.stageHeight;
            this.sv.videoShow.width = Math.floor(214 * 180 / 160);
            this.sv.fullScreenB.width = this.sv.videoShow.width;
            this.sv.videoShow.x = (214 - this.sv.videoShow.width) / 2;
            this.sv.fullScreenB.x = this.sv.videoShow.x;
            return;
        }// end function

        private function visTrue()
        {
            this.sv.bg_mc.visible = true;
            this.sv.Mic.visible = true;
            this.sv.controlMicBtn.visible = true;
            this.sv.mc.visible = true;
            this.sv.soundMicBar.visible = true;
            this.sv.speaker.visible = true;
            this.sv.controlBtn.visible = true;
            this.sv.soundBar.visible = true;
            this.sv.videoShow.height = this.sv.stage.stageHeight - 20;
            this.sv.videoShow.width = 214;
            this.sv.fullScreenB.width = this.sv.videoShow.width;
            this.sv.videoShow.x = 0;
            this.sv.fullScreenB.x = 0;
            return;
        }// end function

        private function MOVER(event:MouseEvent) : void
        {
            this.fb.gotoAndPlay(51);
            return;
        }// end function

        private function MOUT(event:MouseEvent) : void
        {
            this.fb.gotoAndPlay(35);
            return;
        }// end function

        private function DOUBLEMC(event:MouseEvent)
        {
            if (this.isFull == false)
            {
                this.sv.stage.align = "T";
                this.sv.stage.scaleMode = "showAll";
                this.sv.stage.displayState = "fullScreen";
                this.isFull = true;
                this.visFalse();
                this.sv.stage.addEventListener(Event.ENTER_FRAME, this.onenterframe);
            }
            else if (this.isFull == true)
            {
                this.sv.stage.align = "T";
                this.sv.stage.scaleMode = "showAll";
                this.sv.stage.displayState = "normal";
                this.isFull = false;
                this.visTrue();
            }
            return;
        }// end function

    }
}
