package com.codyy.ppmeet.red5 {
	import com.codyy.ppmeet.*;
	import com.codyy.ppmeet.util.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class SmallVideo extends Sprite {
		private var sv:SpeakerVideo = null;
		private var minVideo:Video = null;
		private var IP:String = "";
		private var rtmpVideoNetConn:NetConnection;
		private var rtmpVideoStream:NetStream;
		private var camera:Camera;
		private var intervalId:Object;
		private var Num:Number;
		private var NetConBoo:Boolean;
		private var reConnTimer:int;
		private var maxBandWidth:int = 512;
		private var videoSize:int = 100;
		
		public function SmallVideo(param1:SpeakerVideo) {
			this.sv = param1;
			this.minVideo = param1.PublishMc.showAndPublish_Video;
			this.IP = this.sv.getParam("ip");
			return;
		}// end function

		public function init(param1:Number = 1) {
			this.minVideo.smoothing = true;
			this.sv.PublishMc.addEventListener(MouseEvent.MOUSE_DOWN, this.onMousedown);
			this.sv.PublishMc.addEventListener(MouseEvent.MOUSE_UP, this.onMouseup);
			this.initRed5();
			this.Num = param1;
			return;
		}// end function

		private function initRed5() : void {
			var _loc_1:* = this.IP || "rtmp://www.codyy.net/oflaDemo";
			var _loc_2:String = "codyy";
			WebHelp.nd("������Ƶl�ӷ�����" + _loc_1);
			if (this.rtmpVideoNetConn) {
				this.rtmpVideoNetConn.close();
			}
			this.rtmpVideoNetConn = new NetConnection();
			this.rtmpVideoNetConn.addEventListener(NetStatusEvent.NET_STATUS, this.red5VideoStatusHandler);
			this.rtmpVideoNetConn.connect(Constans.RTMP_VIDEO, Constans.RTMP_USER, Constans.GROUP_ID.replace("meet_", "meet_small_"));
			this.rtmpVideoNetConn.client = this;
			Constans.pushConnection(this.rtmpVideoNetConn);
			return;
		}// end function

		private function red5VideoStatusHandler(event:NetStatusEvent) : void {
			var evt:* = event;
			switch(evt.info.code) {
				case "NetConnection.Connect.Success": {
					WebHelp.nd("������ƵRed5l�ӳɹ���" + this.sv.getParam("server") + "��");
					this.NetConBoo = true;
					if (this.Num == 1) {
						this.clearVideo();
					} else {
						this.publishVideo();
					}
					break;
				}
				case "NetConnection.Connect.Failed": {
					WebHelp.nd("������ƵRed5l��ʧ��");
					WebUtil.sendMsg({act:"sys", say:"l����Ƶ������ʧ�ܣ�" + evt.info.code});
					break;
				}
				case "NetConnection.Connect.Closed": {
					WebHelp.nd("������ƵRed5l�ӶϿ�");
					this.NetConBoo = false;
					clearInterval(this.reConnTimer);
					this.reConnTimer = setInterval(function () {
						if (!NetConBoo && !rtmpVideoNetConn.connected) {
							initRed5();
						}
						return;
						}// end function
					, 3000);
				}
				default:
					break;
			}
			return;
		}// end function

		private function onMousedown(event:MouseEvent) : void {
			Constans.MIX_VIDEO = true;
			this.sv.PublishMc.startDrag(false);
			return;
		}// end function

		private function onMouseup(event:MouseEvent) : void {
			Constans.MIX_VIDEO = false;
			this.sv.PublishMc.stopDrag();
			return;
		}// end function

		private function clearVideo() {
			this.minVideo.clear();
			this.minVideo.attachCamera(null);
			if (this.rtmpVideoStream) {
				this.rtmpVideoStream.attachCamera(null);
				this.rtmpVideoStream.attachAudio(null);
				this.rtmpVideoStream.receiveAudio(false);
				this.rtmpVideoStream.receiveVideo(false);
				this.rtmpVideoStream.close();
				this.rtmpVideoStream = null;
			}
			return;
		}// end function

		private function publishVideo() {
			WebHelp.nd("���˷�����Ƶ��" + this.getKey() + "_video");
			this.camera = this.getCam();
			this.rtmpVideoStream = new NetStream(this.rtmpVideoNetConn);
			this.rtmpVideoStream.attachCamera(this.camera);
			this.minVideo.attachCamera(this.camera);
			WebUtil.info("����С��Ƶ1��" + this.getKey());
			this.rtmpVideoStream.publish(this.getKey(), "live");
			this.rtmpVideoStream.addEventListener(NetStatusEvent.NET_STATUS, function (param1) {
				WebUtil.info("pub : " + param1.info.code);
				return;
			}// end function
			);
			WebHelp.nd("С��Ƶ������ɣ�");
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
			this.camera.setQuality((parseFloat(this.sv.getParam("limitBandWidth")) || this.maxBandWidth) * 1024, Math.floor(parseFloat(this.sv.getParam("lQuality")) || 90));
			this.videoSize = this.sv.getParam("lSize") ? (parseInt(this.sv.getParam("lSize"))) : (this.videoSize);
			this.camera.setMode(this.videoSize, this.videoSize * this.sv.videoShow.height / this.sv.videoShow.width, Math.floor(parseFloat(this.sv.getParam("frames")) || 12));
			return this.camera;
		}// end function

		private function checkCamBusy() : void {
			var intelvalTimes:*;
			var afun:*;
			var jihuo:*;
			WebUtil.info("camera length : " + Camera.names.length);
			if (Camera.names.length) {
				intelvalTimes;
				this.intervalId = setInterval(function () {
					var _loc_2:* = intelvalTimes + 1;
					intelvalTimes = _loc_2;
					WebUtil.info("camera FPS : " + intelvalTimes + "---" + camera.currentFPS);
					if (camera.currentFPS < 1) {
						if (intelvalTimes >= 80) {
							if (camera.name.indexOf("17") > -1) {
								WebHelp.callJS("flashAV", "visual_camera");
							} else {
								WebHelp.callJS("flashAV", "camera_busy");
							}
							clearInterval(intervalId);
						}
					} else {
						WebHelp.callJS("flashAV", "");
						clearInterval(intervalId);
					}
					return;
				}// end function
				, 100);
			} else {
				WebHelp.callJS("flashAV", "");
			}
			return;
        }// end function

        private function getKey() : String {
        	return Constans.E_CODE + "meet_" + this.sv.getParam("meetId") + "_" + this.sv.getParam("myid") + "_video";
        }// end function
    }
}
