/********************************************************************************
 *
 *  ACTSONE COMPANY
 *  Copyright 2012 Actsone 
 *  All Rights Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 ***********************************************************************************/

package kr.co.actsone.utils
{
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
 
	
	public class MouseWheelTrap
	{
		static private var _mouseWheelTrapped:Boolean;
		
		public static var isMouseOutGrid:Boolean=true;
		
		public static var component:UIComponent=null;
		
		public static var gridoneId:String="";
	 
 
		/*************************************************************
		 * set up
		 * **********************************************************/
		public static function setup(com:UIComponent=null):void
		{
			if (com != null)
			{
				component=com;
				component.addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
				component.addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			}
			else
			{
				//making it work better for flex. use 'stage' for flash
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.CLICK, mouseClickHandler);
				//making it work better for flex. use 'stage' for flash 
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			}
			
		}
		
		/*************************************************************
		 * mouse roll over handler
		 * **********************************************************/
		private static function mouseRollOverHandler(event:MouseEvent):void
		{
			isMouseOutGrid=false;
			allowBrowserScroll(false);
		}
		
		/*************************************************************
		 * mouse roll out handler
		 * **********************************************************/
		private static function mouseRollOutHandler(event:MouseEvent):void
		{
			isMouseOutGrid=true;
			allowBrowserScroll(true);
		}
		
		/*************************************************************
		 * mouse click handler
		 * **********************************************************/
		private static function mouseClickHandler(event:MouseEvent):void
		{
			isMouseOutGrid=false;
			allowBrowserScroll(false);
		 
		}
		
		/*************************************************************
		 * allow browser scroll
		 * **********************************************************/
		public static function allowBrowserScroll(allow:Boolean):void
		{
         
			if (ExternalInterface.available)
			{
				ExternalInterface.call("allowBrowserScroll"+gridoneId, allow, FlexGlobals.topLevelApplication.id);
			}
		}
		
		/*************************************************************
		 * create mouse wheel trap
		 * **********************************************************/
		private static function createMouseWheelTrap():void
		{
			if (_mouseWheelTrapped)
			{
				return;
			}
			_mouseWheelTrapped=true;
			
			return;
 
		}
	}
}