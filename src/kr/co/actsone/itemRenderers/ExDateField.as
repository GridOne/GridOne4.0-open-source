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
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import kr.co.actsone.common.Global;
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.events.SAEvent;
	
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	[Event(name="textInputDateKeyDown", type="kr.co.actsone.events.SAEvent")]
	
	public class ExDateField extends DateField
	{
		public function ExDateField()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,createCompleteHandler);
		}
		
		/******************************************************************************************
		 * create completed handler
		 ******************************************************************************************/
		protected function createCompleteHandler(event:FlexEvent):void
		{
			this.textInput.addEventListener(KeyboardEvent.KEY_DOWN,textInputKeyDownHandler);
		}
		
		/******************************************************************************************
		 * text input key down handler
		 ******************************************************************************************/
		private function textInputKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE)
			{
				var saEvent:SAEvent = new SAEvent(SAEvent.TEXT_INPUT_DATE_KEY_DOWN);
				saEvent.data = {keyboardEvent: event};
				this.dispatchEvent(saEvent);
			}
		}
		
		/******************************************************************************************
		 * update display list 
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(Global.DEFAULT_LANG == "KR")
			{
				this.dayNames  =["일", "월", "화", "수", "목", "금", "토"];
				this.monthNames=["1", "2", "3", "4", "5","6", "7", "8", "9", "10", "11", "12"];
				this.monthSymbol ="월";
			}
			else
			{
				this.dayNames  =["S", "M", "T", "W", "T", "F", "S"];
				this.monthNames=["January", "February", "March", "April", "May","June", "July", "August", "September", "October", "November", "December"];
			}
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		/******************************************************************************************
		 * get text input value
		 ******************************************************************************************/
		public function getTextInputValue():String
		{
			return this.textInput.text;
		}
		
		/******************************************************************************************
		 * Get accessibility name for screen reader
		 * @author Thuan
		 ******************************************************************************************/
		public function getAccessibilityName():String
		{
			this.listData
			var listOwner: ExAdvancedDataGrid;
			
			if (this.listData && this.listData.owner)
				listOwner = this.listData.owner as ExAdvancedDataGrid;
			else
				return "";
			
			var strReader:String = listOwner.columns[this.listData.columnIndex].strAccessReader;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_DATEFIELD);
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.textInput.text);
				}
				else // don't have control type in strAccessReader
				{
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.textInput.text);
				}
				//				trace("Label Renderer strReader != null: " + strReader);
			}
			else // make column default information
			{
				strReader = Global.ACCESS_READER_COLUMN_DEFAULT + " " + Global.ACCESS_READER_CONTROL + " " + 
					Global.ACCESS_READER_DATEFIELD + " " + Global.ACCESS_READER_CELL + " " + this.textInput.text;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;
		}
	}
}