// ActionScript file
package com.tim.chinesegreat {
	public class Constants {
		// FMS服务器地址
		public static var rtmpUrl:String = "rtmp://192.168.1.199/tim-test";

		// 未处理的请求.
		public static var NO_HANDLE:int = 0;

		// 正在处理的请求
		public static var CURRENT_HANDLE:int = 1;

		// 被忽略的请求
		public static var LOSE_HANDLE:int = 2;

		// 接受的请求
		public static var ACCEPT_HANDLE:int = 3;

		// 拒绝的请求
		public static var REJECT_HANDLE:int = 4;
		
		// 取消请求
		public static var CANCEL_HANDLE:int = 5;
	}
}