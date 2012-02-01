package com.codyy.ppmeet.p2p
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.util.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class P2pSmallVideo extends Sprite
    {
        private var sv:SpeakerVideo = null;
        private var minVideo:Video = null;
        private var Num:Number;
        private var _netConnection:NetConnection;
        private var _outgoingStream:NetStream;
        private const SERVER:String = "rtmfp://stratus.adobe.com/";
        private const DEVKEY:String = "c50af1426e2afbd7d1147903-e331e5f149d2";
        private var _netGroup:NetGroup;
        private var _estimatedP2PMembers:Number;
        private var camera:Camera;
        private var intervalId:Object;
        private var _groupSpecifier:GroupSpecifier;
        private var _groupSpec:String;
        private var maxBandWidth:int = 512;
        private var videoSize:int = 100;

        public function P2pSmallVideo(param1:SpeakerVideo)
        {
            this.sv = param1;
            this.minVideo = param1.PublishMc.showAndPublish_Video;
            return;
        }// end function

        public function init(param1:Number = 1)
        {
            this.sv.pauseMC.visible = false;
            this.minVideo.smoothing = true;
            this.sv.PublishMc.addEventListener(MouseEvent.MOUSE_DOWN, this.onMousedown);
            this.sv.PublishMc.addEventListener(MouseEvent.MOUSE_UP, this.onMouseup);
            this.initRTMFP();
            this.Num = param1;
            return;
        }// end function

        private function initRTMFP()
        {
            if (this._netConnection)
            {
                this._netConnection.close();
                this._netConnection = null;
            }
            this._netConnection = new NetConnection();
            if (this.sv.getParam("maxPeer"))
            {
                this._netConnection.maxPeerConnections = parseInt(this.sv.getParam("maxPeer"));
                ;
            }
            this._netConnection.objectEncoding = ObjectEncoding.AMF0;
            this._netConnection.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            WebHelp.nd("��ʼ��������Ƶ��" + (this.sv.getParam("rtmfp") || this.SERVER + this.DEVKEY));
            this._netConnection.connect(this.sv.getParam("rtmfp") || this.SERVER + this.DEVKEY);
            Constans.pushConnection(this._netConnection);
            return;
        }// end function

        private function onNetStatus(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    WebHelp.nd("��ʼ��������Ƶ�ɹ���");
                    WebUtil.sendMsg({act:"sys", say:"��ȡ��ݱ�ʶ�ųɹ���"});
                    this._createGroupSpec();
                    break;
                }
                case "NetConnection.Connect.Closed":
                case "NetConnection.Connect.Failed":
                case "NetConnection.Connect.Rejected":
                case "NetConnection.Connect.AppShutdown":
                case "NetConnection.Connect.InvalidApp":
                {
                    if (Constans.IS_CLOSE)
                    {
                        return;
                    }
                    WebHelp.nd("������Ƶl��ʧ�ܣ�ʹ��NetGroupl�ӣ�");
                    WebUtil.sendMsg({act:"sys", say:"l�ӷ�����ʧ�ܣ�" + event.info.code});
                    if (this._netGroup)
                    {
                        this.clearNetGroup();
                    }
                    this._outgoingStream = null;
                    break;
                }
                case "NetStream.Connect.Success":
                {
                    WebHelp.nd("������ƵNetStream�ɹ�");
                    if (this.Num == 1)
                    {
                        this.clearVideo();
                    }
                    else
                    {
                        this.publishVideo();
                    }
                    break;
                }
                case "NetStream.Connect.Rejected":
                case "NetStream.Connect.Failed":
                {
                    WebHelp.nd("������ƵNetStreamʧ��");
                    break;
                }
                case "NetStream.Publish.Start":
                {
                    break;
                }
                case "NetStream.MulticastStream.Reset":
                case "NetStream.Buffer.Full":
                {
                }
                default:
                {
                    break;
                }
                case "NetGroup.Connect.Rejected":
                {
                    WebHelp.nd("������ƵNetGroup�ɹ�");
                    WebUtil.sendMsg({act:"sys", say:"���Ѽ��������" + this.getKey()});
                    this._estimatedP2PMembers = this._netGroup.estimatedMemberCount;
                    if (this.Num == 1)
                    {
                        this.clearVideo();
                    }
                    else
                    {
                        this.onStartOutgoingStream();
                    }
                    break;
                }
                case "NetGroup.Connect.Failed":
                case :
                {
                    WebHelp.nd("������ƵNetGroupʧ��");
                    try
                    {
                        WebUtil.sendMsg({type:"group", act:"speakerNetGroupDown", from:"sys", to:"sys", say:"", data:new Date().getTime()});
                    }
                    catch (e)
                    {
                    }
                    this.clearNetGroup();
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function onStartOutgoingStream() : void
        {
            try
            {
                this.clearVideo();
                this._outgoingStream = new NetStream(this._netConnection, this._groupSpec);
                this._outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
                this._outgoingStream.client = this;
                Constans.pushNetStream(this._outgoingStream);
            }
            catch (e)
            {
                WebUtil.info("_outgoingStream=" + e.message);
            }
            return;
        }// end function

        private function _createGroupSpec() : void
        {
            this._groupSpecifier = new GroupSpecifier("%E9%98%94%E5%9C%B0" + this.sv.getParam("meetId"));
            this._groupSpecifier.postingEnabled = true;
            this._groupSpecifier.multicastEnabled = true;
            if (this.sv.getParam("intranet"))
            {
                this._groupSpecifier.ipMulticastMemberUpdatesEnabled = true;
                this._groupSpecifier.addIPMulticastAddress("224.0.1.200:3000");
            }
            else
            {
                this._groupSpecifier.serverChannelEnabled = true;
            }
            this._groupSpec = this._groupSpecifier.groupspecWithoutAuthorizations();
            this.onJoinNetGroup();
            return;
        }// end function

        private function onJoinNetGroup() : void
        {
            this._netGroup = new NetGroup(this._netConnection, this._groupSpec);
            return;
        }// end function

        private function onMousedown(event:MouseEvent) : void
        {
            Constans.MIX_VIDEO = true;
            this.sv.PublishMc.startDrag(false);
            return;
        }// end function

        private function onMouseup(event:MouseEvent) : void
        {
            Constans.MIX_VIDEO = false;
            this.sv.PublishMc.stopDrag();
            return;
        }// end function

        private function publishVideo()
        {
            try
            {
                WebHelp.nd("���˷�����Ƶ��" + this.getKey() + "_video");
                this.camera = this.getCam();
                this.minVideo.attachCamera(null);
                this.minVideo.attachCamera(this.camera);
                // 设置输出流
                this._outgoingStream = WebUtil.setCamH264Setting(this._outgoingStream);
                this._outgoingStream.attachCamera(this.camera);
                WebUtil.info("����С��Ƶ1��" + this.getKey());
                this._outgoingStream.publish(this.getKey(), "live");
                this._outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent)
            {
                WebUtil.info("pub : " + event.info.code);
                return;
            }// end function
            );
            }
            catch (e)
            {
                WebUtil.info("publishVideo:" + e.message);
            }
            return;
        }// end function

        private function getCam() : Camera {
            this.camera = WebHelp.getCam(this.camera);
            WebHelp.info("cam:" + Constans.IS_CAMERA_CHECK);
            if (!Constans.IS_CAMERA_CHECK) {
                Constans.IS_CAMERA_CHECK = true;
                try {
                    this.checkCamBusy();
                } catch (e) {}
            }
            if (this.camera.name.indexOf("17") > -1) {
                return this.camera;
            }
            this.camera.setQuality((parseFloat(this.sv.getParam("limitBandWidth")) || this.maxBandWidth) * 1024, Math.floor(parseFloat(this.sv.getParam("lQuality")) || 85));
            this.videoSize = this.sv.getParam("lSize") ? (parseInt(this.sv.getParam("lSize"))) : (this.videoSize);
            this.camera.setMode(this.videoSize, this.videoSize * this.sv.videoShow.height / this.sv.videoShow.width, Math.floor(parseFloat(this.sv.getParam("frames")) || 12));
            return this.camera;
        }// end function

        private function checkCamBusy() : void
        {
            var intelvalTimes:*;
            var afun:*;
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

        private function clearVideo()
        {
            try
            {
                this.minVideo.attachCamera(null);
                this.minVideo.clear();
                if (this._outgoingStream)
                {
                    this._outgoingStream.attachCamera(null);
                    this._outgoingStream.attachAudio(null);
                    this._outgoingStream.receiveAudio(false);
                    this._outgoingStream.receiveVideo(false);
                    this._outgoingStream.close();
                    this._outgoingStream = null;
                }
            }
            catch (e)
            {
                WebUtil.info("clearVideo��" + e.message);
            }
            return;
        }// end function

        private function clearNetGroup() : void
        {
            this._netGroup.close();
            this._netGroup = null;
            return;
        }// end function

        private function getKey() : String
        {
            return Constans.E_CODE + "meet_" + this.sv.getParam("meetId") + "_" + this.sv.getParam("myid") + "_video";
        }// end function

    }
}
