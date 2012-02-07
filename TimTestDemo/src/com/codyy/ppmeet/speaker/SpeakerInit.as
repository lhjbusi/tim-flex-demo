package com.codyy.ppmeet.speaker {
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.ui.*;
    import com.codyy.ppmeet.util.*;
    import flash.media.*;
    import flash.utils.*;

    public class SpeakerInit extends Object {
        private var sv:SpeakerVideo = null;

        public function SpeakerInit(param1:SpeakerVideo) {
            this.sv = param1;
            return;
        }// end function

        public function init() {
            this.checkDevice();
            var _loc_1:* = new SpeakerLine(this.sv);
            _loc_1.initConnect();
            this.sv.sLines["speaker_1"] = _loc_1;
            WebUtil.addCallBack("startSpeaker", this.startSpeaker);
            WebUtil.addCallBack("audioStart", this.audioStart);
            WebUtil.addCallBack("audioStop", this.audioStop);
            WebUtil.addCallBack("stopSpeaker", this.stopSpeaker);
            WebUtil.addCallBack("receiveAudioAndVideo", this.receiveAudioAndVideo);
            WebUtil.addCallBack("receiveAudio", this.receiveAudio);
            WebUtil.addCallBack("startPublishVideo", this.startPublishVideo);
            WebUtil.addCallBack("startReceiveVideo", this.startReceiveVideo);
            WebUtil.addCallBack("stopReceiveSpeaker", this.stopReceiveSpeaker);
            WebUtil.addCallBack("cancleSpeaker", this.cancleSpeaker);
            WebUtil.addCallBack("closeVideo", this.switchVideo);
            WebUtil.addCallBack("changeVideoLine", this.changeVideoLine);
            WebUtil.addCallBack("getCameraStatus", this.getCameraStatus);
            WebUtil.addCallBack("debug", this.debug);
            WebUtil.addCallBack("clearNet", this.clearNet);
            WebUtil.addCallBack("setHostImg", this.setHostImg);
            var _loc_2:* = new FullScreen(this.sv);
            _loc_2.init();
            if (this.sv.getParam("speakeruid")) {
                this.reveiveUid();
            }
            return;
        }// end function

        public function avStatus() {
            setTimeout(function () {
                var _loc_1:Number = 0;
                var _loc_2:Number = 0;
                try {
                    _loc_2 = Camera.getCamera().activityLevel;
                } catch (error) {
                    _loc_1 = Microphone.getMicrophone().activityLevel;
                }
                WebUtil.info("�豸�����Mic ActiveLevel��" + _loc_1 + "��Camera ActiveLevel��" + _loc_2);
                _loc_1 = _loc_1 > 0 && _loc_1 < 100 ? (1):(0);
                _loc_2 = _loc_2 > 0 && _loc_2 < 100 ? (1):(0);
                WebUtil.info("�豸�����al��" + _loc_1 + "��vl��" + _loc_2);
                WebUtil.callJS("hasDevice", [_loc_2, _loc_1]);
                return;
            }// end function
            , 3000);
            return;
        }// end function

        public function avNamesStatus() {
            var _loc_3:Camera = null;
            var _loc_1:Number = 0;
            var _loc_2:Number = 0;
            if (Constans.MEET_TYPE == 2) {
                _loc_3 = Camera.getCamera();
                try {
                    _loc_2 = Camera.names.length > 0 ? (1):(0);
                    _loc_3 = null;
                } catch (error) {}
            } else {
                _loc_2 = 1;
            }
            try {
                _loc_1 = Microphone.names.length > 0 ? (1):(0);
            } catch (error){}
            WebUtil.info("�豸�����al��" + _loc_1 + "��vl��" + _loc_2);
            Constans.HAS_CAMEAR = _loc_2 > 0;
            WebUtil.callJS("hasDevice", [_loc_2, _loc_1]);
            return;
        }// end function

        public function checkDevice() {
            this.avNamesStatus();
            return;
        }// end function

        public function setVolume(param1:Number = 1) {
            var _loc_2:* = new SoundTransform(param1, 0);
            SoundMixer.soundTransform = _loc_2;
            Constans.MIC_VOLUME = param1;
            return;
        }// end function

        private function startSpeaker(param1 = "1"):void {
            WebUtil.info("startSpeaker:" + param1);
            this.clearUidSpeaker(param1);
            this.clearLine(param1);
            var _loc_2:* = new SpeakerLine(this.sv);
            _loc_2.speaker(param1);
            this.sv.sLines["speaker_" + param1] = _loc_2;
            if (this.getCameraStatus(param1) == "0") {
                this.sv.setHead(true);
            } else if (Constans.MEET_TYPE == 2) {
                if (Constans.RTMP_LINE == 0) {
                    this.sv.p2pLargeVideo.init(1);
                    this.sv.p2pSmallVideo.init(1);
                } else {
                    this.sv.largeVideo.init(1);
                    this.sv.smallVideo.init(1);
                }
            }
            return;
        }// end function

        private function startPublishVideo(param1 = "1"):void {
            if (this.getCameraStatus(param1) == "0") {
                this.sv.setHead(true);
            } else if (Constans.MEET_TYPE == 2) {
                if (Constans.RTMP_LINE == 0) {
                    this.sv.p2pLargeVideo.init(1);
                    this.sv.p2pSmallVideo.init(1);
                } else {
                    this.sv.largeVideo.init(1);
                    this.sv.smallVideo.init(1);
                }
            }
            return;
        }// end function

        private function startReceiveVideo(param1 = "1"):void {
            if (this.getCameraStatus(param1) == "0") {
                this.sv.setHead(true);
            } else if (Constans.MEET_TYPE == 2) {
                if (Constans.RTMP_LINE == 0) {
                    this.sv.p2pLargeVideo.init(0);
                    this.sv.p2pSmallVideo.init(0);
                } else {
                    this.sv.largeVideo.init(0);
                    this.sv.smallVideo.init(0);
                }
            }
            return;
        }// end function

        private function audioStart(param1 = "1", param2:Boolean = false):void {
            var _loc_5:SpeakerLine = null;
            WebUtil.DMT("audioStart��" + param1 + "��" + param2 + "��");
            var _loc_3:* = param1.split(",");
            var _loc_4:Number = 0;
            while (_loc_4 < _loc_3.length) {
                this.clearLine(_loc_3[_loc_4]);
                _loc_5 = new SpeakerLine(this.sv);
                _loc_5.isSpeaker = param2;
                if (param2) {
                    this.clearUidSpeaker(_loc_3[_loc_4]);
                    _loc_5.speaker(_loc_3[_loc_4]);
                } else {
                    this.clearUidAudio(_loc_3[_loc_4]);
                    _loc_5.receivceSpeaker(_loc_3[_loc_4]);
                }
                this.sv.sLines["speaker_" + _loc_3[_loc_4]] = _loc_5;
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        private function audioStop(param1 = "1", param2:Boolean = false):void {
            var sline:SpeakerLine;
            var uid:* = param1;
            var isSpeaker:* = param2;
            WebUtil.info("audioStop��" + uid + "��" + isSpeaker + "��");
            try {
                sline = this.sv.sLines["speaker_" + uid];
                sline.stopAudioPlay(uid);
                sline;
                this.sv.sLines["speaker_" + uid] = null;
            } catch (e) {
                WebUtil.info("��ֹͣ�����û������쳣(" + e + ")");
            }
            WebUtil.info("��ֹͣ�����û��������(" + uid + ")");
            return;
        }// end function

        private function stopSpeaker(param1 = "1", param2:Number = 0):void {
            var i:*;
            var uid:* = param1;
            var flag:* = param2;
            try {
                this.clearUidSpeaker(uid);
                this.clearUidAudio(uid);
                WebUtil.info("speaker_" + uid);
                var _loc_4:int = 0;
                var _loc_5:* = this.sv.sLines;
                while (_loc_5 in _loc_4) {
                    i = _loc_5[_loc_4];
                    WebUtil.info("line:" + i);
                }
                this.sv.sLines["speaker_" + uid].stopSpeaker();
                this.sv.sLines["speaker_" + uid] = null;
            } catch (e:Error) {
                WebUtil.info("stopSpeaker 1:" + e.message);
            }
            if (flag > 0) {
                Constans.IS_CLOSE = true;
                try {
                    this.sv.sLines["speaker_1"].stopSpeaker();
                    this.sv.sLines["speaker_1"] = null;
                } catch (e) {
                    WebUtil.info("stopSpeaker 2:" + e.message);
                }
            }
            if (flag > 0) {
                this.sv = null;
                Constans.RTMFP_DEVKEY = "";
                Constans.RTMFP_SERVER = "";
                Constans.RTMP_SERVER = "";
            }
            return;
        }// end function

        private function switchVideo(param1 = "1", param2:Number = 0):void {
            var uid:* = param1;
            var flag:* = param2;
            try {
                WebUtil.info("switch video��" + flag + "��");
                var _loc_4:Boolean = true;
                Constans.IS_CLOSE = true;
                if (this.getCameraStatus(uid) == "0") {
                    this.sv.setHead(true);
                } else if (Constans.MEET_TYPE == 2) {
                    if (Constans.RTMP_LINE == 0) {
                        this.sv.p2pLargeVideo.init(0);
                        this.sv.p2pSmallVideo.init(0);
                    } else {
                        this.sv.largeVideo.init(0);
                        this.sv.smallVideo.init(0);
                    }
                }
            } catch (e:Error) {
                WebUtil.info(e.message);
            }
            return;
        }// end function

        private function cancleSpeaker(param1 = "1"):void {
            WebUtil.info("cancleSpeaker");
            WebUtil.info("�Ѷ��󽻸�����ˣ�" + param1);
            this.sv.sLines["speaker"].cancleSpeaker(param1);
            return;
        }// end function

        private function receiveAudioAndVideo(param1 = "1"):void {
            WebUtil.info("receiveAudioAndVideo");
            this.clearUidSpeaker(param1);
            this.clearUidAudio(param1);
            this.clearLine(param1);
            var _loc_2:* = new SpeakerLine(this.sv);
            _loc_2.receivceSpeaker(param1);
            this.sv.sLines["speaker_" + param1] = _loc_2;
            if (this.getCameraStatus(param1) == "0") {
                this.sv.setHead(true);
            } else if (Constans.MEET_TYPE == 2) {
                if (Constans.RTMP_LINE == 0) {
                    this.sv.p2pLargeVideo.init(0);
                    this.sv.p2pSmallVideo.init(0);
                } else {
                    this.sv.largeVideo.init(0);
                    this.sv.smallVideo.init(0);
                }
            }
            return;
        }// end function

        private function clearUidAudio(param1 = "1") {
            if (this.sv.uidAudio.indexOf(param1) > -1) {
                this.sv.uidAudio.splice(this.sv.uidAudio.indexOf(param1), 1);
            }
            return;
        }// end function

        private function clearUidSpeaker(param1 = "1") {
            if (this.sv.uidSpeak.indexOf(param1) > -1) {
                this.sv.uidSpeak.splice(this.sv.uidSpeak.indexOf(param1), 1);
            }
            return;
        }// end function

        private function receiveAudio(param1 = "1"):void {
            var _loc_4:SpeakerLine = null;
            WebUtil.info("receiveAudio");
            var _loc_2:* = param1.split(",");
            var _loc_3:Number = 0;
            while (_loc_3 < _loc_2.length) {
                this.clearUidAudio(_loc_2[_loc_3]);
                this.clearLine(_loc_2[_loc_3]);
                _loc_4 = new SpeakerLine(this.sv);
                _loc_4.receivceSpeaker(_loc_2[_loc_3]);
                this.sv.sLines["speaker_" + _loc_2[_loc_3]] = _loc_4;
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function reveiveUid():void {
            var _loc_3:SpeakerLine = null;
            WebUtil.info("reveiveUid");
            this.audioStart(this.sv.getParam("myid"));
            var _loc_1:* = this.sv.getParam("speakeruid").split(",");
            var _loc_2:Number = 0;
            while (_loc_2 < _loc_1.length) {
                this.clearUidAudio(_loc_1[_loc_2]);
                this.clearLine(_loc_1[_loc_2]);
                _loc_3 = new SpeakerLine(this.sv);
                _loc_3.receivceSpeaker(_loc_1[_loc_2]);
                this.sv.sLines["speaker_" + _loc_1[_loc_2]] = _loc_3;
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function stopReceiveSpeaker(param1 = "1"):void {
            WebUtil.info("stopReceiveSpeaker");
            this.sv.sLines["speaker_" + param1].stopSpeaker();
            this.sv.sLines["speaker_" + param1] = null;
            return;
        }// end function

        private function changeVideoLine(param1:Number = 0, param2:Boolean = true):void {
            var line:* = param1;
            var isSpeaker:* = param2;
            if (Constans.MEET_TYPE != 2) {
                return;
            }
            try {
                WebUtil.info("changeVideoLine��" + line + "��" + isSpeaker + "��");
                Constans.RTMP_LINE = line;
                Constans.params["server"] = isSpeaker;
                WebUtil.info("server:" + WebHelp.getParam("server"));
                if (isSpeaker) {
                    if (Constans.RTMP_LINE == 0) {
                        this.sv.p2pLargeVideo.init(1);
                        this.sv.p2pSmallVideo.init(1);
                    } else {
                        this.sv.largeVideo.init(1);
                        this.sv.smallVideo.init(1);
                    }
                } else if (Constans.RTMP_LINE == 0) {
                    this.sv.p2pLargeVideo.init(0);
                    this.sv.p2pSmallVideo.init(0);
                } else {
                    this.sv.largeVideo.init(0);
                    this.sv.smallVideo.init(0);
                }
                WebUtil.info("��Ƶ��·�л��ɹ���");
            } catch (e) {
                WebUtil.info(e);
            }
            return;
        }// end function

        private function debug(param1:Number = 0) {
            WebUtil.info("debug");
            Constans.DEBUG = param1 == 1;
            return;
        }// end function

        private function getCameraStatus(param1 = "1"):String {
            var uid:* = param1;
            var hasCamera:*;
            try {
                hasCamera = WebUtil.callJS("getCameraStatus", uid).toString();
            } catch (e) {
                WebUtil.info("getCameraStatus:" + e);
            }
            return "1";
        }// end function

        private function clearLine(param1 = "1") {
            var sline:SpeakerLine;
            var uid:* = param1;
            try {
                sline = this.sv.sLines["speaker_" + uid];
                sline.stopSpeaker(uid);
                sline;
                this.sv.sLines["speaker_" + uid] = null;
            } catch (e) {
                WebUtil.info("�����l�� clearLine");
            }
            WebUtil.info("�����l�� clearLine���");
            return;
        }// end function

        private function clearNet(param1 = "1") {
            var i:*;
            var j:*;
            var uid:* = param1;
            this.clearUidSpeaker(uid);
            this.clearUidAudio(uid);
            Constans.IS_CLOSE = true;
            WebHelp.nd("clearNet ��" + new Date().toLocaleDateString());
            try {
                this.switchVideo(1, 1);
                this.stopSpeaker(uid, 1);
            } catch (e) {
                this.sv.videoShow.clear();
                this.sv.videoShow.attachCamera(null);
            } catch (e) {
                WebUtil.info("VideoDis clear attach null");
                WebUtil.info("clearNet��" + Constans.NET_STREAMS.length + "��" + Constans.CONNECTIONS.length + "��");
                i;
                while (i < Constans.NET_STREAMS.length) {
                    WebUtil.info("--- " + i + ":" + Constans.NET_STREAMS[i]);
                    try {
                        Constans.NET_STREAMS[i].attachAudio(null);
                    }
                    catch (e) {
                        WebUtil.info("close netstream attachAudio error:" + i);
                        Constans.NET_STREAMS[i].attachCamera(null);
                    } catch (e) {
                        WebUtil.info("close netstream attachCamera error:" + i);
                        Constans.NET_STREAMS[i].close();
                    } catch (e) {
                        WebUtil.info("close netstream close error:" + i);
                        Constans.NET_STREAMS[i] = null;
                    } catch (e) {
                        WebUtil.info("close netstream null error:" + i);
                    }
                    i = (i + 1);
                }
                j;
                while (j < Constans.CONNECTIONS.length) {
                    WebUtil.info("=== " + j + ":" + Constans.CONNECTIONS[j]);
                    try {
                        Constans.CONNECTIONS[j].close();
                        Constans.CONNECTIONS[j] = null;
                    } catch (e) {
                        WebUtil.info("close connection error:" + j);
                    }
                    j = (j + 1);
                }
            } catch (e) {}
            WebUtil.callJS("flashQuitMeet", "");
            WebHelp.nd("�ر�l�ӡ�" + new Date().getUTCDate());
            return;
        }// end function

        private function setHostImg(param1:String = "") {
            this.sv.setAudioMeet(param1);
            return;
        }// end function
    }
}
