package com.codyy.ppmeet.event
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.net.*;
    import com.codyy.ppmeet.speaker.*;
    import com.codyy.ppmeet.util.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class Red5Event extends Object
    {
        private var sline:SpeakerLine = null;
        private var mic:Microphone = null;
        private var ns:NetStream = null;
        private var nc:NetConnection = null;
        private var reConnTimer:int;
        private var NetConBoo:Boolean;
        private var ChangeBoo:Boolean;
        private var transForm:SoundTransform;

        public function Red5Event(param1:SpeakerLine)
        {
            this.sline = param1;
            return;
        }// end function

        public function initConnection() : void
        {
            if (this.nc)
            {
                this.nc.close();
                this.nc = null;
            }
            this.nc = new NetConnection();
            this.nc.objectEncoding = ObjectEncoding.AMF0;
            this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.feedRed5);
            this.nc.connect(Constans.RTMP_SERVER, Constans.RTMP_USER, Constans.GROUP_ID.replace("meet_", "meet_audio_"));
            this.nc.client = this.sline.sv;
            Constans.pushConnection(this.nc);
            return;
        }// end function

        public function feedRed5(event:NetStatusEvent) : void
        {
            var event:* = event;
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.NetConBoo = true;
                    this.ChangeBoo = false;
                    if (this.sline.isSpeaker)
                    {
                        WebUtil.DMT("开始发布red5麦克风语音");
                        this.outMic();
                    }
                    else
                    {
                        WebUtil.DMT("开始接收red5主讲人语音");
                        this.inAudio();
                    }
                    break;
                }
                case "NetConnection.Connect.Failed":
                {
                    WebUtil.info("Red5连接失败，开始进行P2P连接。");
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    this.NetConBoo = false;
                    clearInterval(this.reConnTimer);
                    this.reConnTimer = setInterval(function ()
            {
                if (!ChangeBoo && !NetConBoo && !nc.connected)
                {
                    initConnection();
                }
                return;
            }// end function
            , 3000);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function outMic()
        {
            this.mic = WebUtil.getMic(this.sline.line == 1, this.sline.sv);
            this.mic.gain = Constans.MIC_GAIN;
            this.transForm = new SoundTransform(Constans.MIC_VOLUME);
            SoundMixer.soundTransform = this.transForm;
            this.ns = new NetStream(this.nc);
            this.ns.attachAudio(this.mic);
            WebUtil.DMT("outkey:" + this.sline.getAudioKey());
            this.ns.publish(this.sline.getAudioKey());
            Constans.pushNetStream(this.ns);
            WebUtil.DMT("red5语音发布成功");
            var _loc_1:* = new NetworkTraffic(this.sline.getAudioKey() + "_outMic", this.ns);
            _loc_1.processUpload();
            if (this.sline.line == 2)
            {
                if (this.sline.sv.mediaRecord.isInit)
                {
                    this.sline.sv.mediaRecord.startRecordIn();
                }
                else
                {
                    setTimeout(this.sline.sv.mediaRecord.startRecordIn, 3000);
                }
            }
            WebUtil.info("开始语音录制");
            return;
        }// end function

        public function inAudio()
        {
            if (this.sline.line == 2)
            {
                if (this.sline.sv.mediaRecord.isInit)
                {
                    this.sline.sv.mediaRecord.stopRecord();
                }
                else
                {
                    setTimeout(this.sline.sv.mediaRecord.stopRecord, 3000);
                }
            }
            this.ns = new NetStream(this.nc);
            this.ns.client = this.sline.sv;
            this.sline.sv.videoDisplay.attachNetStream(this.ns);
            this.ns.receiveAudio(true);
            WebUtil.DMT("inkey:" + this.sline.getAudioKey());
            this.ns.play(this.sline.getAudioKey());
            Constans.pushNetStream(this.ns);
            WebUtil.DMT("red5语音接收成功");
            var _loc_1:* = new NetworkTraffic(this.sline.getAudioKey() + "_inMic", this.ns);
            _loc_1.processDownload();
            return;
        }// end function

        public function clearStream() : void
        {
            this.ChangeBoo = true;
            if (this.sline.sv.getParam("server") != "1" && this.mic)
            {
                WebUtil.DMT("清理Mic");
                this.mic.gain = 0;
            }
            if (this.ns && this.ns != null)
            {
                try
                {
                    this.mic.gain = 0;
                    this.mic.soundTransform.volume = 0;
                    this.mic.setSilenceLevel(100, 1);
                }
                catch (e)
                {
                    WebUtil.info("clearStream : " + e);
                }
                WebUtil.DMT("MicroPhone关闭完成");
                this.mic = null;
                this.ns.attachAudio(null);
                this.ns.publish(this.sline.getAudioKey());
                this.ns.receiveAudio(false);
                this.ns.play(this.sline.getAudioKey());
                this.ns.close();
                WebUtil.DMT("关闭语音流 （" + this.sline.rkey + "）： " + this.sline.getAudioKey());
            }
            if (this.nc && this.nc != null)
            {
                this.nc.close();
                WebUtil.info("关闭语音连接");
            }
            return;
        }// end function

        public function stopAudioPlay() : void
        {
            WebUtil.DMT("red5 stopAudioPlay speaker");
            if (this.ns && this.ns != null)
            {
                this.ns.receiveAudio(false);
                this.ns.play(this.sline.getAudioKey());
                this.ns.close();
                WebUtil.DMT("stopAudioPlay 关闭语音流 （" + this.sline.rkey + "）： " + this.sline.getAudioKey());
            }
            if (this.nc && this.nc != null)
            {
                this.nc.close();
                WebUtil.DMT("stopAudioPlay 关闭语音连接");
            }
            return;
        }// end function

    }
}
