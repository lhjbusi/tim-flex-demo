package com.codyy.ppmeet.net {
	import com.codyy.ppmeet.*;
	import com.codyy.ppmeet.media.*;
	import com.codyy.ppmeet.util.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class SharedObjectMsg extends Object {
		public var sv:SpeakerVideo = null;
		public var nc:NetConnection = null;
		public var so:SharedObject = null;
		public var uid:String = "";
		public var msgs:Array;

		public function SharedObjectMsg(param1:SpeakerVideo) {
			this.msgs = new Array();
			this.sv = param1;
			this.initFunction();
			this.initConnection();
			return;
		}// end function

		public function initFunction() {
			this.uid = new Date().getTime() + "";
			WebHelp.addCallBack("sendData", this.sendData);
			setInterval(function() {
				saveMsgQuee();
				return;
			}// end function
			, 5*1000);
			return;
        }// end function

		public function initConnection() {
			this.nc = new NetConnection();
			this.nc.client = this;
			this.nc.objectEncoding = ObjectEncoding.AMF0;
			this.nc.connect(Constans.RTMP_SERVER, "", Constans.GROUP_ID);
			this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
			return;
		}// end function

		public function netStatusHandler(event:NetStatusEvent):void {
			var s:*;
			var evt:* = event;
			WebHelp.info("netStatusHandler:" + evt.info.code);
			if (evt.info.code == "NetConnection.Connect.Success") {
				WebHelp.info("��ʼ���ı����췿�䣺" + Constans.E_CODE + "pchat_" + this.sv.getParam("meetId"));
				this.so = SharedObject.getRemote(Constans.E_CODE + "pchat_" + this.sv.getParam("meetId"), this.nc.uri, false);
				this.so.connect(this.nc);
				this.so.addEventListener(SyncEvent.SYNC, this.newMessageHandler);
				setTimeout(function() {
				WebHelp.info("����������Ϣ");
				try {
					s = "<root type=\'group\' c=\'red5linkUp\' from=\'sys\'  to=\'sys\' say=\'\' date=\'" + new Date().getTime() + "\'/>";
					sendData(s);
					callPage(s);
				} catch (e) {}
				WebHelp.info("����������Ϣ���");
				return;
				}// end function
				, 1000);
			}
			if (evt.info.code == "NetConnection.Connect.Closed") {
				this.callPage(s);
				this.sendData(s);
			}
			return;
		}// end function

		public function callPage(param1:String):void {
			WebHelp.callJS("flash_call", param1);
			return;
		}// end function
		
		public function showTime(param1:String):void {
			MediaRecord.RECORD_TIME = parseInt(param1);
			try {
				WebHelp.callJS("showRecordTime", param1);
			} catch (e) {}
			return;
		}// end function

		public function newMessageHandler(event:SyncEvent):void {
			var _loc_4:* = undefined;
			var _loc_5:Object = null;
			var _loc_2:* = event.changeList;
			var _loc_3:* = 0;
			while (_loc_3 < _loc_2.length) {
				_loc_4 = _loc_2[_loc_3];
				if (_loc_4.name != undefined) {
					switch(_loc_4.name) {
						case "text_message": {
							_loc_5 = this.so.data.text_message;
							if (_loc_5.uid != this.uid) {
								WebHelp.info("�յ�������Ϣ(" + _loc_5.uid + ")��" + _loc_5.msg + "---" + _loc_5.rtime);
								if (_loc_5.rtime > 0) {
									this.showTime(_loc_5.rtime);
								} else {
									this.callPage(_loc_5.msg);
								}
							} else {
								this.saveMsg(_loc_5.msg);
							}
							break;
						}
						default:
							break;
					}
				}
				_loc_3 = _loc_3 + 1;
			}
			return;
		}// end function

		public function sendData(param1:String = "", param2:int = 0):void {
			var _loc_3:* = new Object();
			_loc_3.uid = this.uid;
			_loc_3.msg = param1;
			_loc_3.rtime = param2 + "";
			this.so.setProperty("text_message", _loc_3);
			this.so.setDirty("text_message");
			return;
		}// end function

		public function saveMsg(param1:String):void {
			if (!param1 || param1.length < 1) {
				return;
			}
			if (this.msgs.length <= Constans.MSG_COUNT) {
				this.msgs.push(param1);
				WebHelp.info("msg:" + this.msgs);
			} else {
				this.saveMsgQuee();
			}
			return;
		}// end function

		public function saveMsgQuee():void {
			var m:String;
			if (this.msgs.length < 1) {
				return;
			}
			var tmsg:* = this.msgs.splice(0, Constans.MSG_COUNT);
			WebHelp.info("������Ϣ��" + tmsg);
			var froms:* = new Array();
			var tos:* = new Array();
			var typs:* = new Array();
			var says:* = new Array();
			var nicks:* = new Array();
			var ofs:* = new Array();
			var i:*;
			while (i < tmsg.length) {
				m = tmsg[i];
				froms.push(WebHelp.getRequest("from", m));
				tos.push(WebHelp.getRequest("to", m));
				typs.push(WebHelp.getRequest("type", m));
				says.push(WebHelp.getRequest("say", m));
				nicks.push(WebHelp.getRequest("nick", m));
				ofs.push(0);
				i = (i + 1);
			}
			WebHelp.ajaxCall("/?r=coco/api/savehistory", {offline:ofs.join("|||"), from:froms.join("|||"), to:tos.join("|||"), type:typs.join("|||"), say:says.join("|||"), send_nick:nicks.join("|||")}, function (param1:Object) {
				WebHelp.info("��Ϣ��¼������" + param1);
				return;
			}// end function
			);
			return;
		}// end function
    }
}
