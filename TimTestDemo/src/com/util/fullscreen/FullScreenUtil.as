package com.util.fullscreen
{
	import flash.display.DisplayObject;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.utils.Dictionary;

	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;

	public class FullScreenUtil
	{
		private static var theCanvas:Canvas;
		private static var displayObjectMap:Dictionary = new Dictionary(true);
		private static var anchorMap:Dictionary = new Dictionary(true);
		private static var _canvasStyleName:String = null;
		
		public static var isFullScreen:Boolean = false;
		
		/**
		 *Getters and setters to facilitate styling the background canvas 
		 * @param val
		 * 
		 */		
		public static function set canvasStyleName(val:String):void{
			_canvasStyleName = val;
		}
		
		public static function get canvasStyleName():String{
			return _canvasStyleName;
		}
		
		/**
		 *Use this method to send the application full screen 
		 * @param color color for the full screen background to be
		 * 
		 */		
		public static function goFullScreen(color:uint = 0x000000):void{
			isFullScreen = true;
			theCanvas = new Canvas();
			theCanvas.mouseEnabled = false;
			
			if(canvasStyleName){
				theCanvas.styleName = canvasStyleName;
			}else{
				theCanvas.setStyle('backgroundColor', color);				
			}
			
			PopUpManager.addPopUp(theCanvas, Application.application as DisplayObject);
			
			Application.application.stage.displayState = StageDisplayState.FULL_SCREEN;
			
			onResize();
							
			(Application.application as DisplayObject).addEventListener(ResizeEvent.RESIZE, onResize);
			theCanvas.systemManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onExitFullScreen);
		}
		
		
		/**
		 *Use this method to exit full screen 
		 * all cleanup and child parenting will be done automatically
		 */		
		public static function exitFullScreen():void{
			isFullScreen = false;
			if(!theCanvas)return;
			(Application.application as DisplayObject).removeEventListener(ResizeEvent.RESIZE, onResize);
			theCanvas.systemManager.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onExitFullScreen);
			if(theCanvas.systemManager.stage.displayState == StageDisplayState.FULL_SCREEN)theCanvas.systemManager.stage.displayState = StageDisplayState.NORMAL;
			PopUpManager.removePopUp(theCanvas);
			readdChildred();
			theCanvas = null;
		}
		
		/**
		 *Use this method to addchildren to the full screen instance after you've called the <code>goFullScreen()</code> method
		 * if you strech proportionally without anchoring the object will be moved to 0,0 in the canvas' coordinate space 
		 * @param displayObject - display object to be added
		 * @param centerHorizontally - whether to center horizontally in the canvas space
		 * @param centerVertically - whether to center vertically in the canvas space
		 * @param stretchProportional - whether to stretch proportionally to cover all of the space
		 * @param anchorLeft - left anchor
		 * @param anchorRight - right anchor
		 * @param anchorTop - top anchor
		 * @param anchorBottom - bottom anchor
		 * 
		 */		
		public static function addChild(displayObject:UIComponent, centerHorizontally:Boolean = false, centerVertically:Boolean = false, stretchProportional:Boolean = false, anchorLeft:Number = -1, anchorRight:Number = -1, anchorTop:Number = -1, anchorBottom:Number = -1 ):void{
			if(!theCanvas)return;
			var infoObject:Object = new Object();
			infoObject['parent'] = displayObject.parent;
			infoObject['x'] = displayObject.x;
			infoObject['y'] = displayObject.y;
			infoObject['width'] = displayObject.width;
			infoObject['height'] = displayObject.height;
			infoObject['percentWidth'] = displayObject.percentWidth
			infoObject['percentHeight'] = displayObject.percentHeight;
			if(displayObject.parent)infoObject['childIndex'] = displayObject.parent.getChildIndex(displayObject);
			displayObjectMap[displayObject] = infoObject;
			
			var anchorObject:Object = new Object();
			anchorObject['stretchProportional'] = stretchProportional;
			anchorObject['anchorLeft'] = anchorLeft;
			anchorObject['anchorRight'] = anchorRight;
			anchorObject['anchorTop'] = anchorTop;
			anchorObject['anchorBottom'] = anchorBottom;
			anchorObject['centerVertically'] = centerVertically;
			anchorObject['centerHorizontally'] = centerHorizontally;
			anchorMap[displayObject] = anchorObject;
			
			
			theCanvas.addChild(displayObject);
			
			onResize();
		}
		
		
		/**
		 *Remove a child explicitly from the full screen view
		 * cleanup is done, and it is reparented 
		 * @param displayObject - child to be removed
		 * 
		 */		
		public static function removeChild(displayObject:UIComponent):void{
			var uic:UIComponent = displayObject as UIComponent;
			var infoObject:Object = displayObjectMap[uic];
			if(!infoObject)return;
			if(infoObject['parent']){
				(infoObject['parent'] as Container).addChildAt(uic, infoObject['childIndex']);
				if(isNaN(infoObject['percentWidth'])){
					uic.width = infoObject['width'];
				}else{
					uic.percentWidth = infoObject['percentWidth'];
				}
				if(isNaN(infoObject['percentHeight'])){
					uic.height = infoObject['height'];
				}else{
					uic.percentHeight = infoObject['percentHeight'];
				}
				uic.x = infoObject['x'];
				uic.y = infoObject['y'];
				delete displayObjectMap[uic];
				delete anchorMap[uic];
			}
		}
		
		/**
		 *Readds all children to their correct containers
		 * used when we're exiting full screen 
		 * 
		 */		
		private static function readdChildred():void{
			for(var key:Object in displayObjectMap){
				if(key is UIComponent){
					removeChild(key as UIComponent);
				}
			}
		}
		
		/**
		 *Called on resize to update the coordinates of anchored children throughout the canvas 
		 * 
		 */		
		private static function updateAnchorStates():void{
			for(var key:Object in anchorMap){
				if(key is UIComponent){
					var uic:UIComponent = key as UIComponent;
					var anchorObject:Object = anchorMap[key];
					var stretchProportional:Boolean = anchorObject['stretchProportional'] as Boolean;
					var anchorLeft:Number = anchorObject['anchorLeft'] as Number;
					var anchorRight:Number = anchorObject['anchorRight'] as Number;
					var anchorTop:Number = anchorObject['anchorTop'] as Number;
					var anchorBottom:Number = anchorObject['anchorBottom'] as Number;
					var centerVertically:Boolean = anchorObject['centerVertically'] as Boolean;
					var centerHorizontally:Boolean = anchorObject['centerHorizontally'] as Boolean;
				
					if(stretchProportional){
						var w:Number = uic.width;
						var h:Number = uic.height;
						var sw:Number = Application.application.screen.width;
						var sh:Number = Application.application.screen.height;
						if(w > h){
							uic.width = sw;
							uic.validateNow();
							uic.height *= (uic.width / w);
							uic.validateNow();
						}else{
							uic.height = sh;
							uic.validateNow();
							uic.width *= (uic.height / h);
							uic.validateNow();
						}
					}
				
					if(anchorLeft != -1){
						uic.x = anchorLeft;
					}
					
					if(anchorRight != -1){
						uic.x = Application.application.screen.width - uic.width - anchorRight;
					}

					if(anchorTop != -1){
						uic.y = anchorTop;
					}
					
					if(anchorBottom != -1){
						uic.y = Application.application.screen.height - uic.height - anchorBottom;
					}
	

					
					if(anchorLeft == -1 && anchorRight == -1 && stretchProportional)uic.x = 0;
					if(anchorTop == -1 && anchorBottom == -1 && stretchProportional)uic.y = 0;
					
					if(centerVertically)uic.y = Application.application.screen.height / 2 - uic.height / 2;
					if(centerHorizontally)uic.x = Application.application.screen.width / 2 - uic.width / 2;
				}
			}
		}
		
		
		/**
		 *When the application is resized 
		 * @param event
		 * 
		 */		
		private static function onResize(event:ResizeEvent = null):void{
			if(!theCanvas)return;
			theCanvas.width = Application.application.screen.width;
			theCanvas.height = Application.application.screen.height;
			theCanvas.validateNow();
			updateAnchorStates();
		}
		
		/**
		 *When full screen is exited with the escape key this will be triggered 
		 * @param e
		 * 
		 */		
		private static function onExitFullScreen(e:FullScreenEvent):void{
			if(e != null && !e.fullScreen)exitFullScreen();
		}

	}
}