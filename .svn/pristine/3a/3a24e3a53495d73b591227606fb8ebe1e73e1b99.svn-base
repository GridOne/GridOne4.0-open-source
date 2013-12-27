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
	
	import mx.containers.Canvas;
	 
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.graphics.BitmapScaleMode;
	
	import spark.components.TextArea;
	
	use namespace mx_internal;
	public class TextAreaRenderer  extends ExUIComponent
	{
		protected var label:UITextField;
		 
		protected var canvas:Canvas;
	 
		public function TextAreaRenderer()
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
			
			if(!canvas)
			{
				canvas = new Canvas();
				canvas.horizontalScrollPolicy="off";
				canvas.verticalScrollPolicy="off";
				canvas.percentWidth=100;
				canvas.percentHeight=100;
				this.addChild(DisplayObject(canvas));
			}
	 
			if (!label)
			{
				label = UITextField(createInFontContext(UITextField));
				label.styleName = this;
				label.setStyle("padding-top",10);
				canvas.addChild(DisplayObject(label));				
			}
		}
		
		/******************************************************************************************
		 * commit properties
		 ******************************************************************************************/
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(label)
			{
				if (data && column)
				{	
					canvas.width = ExAdvancedDataGrid(this.listData.owner).columns[this.listData.columnIndex].width;
				 
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
					else if(this.label.enabled)
						this.label.enabled = true;
					
					_isStrikeThrough = isStrikeThroughText();
					
					_height = this.label.textHeight;
					
					if(data[this.dataField] == null)
						data[this.dataField] =this.label.text;
					
					this.label.text=data[dataField];
				 							
					label.multiline = listOwner.variableRowHeight;
					label.wordWrap = ExAdvancedDataGrid(listOwner).columnWordWrap(column);
		 
					var dataTips:Boolean = listOwner.showDataTips;
 
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
		 * update display list
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			 
			var startx:Number = 0;
			var maxLength:Number=column.maxLength;
			maxHeight =200;
			if(this.listOwner && this.listOwner.nCellPadding)
			{
				startx += this.listOwner.nCellPadding;
			}
		 
				this.label.x = startx-2;
				this.label.y=2;
				label.width = column.width;
 
			if (label.textHeight <=20)
			{
				canvas.height=listOwner.rowHeight;
				label.height = listOwner.rowHeight;
			}
			else if (label.textHeight >maxHeight)
			{
				 
				canvas.height=maxHeight;
				label.height =maxHeight;
			}
			else
			{
				canvas.height=label.textHeight;
				label.height = label.textHeight+10;	
			}
			
			 
		  //  Alert.show(this.height + "");
			label.setActualSize(label.width, label.height);
			
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
			
			var truncated:Boolean;
			truncated = label.truncateToFit();				
			
//			if (!toolTipSet)
//				super.toolTip = truncated ? this.label.text : null;
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			drawStrikeThrough(this.label);
			
			//because some reason, this style is cleaned. We need to re-set it again.
			this.setStyle('textDecoration',column.getStyle('textDecoration'));
		}
		
		/******************************************************************************************
		 * measure
		 ******************************************************************************************/
		override protected function measure():void
		{
			super.measure();
			var w:Number = 0;
			 
			// guarantee that label width isn't zero because it messes up ability to measure
			if (label.width < 4 || label.height < 4)
			{
				label.width = 4;
				label.height = 16;
			}
			
			if (isNaN(explicitWidth))
			{
				w += label.getExplicitOrMeasuredWidth();    
				measuredWidth = w;
			}
			else
			{
				//linkbt.width = Math.max(explicitWidth - w-5, 4);
				label.width=explicitWidth-label.width-5;
			}
			
			measuredHeight = label.getExplicitOrMeasuredHeight();
			 
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
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_LABEL);
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
					Global.ACCESS_READER_LABEL + " " + Global.ACCESS_READER_CELL + " " + this.label.text;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;
		}
			
	}
}