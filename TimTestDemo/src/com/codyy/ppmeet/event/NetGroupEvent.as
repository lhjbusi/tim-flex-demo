package com.codyy.ppmeet.event
{
    import com.codyy.ppmeet.speaker.*;
    import com.codyy.ppmeet.util.*;
    import flash.events.*;

    public class NetGroupEvent extends Object
    {
        private var sline:SpeakerLine = null;

        public function NetGroupEvent(param1:SpeakerLine)
        {
            this.sline = param1;
            return;
        }// end function

        public function feedNetGroup(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetGroup.Posting.Notify":
                {
                    WebUtil.callJS("flash_call", event.info.message);
                    break;
                }
                case "NetGroup.Neighbor.Connect":
                {
                    if (event.info.neighbor != this.sline.netGroup.convertPeerIDToGroupAddress(this.sline.nearID))
                    {
                        WebUtil.sendMsg({act:"sys", say:"新成员进入P2P网络(" + event.info.neighbor + ")."});
                        this.sline.p2pMembers = this.sline.netGroup.estimatedMemberCount;
                    }
                    break;
                }
                case "NetGroup.Neighbor.Disconnect":
                {
                    WebUtil.sendMsg({from:this.sline.nearID, act:"sys", say:"已登出"});
                    this.sline.p2pMembers = this.sline.netGroup.estimatedMemberCount;
                    break;
                }
                case "NetGroup.LocalCoverage.Notify":
                case "NetGroup.SendTo.Notify":
                case "NetGroup.MulticastStream.PublishNotify":
                case "NetGroup.MulticastStream.UnpublishNotify":
                case "NetGroup.Replication.Fetch.SendNotify":
                case "NetGroup.Replication.Fetch.Failed":
                case "NetGroup.Replication.Fetch.Result":
                case "NetGroup.Replication.Request":
                {
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

    }
}
