package com.codyy.ppmeet.red5
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.net.*;
    import com.codyy.ppmeet.util.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class LargeVideo extends Sprite
    {
        private var sv:SpeakerVideo = null;
        private var VideoDis:Video = null;
        private var IP:String = "";
        private var rtmpVideoNetConn:NetConnection;
        private var rtmpVideoStream:NetStream;
        private var receVideoStream:NetStream;
        private var camera:Camera;
        private var maxBandWidth:int = 512;
        private var videoSize:int = 300;
        private var intervalId:Object;
        private var networkBad:int = 0;
        private var Num:Number;
        private var lastTime:int;
        private var reConnTimer:int;
        private var NetConBoo:Boolean;

        public function LargeVideo(param1:SpeakerVideo)
        {
            this.sv = param1;
            this.VideoDis = param1.videoShow;
            this.IP = this.sv.getParam("ip");
            return;
        }// end function

        public function init(param1:Number = 1)
        {
            this.sv.pauseMC.visible = false;
            this.VideoDis.smoothing = true;
            this.initRed5();
            this.Num = param1;
            return;
        }// end function

        private function initRed5() : void
        {
            var _loc_1:* = this.IP || "rtmp://www.codyy.net/oflaDemo";
            var _loc_2:String = "codyy";
            WebHelp.nd("主讲人视频连接服务器：" + _loc_1);
            if (this.rtmpVideoNetConn)
            {
                this.rtmpVideoNetConn.close();
                this.rtmpVideoNetConn = null;
            }
            this.rtmpVideoNetConn = new NetConnection();
            this.rtmpVideoNetConn.addEventListener(NetStatusEvent.NET_STATUS, this.red5VideoStatusHandler);
            var _loc_3:* = Constans.GROUP_ID.replace("meet_", "meet_large_");
            if (this.IP)
            {
                this.rtmpVideoNetConn.connect(this.IP, Constans.RTMP_USER, _loc_3);
            }
            else
            {
                this.rtmpVideoNetConn.connect(Constans.RTMP_VIDEO, Constans.RTMP_USER, _loc_3);
            }
            this.rtmpVideoNetConn.client = this;
            Constans.pushConnection(this.rtmpVideoNetConn);
            return;
        }// end function

        private function red5VideoStatusHandler(event:NetStatusEvent) : void
        {
            var evt:* = event;
            switch(evt.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    WebHelp.nd("主讲人视频Red5连接成功（" + this.sv.getParam("server") + "）");
                    this.NetConBoo = true;
                    if (this.Num == 1)
                    {
                        this.sendRtmpVideoStream();
                    }
                    else
                    {
                        this.receiveRtmpVideoStream();
                    }
                    break;
                }
                case "NetConnection.Connect.Failed":
                {
                    WebHelp.nd("主讲人视频Red5连接失败");
                    WebUtil.sendMsg({act:"sys", say:"连接视频服务器失败：" + evt.info.code});
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    WebHelp.nd("主讲人视频Red5连接断开");
                    this.NetConBoo = false;
                    clearInterval(this.reConnTimer);
                    this.reConnTimer = setInterval(function ()
            {
                if (!NetConBoo && !rtmpVideoNetConn.connected)
                {
                    initRed5();
                }
                return;
            }// end function
            , 3000);
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function sendRtmpVideoStream()
        {
            WebHelp.nd("主讲人发布视频：" + this.getKey() + "_video");
            this.camera = this.getCam();
            if (this.camera.muted)
            {
                this.camera.addEventListener(StatusEvent.STATUS, function (event:StatusEvent) : void
            {
                switch(event.code)
                {
                    case "Camera.Unmuted":
                    {
                        _startPublish();
                        ;
                    }
                    case "Camera.Muted":
                    {
                        ExternalInterface.call("onSure", "");
                        ;
                    }
                    default:
                    {
                        ;
                    }
                }
                return;
            }// end function
            );
            }
            else
            {
                this._startPublish();
            }
            return;
        }// end function

        private function _startPublish()
        {
            try
            {
                this.disconnectStream();
                this.VideoDis.attachNetStream(null);
            }
            catch (e)
            {
                WebUtil.info("vs 1" + e.message);
            }
            this.rtmpVideoStream = new NetStream(this.rtmpVideoNetConn);
            this.rtmpVideoStream = WebUtil.setCamH264Setting(this.rtmpVideoStream);
            this.rtmpVideoStream.attachCamera(this.camera);
            this.VideoDis.attachCamera(this.camera);
            this.sv.removeHead();
            WebUtil.info("发布视频1：（" + this.getKey() + "_video）");
            setTimeout(function ()
            {
                rtmpVideoStream.publish(getKey() + "_video", "live");
                Constans.pushNetStream(this.rtmpVideoStream);
                WebHelp.nd("主讲人发布视频完成！");
                var nt:* = new NetworkTraffic(getKey() + "_video", rtmpVideoStream);
                nt.processUpload();
                rtmpVideoStream.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent) : void
                {
                    return;
                }// end function
                );
                return;
            }// end function
            , 3000);
            return;
        }// end function

        public function receiveRtmpVideoStream()
        {
            try
            {
                this.disconnectStream();
                this.VideoDis.attachNetStream(null);
            }
            catch (e)
            {
                WebUtil.info("vs 2" + e);
            }
            WebHelp.nd("接收red5主讲人发布视频：" + this.getKey() + "_video");
            this.receVideoStream = new NetStream(this.rtmpVideoNetConn);
            this.VideoDis.attachNetStream(this.receVideoStream);
            WebHelp.nd("接收主讲人视频：" + this.getKey() + "_video");
            this.receVideoStream.play(this.getKey() + "_video");
            Constans.pushNetStream(this.receVideoStream);
            WebHelp.nd("接收主讲人视频完成！");
            nt = new NetworkTraffic(this.getKey() + "_video", this.receVideoStream);
            nt.processDownload();
            this.sv.removeHead();
            this.receVideoStream.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent) : void
            {
                switch(event.info.code)
                {
                    case "NetStream.Play.InsufficientBW":
                    {
                        var _loc_3:* = networkBad + 1;
                        networkBad = _loc_3;
                        if (networkBad % 5 == 0)
                        {
                            WebHelp.callJS("flashAV", "network_Bad");
                        }
                        ;
                    }
                    case "NetStream.Play.UnpublishNotify":
                    {
                        receiveRtmpVideoStream();
                        ;
                    }
                    default:
                    {
                        ;
                    }
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function disconnectStream()
        {
            if (this.rtmpVideoStream)
            {
                this.rtmpVideoStream.attachAudio(null);
                this.rtmpVideoStream.attachCamera(null);
                this.rtmpVideoStream.receiveAudio(false);
                this.rtmpVideoStream.receiveVideo(false);
                this.rtmpVideoStream.close();
                this.rtmpVideoStream = null;
            }
            if (this.receVideoStream)
            {
                this.receVideoStream.attachAudio(null);
                this.receVideoStream.attachCamera(null);
                this.receVideoStream.receiveAudio(false);
                this.receVideoStream.receiveVideo(false);
                this.receVideoStream.close();
                this.receVideoStream = null;
            }
            return;
        }// end function

        private function getCam() : Camera
        {
            this.camera = WebHelp.getCam(this.camera);
            WebHelp.info("cam:" + Constans.IS_CAMERA_CHECK);
            if (!Constans.IS_CAMERA_CHECK)
            {
                Constans.IS_CAMERA_CHECK = true;
                try
                {
                    this.checkCamBusy();
                }
                catch (e)
                {
                }
            }
            if (this.camera.name.indexOf("17") > -1)
            {
                return this.camera;
            }
            this.camera.setKeyFrameInterval(Constans.params["keyFrames"] ? (Constans.params["keyFrames"]) : (15));
            this.camera.setQuality((parseFloat(this.sv.getParam("limitBandWidth")) || this.maxBandWidth) * 1024, Math.floor(parseFloat(this.sv.getParam("quality")) || 100));
            this.videoSize = this.sv.getParam("gaoqing") ? (parseInt(this.sv.getParam("gaoqing"))) : (this.videoSize);
            this.camera.setMode(this.videoSize, this.videoSize * this.VideoDis.height / this.VideoDis.width, Math.floor(parseFloat(this.sv.getParam("frames")) || 12));
            return this.camera;
        }// end function

        private function checkCamBusy() : void
        {
            var intelvalTimes:*;
            var afun:*;
            var jihuo:*;
            WebUtil.info("camera length : " + Camera.names.length);
            if (Camera.names.length)
            {
                intelvalTimes;
                this.intervalId = setInterval(function ()
            {
                var _loc_2:* = intelvalTimes + 1;
                intelvalTimes = _loc_2;
                WebUtil.info("camera FPS : " + intelvalTimes + "---" + camera.currentFPS);
                if (camera.currentFPS < 1)
                {
                    if (intelvalTimes >= 80)
                    {
                        if (camera.name.indexOf("17") > -1)
                        {
                            WebHelp.callJS("flashAV", "visual_camera");
                        }
                        else
                        {
                            WebHelp.callJS("flashAV", "camera_busy");
                        }
                        clearInterval(intervalId);
                    }
                }
                else
                {
                    WebHelp.callJS("flashAV", "");
                    clearInterval(intervalId);
                }
                return;
            }// end function
            , 100);
            }
            else
            {
                WebHelp.callJS("flashAV", "");
            }
            return;
        }// end function

        private function getKey() : String
        {
            return Constans.E_CODE + (this.sv.getParam("meetTime") ? (this.sv.getParam("meetTime") + "/") : ("")) + (this.sv.getParam("meetId") || "codyyGroup");
        }// end function

    }
}
