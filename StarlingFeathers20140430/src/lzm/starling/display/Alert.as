package lzm.starling.display
{
	import flash.geom.Rectangle;
	
	import lzm.starling.STLConstant;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;

	public class Alert
	{
		
		private static var background:Quad;
		private static var dialogs:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public static function show(display:DisplayObject):void{
			STLConstant.currnetAppRoot.addChild(display);
		}
		
		public static function alert(dialog:DisplayObject, needBack:Boolean = true, setXY:Boolean = true):void{
			if(dialogs.indexOf(dialog) != -1){
				return;
			}
			
			dialog.addEventListener(Event.ADDED_TO_STAGE,dialogAddToStage);
			if(needBack)
			{
				initBackGround();
				STLConstant.currnetAppRoot.addChild(background);
				Starling.juggler.tween(background, 0.2, {alpha:0.5});
			}else
			{
				if(background)
					background.removeFromParent();
			}
			STLConstant.currnetAppRoot.addChild(dialog);
			
//			var dialogRect:Rectangle = dialog.getBounds(dialog.parent);
			if(setXY)
			{
				dialog.x = (STLConstant.StageWidth - dialog.width)/2;
				dialog.y = (STLConstant.StageHeight - dialog.height)/2;
			}
		}
		
		private static function dialogAddToStage(e:Event):void{
			var dialog:DisplayObject = e.currentTarget as DisplayObject;
			dialog.removeEventListener(Event.ADDED_TO_STAGE,dialogAddToStage);
			dialog.addEventListener(Event.REMOVED_FROM_STAGE,dialogRemoveFromStage);
			
			dialogs.push(dialog);
		}
		
		private static function dialogRemoveFromStage(e:Event):void{
			var dialog:DisplayObject = e.currentTarget as DisplayObject;
			dialog.removeEventListener(Event.REMOVED_FROM_STAGE,dialogRemoveFromStage);
			
			dialogs.pop();
			
			if(dialogs.length == 0){
				if(background && background.parent)
					Starling.juggler.tween(background, 0.2, {alpha:0, onComplete:function():void{background.removeFromParent();}});
			}else{
				dialog = dialogs[dialogs.length-1];
				try{
					if(background)
						STLConstant.currnetAppRoot.swapChildren(background,dialog);
				} catch(error:Error) {}
			}
		}
		
		private static function initBackGround():void{
			if(background) return;
			background = new Quad(STLConstant.StageWidth,STLConstant.StageHeight,0x000000);
			background.alpha = 0;
		}
		
	}
}