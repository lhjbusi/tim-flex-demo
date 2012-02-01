package com.codyy.ppmeet.media
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.net.*;
    import com.codyy.ppmeet.util.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class MediaRecord extends Object
    {
        public var sv:SpeakerVideo = null;
        private var nc:NetConnection = null;
        private var ns:NetStream = null;
        private var audio:NetStream = null;
        private var video:NetStream = null;
        private var key:String = "";
        public var isInit:Boolean = false;
        private var isRecord:Boolean = false;
        private var msg:SharedObjectMsg = null;
        public var time_interval:uint = 0;
        public static var RECORD_TIME:int = 0;

        public function MediaRecord(param1:SpeakerVideo)
        {
            this.sv = param1;
            if (this.sv.getParam("isRecord") == "1")
            {
                this.isRecord = true;
            }
            return;
        }// end function

        public function setMsg(param1:SharedObjectMsg)
        {
            this.msg = param1;
            return;
        }// end function

        public function initEvent()
        {
            WebUtil.addCallBack("startRecord", this.startRecord);
            WebUtil.addCallBack("stopRecordAudio", this.stopRecordAudio);
            WebUtil.addCallBack("stopRecordVideo", this.stopRecordVideo);
            WebUtil.addCallBack("stopRecord", this.stopRecord);
            return;
        }// end function

        public function initConnection()
        {
            this.getKey();
            this.nc = new NetConnection();
            this.nc.objectEncoding = ObjectEncoding.AMF0;
            this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.feedEvent);
            this.nc.connect(Constans.RTMP_SERVER, Constans.RTMP_USER, Constans.GROUP_ID);
            this.nc.client = this;
            Constans.pushConnection(this.nc);
            return;
        }// end function

        public function getKey()
        {
            var _loc_1:* = this.sv.getParam("meetTime");
            var _loc_2:* = this.sv.getParam("meetId");
            this.key = "";
            var _loc_3:* = this.key + (_loc_1 + "/");
            this.key = this.key + (_loc_1 + "/");
            var _loc_3:* = this.key + (_loc_2 + "/");
            this.key = this.key + (_loc_2 + "/");
            this.key = this.key + (new Date().getTime() + "_record");
            return;
        }// end function

        public function initStream() : void
        {
            this.ns = new NetStream(this.nc);
            this.ns.addEventListener(NetStatusEvent.NET_STATUS, this.feedNSEvent);
            this.ns = WebUtil.setCamH264Setting(this.ns);
            this.ns.publish(this.key, "record");
            Constans.pushNetStream(this.ns);
            var _loc_1:* = new NetworkTraffic(this.key + "_micRecord", this.ns);
            _loc_1.processUpload();
            this.isInit = true;
            WebUtil.info("录制初始化完成");
            this.recordAudio();
            this.recordVideo();
            return;
        }// end function

        public function feedEvent(event:NetStatusEvent) : void
        {
            WebUtil.info("Record status : " + event.info.code);
            if (event.info.code == "NetConnection.Connect.Success")
            {
                this.initStream();
            }
            return;
        }// end function

        public function feedNSEvent(event:NetStatusEvent) : void
        {
            WebUtil.info("Record status : " + event.info.code);
            return;
        }// end function

        public function recordAudio() : void
        {
            WebUtil.info("开始录制音频");
            this.ns.attachAudio(WebUtil.getMic(false));
            return;
        }// end function

        public function stopRecordAudio() : void
        {
            WebUtil.info("停止录制音频");
            if (this.ns)
            {
                this.ns.attachAudio(null);
            }
            return;
        }// end function

        public function recordVideo() : void
        {
            if (Constans.MEET_TYPE != 2)
            {
                return;
            }
            WebUtil.info("开始录制，视频录制Key：" + this.key);
            this.ns.attachCamera(WebHelp.getCam());
            return;
        }// end function

        public function stopRecordVideo() : void
        {
            if (Constans.MEET_TYPE != 2)
            {
                return;
            }
            WebUtil.info("停止录制，视频录制Key：" + this.key);
            if (this.ns)
            {
                this.ns.attachCamera(null);
            }
            return;
        }// end function

        public function startRecordIn() : void
        {
            if (this.isRecord)
            {
                this.stopRecord();
                WebUtil.info("开始录制");
                this.initConnection();
                clearInterval(this.time_interval);
                WebUtil.alert("开始录制");
                this.time_interval = setInterval(function ()
            {
                try
                {
                    WebUtil.info("时间统计定时器执行 : " + MediaRecord.RECORD_TIME);
                    var _loc_1:* = MediaRecord;
                    _loc_1.RECORD_TIME = MediaRecord.RECORD_TIME + 1;
                    msg.sendData("", MediaRecord.RECORD_TIME++);
                    msg.showTime(MediaRecord.RECORD_TIME + "");
                }
                catch (e)
                {
                }
                return;
            }// end function
            , 1000);
            }
            return;
        }// end function

        public function startRecord() : void
        {
            this.isRecord = true;
            this.startRecordIn();
            return;
        }// end function

        public function stopRecordOut() : void
        {
            this.isInit = false;
            WebUtil.info("停止录制");
            return;
        }// end function

        public function stopRecord() : void
        {
            this.stopRecordOut();
            WebUtil.info("stop record success.");
            clearInterval(this.time_interval);
            WebUtil.info("stop record clearInterval success.");
            return;
        }// end function

    }
}
