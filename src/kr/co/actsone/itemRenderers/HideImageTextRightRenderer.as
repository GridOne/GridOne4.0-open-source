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
	import flash.text.TextLineMetrics;
	
	import kr.co.actsone.common.Global;
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.events.SAEvent;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.graphics.BitmapScaleMode;
	
	use namespace mx_internal;
	public class HideImageTextRightRenderer extends ExUIComponent  
	{
		protected var linkIcon:Image;
		protected var linkbt:UITextField;
 
		
		private var columnImageTextAlign:String= "right";
		
		public function HideImageTextRightRenderer()
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
		
			if(!linkIcon)
			{
				linkIcon = new Image();				
				this.linkIcon.styleName = this;
		 
			}
			 
			if (!linkbt)
			{
				linkbt = UITextField(createInFontContext(UITextField));
				linkbt.styleName = this;
				linkbt.setStyle("padding-right",5);
				this.addChild(DisplayObject(linkbt));				
			}
		}
 
		/******************************************************************************************
		 * set data
		 ******************************************************************************************/
		override public function set data(value:Object):void
		{
			if (value !=null)
			{
				super.data=value;
			}	
			
		}
		/******************************************************************************************
		 * update data
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(linkbt)
			{
				if (data && column)
				{	
					this.width = ExAdvancedDataGrid(this.listData.owner).columns[this.listData.columnIndex].width-5;
					this.height = listOwner.rowHeight;
					var activation:String=this.listOwner.getCellProperty('activation',data[Global.ACTSONE_INTERNAL],dataField);
					if(activation == null)
						activation = column.cellActivation;				
					if(activation != null)
					{
						if (activation == Global.ACTIVATE_DISABLE)
						{
							this.linkbt.enabled = false;
						}
						else
						{					
							this.linkbt.enabled = true;
						}
					}
					else if(this.linkbt.enabled)
						this.linkbt.enabled = true;
					
					_isStrikeThrough = isStrikeThroughText();
					
					_height = listOwner.rowHeight;
					
					if(column.getStyle("imageTextAlign") != undefined && column.getStyle("imageTextAlign")!= null)						
						columnImageTextAlign = column.getStyle("imageTextAlign");
					
					if(data[this.dataField] == null)
						data[this.dataField] = "";
					this.linkbt.text=data[dataField];					
					if(data[dataField+Global.SELECTED_IMAGE_INDEX]==null)
					{
						data[dataField+Global.SELECTED_IMAGE_INDEX]=0;
					}
					var index:int=parseInt(data[dataField + Global.SELECTED_IMAGE_INDEX]);
					if(!column.isUseGridImage)
					{ 
						this.linkIcon.source=column.imageList[index];
					}
					else
					{
						this.linkIcon.source=(this.listData.owner as ExAdvancedDataGrid).imageList[index];
					}							
					if(this.linkIcon.source == null || this.linkIcon.source == "")
					{									
						this.linkIcon.includeInLayout = false;						
						this.linkIcon.visible = false;											
					}
					else
					{
						this.linkIcon.includeInLayout = true;
						this.linkIcon.visible = true;
						this.linkIcon.width=column.imageWidth;
						this.linkIcon.height=column.imageHeight;						
					}									
					linkbt.multiline = listOwner.variableRowHeight;
					linkbt.wordWrap = ExAdvancedDataGrid(listOwner).columnWordWrap(column);
				  
					var dataTips:Boolean = listOwner.showDataTips;
					if (column.showDataTips == true)
						dataTips = true;
					if (column.showDataTips == false)
						dataTips = false;
					if (dataTips)
					{
						if (!(data is ExAdvancedDataGridColumn) && (linkbt.textWidth > linkbt.width
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
					linkbt.text = " ";
					toolTip = null;
				}
			}
			invalidateDisplayList();
		}
		
		/******************************************************************************************
		 * measure
		 ******************************************************************************************/
		override protected function measure():void
		{
			super.measure();
			var w:Number = 0;
			
			if (linkIcon)
				w += linkIcon.measuredWidth;
			
			// guarantee that label width isn't zero because it messes up ability to measure
			if (linkbt.width < 4 || linkbt.height < 4)
			{
				linkbt.width = 4;
				linkbt.height = 16;
			}
			
			if (isNaN(explicitWidth))
			{
				w += linkbt.getExplicitOrMeasuredWidth();    
				measuredWidth = w;
			}
			else
			{
				//linkbt.width = Math.max(explicitWidth - w-5, 4);
				linkbt.width=explicitWidth-linkbt.width-5;
			}
			
			measuredHeight = linkbt.getExplicitOrMeasuredHeight();
			if (linkIcon && linkIcon.measuredHeight > measuredHeight)
				measuredHeight = linkIcon.measuredHeight;
		}
		
		/******************************************************************************************
		 * Processes the properties set on the component
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			var startx:Number = 0;
			if(this.listOwner && this.listOwner.nCellPadding)
			{
				startx += this.listOwner.nCellPadding;
			}
			if(linkIcon.includeInLayout)
			{
				if(columnImageTextAlign == 'right')
				{
					linkIcon.x = column.width - linkIcon.width;
					linkbt.x =startx+3;
					linkbt.width = column.width;						
				}
				
			}
			else
			{
				this.linkbt.x = startx-3;
				this.linkbt.y=2;
				linkbt.width = column.width;
			}
			
			if (linkIcon.includeInLayout && linkIcon.visible)
			{
				linkIcon.setActualSize(linkIcon.width, linkIcon.height);
			}						
			
			var t:String = getMinimumText(linkbt.text);
			
			var textFieldBounds:Rectangle= measureTextFieldBounds(t);
			//linkbt.height = textFieldBounds.height;
			linkbt.height = unscaledHeight-5;
			linkbt.setActualSize(linkbt.width, linkbt.height);
			
			var verticalAlign:String = getStyle("verticalAlign");
			if (verticalAlign == "top")
			{
				linkbt.y = 0;
				if (linkIcon)
					linkIcon.y = 0;
			}
			else if (verticalAlign == "bottom")
			{
				linkbt.y = unscaledHeight - linkbt.height + 2; // 2 for gutter
				if (linkIcon)
					linkIcon.y = unscaledHeight - linkIcon.height;
			}
			else
			{
				linkbt.y = (unscaledHeight - linkbt.height) / 2;
				if (linkIcon)
					linkIcon.y = (unscaledHeight - linkIcon.height) / 2;
			}
			
			var truncated:Boolean;
			truncated = linkbt.truncateToFit();				
			
			if (!toolTipSet)
				super.toolTip = truncated ? this.linkbt.text : null;
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			drawStrikeThrough(this.linkbt);
			
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
			//			applyColor(this.linkbt,this.getStyle('color'));
			if (data && parent)
			{
				var newColor:Number = getCurentColor();
				var oldColor:* = linkbt.textColor;
				if (oldColor != newColor)
				{
					linkbt.setColor(newColor);
					invalidateDisplayList();
				}
			}
		}
		
		/**************************************************************************
		 * Get information of column such as: Header text and column type
		 * @param object need to be drawn strike through text
		 * @author Duong Pham 
		 **************************************************************************/
		override public function drawStrikeThrough(label:*):void
		{
			if(!strike.parent)
				this.addChild(strike);
			this.strike.graphics.clear();
			if (_isStrikeThrough && label.text != "" && label)
			{
				this.strike.graphics.moveTo(0, 0);
				this.strike.graphics.lineStyle(1, this.getStyle("color"), 1);
				var align:String=this.getStyle("textAlign");
				var y:int=0;
				var x:int=0;
				if(align=="center")
				{
					x=this.width/2-label.textWidth/2+1;
					if(listOwner.nCellPadding)
						x += listOwner.nCellPadding;
				}
				else if(align=="right")
				{
					x=this.width-label.textWidth-2;
				}
				else
				{
					x = 2;
					if(listOwner.nCellPadding)
						x += listOwner.nCellPadding;
				}
				
				if(columnImageTextAlign == "left")
					x += linkIcon.width;
				for (var i:int=0; i < label.numLines; i++)
				{
					var metrics:TextLineMetrics=label.getLineMetrics(i);
					if (i == 0)
					{
						y+=(metrics.ascent * 0.66) + 2;
					}
					else
					{
						y+=metrics.height;
					}
					this.strike.graphics.moveTo(x, y);
					this.strike.graphics.lineTo(x+metrics.width-1, y);
				}
			}
		}
		
		/******************************************************************************************
		 * Get accessibility name for screen reader
		 * @author Thuan
		 ******************************************************************************************/
		override public function getAccessibilityName():String
		{
			//return "Component is ImageText. Value is " + this.linkbt.text;
			
			var strReader:String = this.column.strAccessReader;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_IMAGETEXT);
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.linkbt.text);
				}
				else // don't have control type in strAccessReader
				{
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.linkbt.text);
				}
				//				trace("Label Renderer strReader != null: " + strReader);
			}
			else // make column default information
			{
				strReader = Global.ACCESS_READER_COLUMN_DEFAULT + " " + Global.ACCESS_READER_CONTROL + " " + 
					Global.ACCESS_READER_IMAGETEXT + " " + Global.ACCESS_READER_CELL + " " + this.linkbt.text;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;
		}
	
	}
}