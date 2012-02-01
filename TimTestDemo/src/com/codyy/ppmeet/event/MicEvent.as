package com.codyy.ppmeet.event
{
    import com.codyy.ppmeet.speaker.*;
    import flash.events.*;

    public class MicEvent extends Object
    {
        private var sline:SpeakerLine = null;

        public function MicEvent(param1:SpeakerLine)
        {
            this.sline = param1;
            return;
        }// end function

        public function feedMicEvent(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    break;
                }
                case "NetConnection.Connect.Closed":
                case "NetConnection.Connect.Failed":
                case "NetConnection.Connect.Rejected":
                case "NetConnection.Connect.AppShutdown":
                case "NetConnection.Connect.InvalidApp":
                case "NetStream.Connect.Success":
                {
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
