package com.codyy.ppmeet.event
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.speaker.*;
    import com.codyy.ppmeet.util.*;
    import flash.events.*;

    public class NetConnectionEvent extends Object
    {
        private var sline:SpeakerLine = null;
        private var sv:SpeakerVideo = null;

        public function NetConnectionEvent(param1:SpeakerLine)
        {
            this.sline = param1;
            this.sv = param1.sv;
            return;
        }// end function

        public function feedNC(event:NetStatusEvent) : void
        {
            WebUtil.info("NetConnect�¼���Ϣ(" + this.sline.line + ")��" + event.info.code);
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.sline.nearID = event.target.nearID;
                    WebUtil.sendMsg({act:"sys", say:"��ȡ��ݱ�ʶ�ųɹ�(" + this.sline.nearID + ")��"});
                    this.sline.createGroup();
                    break;
                }
                case "NetConnection.Connect.Closed":
                case "NetConnection.Connect.Failed":
                case "NetConnection.Connect.Rejected":
                case "NetConnection.Connect.AppShutdown":
                case "NetConnection.Connect.InvalidApp":
                case "NetStream.Connect.Success":
                {
                    if (this.sline.isSpeaker)
                    {
                        WebUtil.info("��ʼ������˷�����");
                        if (this.sline.micStream)
                        {
                            this.sline.micPublish();
                        }
                        else
                        {
                            this.sline.outMic();
                        }
                    }
                    else
                    {
                        this.sline.audioPlay();
                        WebUtil.info("��ʼ��������������");
                    }
                    break;
                }
                case "NetStream.Connect.Rejected":
                case "NetStream.Connect.Failed":
                {
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
                    WebUtil.sendMsg({act:"sys", say:"���Ѽ��������" + this.sline.getAudioKey()});
                    var _loc_2:* = this.sline.netGroup.estimatedMemberCount;
                    this.sline.p2pMembers = this.sline.netGroup.estimatedMemberCount;
                    if (this.sv.getParam("server"))
                    {
                        this.sline.outMic();
                    }
                    else
                    {
                        this.sline.inAudio();
                    }
                    break;
                }
                case "NetGroup.Connect.Failed":
                case :
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

    }
}
