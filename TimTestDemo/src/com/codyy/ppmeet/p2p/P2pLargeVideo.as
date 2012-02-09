package com.codyy.ppmeet.p2p {
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.net.*;
    import com.codyy.ppmeet.util.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class P2pLargeVideo extends Sprite {
        private var sv:SpeakerVideo = null;
        private var VideoDis:Video = null;
        private var Num:Number;
        private var _netConnection:NetConnection;
        private var _outgoingStream:NetStream;
        private var _incomingStream:NetStream;
        private var _netConnectionConnected:Boolean;
        private var _netGroupConnected:Boolean;
        private const SERVER:String = "rtmfp://stratus.adobe.com/";
        private const DEVKEY:String = "c50af1426e2afbd7d1147903-e331e5f149d2";
        private var _netGroup:NetGroup;
        private var _nearID:String;
        private var _groupSpec:String;
        private var _estimatedP2PMembers:Number;
        private var camera:Camera;
        private var maxBandWidth:int = 512;
        private var videoSize:Number = 300;
        private var intervalId:Object;
        private var _groupSpecifier:GroupSpecifier;

        public function P2pLargeVideo(param1:SpeakerVideo) {
            this.sv = param1;
            this.VideoDis = param1.videoShow;
            return;
        }// end function

        public function init(param1:Number = 1) {
            this.sv.pauseMC.visible = false;
            this.VideoDis.smoothing = true;
            this.initRTMFP();
            this.Num = param1;
            return;
        }// end function

        private function initRTMFP() {
            if (this._netConnection) {
                this._netConnection.close();
                this._netConnection = null;
            }
            this._netConnection = new NetConnection();
            if (this.sv.getParam("maxPeer")) {
                this._netConnection.maxPeerConnections = parseInt(this.sv.getParam("maxPeer"));
            }
            this._netConnection.objectEncoding = ObjectEncoding.AMF0;
            this._netConnection.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            WebHelp.nd("��ʼ��������Ƶ��" + (this.sv.getParam("rtmfp") || this.SERVER + this.DEVKEY));
            this._netConnection.connect(this.sv.getParam("rtmfp") || this.SERVER + this.DEVKEY);
            Constans.pushConnection(this._netConnection);
            return;
        }// end function

        private function onNetStatus(event:NetStatusEvent) : void {
            switch(event.info.code) {
                case "NetConnection.Connect.Success": {
                    WebHelp.nd("��ʼ��������Ƶ�ɹ���");
                    this._netConnectionConnected = true;
                    WebUtil.sendMsg({act:"sys", say:"��ȡ��ݱ�ʶ�ųɹ���"});
                    this._createGroupSpec();
                    break;
                }
                case "NetConnection.Connect.Closed":
                case "NetConnection.Connect.Failed":
                case "NetConnection.Connect.Rejected":
                case "NetConnection.Connect.AppShutdown":
                case "NetConnection.Connect.InvalidApp": {
                    if (Constans.IS_CLOSE) {
                        return;
                    }
                    WebHelp.nd("������Ƶl��ʧ�ܣ�ʹ��NetGroupl�ӣ�");
                    WebUtil.sendMsg({act:"sys", say:"l�ӷ�����ʧ�ܣ�" + event.info.code});
                    if (this._netGroup) {
                        this.clearNetGroup();
                    }
                    this._outgoingStream = null;
                    this._incomingStream = null;
                    this._netConnectionConnected = false;
                    break;
                }
                case "NetStream.Connect.Success": {
                    WebHelp.nd("������ƵNetStream�ɹ�");
                    if (this.Num == 1)
                        this._attachLocalVideo();
                    else
                        this._attachPeerVideo();
                    break;
                }
                case "NetStream.Connect.Rejected":
                case "NetStream.Connect.Failed":
                    WebHelp.nd("������ƵNetStreamʧ��");
                    break;
                case "NetStream.Publish.Start":
                    break;
                case "NetStream.MulticastStream.Reset":
                case "NetStream.Buffer.Full":
                default:
                    break;
                case "NetGroup.Connect.Rejected":
                    WebHelp.nd("������ƵNetGroup�ɹ�");
                    this._netGroupConnected = true;
                    WebUtil.sendMsg({act:"sys", say:"���Ѽ��������" + this.getKey()});
                    this._estimatedP2PMembers = this._netGroup.estimatedMemberCount;
                    if (this.Num == 1)
                        this.onStartOutgoingStream();
                    else
                        this.onStartIncomingStream();
                    break;
                case "NetGroup.Connect.Failed":
                case : {
                    WebHelp.nd("������ƵNetGroupʧ��");
                    try {
                        WebUtil.sendMsg({type:"group", act:"speakerNetGroupDown", from:"sys", to:"sys", say:"", data:new Date().getTime()});
                    } catch (e) {}
                    this.clearNetGroup();
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _attachLocalVideo() : void
        {
            var loader:Loader;
            this.camera = this.getCam();
            if (this.camera == null) {
                loader = new Loader();
                loader.load(new URLRequest("public/img/meet/nobody.jpg"));
                this.sv.stage.addChild(loader);
                this.sv.stage.setChildIndex(loader, 0);
            }
            // 用户是否允许访问摄像头
            if (this.camera.muted) {
                this.camera.addEventListener(StatusEvent.STATUS, function (event:StatusEvent) : void {
	                switch(event.code) {
	                    case "Camera.Unmuted": {
	                        _startp2ppublish();
	                    }
	                    case "Camera.Muted": {
	                        ExternalInterface.call("onSure", "");
	                    }
	                    default:
	                    	break;
	                }
	                return;
	            }// end function
	            );
            }
            else
            {
                this._startp2ppublish();
            }
            return;
        }// end function

        private function _startp2ppublish()
        {
            this.sv.removeHead();
            this.VideoDis.attachCamera(null);
            this.VideoDis.attachCamera(this.camera);
            this._outgoingStream = WebUtil.setCamH264Setting(this._outgoingStream);
            this._outgoingStream.attachCamera(this.camera);
            WebUtil.info("publish video : " + this.getKey());
            WebHelp.nd("���˷�����Ƶ��ɣ�" + this.getKey() + "_video");
            this._outgoingStream.publish(this.getKey() + "_video");
            this._outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent)
            {
                WebUtil.info("pub 1 :" + event.info.code);
                return;
            }// end function
            );
            WebHelp.nd("���˷�����Ƶ��ɣ�");
            var nt:* = new NetworkTraffic(this.getKey() + "_video", this._outgoingStream);
            nt.processUpload();
            return;
        }// end function

        private function _attachPeerVideo() : void
        {
            this.VideoDis.attachNetStream(null);
            this.VideoDis.attachNetStream(this._incomingStream);
            WebHelp.nd("����������Ƶ��" + this.getKey() + "_video");
            this._incomingStream.play(this.getKey() + "_video");
            this.sv.removeHead();
            WebHelp.nd("����������Ƶ��ɣ�");
            var _loc_1:* = new NetworkTraffic(this.getKey() + "_video", this._incomingStream);
            _loc_1.processDownload();
            return;
        }// end function

        private function disconnectStream()
        {
            if (this._outgoingStream)
            {
                this._outgoingStream.attachAudio(null);
                this._outgoingStream.attachCamera(null);
                this._outgoingStream.receiveAudio(false);
                this._outgoingStream.receiveVideo(false);
                this._outgoingStream.close();
                this._outgoingStream = null;
            }
            if (this._incomingStream)
            {
                this._incomingStream.attachAudio(null);
                this._incomingStream.attachCamera(null);
                this._incomingStream.receiveAudio(false);
                this._incomingStream.receiveVideo(false);
                this._incomingStream.close();
                this._incomingStream = null;
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
            if (this.camera.name == "17GuaGua Cam")
            {
                return this.camera;
            }
            this.camera.setQuality((parseFloat(this.sv.getParam("limitBandWidth")) || this.maxBandWidth) * 1024, Math.floor(parseFloat(this.sv.getParam("quality")) || 85));
            this.videoSize = this.sv.getParam("gaoqing") ? (parseInt(this.sv.getParam("gaoqing"))) : (this.videoSize);
            this.camera.setMode(this.videoSize, this.videoSize * this.VideoDis.height / this.VideoDis.width, Math.floor(parseFloat(this.sv.getParam("frames")) || 12));
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
                        WebHelp.callJS("flashAV", "camera_busy");
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

        private function onStartOutgoingStream() : void
        {
            try
            {
                this.disconnectStream();
                this._outgoingStream = new NetStream(this._netConnection, this._groupSpec);
                this._outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
                this._outgoingStream.client = this;
                Constans.pushNetStream(this._outgoingStream);
            }
            catch (e)
            {
                WebHelp.nd("_outgoingStream=" + e.message);
            }
            return;
        }// end function

        private function onStartIncomingStream() : void
        {
            try
            {
                this.disconnectStream();
                this._incomingStream = new NetStream(this._netConnection, this._groupSpec);
                this._incomingStream.client = this;
                Constans.pushNetStream(this._incomingStream);
            }
            catch (e)
            {
                WebHelp.nd("_incomingStream=" + e.message);
            }
            return;
        }// end function

        private function _createGroupSpec() : void {
            this._groupSpecifier = new GroupSpecifier("%E9%98%94%E5%9C%B0" + this.sv.getParam("meetId"));
            this._groupSpecifier.postingEnabled = true;
            this._groupSpecifier.multicastEnabled = true;
            if (this.sv.getParam("intranet")) {
            	// 允许在 IP 多播套接字中交换有关组成员资格的信息-有助于提高P2P性能
                this._groupSpecifier.ipMulticastMemberUpdatesEnabled = true;
                // 
                this._groupSpecifier.addIPMulticastAddress("224.0.1.200:3000");
            } else {
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

        private function clearNetGroup() : void
        {
            this._netGroup.close();
            this._netGroupConnected = false;
            this._netGroup = null;
            return;
        }// end function

        private function getKey() : String
        {
            return Constans.E_CODE + (this.sv.getParam("meetTime") ? (this.sv.getParam("meetTime") + "/") : ("")) + (this.sv.getParam("meetId") || "codyyGroup");
        }// end function

    }
}
