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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import kr.co.actsone.common.Global;
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	
	import mx.containers.Canvas;
	import mx.controls.DateField;
	import mx.controls.TextInput;
	import mx.core.IUITextField;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	
	public class CalendarRenderer extends ExUIComponent
	{
		protected var label:IUITextField;
		protected var dateField:ExDateField;
		protected var formatter:DateFormatter;
		protected var canvas:Canvas;
		
		private var _text:String = "";

		[Bindable]
		public var myDateString:String="";
		[Bindable]
		public var labelWidth:int;
		
		public function CalendarRenderer()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
			this.setStyle('verticalAlign','middle');
			this.setStyle('horizontalGap',0);
		}
		
		/******************************************************************************************
		 * Create child objects of the component.
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function createChildren():void
		{
			super.createChildren();
 
			if(!canvas)
			{
				canvas = new Canvas();
 
				canvas.horizontalScrollPolicy="off";
				canvas.verticalScrollPolicy="off";
				canvas.enabled=true;
			 	this.addChild(DisplayObject(canvas));				
			}
			if(!dateField)
			{
				dateField = new ExDateField();
				dateField.includeInLayout = false;
				dateField.visible = false;
				dateField.focusEnabled = true;
				dateField.editable = false;
				dateField.width = 20;
				dateField.height = 18;
				dateField.setStyle('paddingTop',0);
				dateField.setStyle('paddingBottom',0);
				dateField.setStyle('paddingLeft',0);
				dateField.setStyle('paddingRight',0);
				dateField.addEventListener(FlexEvent.INITIALIZE,initHandler);
				dateField.addEventListener(DropdownEvent.OPEN,openHandler);
				dateField.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownCalendarHandler);
 
		 	 	canvas.addChild(DisplayObject(dateField));
			}
			
			if (!label)
			{
				label = IUITextField(createInFontContext(UITextField));
				label.styleName = this;
				label.addEventListener(MouseEvent.CLICK,clickLabelHandler);
				label.addEventListener(MouseEvent.MOUSE_OUT,canvasMouseOutHanlder);
				label.addEventListener(MouseEvent.MOUSE_OVER, canvasMouseOverHandler);
				label.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
 
		  		canvas.addChild(DisplayObject(label));
			}
						
			if(!formatter)
			{
				formatter = new DateFormatter();
				formatter.formatString = "YYYYMMDD";				
			}
		}
		
		/******************************************************************************************
		 * Processes the properties set on the component
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function commitProperties():void
		{
			super.commitProperties();	
			
			if(data==null || this.column.width==0)
			{
				this.label.text="";
				return;
			}	
			if(this.label)
			{
				if(data && column)
				{
					var activation:String=this.listOwner.getCellProperty('activation',data[Global.ACTSONE_INTERNAL],dataField);
					if(activation == null)
						activation = column.cellActivation;				
					if(activation != null)
					{
						if (activation == Global.ACTIVATE_DISABLE)
						{
							this.label.enabled = false;
						}
						else
						{					
							this.label.enabled = true;
						}
					}
					else if(!this.label.enabled)
						this.label.enabled = true;
					
					_isStrikeThrough = isStrikeThroughText();
					
					if (data != null && data[dataField] != null)
					{					
						var date:Date;
						date=DateField.stringToDate(data[dataField], column.dateInputFormatString);
						if (date != null)
						{
							formatter.formatString=column.dateOutputFormatString;
							myDateString=formatter.format(date);
						}
						else
							myDateString="";
					}
					else
					{
						if(data[dataField] == null)
							data[dataField] = "";
						myDateString="";
					}
				 	 labelWidth=ExAdvancedDataGrid(this.listData.owner).columns[this.listData.columnIndex].width;
					 
					
					canvas.width = labelWidth;
					canvas.height =this.listOwner.height-3;
					_text = myDateString;
					this.label.text=myDateString;
					if(this.listOwner.nCellPadding)
						this.label.width = labelWidth - this.listOwner.nCellPadding-10;
					else
						this.label.width = labelWidth-10;	
					var dataTips:Boolean = listOwner.showDataTips;
					if (column.showDataTips == true)
						dataTips = true;
					if (column.showDataTips == false)
						dataTips = false;
					if (dataTips)
					{
						if (!(data is ExAdvancedDataGridColumn) && (label.textWidth > label.width
							|| column.dataTipFunction || column.dataTipField 
							|| listOwner.dataTipFunction || listOwner.dataTipField))
						{
							toolTip = column.itemToDataTip(data);
						}
						else
						{
							toolTip = null;
						}
					}
					else if (listOwner.toolTipData !="" && column.toolTipData !="")
					{
						toolTip = listOwner.toolTipData;
					}
					else
					{
						toolTip = null;
					}
				}
				else
				{
					label.text = " ";
					toolTip = null;
				}	
			}
			invalidateDisplayList();
		}

		/******************************************************************************************
		 * Handler of creationComplete event init this item renderer.
		 * @author Duong Pham
		 ******************************************************************************************/
		private function creationCompleteHandler(event:FlexEvent):void
		{
		}
		
		/******************************************************************************************
		 * Handler of mouse out event of canvas
		 * @author Duong Pham
		 ******************************************************************************************/
		protected function canvasMouseOutHanlder(event:MouseEvent):void
		{
			if (this.listOwner.columns[this.listData.columnIndex].editable)
			{
				this.dateField.visible=false;
				this.dateField.includeInLayout = false;
				label.width=labelWidth-10;
				label.text = _text;		//to be used in truncateToFit
			} 
		}
		
		/******************************************************************************************
		 * Handler of mouse over event of canvas
		 * @author Duong Pham
		 ******************************************************************************************/
		private function canvasMouseOverHandler(event:MouseEvent):void
		{				
			if(this.label.enabled)
			{
				if (this.listOwner.columns[this.listData.columnIndex].editable)
				{
					var cellActivation:String=this.listOwner.getCellProperty('activation',data[Global.ACTSONE_INTERNAL],dataField);
					if(cellActivation != null)
					{
						if(cellActivation == Global.ACTIVATE_ONLY || cellActivation == Global.ACTIVATE_DISABLE)
							return;						
					}
					else if(column.cellActivation == Global.ACTIVATE_ONLY || column.cellActivation == Global.ACTIVATE_DISABLE)
						return;
					if(this.listOwner.strCellClickAction == Global.ROWSELECT)
						return;			
					if(this.listOwner.editedItemPosition && this.listOwner.editedItemPosition.columnIndex == this.listData.columnIndex && this.listOwner.editedItemPosition.rowIndex == this.listData.rowIndex)
						return;	
					if(!this.dateField.visible && !this.dateField.includeInLayout)
					{
						this.dateField.visible=true;
						this.dateField.includeInLayout=true;
					}
					if(listOwner.nCellPadding)
						label.width=column.width - this.dateField.width - listOwner.nCellPadding;
					else
						label.width=column.width - this.dateField.width;
					
					//use for roll over font color of column
					this.listOwner._selectedColIndex = listData.columnIndex;
 
					this.dateField.x = this.width - dateField.width;
				    this.dateField.y = Math.ceil(this.height - this.dateField.height)/2;
					
				} 
			}
		}
		
		/******************************************************************************************
		 * Handler of mouse down event
		 * @author Duong Pham
		 ******************************************************************************************/
		protected function onMouseDownHandler(event:MouseEvent):void
		{
			if (this.listOwner.columns[this.listData.columnIndex].editable)
			{
				this.dateField.visible=false;
				this.dateField.includeInLayout = false;
				label.width=labelWidth;
				label.height=this.height-3;
			} 				
		}
		
		/******************************************************************************************
		 * Draws the object and/or sizes and positions its children...
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var truncated:Boolean;
			truncated = label.truncateToFit();				
			
			if (!toolTipSet)
				super.toolTip = truncated ? this.label.text : null;
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			//this.label.move(0,0);
			
			var startX:Number = 0;
			if(this.listOwner && this.listOwner.nCellPadding)
			{
				startX += this.listOwner.nCellPadding;
			}
			var t:String = getMinimumText(label.text);
			var textFieldBounds:Rectangle = measureTextFieldBounds(t);
			label.height = unscaledHeight;
			if(dateField.visible)
			{
				label.setActualSize(unscaledWidth - startX - dateField.width, label.height);
			}
			else
				label.setActualSize(unscaledWidth - startX, label.height);
			
			var verticalAlign:String = getStyle("verticalAlign");
			if (verticalAlign == "top")
			{
				label.y = 0;
			}
			else if (verticalAlign == "bottom")
			{
				label.y = unscaledHeight - label.height + 2; // 2 for gutter
			}
			else
			{
				label.y = (unscaledHeight - label.height) / 2;
			}
			
			drawStrikeThrough(this.label);
			
			//because some reason, this style is cleaned. We need to re-set it again.
			this.setStyle('textDecoration',column.getStyle('textDecoration'));
			
		}
		
		/******************************************************************************************
		 * Apply color of cell
		 * @author Duong Pham
		 ******************************************************************************************/
		override public function validateNow():void
		{
			super.validateNow();
			if (data && parent)
			{
				var newColor:Number = getCurentColor();
				var oldColor:* = label.textColor;
				if (oldColor != newColor)
				{
					label.setColor(newColor);
					invalidateDisplayList();
				}
			}
		}
		
		/******************************************************************************************
		 * Get accessibility name for screen reader
		 * @author Thuan
		 ******************************************************************************************/
		override public function getAccessibilityName():String
		{
			//return "Component is DateField. Value is " + this.label.text;
			var strReader:String = this.column.strAccessReader;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_CALENDAR);
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.label.text);
				}
				else // don't have control type in strAccessReader
				{
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.label.text);
				}
				//				trace("Label Renderer strReader != null: " + strReader);
			}
			else // make column default information
			{
				strReader = Global.ACCESS_READER_COLUMN_DEFAULT + " " + Global.ACCESS_READER_CONTROL + " " + 
					Global.ACCESS_READER_CALENDAR + " " + Global.ACCESS_READER_CELL + " " + this.label.text;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;
		}
		
		/******************************************************************************************
		 * mouse down in calendar
		 * @author Duong Pham
		 ******************************************************************************************/
		private function mouseDownCalendarHandler(event:MouseEvent):void
		{
			this.dateField.close();
			column.isShowCalendar=true;
			this.listOwner.dispatchEvent(new Event("clickCalendar"));
		}
		
		/******************************************************************************************
		 * handle mouse click event when click label
		 * @author Duong Pham
		 ******************************************************************************************/
		private function clickLabelHandler(event:MouseEvent):void
		{
			if (this.listOwner.editable && column.editable)
				column.isShowCalendar=false;
		}
		
		/******************************************************************************************
		 * handle open event
		 * @author Duong Pham
		 ******************************************************************************************/
		private function openHandler(event:DropdownEvent):void
		{
			this.dateField.close();
			column.isShowCalendar=true;
		}
		
		private var tf:TextInput;
		
		/******************************************************************************************
		 * handle initilize event of dateField
		 * @author Duong Pham
		 ******************************************************************************************/
		private function initHandler(event:FlexEvent):void
		{
			tf=dateField.mx_internal::getTextInput();
			tf.visible=false;
			tf.includeInLayout=false;
		}
	}
}