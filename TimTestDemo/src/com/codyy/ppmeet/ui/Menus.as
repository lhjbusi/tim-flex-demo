package com.codyy.ppmeet.ui
{
    import com.codyy.ppmeet.*;
    import com.codyy.ppmeet.util.*;
    import flash.events.*;
    import flash.system.*;
    import flash.ui.*;

    public class Menus extends Object
    {
        private var sv:SpeakerVideo = null;

        public function Menus(param1:SpeakerVideo)
        {
            this.sv = param1;
            return;
        }// end function

        public function codyyMenus()
        {
            var item_codyy:ContextMenuItem;
            var rm_codyy:ContextMenu;
            Security.allowDomain("*");
            rm_codyy = new ContextMenu();
            rm_codyy.hideBuiltInItems();
            item_codyy = new ContextMenuItem("À«µØÍøÂç");
            item_codyy.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (event:ContextMenuEvent)
            {
                WebUtil.openUrl("http://www.codyy.com", "_blank");
                return false;
            }// end function
            );
            rm_codyy.customItems.push(item_codyy);
            this.sv.contextMenu = rm_codyy;
            return;
        }// end function

    }
}
