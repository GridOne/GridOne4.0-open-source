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
	import flash.geom.Rectangle;
	
	import kr.co.actsone.common.ColumnType;
	import kr.co.actsone.common.Global;
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridItemRenderer;
	
	import mx.controls.listClasses.BaseListData;
	import mx.core.IUITextField;
	import mx.core.UITextField;

	public class HtmlRenderer extends ExAdvancedDataGridItemRenderer
	{
		public function HtmlRenderer()
		{
			super();
			this.multiline = true;
			this.mouseWheelEnabled = false;
		}

		/**************************************************************************
		 * update html text for cell
		 * @author Duong Pham 
		 **************************************************************************/
		override public function validateProperties():void
		{
			super.validateProperties();
			if (listData)
			{
				var listOwner:ExAdvancedDataGrid=this.listData.owner as ExAdvancedDataGrid;
				var column:ExAdvancedDataGridColumn=listOwner.columns[this.listData.columnIndex];	
				listOwner.variableRowHeight = true;
				htmlText = data[column.dataField];
				if (getStyle("plainText"))
				{
					text = text;
				}
				
				var activation:String=listOwner.getCellProperty('activation',data[Global.ACTSONE_INTERNAL],column.dataField);
				if(activation == null)
					activation = column.cellActivation;				
				if(activation != null)
				{
					if (activation == Global.ACTIVATE_DISABLE)
					{
						this.enabled = false;
					}
					else
					{					
						this.enabled = true;
					}
				}
				else if(!this.enabled)
					this.enabled = true;
			}
		}
		
		/**************************************************************************
		 * Get information of column such as: Header text and column type
		 * @author Thuan 
		 **************************************************************************/
		protected function getAccessibilityNameDefault():String
		{
			var colIndex: int = listData.columnIndex;
			var columnInfor: String = "";
			var listOwner:ExAdvancedDataGrid=this.listData.owner as ExAdvancedDataGrid;
			var column:ExAdvancedDataGridColumn=listOwner.columns[colIndex];	
			
			if ((this.owner as ExAdvancedDataGrid).columns[colIndex] && ((this.owner as ExAdvancedDataGrid).columns[colIndex].headerText))
				columnInfor = Global.ACCESS_READER_HEADER + " " + (this.owner as ExAdvancedDataGrid).columns[colIndex].headerText + ". ";
			
			columnInfor += Global.ACCESS_READER_COLUMN + column.type + ". ";
			
			return columnInfor;
		}
				
		/******************************************************************************************
		 * Get accessibility name for screen reader
		 * @author Thuan
		 ******************************************************************************************/
		/*override public function getAccessibilityName():String
		{
			var listOwner:ExAdvancedDataGrid=this.listData.owner as ExAdvancedDataGrid;
			var column:ExAdvancedDataGridColumn=listOwner.columns[this.listData.columnIndex];
			
			var strReader:String = column.strAccessReader;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_LABEL);
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.text);
				}
				else // don't have control type in strAccessReader
				{
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, this.text);
				}
				//				trace("Label Renderer strReader != null: " + strReader);
			}
			else // make column default information
			{
				strReader = Global.ACCESS_READER_COLUMN_DEFAULT + " " + Global.ACCESS_READER_CONTROL + " " + 
					Global.ACCESS_READER_LABEL + " " + Global.ACCESS_READER_CELL + " " + this.text;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;
		}*/
	}
}