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
	import flash.text.TextLineMetrics;
	
	import kr.co.actsone.common.Global;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.events.SAEvent;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	public class ButtonRenderer extends ExUIComponent
	{
		protected var btn:Button;
		
		public function ButtonRenderer()
		{
			super();
			tabEnabled = false;
			mouseEnabled = true;
			mouseChildren = true;
			mouseFocusEnabled = true;
		}
		
		/******************************************************************************************
		 * Create child objects of the component.
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!btn)
			{
				btn = new Button();
				this.btn.styleName = this;
				btn.styleName = "buttonRendererStyle";
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownButtonHandler);
				addChild(DisplayObject(btn));
			}
		}
		
		/******************************************************************************************
		 * mouse down button handler
		 * @author Duong Pham
		 ******************************************************************************************/
		protected function onMouseDownButtonHandler(event:MouseEvent):void
		{
			var saEvent:SAEvent=new SAEvent(SAEvent.ON_BUTTON_CLICK,true);
			saEvent.columnKey=dataField;
			saEvent.nRow=this.listOwner.getItemIndex(data);
			this.listOwner.dispatchEvent(saEvent); 
		}
		
		/******************************************************************************************
		 * Processes the properties set on the component
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(this.btn)
			{
				if(data && column)
				{
					if(btn==null)
						return;

					var activation:String=this.listOwner.getCellProperty('activation',data[Global.ACTSONE_INTERNAL],dataField);
					if(activation == null)
						activation = column.cellActivation;
					if(activation != null)
					{
						if (activation == Global.ACTIVATE_DISABLE)
						{
							this.btn.enabled = false;
						}
						else
						{					
							this.btn.enabled = true;
						}
					}
					else if(!this.btn.enabled)
						this.btn.enabled = true;
					
					if(this.column.buttonText != "")
						btn.label = this.column.buttonText;
					else
					{
						btn.label = "Link";
					}
					
					if(data[dataField+Global.SELECTED_BUTTON_INDEX]==true)
					{
						btn.visible = false;
					}
					else
					{
						btn.visible = true;
					}
					
					btn.width=this.column.width;
					var dataTips:Boolean = listOwner.showDataTips;
					if (column.showDataTips == true)
						dataTips = true;
					if (column.showDataTips == false)
						dataTips = false;
					if (dataTips)
					{
						var metrics:TextLineMetrics=measureText(btn.label);
						var textWidth:int = metrics.width;
						if (!(data is ExAdvancedDataGridColumn) && (textWidth > btn.width
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
					btn.label = " ";
					toolTip = null;
				}
			}
			invalidateDisplayList();
		}
		
		/******************************************************************************************
		 * Draws the object and/or sizes and positions its children.
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			this.btn.move(0,0);
			this.btn.setActualSize(unscaledWidth,unscaledHeight);
		}
		
		/******************************************************************************************
		 * Apply color of cell
		 * @author Duong Pham
		 ******************************************************************************************/
		override public function validateNow():void
		{
			super.validateNow();
			applyColor(this.btn,this.getStyle('color'));
		}
		
		/******************************************************************************************
		 * Get accessibility name for screen reader
		 * @author Thuan
		 ******************************************************************************************/
		override public function getAccessibilityName():String
		{
			//return "Component is button. Label of button is " + this.btn.label;
			
			var strReader:String = this.column.strAccessReader;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_BUTTON);
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.btn.label);
				}
				else // don't have control type in strAccessReader
				{
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.btn.label);
				}
				//				trace("Label Renderer strReader != null: " + strReader);
			}
			else // make column default information
			{
				strReader = Global.ACCESS_READER_COLUMN_DEFAULT + " " + Global.ACCESS_READER_CONTROL + " " + 
					Global.ACCESS_READER_BUTTON + " " + Global.ACCESS_READER_CELL + " " + this.btn.label;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;
		}
	}
}