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

package kr.co.actsone.accessibility
{
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridHeaderInfo;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridHeaderRenderer;
	
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class AccessibilityUtils
	{
		public function AccessibilityUtils()
		{
		}
		
		/****************************************************************
		 * send message to screen reader
		 * **************************************************************/
		public  static function sendMsgToScreenReader(grid : ExAdvancedDataGrid) :String
		{
			//get current selected cells
			var cellArr: Array = grid.selectedCells;
			var sCellReader: String = "";
			
			if (grid.selectionMode == "multipleRows")
			{
				return sCellReader;
			}
			else if(cellArr.length > 0)
			{
				var colIndex: int = int(cellArr[0]["columnIndex"]);
				var rowIndex: int = int(cellArr[0]["rowIndex"]);
 
				var itemRenderer:* = grid.getCellItemAt(rowIndex, colIndex); //// command line 1
 
				if (itemRenderer != null)
					sCellReader = itemRenderer.getAccessibilityFullInfor();
			}
			return sCellReader;
		}
		
		/****************************************************************
		 * read header GridOne
		 * **************************************************************/
		public static function readHeaderGridOne(grid: ExAdvancedDataGrid, sHeaderReader: String) : String
		{
			var headerInfo:ExAdvancedDataGridHeaderInfo = grid.selectedHeaderInfo;
			var headerRenderer: Object = headerInfo.headerItem;
			
			if (headerRenderer && !(headerRenderer is ExAdvancedDataGridHeaderRenderer))
				sHeaderReader = headerRenderer.getAccessibilityName(sHeaderReader);
			
			return sHeaderReader;
		}
	}	
}