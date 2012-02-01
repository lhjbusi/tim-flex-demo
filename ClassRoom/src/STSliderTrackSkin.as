package     
{    
import flash.display.GradientType;    
import mx.styles.StyleManager;    
import mx.utils.ColorUtil;    
import mx.skins.halo.SliderTrackSkin;    
   
public class STSliderTrackSkin extends SliderTrackSkin {    
   
    public function STSliderTrackSkin() {    
        super();    
    }    
   
    override public function get measuredHeight():Number {    
        return 8; //HSlider的高度    
    } 
    
    override protected function updateDisplayList(w:Number, h:Number):void {	
		super.updateDisplayList(w, h);

		// User-defined styles.
		var borderColor:Number = getStyle("borderColor");
		var fillAlphas:Array = getStyle("fillAlphas");
		var fillColors:Array = getStyle("trackColors") as Array;
		StyleManager.getColorNames(fillColors);

		// Derivative styles.
		var borderColorDrk:Number = ColorUtil.adjustBrightness2(borderColor, -50);
		graphics.clear();	
	}
    
    
    
    
       
}    
}   