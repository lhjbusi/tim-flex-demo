package com.codyy.ppmeet {
	import com.codyy.ppmeet.control.*;
	import com.codyy.ppmeet.media.*;
	import com.codyy.ppmeet.net.*;
	import com.codyy.ppmeet.p2p.*;
	import com.codyy.ppmeet.red5.*;
	import com.codyy.ppmeet.speaker.*;
	import com.codyy.ppmeet.ui.*;
	import com.codyy.ppmeet.util.*;
	import com.codyy.ui.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class SpeakerVideo extends MovieClip {
		public var speaker:MovieClip;
		public var videoDisplay:Video;
		public var nobody:MovieClip;
		public var PublishMc:MovieClip;
		public var pauseMC:MovieClip;
		public var rateInfo:TextField;
		public var controlMicBtn:MovieClip;
		public var controlBtn:MovieClip;
		public var fullScreenB:MovieClip;
		public var soundMicBar:MovieClip;
		public var wait_txt:TextField;
		public var soundBar:MovieClip;
		public var Mic:MovieClip;
		public var videoShow:Video;
		public var bg_mc:MovieClip;
		public var mc:MovieClip;
		public var Container:MovieClip;
		private var videoSize:Number = 300;
		private var videoWithAudio:Boolean = false;
		private var maxBandWidth:int = 512;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var ns2:NetStream;
		public var mic:Microphone;
		public var mic111:Microphone;
		private var camera:Camera;
		public var param:Object;
		private var currentCamVolume:Number;
		public var uidAudio:Array;
		public var uidSpeak:Array;
		public var sLines:Object;
		public var lines:Number = 1;
		public var largeVideo:LargeVideo = null;
		public var smallVideo:SmallVideo = null;
		public var p2pLargeVideo:P2pLargeVideo = null;
		public var p2pSmallVideo:P2pSmallVideo = null;
		public var mediaRecord:MediaRecord = null;
		public var sMsg:SharedObjectMsg = null;
		public var checker:Check = null;
		
		public function SpeakerVideo() {
			this.param = stage.loaderInfo.parameters;
			this.currentCamVolume = SoundMixer.soundTransform.volume;
			this.uidAudio = [];
			this.uidSpeak = [];
			this.sLines = new Object();
			Security.allowDomain("*");
			Constans.params = stage.loaderInfo.parameters;
			Constans.GROUP_ID = "groupId=meet_" + Constans.params["meetId"];
			this.checker = new Check();
			this.checker.checkPrivary();
			this.initServer();
			this.mediaRecord = new MediaRecord(this);
			this.mediaRecord.initEvent();
			var _loc_1:* = new SpeakerInit(this);
			_loc_1.setVolume(0.3);
			_loc_1.init();
			var _loc_2:* = new ControlSound(this);
			_loc_2.init();
			this.main();
			this.sMsg = new SharedObjectMsg(this);
			this.mediaRecord.setMsg(this.sMsg);
			NetworkTraffic.display();
			return;
		}// end function

		public function setAudioMeet(param1:String = "") {
			var maskLoader:Sprite;
			var onCom:Function;
			var img:* = param1;
			onCom = function (event:Event) : void {
				var _loc_2:* = event.target.loader;
				_loc_2.content.width = 214;
				_loc_2.content.height = 160;
				maskLoader.addChild(_loc_2);
				return;
			}// end function
			;
			if (!img) {
				img = Constans.HOST_IMG || "/public/img/meet/audio.jpg";
			}
			maskLoader = new Sprite();
			maskLoader.graphics.beginFill(16777215, 1);
			maskLoader.graphics.drawRect(0, 0, 214, 160);
			maskLoader.graphics.endFill();
			this.addChild(maskLoader);
			var loader:* = new Loader();
			loader.load(new URLRequest(img));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCom);
			return;
		}// end function

		public function setHead(param1:Boolean = false) {
			var f:* = param1;
			if (f) {
				setTimeout(function () {
					nobody.visible = true;
					return;
				}// end function
				, 3000);
			} else
				this.nobody.visible = true;
			return;
		}// end function

		public function removeHead(param1:Boolean = false) {
			var f:* = param1;
			if (f) {
				setTimeout(function () {
					nobody.visible = false;
					return;
				}// end function
				, 3000);
			} else
				this.nobody.visible = false;
			return;
		}// end function

		public function initServer() {
			var _loc_1:* = this.getParam("rtmp");
			var _loc_2:* = this.getParam("user");
			var _loc_3:* = this.getParam("rtmfp");
			var _loc_4:* = this.getParam("dvekey");
			var _loc_5:* = this.getParam("debug");
			var _loc_6:* = this.getParam("p2p");
			var _loc_7:* = this.getParam("fdebug");
			var _loc_8:* = this.getParam("msgcount");
			var _loc_9:* = this.getParam("network");
			var _loc_10:* = this.getParam("rtmpVideo");
			if (this.getParam("rtmpVideo")) {
				Constans.RTMP_VIDEO = _loc_10;
			} else {
				Constans.RTMP_VIDEO = _loc_1;
			}
			var _loc_11:* = this.getParam("code");
			if (this.getParam("code")) {
				Constans.E_CODE = _loc_11 + "_";
			}
			var _loc_12:* = this.getParam("meetType");
			if (this.getParam("meetType")) {
				Constans.MEET_TYPE = _loc_12;
			}
			var _loc_13:* = this.getParam("meetModel");
			if (this.getParam("meetModel")) {
				Constans.MEET_MODEL = _loc_13;
			}
			var _loc_14:* = _loc_3;
			Constans.RTMFP_SERVER = _loc_3;
			var _loc_14:* = _loc_4;
			Constans.RTMFP_DEVKEY = _loc_4;
			var _loc_14:* = _loc_1;
			Constans.RTMP_SERVER = _loc_1;
			var _loc_14:* = _loc_2;
			Constans.RTMP_USER = _loc_2;
			var _loc_14:* = _loc_5 && _loc_5 != 0;
			Constans.DEBUG = _loc_5 && _loc_5 != 0;
			var _loc_14:* = _loc_6 == "1";
			Constans.P2P = _loc_6 == "1";
			var _loc_14:* = _loc_7 && _loc_7 != 0;
			Constans.FILE_DEBUG = _loc_7 && _loc_7 != 0;
			var _loc_14:* = _loc_9 && _loc_9 != 0;
			Constans.NETWORD_TRAFFIC = _loc_9 && _loc_9 != 0;
			Constans.RTMP_LINE = _loc_10;
			Constans.HOST_IMG = this.getParam("hostImg");
			var _loc_14:* = parseInt(_loc_8);
			Constans.MSG_COUNT = parseInt(_loc_8);
			WebUtil.info("��ҵ�룺" + Constans.E_CODE);
			WebUtil.info("RTMFP���л�����" + Constans.RTMFP_SERVER + " --- " + Constans.RTMFP_DEVKEY);
			WebUtil.info("Red5���л�����" + Constans.RTMP_SERVER + " --- " + Constans.RTMP_USER);
			WebUtil.info("��·����ͨѶP2P���л�����" + (Constans.P2P ? ("P2P") : ("Red5")));
			WebUtil.info("��ͳ�ƿ��أ�" + Constans.NETWORD_TRAFFIC);
			WebUtil.info("Debug ������Debug ��" + Constans.DEBUG + " --- File Debug ��" + Constans.FILE_DEBUG);
			WebUtil.info("SharedObjectMsg Count �� " + Constans.MSG_COUNT);
			WebUtil.info("RTMP Line �� " + Constans.RTMP_LINE);
			WebUtil.info("Video IP �� " + WebHelp.getParam("ip"));
			WebUtil.info("�������� �� " + (Constans.MEET_TYPE == 1 ? ("�������") : ("��Ƶ����")));
			WebUtil.info("����ģʽ �� " + (Constans.MEET_MODEL == 1 ? ("��ͨģʽ") : ("ֱ��ģʽ")));
			if (Constans.MEET_TYPE == 1) {
				this.setAudioMeet();
			}
			return;
		}// end function

		private function main() : void {
			var _loc_1:* = new Menus(this);
			_loc_1.codyyMenus();
			var _loc_2:* = new FullScreen(this);
			var _loc_3:* = new WebUtil(this);
			if (Constans.MEET_TYPE == 2) {
			this.largeVideo = new LargeVideo(this);
			this.smallVideo = new SmallVideo(this);
			this.p2pLargeVideo = new P2pLargeVideo(this);
			this.p2pSmallVideo = new P2pSmallVideo(this);
			if (Constans.RTMP_LINE == 0) {
				if (this.param["server"]) {
					this.p2pLargeVideo.init(1);
					this.p2pSmallVideo.init(1);
				} else {
					this.p2pLargeVideo.init(0);
					this.p2pSmallVideo.init(0);
				}
			} else if (this.param["server"]) {
				this.largeVideo.init(1);
				this.smallVideo.init(1);
			} else {
				this.largeVideo.init(0);
				this.smallVideo.init(0);
			}
			this.videoSize = this.param["gaoqing"] ? (this.param["gaoqing"]) : (this.videoSize);
			this.videoWithAudio = this.param["videoWithAudio"] ? (true) : (false);
			}
			return;
		}// end function

		public function getKey(param1 = "") : String {
			return Constans.E_CODE + (this.param["meetTime"] ? (this.param["meetTime"] + "/") : ("")) + (this.param["meetId"] || "codyyGroup") + "_" + param1;
		}// end function

		public function getParam(param1:String) : String {
			return this.param[param1] || "";
		}// end function
	}
}
