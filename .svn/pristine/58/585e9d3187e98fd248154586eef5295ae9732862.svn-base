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
	import flash.geom.Rectangle;
	
	import kr.co.actsone.common.ColumnType;
	import kr.co.actsone.common.Global;
	import kr.co.actsone.common.LabelFunctionLib;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.summarybar.SummaryBar;
	import kr.co.actsone.summarybar.SummaryBarConstant;
	import kr.co.actsone.utils.UtilFunc;
	
	import mx.core.IUITextField;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	use namespace mx_internal;
	
	public class TotalColumnRenderer extends ExUIComponent
	{
		protected var label:IUITextField;
		
		public function TotalColumnRenderer()
		{
			super();
			tabEnabled = false;
			this.setStyle('verticalAlign','middle');
		}
		
		/******************************************************************************************
		 * create children
		 ******************************************************************************************/
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!label)
			{
				label = IUITextField(createInFontContext(UITextField));
				label.styleName = this;
				
				addChild(DisplayObject(label));
			}
		}
		
		/******************************************************************************************
		 * commit properties
		 ******************************************************************************************/
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(data == null)
				return;
			
			if(this.label)
			{
				if (data && column && column.width > 0)
				{
					var originalText : String = '';
					
					if(data[this.dataField] == null)
						data[this.dataField] = "";
					
					label.width = column.width;
					this.height = listOwner.rowHeight;	
					originalText=column.itemToLabel(data);
					
					var summaryBar:SummaryBar = column.summaryBar;
					if(summaryBar)
					{
						if(summaryBar.strFunction == SummaryBarConstant.FUNC_CUSTOM)
						{
							var tmpData:String= column.positionTotalChange[summaryBar.summaryBarKey + '_' + summaryBar.totalColDataField + '_' + listData.rowIndex ];
							if(tmpData != null)
							{
								if(column.formatType != null && column.formatType[summaryBar.summaryBarKey] != null)
									originalText = listOwner.summaryBarManager.formatBaseOnPatternTotal(column,Number(tmpData),data);
								else
									originalText = tmpData;
							}
							else
							{
								originalText ='';
							}
						}
						else
						{
							if(isNaN(Number(data[summaryBar.totalColDataField]))) // using for case of user set text is not number
								originalText = data[summaryBar.totalColDataField];
							else
								originalText = listOwner.summaryBarManager.formatBaseOnPatternTotal(column,data[summaryBar.totalColDataField],data);
						}
					}
					
					label.text = originalText;
					
					label.multiline = listOwner.variableRowHeight;
					label.wordWrap = listOwner.columnWordWrap(column);
					
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
					label.width = 0;
				}
			}
			invalidateDisplayList();
		}
		
		/******************************************************************************************
		 * update display list
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var truncated:Boolean;
			truncated = label.truncateToFit();				
			
			if (!toolTipSet)
				super.toolTip = truncated ? this.label.text : null;
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			this.label.move(0,0);
			var startX:Number = 0;
			if(this.listOwner && this.listOwner.nCellPadding)
			{
				startX += this.listOwner.nCellPadding;
			}
			var t:String = getMinimumText(label.text);
			
			var textFieldBounds:Rectangle = measureTextFieldBounds(t);
			label.height = textFieldBounds.height;
			
			this.label.setActualSize(unscaledWidth - startX, textFieldBounds.height);
			
			var textAlign:String = getStyle("textAlign");
			if (textAlign == "left")
			{
				label.x = startX;
			}
			else if (textAlign == "right")
			{
				label.x = unscaledWidth - startX - label.width + 2; // 2 for gutter
			}
			else
			{
				label.x = (unscaledWidth - label.width) / 2  - startX;
			}
			
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
			var styleValue:String = getSummaryBarCellStyle('textDecoration');
			this.setStyle('textDecoration',styleValue);
		}
		
		/******************************************************************************************
		 * Apply color of cell
		 * @author Duong Pham
		 ******************************************************************************************/
		override public function validateNow():void
		{
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
			super.validateNow();
		}
		
		/******************************************************************************************
		 * Get accessibility name for screen reader
		 * @author Thuan
		 ******************************************************************************************/
		override public function getAccessibilityName():String
		{
			var strReader:String = this.column.strAccessReader;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_COLUMNTOTAL);
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
					Global.ACCESS_READER_COLUMNTOTAL + " " + Global.ACCESS_READER_CELL + " " + this.label.text;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;
		}
	}
}