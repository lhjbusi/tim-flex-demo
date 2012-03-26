package writepad3_fla
{
    import fl.containers.*;
    import fl.controls.*;
    import fl.data.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.ui.*;

    dynamic public class MainTimeline extends MovieClip
    {
        public var bfb:TextField;
        public var webCarve:MovieClip;
        public var myLoad:ScrollPane;
        public var eraser:MovieClip;
        public var eraser_small:MovieClip;
        public var fullScreenB:MovieClip;
        public var bg:MovieClip;
        public var masker:MovieClip;
        public var comPercent:ComboBox;
        public var pen:MovieClip;
        public var currentpage:TextField;
        public var stageMc:MovieClip;
        public var topBg:MovieClip;
        public var doublemc:MovieClip;
        public var comboBox:ComboBox;
        public var nextbtn:MovieClip;
        public var input_btn:MovieClip;
        public var prevbtn:MovieClip;
        public var capturing:MovieClip;
        public var param:Object;
        public var ip:String;
        public var port:String;
        public var meetId:String;
        public var myID:String;
        public var client:String;
        public var interval:Number;
        public var current:String;
        public var bgURL:String;
        public var curID:String;
        public var toID:Object;
        public var lastMessageID:String;
        public var noSocket:String;
        public var indexID:Number;
        public var num:Number;
        public var sendInterval:uint;
        public var bb:Number;
        public var initRID:Number;
        public var boo:Boolean;
        public var time1:Number;
        public var mc:MovieClip;
        public var idx:Number;
        public var receiveIdx:Object;
        public var pressed:Boolean;
        public var receivePressed:Boolean;
        public var movieClips:Object;
        public var txtArr:Array;
        public var oldXY:Object;
        public var arr:Array;
        public var arr_:Object;
        public var buffer:Object;
        public var lastSCROLL:Object;
        public var tout:Object;
        public var Vol:Number;
        public var volBoo:Boolean;
        public var Index:uint;
        public var MOUSEDOWN:Object;
        public var webCar:String;
        public var captur:String;
        public var inputArr:Array;
        public var inputIndex:int;
        public var textIndex:uint;
        public var hadtext:Boolean;
        public var _value:uint;
        public var nomove:Array;
        public var xmlSocket:XMLSocket;
        public var person:Object;
        public var rgb:Object;
        public var colorNum:Object;
        public var reveUnico:Array;
        public var ARR:Array;
        public var isDir:Object;
        public var PPT:String;
        public var maxSize:String;
        public var loaded:String;
        public var sendNum:Object;
        public var pointerNum:Object;
        public var xy:Object;
        public var item:String;
        public var i:Object;
        public var itemArr:Array;
        public var j:Object;
        public var Unico:Array;
        public var missMess:String;
        public var myMenu:ContextMenu;

        public function MainTimeline()
        {
            addFrameScript(0, this.frame1);
            this.__setProp_comboBox_();
            return;
        }// end function

        public function RESIZE(event:Event)
        {
            var er:*;
            var i:*;
            var e:* = event;
            this.bfb.x = stage.stageWidth / 2 - this.bfb.width / 2;
            try
            {
                this.setStage();
            }
            catch (e)
            {
                er;
                var _loc_4:int = 0;
                var _loc_5:* = e;
                while (_loc_5 in _loc_4)
                {
                    
                    i = _loc_5[_loc_4];
                    er = er + (i + ":" + e[i] + ",");
                }
                ExternalInterface.call("flash_call", "<root from=\'sys\' c=\'sys\' to=\'*\' type=\'group\' say=\'flash错误：" + er + "\'/>");
            }
            return;
        }// end function

        public function inputHandler(event:MouseEvent) : void
        {
            var e:* = event;
            if (this.hadtext)
            {
                return;
            }
            this.hadtext = true;
            var input_mc:* = new INPUT_MC();
            input_mc.input_txt.textColor = 16711680;
            input_mc.input_txt.autoSize = TextFieldAutoSize.LEFT;
            input_mc.input_txt.wordWrap = true;
            input_mc.input_txt.border = true;
            try
            {
                stage.focus = input_mc.input_txt;
            }
            catch (e)
            {
                DM("kkk" + e.message);
            }
            this.stageMc.addChild(input_mc);
            input_mc.x = this.input_btn.x - this.stageMc.x;
            input_mc.y = 40 - this.stageMc.y;
            this.nomove[0] = input_mc.x;
            this.nomove[1] = input_mc.y;
            this.inputArr.push(input_mc);
            input_mc.id = this.inputIndex;
            this.textIndex = this.inputIndex;
            var _loc_3:String = this;
            var _loc_4:* = this.inputIndex + 1;
            _loc_3.inputIndex = _loc_4;
            input_mc.addEventListener(MouseEvent.MOUSE_DOWN, this.mousedHandler);
            input_mc.addEventListener(MouseEvent.MOUSE_UP, this.mouseuHandler);
            input_mc.addEventListener(MouseEvent.MOUSE_MOVE, this.mousemHandler);
            return;
        }// end function

        public function mousedHandler(event:MouseEvent) : void
        {
            event.currentTarget.startDrag(false);
            return;
        }// end function

        public function mousemHandler(event:MouseEvent) : void
        {
            this.textIndex = event.currentTarget.id;
            return;
        }// end function

        public function mouseuHandler(event:MouseEvent) : void
        {
            event.currentTarget.stopDrag();
            if (this.hadtext)
            {
                return;
            }
            this.sendData("<root from=\'" + this.myID + "\' to=\'" + this.toID + "\' inputX=\'" + event.currentTarget.x + "\' inputY=\'" + event.currentTarget.y + "\' ArrLength=\'" + this.inputArr.length + "\' txtID=\'" + event.currentTarget.id + "\' p2p=\'1\' type=\'group\' act=\'inputXY\' />");
            return;
        }// end function

        public function alert(param1)
        {
            return ExternalInterface.call("alert", param1 + "");
        }// end function

        public function DM(param1)
        {
            return this.param["debug"] ? (ExternalInterface.call("DM", param1 + "")) : ("");
        }// end function

        public function getParam(param1:String) : String
        {
            return this.param[param1];
        }// end function

        public function getContentXY()
        {
            return this.myLoad.content ? ([this.myLoad.content.x, this.myLoad.content.y]) : ([0, 0]);
        }// end function

        public function onConnects(event:Event) : void
        {
            if (event)
            {
                this.xmlSocket.send("<root from=\'" + this.myID + "\' type=\'login\' gid=\'" + this.meetId || "codyyGroup" + "\' to=\'" + this.myID + "\' say=\'\' />");
                ExternalInterface.call("flash_call", "<root from=\'sys\' c=\'sys\' to=\'*\' type=\'group\' say=\'连接服务器成功！\'/>");
            }
            else
            {
                ExternalInterface.call("flash_call", "<root from=\'sys\' c=\'sys\' to=\'*\' type=\'group\' say=\'连接服务器失败！\'/>");
            }
            return;
        }// end function

        public function onDatas(... args) : void
        {
            args = new activation;
            var item:*;
            var t:*;
            var from:*;
            var input_mc:INPUT_MC;
            var un:int;
            var id:uint;
            var input_:INPUT_MC;
            var n:uint;
            var u:uint;
            var s:*;
            var c:*;
            var __x:*;
            var __y:*;
            var ___x:*;
            var ___y:*;
            var j:*;
            var len2:*;
            var event:* = args;
            this.DM("onDatas 收到");
            var msg:* =  + "";
            this.DM("白板收到：" + );
            if (indexOf("time=") > 0)
            {
                ExternalInterface.call("flash_call", );
                return;
            }
            XML.ignoreWhitespace = true;
            var xml:* = new XML("<root>" +  + "</root>");
            this.DM("xml 解析结果:" + );
            var _loc_3:int = 0;
            var _loc_4:* = ;
            while (_loc_4 in _loc_3)
            {
                
                item = _loc_4[_loc_3];
                t = @act;
                from = @from;
                if ( == "zoom")
                {
                    this.comPercent.enabled = true;
                    this.comPercent.selectedIndex = @index;
                    this.upDateS("beCalled");
                    try
                    {
                        this.myLoad.horizontalScrollPosition = 0;
                        this.myLoad.verticalScrollPosition = 0;
                    }
                    catch (e)
                    {
                    }
                    try
                    {
                    }
                    if ( == "inputtext")
                    {
                        this.reveUnico = @input.split(",");
                        if (this.reveUnico.length > 0)
                        {
                            input_mc = new INPUT_MC();
                            input_txt.type = TextFieldType.DYNAMIC;
                            input_txt.textColor = 16711680;
                            input_txt.selectable = false;
                            input_txt.autoSize = TextFieldAutoSize.LEFT;
                            input_txt.wordWrap = true;
                            x = @inputX;
                            y = @inputY;
                            this.stageMc.addChild();
                            addChild(this.stageMc);
                            this.txtArr.push();
                            if (this.txtArr.length < (parseInt(@targetID) + 1))
                            {
                                this.txtArr = [];
                                id;
                                while ( < @targetID)
                                {
                                    
                                    input_ = new INPUT_MC();
                                    this.txtArr.push();
                                    id = ( + 1);
                                }
                                this.txtArr.push();
                            }
                            name = @from;
                            id = @targetID;
                            un;
                            while ( < this.reveUnico.length)
                            {
                                
                                input_txt.appendText(String.fromCharCode(this.reveUnico[]));
                                un = ( + 1);
                            }
                        }
                    }
                    if ( == "inputXY")
                    {
                        this.ARR = [];
                        n;
                        while ( < this.txtArr.length)
                        {
                            
                            if (this.txtArr[].name == @from)
                            {
                                this.ARR.push(this.txtArr[]);
                            }
                            n = ( + 1);
                        }
                        if (parseInt(@ArrLength) < this.ARR.length)
                        {
                            if (@ArrLength == 1)
                            {
                                this._value = this.ARR.length - 1;
                            }
                            this.ARR[parseInt(@txtID) + this._value].x = @inputX;
                            this.ARR[parseInt(@txtID) + this._value].y = @inputY;
                            return;
                        }
                        u;
                        while ( < this.txtArr.length)
                        {
                            
                            if (this.txtArr[].name == @from && this.txtArr[].id == @txtID)
                            {
                                this.txtArr[].x = @inputX;
                                this.txtArr[].y = @inputY;
                                return;
                            }
                            u = ( + 1);
                        }
                    }
                }
                catch (e)
                {
                    DM("inputtext error:" + e.message);
                }
                if ( == "randompage")
                {
                    try
                    {
                        this.DM("翻页同步开始");
                        this.indexID = @index;
                        this.comboBox.selectedIndex = this.indexID;
                        this.DM("开始加载图片");
                        this.setImageSize();
                        this.DM("清除画笔");
                        this.clearPad();
                        this.pen.x = this.comboBox.x + this.comboBox.width / 3;
                        this.pen.y = this.comboBox.y + this.comboBox.height / 3;
                        this.DM("翻页同步结束");
                    }
                    catch (e)
                    {
                        DM("randompage error:" + e.message);
                    }
                }
                if ( == "scroll")
                {
                    s = @say.split(",");
                    c = @min.split(",");
                    if ([0] > 5)
                    {
                        this.myLoad.verticalScrollPosition = [0];
                    }
                    else
                    {
                        this.myLoad.verticalScrollPosition = this.myLoad.content.height - this.myLoad.height + 10;
                    }
                    if ([1] > 5)
                    {
                        this.myLoad.horizontalScrollPosition = [1];
                    }
                    else
                    {
                        this.myLoad.horizontalScrollPosition = this.myLoad.content.width - this.myLoad.width + 10;
                    }
                }
                if ( == "padClear")
                {
                    this.clearPad();
                    this.pen.x = this.eraser.x + this.eraser.width / 3;
                    this.pen.y = this.eraser.y + this.eraser.height / 3;
                    continue;
                }
                if (!this.receiveIdx[])
                {
                    this.receiveIdx[] = 0;
                    if (this.colorNum == 3)
                    {
                        this.colorNum = 0;
                        ;
                    }
                    this.person[] = this.rgb[this.colorNum];
                    var _loc_5:String = this;
                    var _loc_6:* = this.colorNum + 1;
                    _loc_5.colorNum = _loc_6;
                }
                if ( == "pad")
                {
                    this.setChildIndex(this.pen, (this.numChildren - 1));
                    if (this.arr_[])
                    {
                    }
                    else
                    {
                        this.arr_[] = [];
                    }
                    s = @say.split(",");
                    j;
                    len2 = length;
                    while ( < )
                    {
                        
                        __x = [];
                        __y = [( + 1)];
                        if ( == 0 &&  == 0)
                        {
                            this.receivePressed = true;
                        }
                        else if ( == -1 &&  == -1)
                        {
                            var _loc_5:* = this.receiveIdx;
                            var _loc_6:* = ;
                            var _loc_7:* = this.receiveIdx[] + 1;
                            _loc_5[_loc_6] = _loc_7;
                            this.receivePressed = false;
                        }
                        else
                        {
                            ___x = Math.floor();
                            ___y = Math.floor();
                            if (this.MOUSEDOWN == 0)
                            {
                                if (this.myLoad.content != null)
                                {
                                    this.pen.x = Math.floor() - (this.myLoad.horizontalScrollPosition || 0) + this.myLoad.content.x;
                                    this.pen.y = Math.floor() - (this.myLoad.verticalScrollPosition || 0) + this.myLoad.content.y;
                                }
                                else
                                {
                                    this.pen.x = Math.floor();
                                    this.pen.y = Math.floor();
                                }
                            }
                            if (this.receivePressed)
                            {
                                var _loc_5:* = this.receiveIdx;
                                var _loc_6:* = ;
                                var _loc_7:* = this.receiveIdx[] + 1;
                                _loc_5[_loc_6] = _loc_7;
                                this.pen.visible = true;
                                this.arr_[][this.receiveIdx[]] = new Sprite();
                                this.arr_[][this.receiveIdx[]].graphics.lineStyle(2, this.person[], 1);
                                this.arr_[][this.receiveIdx[]].graphics.moveTo(, );
                                this.movieClips.push(this.arr_[][this.receiveIdx[]]);
                                this.stageMc.addChild(this.arr_[][this.receiveIdx[]]);
                                addChild(this.stageMc);
                                this.receivePressed = false;
                            }
                            this.arr_[][this.receiveIdx[]].graphics.lineTo(, );
                        }
                        j =  + 2;
                    }
                }
            }
            return;
        }// end function

        public function getRID(param1)
        {
            var _loc_2:String = this;
            var _loc_3:* = this.initRID + 1;
            _loc_2.initRID = _loc_3;
            return this.initRID;
        }// end function

        public function sendXML(param1 = null, param2 = null)
        {
            var xml:*;
            var isClear:* = param1;
            var flag:* = param2;
            var curID:* = this.getRID(6);
            if (isClear)
            {
                xml = "<root from=\'" + this.myID + "\' MID=\'" + this.lastMessageID + "\' NID=\'" + curID + "\' type=\'group\' act=\'" + (flag ? ("pad") : ("padClear")) + "\' p2p=\'1\' to=\'" + this.toID + "\' say=\'" + (flag ? (isClear.join(",")) : (mouseX + "," + mouseY)) + "\' />";
                this.sendData(xml);
            }
            else if (this.buffer.length)
            {
                try
                {
                    xml = "<root from=\'" + this.myID + "\' MID=\'" + this.lastMessageID + "\' NID=\'" + curID + "\' xy=\'" + this.getContentXY() + "\' type=\'group\' act=\'pad\' p2p=\'1\' to=\'" + this.toID + "\' say=\'" + this.buffer.join(",") + "\' />";
                    this.sendData(xml);
                }
                catch (e)
                {
                }
                this.buffer = [];
            }
            this.lastMessageID = curID;
            return;
        }// end function

        public function sendData(param1)
        {
            this.DM("sendData 收到");
            if (!this.noSocket)
            {
                this.xmlSocket.send(param1);
            }
            else
            {
                ExternalInterface.call("sendXY", param1);
            }
            return;
        }// end function

        public function DOUBLEMC(param1)
        {
            if (this.fullScreenB.currentFrame == 1)
            {
                this.Full();
                root.fullScreenB.gotoAndStop(2);
            }
            else
            {
                this.noFull();
                root.fullScreenB.gotoAndStop(1);
            }
            return;
        }// end function

        public function fullS(event:MouseEvent)
        {
            if (this.fullScreenB.currentFrame == 1)
            {
                this.fullScreenB.gotoAndStop(2);
            }
            else
            {
                this.fullScreenB.gotoAndStop(1);
            }
            if (this.fullScreenB.currentFrame == 2)
            {
                this.Full();
            }
            else
            {
                this.noFull();
            }
            return;
        }// end function

        public function setFull()
        {
            this.oldXY = this.getContentXY();
            this.boo = true;
            this.showUI(false);
            setTimeout(function ()
            {
                bg.x = eraser.x - 660;
                topBg.width = bg.x;
                return;
            }// end function
            , 300);
            this.myLoad.horizontalScrollPosition = 0;
            this.myLoad.verticalScrollPosition = 0;
            this.fullScreenB.fullS_txt.text = this.param["normal"] || "还原";
            return;
        }// end function

        public function Full()
        {
            if (this.param["small"])
            {
                stage.displayState = StageDisplayState.FULL_SCREEN;
                this.setFull();
            }
            else
            {
                this.setFull();
            }
            if (this.client)
            {
            }
            else
            {
                this.sendData("<root from=\'" + this.myID + "\' type=\'group\' act=\'fullBtn\' p2p=\'1\' to=\'" + this.toID + "\' say=\'" + 1 + "\' />");
            }
            ExternalInterface.call("fullScreenNow", this.client);
            return;
        }// end function

        public function setNoFull()
        {
            this.oldXY = this.getContentXY();
            this.boo = false;
            if (this.client == "")
            {
                this.showUI(true);
            }
            this.stageMc.x = this.getMyLoadContentXY().x;
            this.stageMc.y = this.getMyLoadContentXY().y;
            this.fullScreenB.fullS_txt.text = this.param["fullScreen"] || "全屏";
            if (this.inputIndex > 0)
            {
                if (this.inputArr[(this.inputIndex - 1)].x == this.nomove[0] && this.inputArr[(this.inputIndex - 1)].y == this.nomove[1])
                {
                    setTimeout(function ()
            {
                inputArr[(inputIndex - 1)].x = input_btn.x - stageMc.x;
                inputArr[(inputIndex - 1)].y = 40 - stageMc.y;
                return;
            }// end function
            , 100);
                }
            }
            return;
        }// end function

        public function noFull()
        {
            this.setNoFull();
            if (this.param["small"])
            {
                this.showUI(false);
                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.displayState = StageDisplayState.NORMAL;
            }
            if (this.client)
            {
            }
            else
            {
                this.sendData("<root from=\'" + this.myID + "\' type=\'group\' act=\'fullBtn\' p2p=\'1\' to=\'" + this.toID + "\' say=\'" + 0 + "\' />");
            }
            ExternalInterface.call("restoreFullScreen", this.client);
            return;
        }// end function

        public function setStage()
        {
            try
            {
                this.currentpage.x = 15;
                this.currentpage.y = stage.stageHeight - 35;
                this.myLoad.setSize(stage.stageWidth, stage.stageHeight - 36);
                this.masker.width = stage.stageWidth - 16;
                this.masker.height = stage.stageHeight - 56;
                this.doublemc.width = stage.stageWidth - 12;
                this.doublemc.height = stage.stageHeight - 52;
                this.fullScreenB.x = stage.stageWidth - this.fullScreenB.width - 4;
                this.comPercent.x = this.fullScreenB.x - this.comPercent.width - 8;
                this.nextbtn.x = this.comPercent.x - this.nextbtn.width - 4;
                this.comboBox.x = this.nextbtn.x - this.comboBox.width - 8;
                this.prevbtn.x = this.comboBox.x - this.prevbtn.width - 4;
                this.eraser.x = this.prevbtn.x - this.eraser.width;
                this.input_btn.x = this.eraser.x - this.input_btn.width - 4;
                this.eraser_small.x = stage.stageWidth - this.fullScreenB.width - 4;
                this.eraser_small.y = stage.stageHeight - 37;
                this.bg.x = this.eraser.x - 662.05;
                setTimeout(function ()
            {
                bg.x = eraser.x - 660;
                topBg.width = bg.x;
                return;
            }// end function
            , 100);
                if (stage.stageWidth < 1)
                {
                    this.tout = setTimeout(this.setStage, 3000);
                    return;
                }
                if (!this.myLoad.content)
                {
                    this.tout = setTimeout(this.setStage, 3000);
                    return;
                }
                if (!this.myLoad.content.width || this.myLoad.content.width < 1)
                {
                    this.tout = setTimeout(this.setStage, 3000);
                    return;
                }
                this.myLoad.content.x = this.getMyLoadContentXY().x;
                this.myLoad.content.y = this.getMyLoadContentXY().y;
                this.stageMc.x = -(this.myLoad.horizontalScrollPosition || 0) + this.getMyLoadContentXY().x;
                this.stageMc.y = -(this.myLoad.verticalScrollPosition || 0) + this.getMyLoadContentXY().y;
                this.oldXY = this.getContentXY();
                clearTimeout(this.tout);
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function changeImage(param1, param2)
        {
            var item:String;
            var i:*;
            var url:* = param1;
            var totalPics:* = param2;
            try
            {
                this.DM("changeImage 收到");
                this.DM("changeImage:url" + url + ",total:" + totalPics);
                this.num = totalPics;
                this.comPercent.selectedIndex = 3;
                this.Vol = this.param["scale"] || 1.3;
                this.stageMc.scaleX = this.Vol;
                this.stageMc.scaleY = this.Vol;
                this.bgURL = url;
                this.indexID = 0;
                this.comboBox.removeAll();
                i;
                while (i <= totalPics)
                {
                    
                    item = i;
                    this.comboBox.addItem({label:item});
                    i = (i + 1);
                }
                setTimeout(function ()
            {
                syscToOthers(bgURL, num);
                setImageSize();
                return;
            }// end function
            , 200);
                this.clearPad();
                ExternalInterface.call("changePadImage", [url, totalPics]);
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function beChangedImage(param1, param2)
        {
            var _loc_3:String = null;
            this.DM("beChangedImage 收到");
            this.DM("beChangedImage:url" + param1 + ",total:" + param2);
            this.num = param2;
            this.bgURL = param1;
            this.indexID = 0;
            this.comboBox.removeAll();
            var _loc_4:* = 1;
            while (_loc_4 <= param2)
            {
                
                _loc_3 = _loc_4;
                this.comboBox.addItem({label:_loc_3});
                _loc_4 = _loc_4 + 1;
            }
            this.setImageSize();
            this.clearPad();
            this.comPercent.selectedIndex = 3;
            this.Vol = this.param["scale"] || 1.3;
            return;
        }// end function

        public function syscToOthers(param1, param2)
        {
            var a:*;
            var curID:*;
            var xml:*;
            var bgURL:* = param1;
            var num:* = param2;
            try
            {
                a = bgURL.split("/");
                bgURL = a.join("/");
                curID = this.getRID(6);
                xml = "<root from=\'" + this.myID + "\' MID=\'" + this.lastMessageID + "\' NID=\'" + curID + "\' type=\'group\' act=\'CIMG\' p2p=\'1\' to=\'" + this.toID + "\' say=\'" + escape(bgURL + "," + num) + "\' />";
                this.sendData(xml);
                this.lastMessageID = curID;
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function setImageSize()
        {
            if (this.client)
            {
                this.showUI(false);
            }
            else if (this.boo)
            {
                this.showUI(false);
            }
            else
            {
                this.showUI(true);
            }
            this.isDir = this.bgURL.substr((this.bgURL.length - 1), 1) == "/";
            this.bgURL = "uploadDir/" + this.bgURL.split("uploadDir/").pop();
            if (this.bgURL != "uploadDir/")
            {
                if (this.isDir)
                {
                    this.myLoad.source = this.bgURL + this.indexID + "." + "jpg";
                    this.comboBox.enabled = true;
                    if (this.num == 1)
                    {
                        this.comboBox.enabled = false;
                    }
                    else
                    {
                        this.comboBox.enabled = true;
                    }
                    if (this.indexID == (this.num - 1))
                    {
                        this.nextbtn.removeEventListener(MouseEvent.CLICK, this.NEXTBTN);
                    }
                    else
                    {
                        this.nextbtn.addEventListener(MouseEvent.CLICK, this.NEXTBTN);
                    }
                }
                else
                {
                    this.myLoad.source = this.bgURL;
                    this.nextbtn.removeEventListener(MouseEvent.CLICK, this.NEXTBTN);
                    this.comboBox.enabled = false;
                }
                this.speaker();
            }
            else if (!this.param["usePad"])
            {
                this.joinner();
            }
            if (this.client == 1)
            {
                this.comboBox.enabled = false;
                this.prevbtn.removeEventListener(MouseEvent.CLICK, this.PREVBTN);
                this.nextbtn.removeEventListener(MouseEvent.CLICK, this.NEXTBTN);
            }
            this.myLoad.horizontalScrollPosition = 0;
            this.myLoad.verticalScrollPosition = 0;
            if (this.isDir)
            {
                this.currentpage.text = this.PPT + (parseInt(this.indexID) + 1) + " / " + this.num || (this.num > 0 ? ("") : (this.bgURL == "uploadDir/" ? (this.param["errorLoad"]) : ("加载文档出错！")));
            }
            else
            {
                this.currentpage.text = "";
            }
            try
            {
                if (this.currentpage.text == this.param["errorLoad"] || "加载文档出错！")
                {
                    this.scrollListener("");
                }
            }
            catch (e)
            {
                DM(param["errorLoad"] || "加载文档出错!" + e);
            }
            ExternalInterface.call("changePadImage", [this.bgURL, this.num]);
            return;
        }// end function

        public function scrollListener(param1) : void
        {
            this.stageMc.y = -this.myLoad.verticalScrollPosition + this.getMyLoadContentXY().y;
            this.stageMc.x = -this.myLoad.horizontalScrollPosition + this.getMyLoadContentXY().x;
            return;
        }// end function

        public function _sycScroll()
        {
            if (this.client)
            {
                return;
            }
            this.sScroll();
            return;
        }// end function

        public function sScroll()
        {
            var _loc_1:* = Math.floor(this.myLoad.verticalScrollPosition || 0) + "," + Math.floor(this.myLoad.horizontalScrollPosition || 0);
            var _loc_2:* = _loc_1.split(",");
            var _loc_3:* = this.lastSCROLL.split(",");
            if (_loc_1 == this.lastSCROLL || Math.abs(_loc_2[1] - _loc_3[1]) < 5 && Math.abs(_loc_2[0] - _loc_3[0]) < 5)
            {
                return;
            }
            this.lastSCROLL = _loc_1;
            var _loc_4:* = Math.floor(this.myLoad.content.height - this.myLoad.height - this.myLoad.verticalScrollPosition) + "," + Math.floor(this.myLoad.content.width - this.myLoad.width - this.myLoad.horizontalScrollPosition);
            this.sendData("<root from=\'" + this.myID + "\' type=\'group\' act=\'scroll\' p2p=\'1\' to=\'" + this.toID + "\' min=\'" + _loc_4 + "\' say=\'" + _loc_1 + "\' />");
            return;
        }// end function

        public function MOUSEM(event:MouseEvent)
        {
            var evt:* = event;
            if (mouseX > stage.stageWidth - 18 || mouseY > stage.stageHeight - 18 || mouseY < 40 || mouseX < 1)
            {
                this.pressed = false;
                Mouse.show();
                this.pen.visible = false;
                return;
            }
            if (this.inputArr.length > 0 && (mouseX > this.inputArr[this.textIndex].x + this.stageMc.x && mouseY > this.inputArr[this.textIndex].y + this.stageMc.y && mouseX < this.inputArr[this.textIndex].x + this.stageMc.x + this.inputArr[this.textIndex].width && mouseY < this.inputArr[this.textIndex].y + this.stageMc.y + this.inputArr[this.textIndex].height))
            {
                this.pressed = false;
                Mouse.show();
                this.pen.visible = false;
                return;
            }
            Mouse.hide();
            this.pen.x = mouseX;
            this.pen.y = mouseY;
            this.pen.visible = true;
            this.setChildIndex(this.pen, (this.numChildren - 1));
            if (this.bb == 0)
            {
                Mouse.hide();
                this.pen.x = mouseX;
                this.pen.y = mouseY;
                this.pen.visible = true;
                this.setChildIndex(this.pen, (this.numChildren - 1));
            }
            else
            {
                Mouse.show();
                this.pen.visible = false;
                return;
            }
            if (this.pressed)
            {
                try
                {
                    this.DM("开发同步给客户端");
                    if (this.myLoad.content != null)
                    {
                        this.arr[this.idx].graphics.lineTo(mouseX - this.myLoad.content.x + (this.myLoad.horizontalScrollPosition || 0), mouseY - this.myLoad.content.y + (this.myLoad.verticalScrollPosition || 0));
                        this.xy = [Math.floor(mouseX - this.myLoad.content.x + (this.myLoad.horizontalScrollPosition || 0)), Math.floor(mouseY - this.myLoad.content.y + (this.myLoad.verticalScrollPosition || 0))];
                    }
                    else
                    {
                        this.arr[this.idx].graphics.lineTo(mouseX + (this.myLoad.horizontalScrollPosition || 0), mouseY + (this.myLoad.verticalScrollPosition || 0));
                        this.xy = [Math.floor(mouseX + (this.myLoad.horizontalScrollPosition || 0)), Math.floor(mouseY + (this.myLoad.verticalScrollPosition || 0))];
                    }
                    this.DM("开发保存到缓冲" + this.xy.join());
                }
                catch (e)
                {
                    try
                    {
                    }
                    if (this.pointerNum % this.sendNum == 0)
                    {
                        this.sendPointer(this.xy);
                    }
                    var _loc_3:String = this;
                    var _loc_4:* = this.pointerNum + 1;
                    _loc_3.pointerNum = _loc_4;
                }
                catch (e)
                {
                }
            }
            return;
        }// end function

        public function sendPointer(param1)
        {
            var arr:* = param1;
            try
            {
                if (arr[0] == -1 && this.param.interval)
                {
                    if (this.buffer.length && this.buffer[(this.buffer.length - 1)][0] == 0)
                    {
                        this.buffer.pop();
                        return;
                    }
                }
                if (this.param.interval > 0)
                {
                    this.buffer.push(arr);
                }
                else
                {
                    this.sendXML(arr, true);
                }
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function MOUSED(event:MouseEvent)
        {
            var curID:*;
            var pressedHDP:*;
            var evt:* = event;
            try
            {
                curID = this.getRID(6);
                this.lastMessageID = curID;
                pressedHDP = mouseX > this.currentpage.x && mouseX < this.currentpage.x + this.currentpage.width && mouseY > this.currentpage.y;
                if (mouseX > stage.stageWidth - 18 || mouseY > stage.stageHeight - 18 || mouseY < 40 || mouseX < 1 || pressedHDP)
                {
                    this.pressed = false;
                }
                else
                {
                    try
                    {
                        if (this.inputArr.length > 0 && (mouseX > this.inputArr[this.textIndex].x + this.stageMc.x && mouseY > this.inputArr[this.textIndex].y + this.stageMc.y && mouseX < this.inputArr[this.textIndex].x + this.stageMc.x + this.inputArr[this.textIndex].width && mouseY < this.inputArr[this.textIndex].y + this.stageMc.y + this.inputArr[this.textIndex].height))
                        {
                            this.pressed = false;
                            return;
                        }
                    }
                    catch (e)
                    {
                        DM("llllll" + e.message);
                    }
                    this.MOUSEDOWN = 1;
                    this.pen.x = mouseX;
                    this.pen.y = mouseY;
                    this.pen.visible = true;
                    var _loc_3:String = this;
                    var _loc_4:* = this.idx + 1;
                    _loc_3.idx = _loc_4;
                    this.pressed = true;
                    this.arr[this.idx] = new Sprite();
                    this.arr[this.idx].graphics.lineStyle(2, 16711680, 1);
                    this.stageMc.addChild(this.arr[this.idx]);
                    this.movieClips.push(this.arr[this.idx]);
                    addChild(this.stageMc);
                    if (this.myLoad.content != null)
                    {
                        this.arr[this.idx].graphics.moveTo(mouseX - this.myLoad.content.x + (this.myLoad.horizontalScrollPosition || 0), mouseY - this.myLoad.content.y + (this.myLoad.verticalScrollPosition || 0));
                    }
                    else
                    {
                        this.arr[this.idx].graphics.moveTo(mouseX + (this.myLoad.horizontalScrollPosition || 0), mouseY + (this.myLoad.verticalScrollPosition || 0));
                    }
                    this.sendPointer([0, 0]);
                }
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function MOUSEU(event:MouseEvent)
        {
            var evt:* = event;
            try
            {
                this.MOUSEDOWN = 0;
                if (this.pressed)
                {
                    this.pressed = false;
                    this.sendPointer([-1, -1]);
                    ;
                }
                this._sycScroll();
                var _loc_3:String = this;
                var _loc_4:* = this.idx + 1;
                _loc_3.idx = _loc_4;
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function clearPad()
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.movieClips.length)
            {
                
                this.movieClips[_loc_1].graphics.clear();
                _loc_1 = _loc_1 + 1;
            }
            var _loc_2:* = 0;
            while (_loc_2 < this.inputArr.length)
            {
                
                this.stageMc.removeChild(this.inputArr[_loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            this.inputArr = [];
            var _loc_3:* = 0;
            while (_loc_3 < this.txtArr.length)
            {
                
                this.stageMc.removeChild(this.txtArr[_loc_3]);
                _loc_3 = _loc_3 + 1;
            }
            this.txtArr = [];
            this.inputIndex = 0;
            this.hadtext = false;
            return;
        }// end function

        public function updateLists(param1)
        {
            var event:* = param1;
            var Uint:* = this.comboBox.selectedItem.label;
            this.indexID = Uint - 1;
            if (Uint <= 1)
            {
                Uint;
                this.prevbtn.removeEventListener(MouseEvent.CLICK, this.PREVBTN);
            }
            else
            {
                this.prevbtn.addEventListener(MouseEvent.CLICK, this.PREVBTN);
            }
            if (Uint >= this.num)
            {
                Uint = this.num;
                this.nextbtn.removeEventListener(MouseEvent.CLICK, this.NEXTBTN);
            }
            else
            {
                this.nextbtn.addEventListener(MouseEvent.CLICK, this.NEXTBTN);
            }
            this.setImageSize();
            this.clearPad();
            setTimeout(function ()
            {
                myLoad.content.scaleX = Vol;
                myLoad.content.scaleY = Vol;
                myLoad.update();
                return;
            }// end function
            , 90);
            if (!this.client && event != "beCalled")
            {
                this.sendData("<root from=\'" + this.myID + "\' to=\'" + this.toID + "\' index=\'" + this.indexID + "\' p2p=\'1\' type=\'group\' act=\'randompage\' />");
                ExternalInterface.call("changePadImage", [this.bgURL, this.num, this.indexID]);
            }
            this.limitCombox(this.comboBox);
            return;
        }// end function

        public function upDateS(param1)
        {
            var e:* = param1;
            this.volBoo = true;
            this.Vol = this.comPercent.selectedItem.data.substr(0, -1) / 100;
            this.Index = this.comPercent.selectedIndex;
            var oxy:* = this.getMyLoadContentXY();
            this.myLoad.content.scaleX = this.Vol;
            this.myLoad.content.scaleY = this.Vol;
            this.myLoad.content.x = this.getMyLoadContentXY().x;
            this.myLoad.content.y = this.getMyLoadContentXY().y;
            this.myLoad.update();
            this.clearPad();
            this.stageMc.x = this.getMyLoadContentXY().x;
            this.stageMc.y = this.getMyLoadContentXY().y;
            try
            {
                this.myLoad.horizontalScrollPosition = 0;
                this.myLoad.verticalScrollPosition = 0;
            }
            catch (e)
            {
            }
            if (this.client || e == "beCalled")
            {
            }
            else
            {
                this.sendData("<root from=\'" + this.myID + "\' type=\'group\' act=\'zoom\' p2p=\'1\' to=\'" + this.toID + "\' index=\'" + this.Index + "\' />");
            }
            this.comPercent.enabled = this.client == 1 ? (false) : (true);
            this.limitCombox(this.comPercent);
            if (this.myLoad.content.height > 7000 || this.myLoad.content.width > 7000)
            {
                this.bfb.htmlText = "<font color=\'#990000\'> " + this.missMess + "</font>";
                setTimeout(function ()
            {
                bfb.htmlText = "";
                return;
            }// end function
            , 3000);
            }
            else
            {
                this.bfb.htmlText = "";
            }
            return;
        }// end function

        public function getMyLoadContentXY()
        {
            try
            {
                return {x:Math.max(0, stage.stageWidth / 2 - this.myLoad.content.width / 2), y:Math.max(0, (stage.stageHeight - 40) / 2 - this.myLoad.content.height / 2)};
            }
            catch (e)
            {
                return {x:0, y:0};
            }
            return;
        }// end function

        public function setCurTime() : void
        {
            this.indexID = parseInt(this.current);
            if (this.current)
            {
                this.comboBox.selectedIndex = parseInt(this.current);
                ;
            }
            return;
        }// end function

        public function Scro(event:Event)
        {
            this.pressed = false;
            return;
        }// end function

        public function openHandler(event:Event)
        {
            this.bb = 1;
            return;
        }// end function

        public function closen(event:Event)
        {
            this.bb = 0;
            return;
        }// end function

        public function PREVBTN(param1)
        {
            var event:* = param1;
            if (!this.comboBox.enabled)
            {
                return;
            }
            var _loc_3:String = this;
            var _loc_4:* = this.indexID - 1;
            _loc_3.indexID = _loc_4;
            this.nextbtn.addEventListener(MouseEvent.CLICK, this.NEXTBTN);
            if (this.indexID <= 0)
            {
                this.indexID = 0;
                this.prevbtn.removeEventListener(MouseEvent.CLICK, this.PREVBTN);
            }
            this.comboBox.selectedIndex = this.indexID;
            this.setImageSize();
            this.clearPad();
            setTimeout(function ()
            {
                myLoad.content.scaleX = Vol;
                myLoad.content.scaleY = Vol;
                myLoad.update();
                return;
            }// end function
            , 90);
            if (!this.client)
            {
                this.sendData("<root from=\'" + this.myID + "\' to=\'" + this.toID + "\' index=\'" + this.indexID + "\' p2p=\'1\' type=\'group\' act=\'randompage\' />");
                ExternalInterface.call("changePadImage", [this.bgURL, this.num, this.indexID]);
            }
            this.limitCombox(this.comboBox);
            return;
        }// end function

        public function limitCombox(param1)
        {
            var cboxstate:*;
            var comboBox:* = param1;
            cboxstate = comboBox.enabled;
            comboBox.enabled = false;
            if (this.limitFY)
            {
                clearTimeout(this.limitFY);
                ;
            }
            this.limitFY = setTimeout(function ()
            {
                comboBox.enabled = cboxstate;
                return;
            }// end function
            , 700);
            return;
        }// end function

        public function NEXTBTN(param1)
        {
            var event:* = param1;
            if (!this.comboBox.enabled)
            {
                return;
            }
            var _loc_3:String = this;
            var _loc_4:* = this.indexID + 1;
            _loc_3.indexID = _loc_4;
            this.prevbtn.addEventListener(MouseEvent.CLICK, this.PREVBTN);
            if (this.indexID >= (this.num - 1))
            {
                this.indexID = this.num - 1;
                this.nextbtn.removeEventListener(MouseEvent.CLICK, this.NEXTBTN);
            }
            this.comboBox.selectedIndex = this.indexID;
            this.setImageSize();
            this.clearPad();
            setTimeout(function ()
            {
                myLoad.content.scaleX = Vol;
                myLoad.content.scaleY = Vol;
                myLoad.update();
                return;
            }// end function
            , 90);
            if (!this.client)
            {
                this.sendData("<root from=\'" + this.myID + "\' to=\'" + this.toID + "\' index=\'" + this.indexID + "\' p2p=\'1\' type=\'group\' act=\'randompage\' />");
                ExternalInterface.call("changePadImage", [this.bgURL, this.num, this.indexID]);
            }
            this.limitCombox(this.comboBox);
            return;
        }// end function

        public function startApply()
        {
            this.DM("startApply 收到");
            this.pressed = false;
            Mouse.hide();
            this.pen.visible = true;
            this.comPercent.enabled = true;
            this.showUI(true);
            if (this.param.interval > 0)
            {
                this.sendInterval = setInterval(function ()
            {
                sendXML();
                return;
            }// end function
            , this.param.interval);
                ;
            }
            this.eraser.addEventListener(MouseEvent.CLICK, this.ERASER);
            this.eraser_small.addEventListener(MouseEvent.CLICK, this.ERASER);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.MOUSEM);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, this.MOUSED);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.MOUSEU);
            this.client = "";
            this.Control();
            if (this.bgURL != "uploadDir/")
            {
                this.speaker();
            }
            else if (!this.param["usePad"])
            {
                this.joinner();
            }
            return;
        }// end function

        public function Control()
        {
            if (this.num > 1)
            {
                this.comboBox.enabled = true;
                if (this.comboBox.selectedItem.label > 1)
                {
                    this.prevbtn.addEventListener(MouseEvent.CLICK, this.PREVBTN);
                }
                if (this.comboBox.selectedItem.label < this.num)
                {
                    this.nextbtn.addEventListener(MouseEvent.CLICK, this.NEXTBTN);
                }
            }
            return;
        }// end function

        public function ERASER(event:MouseEvent) : void
        {
            this.clearPad();
            this.sendXML(true);
            return;
        }// end function

        public function stopApply()
        {
            this.DM("stopApply 收到");
            Mouse.show();
            this.pen.visible = false;
            this.eraser.removeEventListener(MouseEvent.CLICK, this.ERASER);
            this.eraser_small.removeEventListener(MouseEvent.CLICK, this.ERASER);
            this.prevbtn.removeEventListener(MouseEvent.CLICK, this.PREVBTN);
            this.nextbtn.removeEventListener(MouseEvent.CLICK, this.NEXTBTN);
            this.comboBox.enabled = false;
            this.comPercent.enabled = false;
            this.showUI(false);
            this.client = 1;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.MOUSEM);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.MOUSED);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.MOUSEU);
            clearInterval(this.sendInterval);
            this.input_btn.removeEventListener(MouseEvent.CLICK, this.inputHandler);
            var _loc_1:uint = 0;
            while (_loc_1 < this.inputArr.length)
            {
                
                this.inputArr[_loc_1].removeEventListener(MouseEvent.MOUSE_DOWN, this.mousedHandler);
                this.inputArr[_loc_1].removeEventListener(MouseEvent.MOUSE_UP, this.mouseuHandler);
                this.inputArr[_loc_1].removeEventListener(MouseEvent.MOUSE_MOVE, this.mousemHandler);
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        public function speaker()
        {
            var _loc_1:uint = 0;
            if (!this.client)
            {
                stage.addEventListener(MouseEvent.MOUSE_MOVE, this.MOUSEM);
                stage.addEventListener(MouseEvent.MOUSE_DOWN, this.MOUSED);
                stage.addEventListener(MouseEvent.MOUSE_UP, this.MOUSEU);
                this.doublemc.addEventListener(MouseEvent.DOUBLE_CLICK, this.DOUBLEMC);
                this.comPercent.enabled = true;
                this.eraser.hideMC.buttonMode = true;
                this.eraser_small.hideMC.buttonMode = true;
                this.prevbtn.hideMC.buttonMode = true;
                this.nextbtn.hideMC.buttonMode = true;
                this.input_btn.addEventListener(MouseEvent.CLICK, this.inputHandler);
                _loc_1 = 0;
                while (_loc_1 < this.inputArr.length)
                {
                    
                    this.inputArr[_loc_1].addEventListener(MouseEvent.MOUSE_DOWN, this.mousedHandler);
                    this.inputArr[_loc_1].addEventListener(MouseEvent.MOUSE_UP, this.mouseuHandler);
                    this.inputArr[_loc_1].addEventListener(MouseEvent.MOUSE_MOVE, this.mousemHandler);
                    _loc_1 = _loc_1 + 1;
                }
            }
            this.fullScreenB.addEventListener(MouseEvent.CLICK, this.fullS);
            this.fullScreenB.hideMC.buttonMode = true;
            return;
        }// end function

        public function joinner()
        {
            if (this.param["small"])
            {
                return false;
            }
            this.pen.visible = false;
            Mouse.show();
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.MOUSEM);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.MOUSED);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.MOUSEU);
            this.doublemc.removeEventListener(MouseEvent.DOUBLE_CLICK, this.DOUBLEMC);
            this.nextbtn.removeEventListener(MouseEvent.CLICK, this.NEXTBTN);
            this.comboBox.enabled = false;
            this.comPercent.enabled = false;
            this.eraser.hideMC.buttonMode = false;
            this.eraser_small.hideMC.buttonMode = false;
            this.prevbtn.hideMC.buttonMode = false;
            this.nextbtn.hideMC.buttonMode = false;
            return;
        }// end function

        public function CAPTURING(event:MouseEvent)
        {
            ExternalInterface.call("beginSnap", "");
            return;
        }// end function

        public function WEBCARVE(event:MouseEvent)
        {
            ExternalInterface.call("showWebSnap", "");
            return;
        }// end function

        public function menuSelect(event:ContextMenuEvent)
        {
            Mouse.show();
            this.pen.visible = false;
            return;
        }// end function

        public function showUI(param1)
        {
            if (this.param["small"])
            {
                param1 = false;
            }
            else
            {
                this.eraser_small.visible = false;
            }
            this.webCarve.visible = param1;
            this.capturing.visible = param1;
            return;
        }// end function

        function __setProp_comboBox_()
        {
            var itemObj0:SimpleCollectionItem;
            var collProps0:Array;
            var collProp0:Object;
            var i0:int;
            var j0:*;
            try
            {
                this.comboBox["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            collObj0 = new DataProvider();
            collProps0;
            i0;
            while (i0 < collProps0.length)
            {
                
                itemObj0 = new SimpleCollectionItem();
                collProp0 = collProps0[i0];
                var _loc_2:int = 0;
                var _loc_3:* = collProp0;
                while (_loc_3 in _loc_2)
                {
                    
                    j0 = _loc_3[_loc_2];
                    itemObj0[j0] = collProp0[j0];
                }
                collObj0.addItem(itemObj0);
                i0 = (i0 + 1);
            }
            this.comboBox.dataProvider = collObj0;
            this.comboBox.editable = false;
            this.comboBox.enabled = true;
            this.comboBox.prompt = "";
            this.comboBox.restrict = "";
            this.comboBox.rowCount = 5;
            this.comboBox.visible = true;
            try
            {
                this.comboBox["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function frame1()
        {
            Security.allowDomain("*");
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.addEventListener(Event.RESIZE, this.RESIZE);
            this.bfb.x = stage.stageWidth / 2 - this.bfb.width / 2;
            this.param = stage.loaderInfo.parameters;
            this.ip = this.param["ip"];
            this.port = this.param["port"];
            this.meetId = this.param["meetId"];
            this.myID = this.param["myID"];
            this.client = this.param["client"];
            this.interval = this.param["interval"] || 300;
            this.current = this.param["current"];
            this.bgURL = this.param["bgURL"] || "";
            this.curID = "";
            this.toID = this.param["toID"];
            this.lastMessageID = "";
            this.noSocket = this.param["noSocket"];
            this.indexID = 0;
            this.num = this.param["num"];
            this.bb = 0;
            this.initRID = 0;
            this.boo = false;
            this.mc = new MovieClip();
            this.idx = 0;
            this.receiveIdx = {};
            this.pressed = false;
            this.receivePressed = false;
            this.movieClips = [];
            this.txtArr = [];
            this.oldXY = [];
            this.arr = [];
            this.arr_ = {};
            this.buffer = [];
            this.lastSCROLL = Math.floor(this.myLoad.verticalScrollPosition || 0) + "," + Math.floor(this.myLoad.horizontalScrollPosition || 0);
            this.tout = 1;
            this.Vol = this.param["scale"] || 1.3;
            this.volBoo = false;
            this.MOUSEDOWN = 0;
            this.webCar = this.param["webCarve"] || "网页剪取";
            this.captur = this.param["capturing"] || "截屏";
            this.webCarve.webClip_txt.htmlText = "<font><b>" + this.webCar + "</b></font>";
            this.capturing.capture_txt.htmlText = "<font><b>" + this.captur + "</b></font>";
            this.eraser.clear_txt.text = this.param["clear"] || "清屏";
            this.eraser_small.clear_txt.text = this.param["clear"] || "清屏";
            this.prevbtn.prev_txt.text = this.param["prev"] || "上页";
            this.nextbtn.next_txt.text = this.param["next"] || "下页";
            this.fullScreenB.fullS_txt.text = this.param["fullScreen"] || "全屏";
            this.bfb.selectable = false;
            this.webCarve.webClip_txt.selectable = false;
            this.capturing.capture_txt.selectable = false;
            this.eraser.clear_txt.selectable = false;
            this.prevbtn.prev_txt.selectable = false;
            this.nextbtn.next_txt.selectable = false;
            this.fullScreenB.fullS_txt.selectable = false;
            this.webCarve.webClip_txt.autoSize = "left";
            this.capturing.capture_txt.autoSize = "left";
            this.eraser.clear_txt.autoSize = "left";
            this.prevbtn.prev_txt.autoSize = "left";
            this.nextbtn.next_txt.autoSize = "left";
            this.fullScreenB.fullS_txt.autoSize = "left";
            this.webCarve.middleBg.width = this.webCarve.webClip_txt.width;
            this.webCarve.rightBg.x = this.webCarve.leftBg.width + this.webCarve.middleBg.width;
            this.capturing.middleBg.width = this.capturing.capture_txt.width;
            this.capturing.rightBg.x = this.capturing.leftBg.width + this.capturing.middleBg.width;
            this.capturing.x = this.webCarve.width + 6;
            this.webCarve.hideMC.width = this.webCarve.rightBg.x + this.webCarve.rightBg.width;
            this.capturing.hideMC.width = this.capturing.rightBg.x + this.capturing.rightBg.width;
            this.fullScreenB.hideMC.width = this.fullScreenB.width;
            this.eraser.hideMC.width = this.eraser.width;
            this.prevbtn.hideMC.width = this.prevbtn.width;
            this.nextbtn.hideMC.width = this.nextbtn.width;
            this.webCarve.hideMC.buttonMode = true;
            this.capturing.hideMC.buttonMode = true;
            this.input_btn.hidemc.buttonMode = true;
            this.inputArr = [];
            this.inputIndex = 0;
            this.hadtext = false;
            this.nomove = [];
            ExternalInterface.addCallback("draw", this.onDatas);
            ExternalInterface.addCallback("sendData", this.sendData);
            ExternalInterface.addCallback("changeImage", this.changeImage);
            ExternalInterface.addCallback("beChangedImage", this.beChangedImage);
            ExternalInterface.addCallback("startApply", this.startApply);
            ExternalInterface.addCallback("stopApply", this.stopApply);
            ExternalInterface.addCallback("openDebug", function ()
            {
                param["debug"] = 1;
                return;
            }// end function
            );
            ExternalInterface.addCallback("isFullScreen", function (param1)
            {
                var isFull:* = param1;
                DM("isFullScreen:" + isFull);
                root.fullScreenB.gotoAndStop(isFull == "1" ? (2) : (1));
                comboBox.close();
                comPercent.close();
                try
                {
                    if (isFull == "1")
                    {
                        setFull();
                    }
                    else
                    {
                        setNoFull();
                    }
                }
                catch (e)
                {
                }
                return;
            }// end function
            );
            ExternalInterface.addCallback("gotoPage", function (param1)
            {
                DM("gotopage:" + param1);
                comboBox.selectedIndex = param1;
                updateLists("beCalled");
                return;
            }// end function
            );
            ExternalInterface.addCallback("setIndexLength", function (param1)
            {
                comboBox.enabled = true;
                var _loc_2:* = comboBox.selectedIndex;
                comboBox.removeAll();
                var _loc_3:* = 1;
                while (_loc_3 <= param1)
                {
                    
                    item = _loc_3;
                    comboBox.addItem({label:item});
                    _loc_3 = _loc_3 + 1;
                }
                comboBox.selectedIndex = _loc_2;
                num = param1;
                comboBox.enabled = !client;
                return;
            }// end function
            );
            if (!this.noSocket)
            {
                this.xmlSocket = new XMLSocket();
                this.xmlSocket.addEventListener(Event.CONNECT, this.onConnects);
                this.xmlSocket.addEventListener(DataEvent.DATA, this.onDatas);
                this.xmlSocket.connect(this.param["ip"] || "im.codyy.net", this.param["port"] || 1333);
            }
            this.toID = this.meetId || "codyyGroup";
            this.person = {};
            this.rgb = [16711680, 16711680, 16711680];
            this.colorNum = 0;
            this.reveUnico = [];
            this.ARR = [];
            this.stageMc.mask = this.masker;
            this.doublemc.doubleClickEnabled = true;
            this.doublemc.addEventListener(MouseEvent.DOUBLE_CLICK, this.DOUBLEMC);
            setTimeout(function ()
            {
                root.fullScreenB.gotoAndStop(1);
                oldXY = getContentXY();
                setStage();
                return;
            }// end function
            , 100);
            this.fullScreenB.addEventListener(MouseEvent.CLICK, this.fullS);
            if (!this.param["first"])
            {
                if (this.client)
                {
                }
                else
                {
                    this.syscToOthers(this.bgURL, this.num);
                }
            }
            if (this.current)
            {
                this.indexID = this.current;
                ;
            }
            this.setImageSize();
            this.isDir = this.bgURL.substr((this.bgURL.length - 1), 1) == "/";
            this.PPT = this.param["ppt"] || "幻灯片 ";
            this.maxSize = this.param["maxSize"] || "请上传尺寸尽可能小于6270*6270像素的图片！";
            this.myLoad.addEventListener(Event.COMPLETE, function (event:Event) : void
            {
                var event:* = event;
                if (myLoad.content.height > 6270 || myLoad.content.width > 6270)
                {
                    bfb.htmlText = "<font color=\'#990000\'> " + maxSize + "</font>";
                    setTimeout(function ()
                {
                    bfb.htmlText = "";
                    return;
                }// end function
                , 6000);
                }
                else
                {
                    bfb.htmlText = "";
                }
                myLoad.content.scaleX = Vol;
                myLoad.content.scaleY = Vol;
                myLoad.content.x = getMyLoadContentXY().x;
                myLoad.content.y = getMyLoadContentXY().y;
                comPercent.enabled = !client;
                myLoad.update();
                scrollListener("");
                DM("myLoad.content.height:" + myLoad.content.height + "::::" + "myLoad.content.width:" + myLoad.content.width);
                return;
            }// end function
            );
            this.loaded = this.param["loaded"] || "已载入 ";
            this.myLoad.addEventListener("progress", function (param1)
            {
                if (param1.target.bytesTotal > 0)
                {
                    bfb.htmlText = "<font color=\'#0000FF\'>" + loaded + Math.floor(param1.target.bytesLoaded / param1.target.bytesTotal * 1000) / 10 + "%</font>";
                }
                return;
            }// end function
            );
            this.myLoad.addEventListener(ScrollEvent.SCROLL, this.scrollListener);
            this.sendNum = this.param["sendNum"] || 1;
            this.pointerNum = 0;
            this.xy = [];
            this.i = 1;
            while (this.i <= this.num)
            {
                
                this.item = this.i;
                this.comboBox.addItem({label:this.item});
                var _loc_2:String = this;
                var _loc_3:* = this.i + 1;
                _loc_2.i = _loc_3;
            }
            this.itemArr = ["500%", "200%", "150%", "100%", "75%", "50%", "25%", "10%"];
            this.j = 0;
            while (this.j < this.itemArr.length)
            {
                
                if (this.itemArr[this.j] == "100%")
                {
                    this.comPercent.addItem({label:this.itemArr[this.j], data:this.Vol * 100 + "%"});
                }
                else
                {
                    this.comPercent.addItem({label:this.itemArr[this.j], data:this.itemArr[this.j]});
                }
                var _loc_2:String = this;
                var _loc_3:* = this.j + 1;
                _loc_2.j = _loc_3;
            }
            this.comPercent.selectedIndex = 3;
            this.comboBox.addEventListener(Event.CHANGE, this.updateLists);
            setInterval(function ()
            {
                if (param["small"] && boo && stage.displayState != StageDisplayState.FULL_SCREEN)
                {
                    DOUBLEMC("");
                }
                return;
            }// end function
            , 500);
            this.Unico = [];
            stage.addEventListener(KeyboardEvent.KEY_DOWN, function (event:KeyboardEvent)
            {
                var u:int;
                var event:* = event;
                if (event.keyCode == 27 && boo)
                {
                    return DOUBLEMC("");
                }
                switch(event.keyCode)
                {
                    case 13:
                    {
                        if (!hadtext)
                        {
                            NEXTBTN("");
                        }
                        else
                        {
                            hadtext = false;
                            stage.focus = null;
                            if (StringUtil.trim(inputArr[textIndex].input_txt.text) == "")
                            {
                                try
                                {
                                    inputArr[textIndex].y = 1000;
                                    inputArr.pop();
                                    var _loc_4:* = inputIndex - 1;
                                    inputIndex = _loc_4;
                                    textIndex = inputIndex - 1;
                                }
                                catch (e)
                                {
                                    DM("tx:::" + e.message);
                                }
                                return;
                            }
                            try
                            {
                                u;
                                while (u < inputArr[textIndex].input_txt.text.length)
                                {
                                    
                                    Unico.push(inputArr[textIndex].input_txt.text.charCodeAt(u));
                                    u = (u + 1);
                                }
                                sendData("<root from=\'" + myID + "\' to=\'" + toID + "\' input=\'" + Unico + "\' inputX=\'" + inputArr[textIndex].x + "\' inputY=\'" + inputArr[textIndex].y + "\' targetID=\'" + inputArr[textIndex].id + "\' p2p=\'1\' type=\'group\' act=\'inputtext\' />");
                                inputArr[textIndex].input_txt.border = false;
                                inputArr[textIndex].input_txt.selectable = false;
                                inputArr[textIndex].input_txt.type = TextFieldType.DYNAMIC;
                                Unico = [];
                            }
                            catch (e)
                            {
                                DM("tx 2::" + e.message);
                            }
                        }
                        break;
                    }
                    case Keyboard.RIGHT:
                    case Keyboard.DOWN:
                    {
                        if (hadtext)
                        {
                        }
                        else
                        {
                            NEXTBTN("");
                        }
                        break;
                    }
                    case 8:
                    {
                        if (hadtext)
                        {
                        }
                        else
                        {
                            PREVBTN("");
                        }
                        break;
                    }
                    case Keyboard.LEFT:
                    case Keyboard.UP:
                    {
                        if (hadtext)
                        {
                        }
                        else
                        {
                            PREVBTN("");
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                return;
            }// end function
            );
            this.missMess = this.param["missMessage"] || "图片太大可能会导致图片信息丢失！";
            this.comPercent.addEventListener(Event.CHANGE, this.upDateS);
            ExternalInterface.addCallback("setDrawXY", function (param1)
            {
                stageMc.x = param1.x;
                stageMc.y = param1.y;
                return;
            }// end function
            );
            if (this.current)
            {
                setTimeout(this.setCurTime, 500);
            }
            this.comboBox.addEventListener(Event.SCROLL, this.Scro);
            this.comPercent.addEventListener(Event.SCROLL, this.Scro);
            this.comboBox.addEventListener(Event.OPEN, this.openHandler);
            this.comboBox.addEventListener(Event.CLOSE, this.closen);
            this.comPercent.addEventListener(Event.OPEN, this.openHandler);
            this.comPercent.addEventListener(Event.CLOSE, this.closen);
            this.nextbtn.addEventListener(MouseEvent.CLICK, this.NEXTBTN);
            if (this.client)
            {
                this.stopApply();
            }
            else
            {
                this.startApply();
            }
            this.comPercent.enabled = false;
            this.capturing.addEventListener(MouseEvent.CLICK, this.CAPTURING);
            this.capturing.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                capturing.leftBg.gotoAndStop(2);
                capturing.middleBg.gotoAndStop(2);
                capturing.rightBg.gotoAndStop(2);
                return;
            }// end function
            );
            this.capturing.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                capturing.leftBg.gotoAndStop(1);
                capturing.middleBg.gotoAndStop(1);
                capturing.rightBg.gotoAndStop(1);
                return;
            }// end function
            );
            this.webCarve.addEventListener(MouseEvent.CLICK, this.WEBCARVE);
            this.webCarve.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                webCarve.leftBg.gotoAndStop(2);
                webCarve.middleBg.gotoAndStop(2);
                webCarve.rightBg.gotoAndStop(2);
                return;
            }// end function
            );
            this.webCarve.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                webCarve.leftBg.gotoAndStop(1);
                webCarve.middleBg.gotoAndStop(1);
                webCarve.rightBg.gotoAndStop(1);
                return;
            }// end function
            );
            this.myMenu = new ContextMenu();
            this.myMenu.hideBuiltInItems();
            this.myMenu.addEventListener(ContextMenuEvent.MENU_SELECT, this.menuSelect);
            this.contextMenu = this.myMenu;
            if (this.param["small"])
            {
                this.showUI(false);
                this.eraser_small.hideMC.buttonMode = true;
            }
            else
            {
                this.eraser_small.visible = false;
            }
            ExternalInterface.addCallback("draw", this.onDatas);
            ExternalInterface.addCallback("sendData", this.sendData);
            ExternalInterface.addCallback("changeImage", this.changeImage);
            ExternalInterface.addCallback("beChangedImage", function (param1, param2)
            {
                beChangedImage(param1, param2);
                return;
            }// end function
            );
            ExternalInterface.addCallback("startApply", this.startApply);
            ExternalInterface.addCallback("stopApply", this.stopApply);
            return;
        }// end function

    }
}
