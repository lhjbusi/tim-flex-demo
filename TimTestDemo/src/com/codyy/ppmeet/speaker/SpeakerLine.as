package com.codyy.ppmeet.speaker
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.event.*;
    import com.codyy.ppmeet.net.*;
    import com.codyy.ppmeet.util.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class SpeakerLine extends Object
    {
        public var line:Number = 0;
        public var sv:SpeakerVideo = null;
        public var nc:NetConnection = null;
        public var nearID:String = "";
        public var p2pMembers:Number = 0;
        private const SERVER:String = "rtmfp://stratus.adobe.com/";
        private const DEVKEY:String = "c50af1426e2afbd7d1147903-e331e5f149d2";
        private var gs:GroupSpecifier = null;
        public var netGroup:NetGroup = null;
        public var groupSpec:String = "";
        private var ncEvent:NetConnectionEvent = null;
        private var ngEvent:NetGroupEvent = null;
        private var micEvent:MicEvent = null;
        private var red5Event:Red5Event = null;
        private var mic:Microphone = null;
        public var audioCon:NetConnection = null;
        public var micStream:NetStream = null;
        public var audioStream:NetStream = null;
        public var isSpeaker:Boolean = false;
        public var rkey:String = "1";

        public function SpeakerLine(param1:SpeakerVideo)
        {
            WebUtil.info("SpeakerLine init");
            this.sv = param1;
            this.line = param1.lines;
            var _loc_2:* = param1;
            var _loc_3:* = param1.lines + 1;
            _loc_2.lines = _loc_3;
            if (this.sv.getParam("server") == "1")
            {
                this.isSpeaker = true;
            }
            return;
        }// end function

        public function initRed5() : void
        {
            if (this.red5Event)
            {
                this.red5Event.clearStream();
            }
            this.red5Event = null;
            this.red5Event = new Red5Event(this);
            this.red5Event.initConnection();
            return;
        }// end function

        public function initConnect() : void
        {
            if (this.sv.getParam("RTMP"))
            {
                this.ncEvent = new NetConnectionEvent(this);
                this.ngEvent = new NetGroupEvent(this);
                this.micEvent = new MicEvent(this);
                this.nc = new NetConnection();
                this.nc.objectEncoding = ObjectEncoding.AMF0;
                this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.ncEvent.feedNC);
                this.nc.connect(Constans.RTMFP_SERVER + Constans.RTMFP_DEVKEY, "", Constans.GROUP_ID);
                Constans.pushConnection(this.nc);
            }
            else
            {
                this.initRed5();
            }
            return;
        }// end function

        public function getAudioKey() : String
        {
            return this.getKey(this.rkey + "_audio");
        }// end function

        public function getKey(param1 = "") : String
        {
            return Constans.E_CODE + (this.sv.getParam("meetTime") ? (this.sv.getParam("meetTime") + "/") : ("")) + (this.sv.getParam("meetId") || "codyyGroup") + "_" + param1;
        }// end function

        public function createGroup() : void
        {
            this.gs = new GroupSpecifier("%E9%98%94%E5%9C%B0" + this.sv.getKey(this.line));
            this.gs.postingEnabled = true;
            this.gs.multicastEnabled = true;
            if (this.sv.getParam("intranet"))
            {
                this.gs.ipMulticastMemberUpdatesEnabled = true;
                this.gs.addIPMulticastAddress("224.0.1.200:3000");
            }
            else
            {
                this.gs.serverChannelEnabled = true;
            }
            this.groupSpec = this.gs.groupspecWithoutAuthorizations();
            this.initNetGroup();
            return;
        }// end function

        private function initNetGroup() : void
        {
            this.netGroup = new NetGroup(this.nc, this.groupSpec);
            this.netGroup.addEventListener(NetStatusEvent.NET_STATUS, this.ngEvent.feedNetGroup);
            return;
        }// end function

        public function outMic() : void
        {
            this.micStream = new NetStream(this.nc, this.groupSpec);
            this.micStream.addEventListener(NetStatusEvent.NET_STATUS, this.micEvent.feedMicEvent);
            this.micStream.client = this.sv;
            Constans.pushNetStream(this.micStream);
            return;
        }// end function

        public function inAudio() : void
        {
            this.audioStream = new NetStream(this.nc, this.groupSpec);
            this.audioStream.client = this.audioStream;
            Constans.pushNetStream(this.audioStream);
            return;
        }// end function

        public function micPublish() : void
        {
            var _loc_1:NetworkTraffic = null;
            this.mic = WebUtil.getMic(this.sv.getParam("loopBack"), this.sv);
            WebUtil.info("麦克风：" + this.mic.name);
            if (this.mic)
            {
                this.mic.gain = 100;
                this.micStream.attachAudio(this.mic);
                this.micStream.publish(this.getAudioKey());
                WebUtil.info("发布语音 key : " + this.getAudioKey());
                _loc_1 = new NetworkTraffic(this.getAudioKey() + "_micPublish", this.micStream);
                _loc_1.processUpload();
            }
            return;
        }// end function

        public function audioPlay() : void
        {
            if (this.mic && this.sv.getParam("server") != "1")
            {
                this.mic.gain = 0;
            }
            if (Constans.MEET_MODEL == 2 && this.sv.getParam("server") != "1")
            {
                return;
            }
            if (!this.audioStream || this.audioStream == null)
            {
                this.inAudio();
            }
            this.sv.videoDisplay.attachNetStream(this.audioStream);
            this.audioStream.receiveAudio(true);
            WebUtil.info("接收语音 key ：" + this.getAudioKey());
            this.audioStream.play(this.getAudioKey());
            var _loc_1:* = new NetworkTraffic(this.getAudioKey() + "_audioPlay", this.audioStream);
            _loc_1.processDownload();
            return;
        }// end function

        public function speaker(param1 = "1") : void
        {
            if (this.sv.uidSpeak.indexOf(param1) < 0)
            {
                this.sv.uidSpeak.push(param1);
                this.isSpeaker = true;
                this.rkey = param1;
                WebUtil.info("begin speaker");
                if (this.sv.getParam("rtmp"))
                {
                    this.initRed5();
                }
                else
                {
                    this.initConnect();
                }
            }
            else
            {
                WebUtil.info("此路语音已连接");
            }
            return;
        }// end function

        public function endSpeaker(param1:Boolean = false) : void
        {
            this.isSpeaker = param1;
            if (this.sv.getParam("RTMP"))
            {
                if (this.audioStream)
                {
                    this.audioPlay();
                }
                else
                {
                    this.initConnect();
                }
            }
            else
            {
                this.initRed5();
            }
            return;
        }// end function

        public function stopSpeaker(param1 = "1") : void
        {
            WebUtil.info("stop speaker");
            this.red5Event.clearStream();
            return;
        }// end function

        public function stopAudioPlay(param1 = "1") : void
        {
            WebUtil.info("stopAudioPlay speaker");
            this.red5Event.stopAudioPlay();
            return;
        }// end function

        public function receivceSpeaker(param1 = "1") : void
        {
            if (this.sv.uidAudio.indexOf(param1) < 0)
            {
                WebUtil.info("开始接收语音");
                this.sv.uidAudio.push(param1);
                this.rkey = param1;
                this.endSpeaker(false);
                WebUtil.info("此音频线路：" + param1);
            }
            else
            {
                WebUtil.info("已经存在此音频线路" + param1);
            }
            return;
        }// end function

        public function cancleSpeaker(param1 = "1") : void
        {
            this.stopSpeaker(param1);
            return;
        }// end function

    }
}
