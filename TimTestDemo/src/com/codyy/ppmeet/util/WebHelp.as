package com.codyy.ppmeet.util {
	import com.codyy.ppmeet.*;
	import flash.events.*;
	import flash.external.*;
	import flash.media.*;
	import flash.net.*;
	
	public class WebHelp extends Object {
		public function WebHelp() {
			return;
		}// end function

		public function MicVolume() {
			var mic:*;
			var activity:Function;
			activity = function (param1) {
				var _loc_2:* = mic.activityLevel;
				return;
			};// end function
			
			mic = getMic(true);
			mic.addEventListener(ActivityEvent.ACTIVITY, activity);
			return;
		}// end function

		public static function getParam(param1:String):String {
			return Constans.params[param1];
		}// end function

		/**
		 * 获取/初始化视频对象，并设置关键贴.
		 */
		public static function getCam(param1:Camera = null):Camera {
			if (param1) {
			} else {
				param1 = Camera.getCamera();
			}
			// 设置关键帧
			param1.setKeyFrameInterval(Constans.params["keyFrames"] ? (Constans.params["keyFrames"]):(15));
			return param1;
		}// end function

		/**
		 * 初始化麦克风及其属性.
		 */
		public static function getMic(param1:Boolean):Microphone {
			var _loc_2:* = Microphone.getMicrophone();
			_loc_2 = Microphone.getMicrophone();
			_loc_2.setLoopBack(false);
			// 麦克风捕获声音的频率
			_loc_2.rate = 44;
			// 麦克风增益
			_loc_2.gain = 60;
			try {
				// 设置噪音衰减分贝数，可选值：-30~0(不衰减)
				_loc_2.noiseSuppressionLevel = -10;
			} catch (e) {}
			// 设置可认定为有声的最低音量输入水平，可选值0~100
			// 以及实际静音前需经历的无声时间长度(毫秒)
			_loc_2.setSilenceLevel(1, 1000);
			// 指定是否使用音频编解码器的回音抑制功能
			_loc_2.setUseEchoSuppression(true);
			Constans.setMic(_loc_2);
			return _loc_2;
		}// end function

		public static function info(param1):void {
			if (Constans.DEBUG) {
				trace(param1);
				callJS("DM", param1 + "");
			}
			return;
		}// end function

		public static function addCallBack(param1:String, param2:Function):void {
			ExternalInterface.addCallback(param1, param2);
			return;
		}// end function
		
		public static function callJS(param1:String, param2):void {
			ExternalInterface.call(param1, param2);
			return;
		}// end function
		
		public static function sendMsg(param1:Object):void {
			callJS("flash_call", "<root from =\'" + (param1.from || "sys") + "\' c=\'" + (param1.act || "sys") + "\' to=\'" + (param1.to || "*") + "\' type=\'" + (param1.type || "group") + "\' say=\'" + encodeURI(param1.say || "") + "\' time=\'" + new Date().toString() + "\' />");
			return;
		}// end function

		public static function openUrl(param1:String, param2:String):void {
			if (param2 == null || param2.length < 1) {
				param2 = "_blank";
			}
			navigateToURL(new URLRequest(param1), param2);
			return;
		}// end function
		
		public static function alert(param1) {
			if (!Constans.DEBUG) {
				return;
			}
			ExternalInterface.call("alert", param1 + "");
			return;
		}// end function
		
		public static function salert(param1) {
			ExternalInterface.call("alert", param1 + "");
			return;
		}// end function

		public static function _logMsg(param1:String):void {
			return;
		}// end function

		public static function ajaxCall(param1:String, param2:Object, param3) {
			var i:*;
			var loader:URLLoader;
			var loader_complete:Function;
			var loader_security:Function;
			var loader_ioError:Function;
			var url:* = param1;
			var postData:* = param2;
			var callBack:* = param3;
			loader_complete = function (event:Event):void {
				if (callBack) {
					callBack(loader.data);
				}
				return;
			};// end function
			
			var loader_httpStatus:* = function (param1):void  {
				info("HTTPStatusEvent.HTTP_STATUS");
				info("HTTP ״̬����:" + param1.state);
				return;
			};// end function
			
			loader_security = function (param1):void {
				info("SecurityErrorEvent.SECURITY_ERROR");
				return;
			};// end function
			
			loader_ioError = function (param1):void {
				info("IOErrorEvent.IO_ERROR");
				return;
			};// end function
			
			var request:* = new URLRequest(url);
			var vars:* = new URLVariables();
			var _loc_5:int = 0;
			var _loc_6:* = postData;
			while (_loc_6 in _loc_5) {
				i = _loc_6[_loc_5];
				vars[i] = postData[i];
			}
			request.data = vars;
			request.method = URLRequestMethod.POST;
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, loader_complete);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_security);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError);
			loader.load(request);
			return;
		}// end function

		public static function nd(param1:String = "", param2:String = "speakerVideo.log", param3:Boolean = false) {
			var s:* = param1;
			var f:* = param2;
			var ff:* = param3;
			WebHelp.info(s);
			if (!Constans.FILE_DEBUG)
				return;
			WebHelp.ajaxCall("/index.php", {r:"common/default/nd", u:"nickyau", s:s, f:f}, function (param1:Object) {
				return;
			});// end function
			return;
		}// end function
		
		public static function evalJS(param1:String) {
			callJS("eval", param1);
			return;
		}// end function
		
		public static function evalJSDebug(param1:String, param2:Boolean = false) {
			if (!Constans.DEBUG && !param2)
				return;
			callJS("eval", param1);
			return;
		}// end function
		
		public static function getRequest(param1, param2) {
			var _loc_3:* = param2.replace(/\'/g, "\"");
			if (_loc_3.indexOf(param1 + "=\"") < 0) {
				return "";
			}
			var _loc_4:* = _loc_3.indexOf(param1 + "=\"") + param1.length + 2;
			var _loc_5:* = _loc_3.indexOf("\"", _loc_4);
			return _loc_3.substr(_loc_4, _loc_5 - _loc_4);
		}// end function
	}
}
