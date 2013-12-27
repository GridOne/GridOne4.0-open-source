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

package kr.co.actsone.itemRenderers
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import kr.co.actsone.common.Global;
	import kr.co.actsone.events.SAEvent;
	
	import mx.controls.RadioButton;
	
	public class RadioButtonRenderer extends ExUIComponent
	{
		
		protected var radio:RadioButton;
		
		public function RadioButtonRenderer()
		{
			super();
			
			tabEnabled = false;
		}
		
		/******************************************************************************************
		 * Create child objects of the component.
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!radio)
			{
				radio = new RadioButton();
				this.radio.styleName = this;
				this.radio.addEventListener(MouseEvent.CLICK,selectThis);
				addChild(DisplayObject(radio));
			}
		}
		
		/******************************************************************************************
		 * Processes the properties set on the component
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (data != null && dataField != "" && radio != null)
			{
				if (data[dataField] != null)
				{
					radio.selected=(data[dataField].toString().toLowerCase().search("true") == 0) ? true : false;
				}
				else
					radio.selected=data[dataField]=false;
			}
			invalidateDisplayList();
		}
		
		/******************************************************************************************
		 * handle mouse click event when selecting radio button.
		 * dispatch event in case radio button is changed state.
		 * @author Duong Pham
		 ******************************************************************************************/
		private function selectThis(event:MouseEvent):void
		{	
			if(column.selectedRadioItem != null)
				column.selectedRadioItem[this.dataField]="0";
			data[dataField]=radio.selected ? "1" : "0";
			column.selectedRadioItem=data;
			//			listOwner.invalidateList();
			if(listOwner.eventArr.hasOwnProperty(SAEvent.RADIOBUTTON_CLICK))
			{
				var saEvent:SAEvent = new SAEvent(SAEvent.RADIOBUTTON_CLICK,true);
				saEvent.nRow=this.listOwner.getItemIndex(this.data);
			//	saEvent.strNewValue = radio.selected;
				saEvent.strNewValue=data[dataField];
				saEvent.columnKey=this.dataField;
				this.listOwner.dispatchEvent(saEvent);
			}
		}
		
		/******************************************************************************************
		 * Draws the object and/or sizes and positions its children.
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			this.radio.move(0,0);
			
			var startX:Number = 0;
			
			
			if(this.listOwner && this.listOwner.nCellPadding)
			{
				startX += this.listOwner.nCellPadding;
			}
			
			radio.width=unscaledWidth/2;
			
			var textAlign:String = getStyle("textAlign");
			if (textAlign == "center")
			{
				radio.x = (unscaledWidth-radio.width)/ 2  + startX-2;
			}
			else if (textAlign == "right")
			{
				radio.x = unscaledWidth - startX - radio.width + 2; // 2 for gutter
			}
			else
			{
				radio.x = startX;
			}		
			this.radio.setActualSize(unscaledWidth/2, unscaledHeight);
		}
		
		/******************************************************************************************
		 * Get accessibility name for screen reader
		 * @author Duong Pham
		 ******************************************************************************************/
		override public function getAccessibilityName():String
		{
			//return "Component is Radio. Value is " + this.radio.selected;
			
			var sChecked:String = this.radio.selected ? "true":"false";
			var strReader:String = this.column.strAccessReader;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_RADIOBUTTON);
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, sChecked);
				}
				else // don't have control type in strAccessReader
				{
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, sChecked);
				}
				//				trace("Label Renderer strReader != null: " + strReader);
			}
			else // make column default information
			{
				strReader = Global.ACCESS_READER_COLUMN_DEFAULT + " " + Global.ACCESS_READER_CONTROL + " " + 
					Global.ACCESS_READER_RADIOBUTTON + " " + Global.ACCESS_READER_CELL + " " + sChecked;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;
		}
	}
}