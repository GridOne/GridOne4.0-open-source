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

package kr.co.actsone.common
{
	import com.brokenfunction.json.encodeJson;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.formats.Float;
	
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.controls.ExAdvancedDataGridBaseEx;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumnGroup;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridHeaderRenderer;
	import kr.co.actsone.events.ExAdvancedDataGridEventReason;
	import kr.co.actsone.events.SAEvent;
	import kr.co.actsone.export.ExcelExportInfo;
	import kr.co.actsone.export.ExcelFileType;
	import kr.co.actsone.export.StyleFooter;
	import kr.co.actsone.export.StyleHeader;
	import kr.co.actsone.filters.FilterDataWithRowHide;
	import kr.co.actsone.importcsv.FileManager;
	import kr.co.actsone.summarybar.SummaryBar;
	import kr.co.actsone.summarybar.SummaryBarConstant;
	import kr.co.actsone.summarybar.SummaryBarManager;
	import kr.co.actsone.utils.ConvertProperty;
	import kr.co.actsone.utils.ErrorMessages;
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.INavigatorContent;
	import mx.events.CloseEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.utils.UIDUtil;
	
	public class GridOneImpl
	{
		protected var gridone:GridOne;
		public var tempCols:ArrayCollection=new ArrayCollection;
		private var err:ErrorMessages=new ErrorMessages();
		public var isDrawUpdate:Boolean=true;
		public var _columnCount:int=0;
		public var waitingLogo:Image=new Image();
		public var sumManager:SummaryBarManager;
		public var rowStatus:RowStatus =new RowStatus(); 
		public var currentpage:int=0;
		public var pageNum:int=1;
		
	    public var excelFileName:String="datagrid";
		 						
		public function GridOneImpl(app:Object)
		{
			gridone=app as GridOne;
		}

		public function get datagrid():ExAdvancedDataGrid
		{
			return gridone.datagrid;
		}							
		
		public function get dgManager():DataGridManager
		{
			return gridone.dgManager;
		}	
		
		public function get gridoneManager():GridOneManager
		{
			return gridone.gridoneManager;
		}	
		
		 
		/*************************************************************
		 * add header for grid
		 * @param columnKey column dataField 
		 * @param columnText header text
		 * @param columnType column type: combo, text, calendar...
		 * @param maxLength length of text in a cell, or length of a number
		 * @param columnWidth column width
		 * @param editable indicate whether column is editable or not
		 * @return ExAdvancedDataGridColumn
		 * ***********************************************************/
		public function createHeader(columnKey:String="", columnText:String="", columnType:String="", maxLength:String="", columnwidth:String="", editable:Boolean=true,property:String=""):ExAdvancedDataGridColumn
		{
			var col:ExAdvancedDataGridColumn=new ExAdvancedDataGridColumn();
			col.minWidth=0;
			col.dataField=columnKey;
			col.headerText=columnText;				
			col.editable = editable;
			if (editable)
				col.cellActivation=Global.ACTIVATE_EDIT;
			else
				col.cellActivation=Global.ACTIVATE_ONLY;
						
			if (columnwidth.charAt(columnwidth.length - 1) == "%")
			{
				col.percentWidth=columnwidth;
			}
			else
			{
				col.width=parseInt(columnwidth);
			}
			
			datagrid.totalVisibleColumnWidth += parseInt(columnwidth);
			
			col.orginalMaxLength=maxLength;		
			
			if (Number(maxLength) < 0 ) //Process for using big number
			{
				if(columnType.toUpperCase() == ColumnType.NUMBER)
				{
					var arr:Array = maxLength.toString().split(".");
					var precLength: int = -1;
					if (arr.length > 1)
						precLength = parseInt(arr[1]);
					col.precision = precLength;
					col.checkPrecision = precLength;
					col.maxValue = Number.MAX_VALUE;	
				}
			}
			else if (parseInt(maxLength) >= 0)
			{
				if(columnType.toUpperCase() == ColumnType.NUMBER)
				{
					var precisionLength:int=parseInt(maxLength.toString().split(".")[1]);
					var numberLength:int=parseInt(maxLength.toString().split(".")[0]);
					if(numberLength==0)
					col.maxValue = Math.pow(10, numberLength) - Math.pow(0.1, precisionLength+1);
					col.precision = precisionLength;
					col.checkPrecision=precisionLength;
				}
				else
				{
					col.maxLength=parseInt(maxLength);
					col.editorMaxChars=parseInt(maxLength);	
				}
			}
			
			if (property !="")
			{
			    var params:Object= new Object();
			    params.textAlign=property;
			}
			
			if (params !=null)
			{
				var objectInfo:Object=ObjectUtil.getClassInfo(params);
				for each (var qname:QName in objectInfo.properties)
				{
					var propertyName:String=qname.localName;
					var propertyValue:String=params[qname.localName];
					if (col.hasOwnProperty(propertyName))
						this.dgManager.setColumnProperty(col, propertyName, propertyValue);
					else
						this.dgManager.setStyleForObject(col, propertyName, propertyValue);
				}
			}
			
			col.type=columnType.toUpperCase();
		 	dgManager.setItemRenderer(col,col.type,false);	
			
			tempCols.addItem(col);
			_columnCount += 1;
 
			return col;						
		}
		
		/*************************************************************
		 * Bound header after adding headers
		 * ***********************************************************/
		public function boundHeader():void
		{			
			for (var i:int=0; i< tempCols.length; i++)
			{
				if(tempCols[i] is ExAdvancedDataGridColumnGroup && (tempCols[i] as ExAdvancedDataGridColumnGroup).isGroup)
				{
					this.datagrid._isGroupedColumn = true;
					break;
				}
			}
			if(this.datagrid._isGroupedColumn)
			{
				this.datagrid.groupedColumns = tempCols.toArray();
				var cols:Array = new Array(); 
				cols = convertGroupColumn(tempCols.toArray() , cols)
				this.datagrid.columns = cols;
				this.dgManager.setColumnDataFieldIndex(cols);
			}
			else
			{
				this.datagrid.columns = tempCols.toArray();
				this.dgManager.setColumnDataFieldIndex(tempCols.toArray());
			}			
			this.datagrid.visible=true;
			datagrid.selectedIndex=0;
			setTimeout(dispatchBoundHeaderEvent,200);
			
			//verify which horizontal scroll bar and vertical scroll bar is used
			dgManager.updateExternalScrollBar();
		}

		/*************************************************************
		 * dispatch bound header complete
		 * ***********************************************************/
		private function dispatchBoundHeaderEvent():void
		{
			//update Application height when data is changed
			gridoneManager.updateGridHeight();
			
			this.datagrid.dispatchEvent(new SAEvent(SAEvent.BOUND_HEADER_COMPLETE));
		}
		
		/*************************************************************
		 * set property or style for datagrid
		 * ***********************************************************/
		public function setDataGridProperty(name:String, value:Object):void
		{
			if (ConvertProperty.proObj.hasOwnProperty(name))
			{
				name = ConvertProperty.proObj[name];
			}
			if (this.datagrid.hasOwnProperty(name) && ConvertProperty.headerStyleObj[name] == null)
				this.dgManager.setDataGridProperty(name, value);
			else
				this.dgManager.setStyleForObject(this.datagrid, name, value);
		}
		
		/*************************************************************
		 * set column property
		 * author: Toan Nguyen
		 * ***********************************************************/
		public function setColumnProperty(dataField:String, name:String, value:Object):void
		{
			try
			{
				var selectedCol:Object;
				selectedCol = this.dgManager.getColumnByDataField(dataField);
				if(selectedCol==null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (selectedCol.hasOwnProperty(name))
					this.dgManager.setColumnProperty(selectedCol, name, value);
				else
					this.dgManager.setStyleForObject(selectedCol, name, value);
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColumnProperty");
			}
		}
		
		/*************************************************************
		 * get value of property of specified column.
		 * @param colField it can be a string object for DataField column or integer object for index column.
		 * @param property name of property.
		 * @return value of property as a object
		 * @author Duong Pham
		 * ***********************************************************/
		public function getColumnProperty(colField:Object, property:String):Object
		{
			var selectedCol:Object;
			if (colField is int)
			{
				selectedCol=this.datagrid.columns[colField];
			}
			else if (colField is String)
			{
				selectedCol = dgManager.getColumnByDataField(colField.toString());
			}
			if (selectedCol != null)
			{
				if (selectedCol.hasOwnProperty(property))
					return selectedCol[property];
				else
					return selectedCol.getStyle(property);
			}
			return null;
		}
		
		/*************************************************************
		 * set column header checkbox visible
		 * author: Duong Pham
		 * ***********************************************************/
		public function setColHDCheckBoxVisible(strColKey:String, bVisible:Boolean, bChangeCellEvent:Boolean=false):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(strColKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (bVisible)
				{
					this.dgManager.setItemRenderer(col, ColumnType.CHECKBOX, true);
				}
				else
				{
					col.headerRenderer=new ClassFactory(ExAdvancedDataGridHeaderRenderer);
					col.isCheckBoxHeaderRenderer=false;
				}
				col.bChangeCellEvent=bChangeCellEvent;
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColHDCheckBoxVisible");
			}
		}
		
		/*************************************************************
		 * add group column for grid		 
		 * ***********************************************************/
		public function createGroup(groupKey:String, groupName:String):ExAdvancedDataGridColumnGroup
		{
			var col:ExAdvancedDataGridColumnGroup=new ExAdvancedDataGridColumnGroup();			
			col._dataFieldGroupCol=groupKey;
			col.headerText=groupName;
			col.isGroup=true;
			this.tempCols.addItem(col);
			return col;
		}
	
		/*************************************************************
		 * append header into group column		 
		 * ***********************************************************/
		public function appendHeader(groupKey:String, columnKey:String):void
		{
			try
			{
				var groupObj:Object=getTempCol(groupKey);				
				if (groupObj == null)				
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(groupObj.addedColumn is ExAdvancedDataGridColumnGroup && (groupObj.addedColumn as ExAdvancedDataGridColumnGroup).isGroup)
				{
					var colObj:Object=getTempCol(columnKey);
					if (colObj == null)
						err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
					if(colObj.addedColumn is ExAdvancedDataGridColumn)
					{
						(colObj.addedColumn as ExAdvancedDataGridColumn).parent=groupKey;						
						(groupObj.addedColumn as ExAdvancedDataGridColumnGroup).children.push(colObj.addedColumn as ExAdvancedDataGridColumn);
					}
					else if(colObj.addedColumn is ExAdvancedDataGridColumnGroup)
					{
						(colObj.addedColumn as ExAdvancedDataGridColumnGroup).parent = groupKey;
						(groupObj.addedColumn as ExAdvancedDataGridColumnGroup).children.push(colObj.addedColumn as ExAdvancedDataGridColumnGroup);
					}
				}
				if(groupObj.index > colObj.index)
				{
					tempCols.removeItemAt(groupObj.index);
					tempCols.removeItemAt(colObj.index);
					tempCols.addItemAt(groupObj.addedColumn,colObj.index);
				}
				else
				{
					tempCols.removeItemAt(colObj.index);					
				}
				
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"appendHeader");
			}
		}
		
		/*************************************************************
		 * get column from tempCol	 
		 * ***********************************************************/
		private function getTempCol(dataField:String):Object
		{			
			var result:Object = null;
			var index:int = -1;
			for each (var col:Object in tempCols)
			{
				index++;
				if(col is ExAdvancedDataGridColumnGroup)
				{
					if ((col as ExAdvancedDataGridColumnGroup)._dataFieldGroupCol == dataField)
					{
						result = new Object();
						result["addedColumn"] = col;
						result["index"] = index;
						break;
					}
				}
				else if(col is ExAdvancedDataGridColumn)
				{
					if (col.dataField == dataField)
					{
						result = new Object();
						result["addedColumn"] = col;
						result["index"] = index;
						break;
					}
				}					
			}
			return result;
		}
		
		/*************************************************************
		 * get column from tempCol	 
		 * ***********************************************************/
		public function convertGroupColumn(groupCol:Array , result:Array):Array
		{
			for each (var item:Object in groupCol)
			{				
				if(item is ExAdvancedDataGridColumnGroup && (item as ExAdvancedDataGridColumnGroup).children.length > 0)
				{
					convertGroupColumn((item as ExAdvancedDataGridColumnGroup).children , result);
				}
				else
					result.push(item);
			}
			return result;
		}
				
		/*************************************************************
		 * set text for group header		 
		 * ***********************************************************/
		public function setGroupHDText(strGroupKey:String, strText:String):void
		{
			try
			{				
				var groupCol:ExAdvancedDataGridColumnGroup= this.dgManager.getColumnByDataField(strGroupKey,true) as ExAdvancedDataGridColumnGroup;;
				if (groupCol == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				groupCol.headerText=strText;
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setGroupHDText");
			}
		}
		
		/*************************************************************
		 * Get group header text
		 * ***********************************************************/		
		public function getGroupHDText(strGroupKey:String):String
		{
			try
			{
				var result:String = "";
				var groupCol:ExAdvancedDataGridColumnGroup = dgManager.getColumnByDataField(strGroupKey,true) as ExAdvancedDataGridColumnGroup;
				if (groupCol == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				result = groupCol.headerText;				
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getGroupHDText");
			}
			return result;
		}
		
		/*************************************************************
		 * set Column header align
		 * ***********************************************************/	
		public function setColHDAlign(strColumnKey:String, strAlign:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.setColumnProperty(strColumnKey, "headerTextAlign", strAlign);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColHDAlign");
			}
		}
		
		/*************************************************************
		 * Get the column width
		 * @param columnKey dataField of column
		 * @author Thuan 
		 * @modified by Duong Pham
		 * ***********************************************************/			
		public function getColWidth(columnKey:String):Number
		{
			var colWidth:Number;
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				colWidth = Math.ceil(col.width as Number);
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getColWidth");
			}
			return colWidth;
		}
		
		/*************************************************************
		 * Set the col fix: Keep column(s) is visible while using horizontal scrolls
		 * @param columnKey The name of dataField column
		 * @author Thuan 
		 * @modified by Duong Pham
		 * ***********************************************************/		
		public function setColFix(columnKey:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = ExAdvancedDataGridColumn(this.dgManager.getColumnByDataField(columnKey));
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				
				var index:int=-1;
				var listParentKey:String = "";
				var arrParent:Array; 
				var parentCol:ExAdvancedDataGridColumnGroup;
				var childColumn:ExAdvancedDataGridColumn;
				var lockColumnIndex:int=0;
				if(this.datagrid._isGroupedColumn)
				{
					if(col.parent == "" || col.parent == null)
					{
						for (index=0 ; index<this.datagrid.groupedColumns.length; index++)
						{
							if(this.datagrid.groupedColumns[index] is ExAdvancedDataGridColumn && (this.datagrid.groupedColumns[index] as ExAdvancedDataGridColumn).dataField == columnKey)
								break;
						}
						lockColumnIndex = index + 1;
						this.setDataGridProperty("lockedColumnCount", lockColumnIndex);
						return;
					}
					else if(col.parent != null && col.parent != "")
					{
						listParentKey += col.parent + "%%";
						listParentKey = getListParentKey(ExAdvancedDataGridColumn(col).parent,listParentKey);
						if(listParentKey != "")
						{
							listParentKey = listParentKey.slice(0,listParentKey.length-2);
							arrParent = listParentKey.split("%%");
							parentCol = dgManager.getColumnByDataField(arrParent[arrParent.length-1]) as ExAdvancedDataGridColumnGroup;
						}
					}
					else		 
					{
						
						if(ExAdvancedDataGridColumnGroup(col).parent != "")
						{
							listParentKey = ExAdvancedDataGridColumnGroup(col).parent + "%%" ;
							listParentKey = getListParentKey(ExAdvancedDataGridColumnGroup(col).parent,listParentKey);
						}
						if(listParentKey != "")
						{
							listParentKey = listParentKey.slice(0,listParentKey.length-2);
							arrParent = listParentKey.split("%%");
							parentCol = dgManager.getColumnByDataField(arrParent[arrParent.length-1]) as ExAdvancedDataGridColumnGroup;						
						}
					}
					for (var i:int=0 ; i<this.datagrid.groupedColumns.length; i++)
					{
						var tmpCol:Object = this.datagrid.groupedColumns[i];
						if(tmpCol.visible)
							index ++;
						if((tmpCol is ExAdvancedDataGridColumnGroup) && ExAdvancedDataGridColumnGroup(tmpCol).isGroup == true
							&& parentCol && ExAdvancedDataGridColumnGroup(tmpCol)._dataFieldGroupCol == parentCol._dataFieldGroupCol)
							break;
					}
					lockColumnIndex = index + 1;
				}
				else
				{
					var cols:Array;
					if(tempCols.length > 0)
						cols = tempCols.toArray();
					else if(this.datagrid.columns.length > 0)
						cols = this.datagrid.columns;
					for each (var column:ExAdvancedDataGridColumn in cols)
					{
						if(column.visible)
						{
							index ++;
							if(column.dataField == columnKey)
								break;
						}
					}			
					lockColumnIndex = index + 1;
				}	
				this.setDataGridProperty("lockedColumnCount", lockColumnIndex);
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColFix");
			}
		}		
		
		/*************************************************************
		 * Reset the col fix: column unfix
		 * @param strColumnKey The name of dataField column
		 * @author Thuan 
		 * ***********************************************************/		
		public function resetColFix():void
		{
			try
			{
				this.setDataGridProperty("lockedColumnCount", 0);
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"resetColFix");
			}
		}
		
		/*************************************************************
		 * Set the row fix: Keep row(s) is visible while using vertical scrolls
		 * @param strColumnKey The name of dataField column
		 * @author Thuan
		 * ***********************************************************/		
		public function setRowFix(rowIndex:int):void
		{ 					
			//Associated with this.setDataGridProperty("lockedRowCount", rowIndex);
			try
			{
				if(rowIndex > this.datagrid.rowCount ||  rowIndex < 1)
				{
					err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				}
				this.datagrid.lockedRowCount = rowIndex;
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setRowFix");
			}
		}	
		
		/*************************************************************
		 * Set the row fix: Row unfix
		 * @param strColumnKey The name of dataField column
		 * @author Thuan
		 * ***********************************************************/		
		public function resetRowFix():void
		{					
			//Associated with this.setDataGridProperty("lockedRowCount", 0);
			try
			{
				this.datagrid.lockedRowCount = 0;
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"resetRowFix");
			}
		}	
		
		/*************************************************************
		 * getColCount: The number of columns to be displayed in a TileList control 
		 * 				or items in a HorizontalList control. For the data grids, 
		 * 				specifies the number of visible columns. 
		 * @author Thuan
		 * ***********************************************************/		
		public function getColCount():int
		{
			var colCount:int = 0;
			try
			{
				if(this.datagrid.columns && this.datagrid.columns.length > 0)
					colCount = this.datagrid.columnCount;
				else
					colCount = _columnCount;
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getColCount");
			}
			return colCount;
		}	
		
		/*************************************************************
		 * setColCellAlign: Set alignment of a column text
		 * @param columnKey The name of dataField column
		 * @param strAlign Left/Center/Right/Justify
		 * @author Thuan
		 * ***********************************************************/				
		public function setColCellAlign(columnKey:String, strAlign:String):void
		{
			try
			{	
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				col.public::setStyle("textAlign", strAlign);
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColCellAlign");
			}					
		}		
 
		/*************************************************************
		 * setColCellBgColor: Set background color to column
		 * @param columnKey The name of dataField column
		 * @author Thuan
		 * ***********************************************************/			
		public function setColCellBgColor(columnKey:String, color:String):void
		{
			try
			{					
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				col.public::setStyle("backgroundColor", color);
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColCellBgColor");
			}
		}		
		
		/*************************************************************
		 * setColCellFgColor: Set foreground color to column
		 * @param columnKey The name of dataField column
		 * @author Thuan
		 * ***********************************************************/			
		public function setColCellFgColor(columnKey:String, color:String):void
		{
			try
			{					
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				col.public::setStyle("color", color);
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColCellFgColor");
			}
		}	
		
		/*************************************************************
		 * set column cell font
		 * @param columnKey The name of dataField column
		 * @param fontName Font nam
		 * @param bBold Whether font bold
		 * @param bItalic Whether font italic
		 * @param bUnderLine Whether font underline
		 * @param bCenterLine Whether font strikethrough
		 * @param nSize Font size
		 * @author Thuan
		 * ***********************************************************/
		public function setColCellFont(columnKey:String, fontName:String, nSize:Number, bBold:Boolean, bItalic:Boolean, bUnderLine:Boolean, bCenterLine:Boolean):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn= dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				col.public::setStyle("fontFamily", fontName);
				if (!isNaN(nSize))
				{
					col.public::setStyle("fontSize",nSize);
				}
				if(bBold)
				{
					col.public::setStyle("fontWeight","bold");
				}
				else
				{
					col.public::setStyle("fontWeight","normal");
				}
				if(bItalic)
				{
					col.public::setStyle("fontStyle","italic");
				}
				else
				{
					col.public::setStyle("fontStyle","normal");
				}
				if(bUnderLine)
				{
					col.public::setStyle("textDecoration","underline");
				}
				else
				{
					col.public::setStyle("textDecoration","none");
				}
				col.bCellFontCLine=bCenterLine;
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColCellFont");					
			}
		}		
		
		/*************************************************************
		 * set column cell font bold
		 * @param columnKey Name of datafield
		 * @param bBold Whether font is bold
		 * @author Thuan
		 * ***********************************************************/
		public function setColCellFontBold(columnKey:String, bBold:Boolean):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				col.public::setStyle("fontWeight",bBold?"bold":"normal");
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColCellFontBold");					
			}
		}		
		
		/*************************************************************
		 * set column cell font italic
		 * @param columnKey Name of datafield
		 * @param bItalic Whether font is italic
		 * @author Thuan
		 * ***********************************************************/
		public function setColCellFontItalic(columnKey:String, bItalic:Boolean):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				col.public::setStyle("fontStyle",bItalic?"italic":"normal");
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColCellFontItalic");	
			}
		}		
		
		/*************************************************************
		 * set column cell font name
		 * @param columnKey Name of datafield
		 * @param fontName Font name in column
		 * @author Thuan
		 * ***********************************************************/
		public function setColCellFontName(columnKey:String, fontName:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				if (fontName != null && fontName != "")
				{
					col.public::setStyle("fontFamily",fontName);
				}
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColCellFontName");	
			}
		}	
		
		/*************************************************************
		 * set column cell font size
		 * @param columnKey Name of datafield
		 * @param nSize Font size in column
		 * @author Thuan
		 * ***********************************************************/
		public function setColCellFontSize(columnKey:String, nSize:Number):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if(col == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				if (isNaN(nSize))
				{
					err.throwError(ErrorMessages.ERROR_NUMBER, Global.DEFAULT_LANG);
				}
				col.public::setStyle("fontSize",nSize);
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColCellFontSize");	
			}
		}		
		
		/*************************************************************
		 * set column cell font underline
		 * @param columnKey Name of datafield
		 * @param bUnderLine Whether font is underline
		 * @author Thuan
		 * ***********************************************************/
		public function setColCellFontULine(columnKey:String, bUnderLine:Boolean):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				col.public::setStyle("textDecoration",bUnderLine?"underline":"none");
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message, "setColCellFontULine");	
			}
		}
		
		/*************************************************************
		 * set column cell font center line
		 * @param columnKey Name of datafield
		 * @param bCenterLine Whether font is center line
		 * @author Duong Pham
		 * ***********************************************************/
		public function setColCellFontCLine(columnKey:String, bCenterLine:Boolean):void
		{
			try
			{
				if (this.datagrid.dataFieldIndex[columnKey] == null)					
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);									
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				col.bCellFontCLine = bCenterLine;
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColCellFontCLine");	
			}
		}
		
		/*************************************************************
		 * set column cell merge
		 * @param columnKey Name of datafield
		 * @param bMerge Whether font is merge
		 * @author Duong Pham
		 * ***********************************************************/
		public function setColCellMerge(columnKey:String, bMerge:Boolean):void
		{
			try
			{
				if (this.datagrid.dataFieldIndex[columnKey] == null)					
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);									
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				col.merge = bMerge;
				this.datagrid.getGroupMergeInfo();
				if(this.datagrid.draggableColumns)
					this.datagrid.draggableColumns = !bMerge;
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColCellMerge");	
			}
		}
		
		/*************************************************************
		 * get column header key
		 * ***********************************************************/
		public function getColHDKey(nColunmIndex:int):String
		{
			try
			{
				var result:String = "";
				if(nColunmIndex < 0  || nColunmIndex >= this.datagrid.columns.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				for (var dataField:String in this.datagrid.defaultDataFieldIndex)
				{
					if (this.datagrid.defaultDataFieldIndex[dataField] == nColunmIndex)
					{
						result = dataField;
						break;
					}
				}					
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getColHDKey");
			}
			return result;
		}
		
		/*************************************************************
		 * get column header visible index
		 * ***********************************************************/
		public function getColHDVisibleIndex(strColumnKey:String):int
		{
			try
			{
				var result:int = -1;
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				result = this.getColumnIndex(strColumnKey);				
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getColHDVisibleIndex");
			}
			return result;
			
		}
		
		/*************************************************************
		 * get column header visible key
		 * ***********************************************************/
		public function getColHDVisibleKey(index:int):String
		{
			try
			{
				var result:String = "";
				var col:ExAdvancedDataGridColumn = this.datagrid.columns[index];
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				result = col.dataField;			
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getColHDVisibleKey");
			}
			return result;			
		}
		
		/*************************************************************
		 * get column index
		 * ***********************************************************/
		public function getColumnIndex(dataField:String):int
		{
			if (this.datagrid.dataFieldIndex.hasOwnProperty(dataField))
				return this.datagrid.dataFieldIndex[dataField];
			return -1;
		}
		
		/*************************************************************
		 * get column header text
		 * @param strColumnKey string of data filed 
		 * ***********************************************************/
		public function getColHDText(strColumnKey:String):String
		{
			try
			{
				var result:String = "";
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				result = col.headerText;
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getColHDText");
			}
			return result;
		}
		
		/*************************************************************
		 * set column header text
		 * @param strColumnKey string of data filed 
		 * @param strText string of text
		 * ***********************************************************/
		public function setColHDText(strColumnKey:String, strText:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				col.headerText = strText;
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColHDText");
			}			
		}
		
		/*************************************************************
		 * Get column header index
		 * @param columnKey:String	 
		 * ***********************************************************/
		public function getColHDIndex(columnKey:String):int
		{
			try
			{
				var result:int = -1;
				var col:ExAdvancedDataGridColumn= dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				result = this.datagrid.defaultDataFieldIndex[columnKey];
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getColHDIndex");					
			}
			return result;
		}
		
		/*************************************************************
		 * Get column header background color
		 * @param columnKey:String
		 * ***********************************************************/
		public function setColHDBgColor(columnKey:String, strColor:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				col.public::setStyle("headerBackgroundColor", strColor);
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColHDBgColor");
			}
		}
		
		/*************************************************************
		 * set color of column header
		 * @param columnKey:String 
		 * @param color:String
		 * ***********************************************************/
		public function setColHDFgColor(columnKey:String, color:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				col.public::setStyle("headerColor", color);
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColHDFgColor");
			}
		}
		
		/*************************************************************
		 * set group header font color and background color
		 * @param columnKey:String ,strFgColor:String,strBgColor:String
		 * author: Duong Pham
		 * ***********************************************************/
		public function setGroupHDColor(strGroupKey:String, strFgColor:String, strBgColor:String):void
		{
			try
			{
				var groupCol:ExAdvancedDataGridColumnGroup=this.dgManager.getColumnByDataField(strGroupKey,true) as ExAdvancedDataGridColumnGroup;
				if (groupCol == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (groupCol.isGroup)
				{
					var strColor:String="";
					
					if (strFgColor != null && strFgColor != "")
					{
						if (strFgColor.search("#") == 0)
							strColor=strFgColor.toString().replace("#", "0x");
						else
							strColor=strFgColor;
						groupCol.public::setStyle("headerColor", strFgColor);
					}
					if (strBgColor != null && strBgColor != "")
					{
						if (strBgColor.search("#") == 0)
							strColor=strBgColor.toString().replace("#", "0x");
						else
							strColor=strBgColor;
						groupCol.public::setStyle("headerBackgroundColor", strBgColor);
					}
					this.datagrid.invalidateList();
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setGroupHDColor");					
			}
		}
		
		/*************************************************************
		 * set group header font		  
		 * ***********************************************************/
		public function setGroupHDFont(strGroupKey:String, strFontName:String, nSize:Number, bBold:Boolean, bItalic:Boolean, bUnderLine:Boolean, bCenterLine:Boolean):void
		{
			try
			{
				var groupCol:ExAdvancedDataGridColumnGroup = this.dgManager.getColumnByDataField(strGroupKey,true) as ExAdvancedDataGridColumnGroup;
				if (groupCol == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (isNaN(nSize))
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				if (strFontName != "" && strFontName != null)
				{
					groupCol.public::setStyle("fontFamily", strFontName);
				}
				groupCol.public::setStyle("fontSize", nSize);
				if (bBold)
				{
					groupCol.public::setStyle("fontWeight", "bold");
				}
				else
				{
					groupCol.public::setStyle("fontWeight", "normal");
				}
				if (bItalic)
				{
					groupCol.public::setStyle("fontStyle", "italic");
				}
				else
				{
					groupCol.public::setStyle("fontStyle", "normal");
				}
				if (bUnderLine)
				{
					groupCol.public::setStyle("textDecoration", "underline");
				}
				else
				{
					groupCol.public::setStyle("textDecoration", "none");
				}
				datagrid.bHDFontCLine=bCenterLine;
				groupCol.bHDFontCLine=bCenterLine;					
				this.datagrid.invalidateList();				
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setGroupHDFont");					
			}
		}
		
		/*************************************************************
		 * set tree mode	  
		 * ***********************************************************/
		public function setTreeMode(strTreeColumnKey:String, strRootKey:String, strDelimiter:String):void
		{
			try
			{
				this.datagrid.summaryBarManager.clearSort();
				if(this.datagrid.dataFieldIndex[strTreeColumnKey] == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.treeInfo=[strRootKey,strDelimiter];
				var currentCols:Array;				
				if(this.datagrid.columns.length > 0)
					currentCols = this.datagrid.columns;
				else
					currentCols = this.tempCols.toArray();
				var itemCol:Object;
				for each(itemCol in currentCols)
				{
					if(itemCol is ExAdvancedDataGridColumn && (itemCol as ExAdvancedDataGridColumn).dataField == strTreeColumnKey)
					{
						(itemCol as ExAdvancedDataGridColumn).type = ColumnType.TREE;
						break;
					}
					if(itemCol is ExAdvancedDataGridColumnGroup)
					{
						var groupCol:ExAdvancedDataGridColumnGroup = itemCol as ExAdvancedDataGridColumnGroup;
						itemCol = dgManager.getChildrenColByGroupCol(strTreeColumnKey, groupCol);	
						if(itemCol)
							break;
					}
				}
				datagrid.isTree=true;
				datagrid.treeDataField=strTreeColumnKey;	
				datagrid.treeColumn = itemCol as ExAdvancedDataGridColumn;				
				this.dgManager.setItemRenderer(itemCol as ExAdvancedDataGridColumn, ColumnType.TREE,false);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setTreeMode");					
			}
		}
		
		/*************************************************************
		 * add a object or text row.
		 * @param object will be added.
		 * ***********************************************************/
		public function addRow(row:Object=null):void
		{
			
		  if (this.datagrid.dataProvider as ArrayCollection)
		  {
			  if(datagrid.summaryBarManager && datagrid.summaryBarManager.hasSummaryBar())
			  {
				  this.datagrid.summaryBarManager.clearSort();
				  datagrid.summaryBarManager.resetSummaryBar();
			  }
			  if(this.datagrid.columns==null || this.datagrid.columns.length==0)
				  return;
			  if (row == null)
			  {
				  row = this.gridone.gridoneManager.createEmptyRow();		
			  } 
			  else
			  {
				  row[Global.ACTSONE_INTERNAL]= UIDUtil.createUID(); //Update for SetActivation: disable Cell
			  }
			  setCRUDRowValue(row, this.datagrid.strInsertRowText, Global.CRUD_INSERT);
			  if (datagrid.dataProvider == null)
				  datagrid.dataProvider=new ArrayCollection([]);			
			  
			  if (datagrid._bkDP == null)
				  datagrid._bkDP=new ArrayCollection([]);
			  
			  datagrid.dataProvider.addItem(row);
			  datagrid._bkDP.addItem(row);
			  var index:int=(datagrid.dataProvider as ArrayCollection).getItemIndex(row);
			  rowStatus._arrRAdd.push(index);
			   
		  }
 
			this.datagrid.selectedItem=row;
			
			//update Application height when data is changed
			gridoneManager.updateGridHeight();
			
			if(this.datagrid.bExternalScroll)
			{
				gridoneManager.updateExternalVerticalScroll(this.datagrid.getLength());
			}
			if (this.datagrid.dataProvider.length > this.datagrid.rowCount)
			{
				this.gridone.vScroll.scrollPosition=this.datagrid.maxVerticalScrollPosition=this.datagrid.maxVerticalScrollPosition + 1;
				this.datagrid.verticalScrollPosition=this.datagrid.maxVerticalScrollPosition;
			}
			else
			{
				this.gridone.vScroll.maxScrollPosition=this.datagrid.maxVerticalScrollPosition=0;
			}
			
			if(this.datagrid.summaryBarManager.hasSummaryBar() && datagrid.rowCount >0)
			{
				this.datagrid.summaryBarManager.reCreateSummaryBar(true);
				this.datagrid.summaryBarManager.clearSort();
			}
				
			//update group mergeCells of datagrid
			if(hasGroupMerge())
			{
				this.datagrid.getGroupMergeInfo();
			}
			
			if(isDrawUpdate)
				this.datagrid.invalidateList();
			
		}
				
		/*************************************************************
		 * add a object or text row at an index.
		 * @param row object or text row will be added.
		 * @param index index of row will be added.
		 * ***********************************************************/
		public function addRowAt(row:Object, index:int):void
		{
			if(datagrid.summaryBarManager && datagrid.summaryBarManager.hasSummaryBar())
			{
				datagrid.summaryBarManager.resetSummaryBar();
			}
			
			this.datagrid.setStyle("verticalGridLines", true);	
			this.datagrid.summaryBarManager.clearSort();
			if (row == null)
			{
				row=this.gridone.gridoneManager.createEmptyRow();				
			}
			setCRUDRowValue(row, this.datagrid.strInsertRowText , Global.CRUD_INSERT);
			if (datagrid.dataProvider == null)
				datagrid.dataProvider=new ArrayCollection([]);
			
			if (datagrid._bkDP == null)
				datagrid._bkDP=new ArrayCollection([]);
			
			if (index < 0)
				index=0;
			else if (index >= datagrid._bkDP.length)
				index=datagrid._bkDP.length;
			var insertedIndex:int;	
			if(index==datagrid._bkDP.length)
				insertedIndex = this.datagrid.getLength();
			else				
				insertedIndex= index;				
			
			datagrid.dataProvider.addItemAt(row, insertedIndex);
			datagrid._bkDP.addItemAt(row,index);
			rowStatus._arrRAdd.push(index);
			//update Application height when data is changed
			gridoneManager.updateGridHeight();
			if(this.datagrid.bExternalScroll)
			{
				gridoneManager.updateExternalVerticalScroll(this.datagrid.getLength());
			}
			
			this.scrollToIndex(index); 
			
			if(this.datagrid.summaryBarManager.hasSummaryBar() && datagrid.rowCount >0)
			{
				this.datagrid.summaryBarManager.reCreateSummaryBar(true);
			}
			//update group mergeCells of datagrid
			if(hasGroupMerge())
			{
				this.datagrid.getGroupMergeInfo();
			}
			if(isDrawUpdate)
				this.datagrid.invalidateList();
		
		}
		
		/*************************************************************
		 * set focus and scroll to a row.
		 * @param row row index of the cell.
		 * ***********************************************************/
		public function scrollToIndex(rowIndex:int):void
		{
			if (datagrid.dataProvider == null)
				return;
			
			if (datagrid._bkDP == null)
				datagrid._bkDP=new ArrayCollection([]);
			
			if (rowIndex < 0)
				rowIndex=0;
			if (rowIndex >= datagrid._bkDP.length)
				rowIndex=datagrid._bkDP.length - 1;
			var activeItem:Object=this.datagrid.getBackupItem(rowIndex);
			rowIndex=this.datagrid.getItemIndex(activeItem);	
			
			if(!this.datagrid.selectCell)
			{						
				datagrid.selectedIndex=rowIndex;		//select row						
			}			
			if(this.datagrid.dataProvider.length>this.datagrid.rowCount)
			{					
				this.datagrid.maxVerticalScrollPosition=this.datagrid.dataProvider.length-this.datagrid.rowCount+1;	
			}
			if (rowIndex > this.datagrid.rowCount - 2)
			{
				var index:int = rowIndex - datagrid.rowCount + 3;
				if(index >=this.datagrid.maxVerticalScrollPosition)
					gridone.vScroll.scrollPosition=this.datagrid.verticalScrollPosition=this.datagrid.maxVerticalScrollPosition;
				else
					gridone.vScroll.scrollPosition=this.datagrid.verticalScrollPosition=index;
			}
			else
				gridone.vScroll.scrollPosition=this.datagrid.verticalScrollPosition=0;
			
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_ROW_ACTIVATE))
			{
				setTimeout(dispatchRowActivateEvent, 100, rowIndex);
			}
		}
		
		/*************************************************************
		 * dispatch row active event
		 * ***********************************************************/
		private function dispatchRowActivateEvent(rowIndex:int):void
		{
			var saEvent:SAEvent=new SAEvent(SAEvent.ON_ROW_ACTIVATE, true);
			saEvent.nRow=rowIndex;
			this.datagrid.dispatchEvent(saEvent);
		}
		
		/*************************************************************
		 * delete a row at an pre-defined index or selected index.
		 * @param index index of row will be deleted. If not declare then current selected index will be used.
		 * ***********************************************************/
		public function deleteRow(index:int=-1):void
		{
			try
			{
				if (!datagrid.isTree)
				{
					if (datagrid.dataProvider == null)
						err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
					if(index >= datagrid._bkDP.length)
					 	err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
					if(index >= datagrid.dataProvider.length)
						return;
					if (index < 0)
					{
						if (datagrid.selectedIndex < 0 || datagrid.selectedIndex >= datagrid.dataProvider.length)
							return;
						index=datagrid.selectedIndex;
					}
					
					if(datagrid.summaryBarManager && datagrid.summaryBarManager.hasSummaryBar())
					{
						datagrid.summaryBarManager.resetSummaryBar();
					}
					
					var item:Object=datagrid.getItemAt(index);
					 
					if(!this.datagrid.bViewDelRowCRUD)
					{
						if(item[this.datagrid.crudColumnKey] == this.datagrid.strInsertRowText)
							datagrid._bkDP.removeItemAt(index);
						else
							setCRUDRowValue(item, this.datagrid.strDeleteRowText , Global.CRUD_DELETE);
					}
					else
					{
						if (setCRUDRowValue(item, this.datagrid.strDeleteRowText , Global.CRUD_DELETE) && item[this.datagrid.crudColumnKey] != this.datagrid.strInsertRowText)
							return;
						 datagrid._bkDP.removeItemAt(index);
					}
					
					var rowStatus:RowStatus=dgManager.getRowKey(item) as RowStatus;
					if (rowStatus != null)
							rowStatus.currentStatus=RowStatus.STATUS_DEL;
					
					if (datagrid.dataProvider as ArrayCollection)
					{
						var removeIndex : int = (datagrid.dataProvider as ArrayCollection).getItemIndex(item);
						(datagrid.dataProvider as ArrayCollection).removeItemAt(removeIndex);
					}
					else
					{
						var removeIndexNode : int = (datagrid.dataProvider as XMLListCollection).getItemIndex(item);
						(datagrid.dataProvider as XMLListCollection).removeItemAt(removeIndexNode);
					}
					
					for each(var col:ExAdvancedDataGridColumn in datagrid.columns)
					{
						if(col.type==ColumnType.CHECKBOX) 
						{
							if(col.arrSelectedCheckbox.getItemIndex(item)!=-1)
								col.arrSelectedCheckbox.removeItemAt(col.arrSelectedCheckbox.getItemIndex(item));
						}
					}
					//update Application height when data is changed
					gridoneManager.updateGridHeight();
					
					//update vertical in case bExternalScroll = false 
					gridoneManager.updateExternalVerticalScroll(this.datagrid.getLength());
					
					if (this.datagrid.dataProvider.length < this.datagrid.rowCount)
					{						
						this.gridone.vScroll.maxScrollPosition=this.datagrid.maxVerticalScrollPosition=0;
					}
					//re-create summary bar.
					if(this.datagrid.summaryBarManager.hasSummaryBar() && datagrid.rowCount >0)
						this.datagrid.summaryBarManager.reCreateSummaryBar(true);	
					//update group mergeCells of datagrid
					if(hasGroupMerge())
						this.datagrid.getGroupMergeInfo();
					//validate grid 
					if(isDrawUpdate)
						this.datagrid.invalidateList();
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"deleteRow");					
			}
import kr.co.actsone.common.Global;

		}
		
		/*************************************************************
		 * get row count
		 * @param isFilter boolean
		 * @return number of row count in datagrid
		 * ***********************************************************/
		public function getRowCount(isFilter:Boolean=false):Number
		{
			var rowCountNum:Number;	
			if(!isFilter)
			{
				if (this.datagrid._bkDP == null)
					rowCountNum=0;
				else
					rowCountNum=this.datagrid._bkDP.length;	
			}
			else
			{
				if(datagrid.dataProvider == null)
					rowCountNum = 0;
				else
					rowCountNum = datagrid.getLength();
			}
			return rowCountNum;
		}
		
		/*************************************************************
		 * set active for row index
		 * ***********************************************************/
		public function setActiveRowIndex(rowIndex:int):void
		{
			if (datagrid.dataProvider == null)
				return;
			
			if (rowIndex < 0)
				rowIndex=0;
			if (rowIndex >= datagrid._bkDP.length)
				rowIndex=datagrid._bkDP.length - 1;
			var activeItem:Object=this.datagrid.getBackupItem(rowIndex);
			if(activeItem==this.datagrid.selectedItem)
				return;
			rowIndex=this.datagrid.getItemIndex(activeItem);
			datagrid.selectedIndex=rowIndex;
			if (rowIndex > this.datagrid.rowCount - 1)
			{
				var index:int = rowIndex - this.datagrid.rowCount + 3;
				if(index > this.datagrid.maxVerticalScrollPosition)
					gridone.vScroll.scrollPosition=this.datagrid.verticalScrollPosition=this.datagrid.maxVerticalScrollPosition
				else
					gridone.vScroll.scrollPosition=this.datagrid.verticalScrollPosition=index;
			}
			else
				gridone.vScroll.scrollPosition=this.datagrid.verticalScrollPosition=0;
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_ROW_ACTIVATE))
			{
				setTimeout(dispatchRowActivateEvent, 1000, rowIndex);
			}
		}
		
		/*************************************************************
		 * get active for row index
		 * ***********************************************************/
		public function getActiveRowIndex():int
		{	
			var rowIndex:int = -1;
			if(!this.datagrid.selectCell)
			{
				rowIndex = this.datagrid.getBackupItemIndex(this.datagrid.selectedItem);
			}			
			return rowIndex;
		}
		
		/*************************************************************
		 * set number format
		 * ***********************************************************/
		public function setNumberFormat(columnKey:String, value:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				//var expression:RegExp=/[^0-9,.#]/g;
				var expression:RegExp=/[#0][#0,.]*[0#]/g;
				var currencyArr:Array=value.split(expression);
				col.strCurrencyBefore=currencyArr[0];
				col.strCurrencyAfter=currencyArr[1];
				var strFormat:Array=value.match(expression);
				var arrPrecision:Array=strFormat[0].split(".");
				col.precision=0;
				if (arrPrecision.length == 2 && arrPrecision[1].toString() != "")
				{
					col.precision=arrPrecision[1].toString().length;
					col.symbolPrecision=arrPrecision[1].toString().charAt(0);
				}
				//updated by Thuan: add conditional col.checkPrecision > -1
				//2013April01
				if (col.precision > col.checkPrecision && col.checkPrecision > -1)  
					col.precision=col.checkPrecision;
				/* var useCurrency:Boolean=false;
				for (var i:int=0; i < value.length; i++)
				{
				if (value.charAt(i) == '$')
				{
				useCurrency=true;
				break;
				}
				}
				col.useCurrency=useCurrency; */
				col.formatString = value;
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setNumberFormat");					
			}
		}
 	
		
		/*************************************************************
		 * set row activation
		 * ***********************************************************/
		public function setRowActivation(nRow:int, strActivation:String):void
		{
			try
			{
				if(nRow < 0 || nRow > this.datagrid.getLength())
					err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				for (var itemKey:String in this.datagrid.dataFieldIndex)
				{
					if (itemKey != null || itemKey != "")
						this.setActivation(itemKey, nRow, strActivation);
				}
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setRowActivation");
			}
		}
		
		/*************************************************************
		 * set activation
		 * ***********************************************************/
		public function setActivation(strColumnKey:String, nRow:int, strActivation:String, isSettingsCell:Boolean = false):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(col.merge)					
					err.throwError(ErrorMessages.ERROR_ACTIVATION_COLKEY_INVALID, Global.DEFAULT_LANG);					
				if (strActivation != Global.ACTIVATE_EDIT && strActivation != Global.ACTIVATE_DISABLE && strActivation != Global.ACTIVATE_ONLY)
					err.throwError(ErrorMessages.ERROR_ACTIVATION_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(strColumnKey,nRow,strActivation,'activation');
				if(isSettingsCell)
					this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				throw new Error(error.message);
			}
		}
		
		/*************************************************************
		 * get activation for specified cell
		 * @param strColumnKey
		 * @param nRow
		 * @author Duong Pham
		 * ***********************************************************/
		public function getCellActivation(strColumnKey:String, nRow:int):String
		{
			try
			{
				var activation:String="";
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(col.merge)					
					err.throwError(ErrorMessages.ERROR_ACTIVATION_COLKEY_INVALID, Global.DEFAULT_LANG);
				var item:Object = this.datagrid.getBackupItem(nRow);
				var uid:String = item[Global.ACTSONE_INTERNAL];
				activation = this.datagrid.getCellProperty('activation',uid,strColumnKey);
				if(activation == null || activation == "")
					activation = col.cellActivation;
			}
			catch(error:Error)
			{
				throw new Error(error.message);
			}
			return activation;
		}
		
		/*************************************************************
		 * set row background color
		 * @param row int
		 * @param color String
		 * ***********************************************************/
		public function setRowBgColor(row:int, color:String):void
		{
			try
			{
				if(row < 0 || row >= this.datagrid.dataProvider.length)
					err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				if (datagrid.dataProvider == null)
					err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				this.datagrid.setRowStyle(row,"backgroundColor",color);
				if (isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setRowBgColor");
			}
		}
		
		/*************************************************************
		 * set row font color
		 * @param row int
		 * @param color String
		 * ***********************************************************/
		public function setRowFgColor(row:int, color:String):void
		{
			try
			{
				if(row < 0 || row >= this.datagrid.dataProvider.length)
					err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				if (datagrid.dataProvider == null)
					err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				this.datagrid.setRowStyle(row,"color",color);
				if (isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setRowFgColor");
			}
		}
		
		/*************************************************************
		 * set row hide
		 * ***********************************************************/
		public function setRowHide(nRow:int, bHide:Boolean,isHandleBkDp:Boolean=true):void
		{
			try
			{
				var indexBk:int=-1;
				var tmpArr:Array=new Array();
				if(this.datagrid.itemEditorInstance)
					this.datagrid.destroyItemEditor();
				if (!this.datagrid.isTree)
				{
					if(datagrid.invisibleIndexOrder == null)
						datagrid.invisibleIndexOrder = new Array();
					var item:Object;
					if(isHandleBkDp)
					{
						if(nRow < 0 || nRow >= this.datagrid._bkDP.length)
							err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
						item = this.datagrid._bkDP.getItemAt(nRow);
						indexBk = nRow;
					}
					else
					{
						//if bHide =true ,nRow will be followed index of dataProvider
						if(bHide)
						{
							if(nRow < 0 || nRow >= this.datagrid.dataProvider.length)
								err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
							item = this.datagrid.getItemAt(nRow);
							indexBk = this.datagrid._bkDP.getItemIndex(item);
						}
						else
						{
							if(nRow < 0 || nRow >= this.datagrid._bkDP.length)
								err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
							//ifbHide = false, nRow will be followed index of dataProviderBackup
							item = this.datagrid._bkDP.getItemAt(nRow);
							indexBk = nRow;
						}
					}
					//save indexBk to apply in case setRowVisible
					var position:Object = getPositionOfIndexInArr(indexBk,datagrid.invisibleIndexOrder);
					if(bHide)
					{
						if(position == null)
						{
							if(datagrid.invisibleIndexOrder.length == datagrid.nRowHideBuffer)
							{
								//remove the first element of array
								datagrid.invisibleIndexOrder.splice(0,1);
							
							}
							//add new element into array
							tmpArr.push(indexBk);
							datagrid.invisibleIndexOrder.push(tmpArr);
						}
					}
					else
					{
						if(position && position['row'] > -1)
						{
							//remove element is not invisible any more
							var detailItemArr:Array = this.datagrid.invisibleIndexOrder[position['row']];
							detailItemArr.splice(position['column'],1);
							if(detailItemArr.length == 0)
							{
								this.datagrid.invisibleIndexOrder.splice(position['row'],1);
							}
								
						}
					}
					
					item[Global.ROW_HIDE] = bHide;					
					setCRUDRowValue(item, this.datagrid.strDeleteRowText, Global.CRUD_DELETE);
					this.datagrid.filter = new FilterDataWithRowHide(this.datagrid.filter,null);
					if (this.datagrid.dataProvider as XMLListCollection)
					{
//					 	(this.datagrid.dataProvider as XMLListCollection).filterFunction=this.datagrid.filter.apply;
//						(this.datagrid.dataProvider as XMLListCollection).refresh();
					}
					else
					{
						(this.datagrid.dataProvider as ArrayCollection).filterFunction = this.datagrid.filter.apply;
						(this.datagrid.dataProvider as ArrayCollection).refresh();
					}
				
					if(this.datagrid.summaryBarManager.hasSummaryBar() && datagrid.rowCount >0)
					{
						this.datagrid.summaryBarManager.reCreateSummaryBar();
					}
					//update Application height when data is changed
					gridoneManager.updateGridHeight();
					
					gridoneManager.updateExternalVerticalScroll(datagrid.getLength());
					//update group mergeCells of datagrid
					if(hasGroupMerge())
					{
						this.datagrid.getGroupMergeInfo();
					}
					
					if(isDrawUpdate)
						this.datagrid.invalidateList();
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setRowHide");			
			}
		}
		
		/*************************************************************
		 * check that value is existed inside array or not
		 * @author Duong Pham
		 * ***********************************************************/
		public function getPositionOfIndexInArr(value:int, arr:Array):Object
		{
			var row:int =-1, column:int=-1;
			var i:int = 0;
			var j:int=0;
			var isExisted:Boolean = false;
			var arrItem:Array;
			for(i=0; i<arr.length; i++)
			{
				if(arr[i] != null)
				{
					if(arr[i].length > 0)
					{
						arrItem = arr[i] as Array;
						for(j=0; j<arrItem.length; j++)
						{
							if(arrItem[j] == value)
							{
								isExisted = true;
								column = j;
								break;
							}
						}
					}
					if(isExisted)
					{
						row = i;
						break;
					}
				}
			}
			if(row > -1 && column > -1 )
				return {row:row,column:column};
			return null;
		}
		
		/*************************************************************
		 * is row hide
		 * ***********************************************************/
		public function isRowHide(nRow:int):Boolean
		{
			var item:Object;
			if(this.datagrid.itemEditorInstance)
				this.datagrid.destroyItemEditor();
			if (!this.datagrid.isTree)
			{
				item = this.datagrid.getBackupItem(nRow); 
			}
			return item[Global.ROW_HIDE];
		}
		/*************************************************************
		 * set CRUD row value
		 * ***********************************************************/
		public function setCRUDRowValue(row:Object, value:String , crudKey:String):Boolean
		{
			if (this.datagrid.crudMode)
			{
				if (row[this.datagrid.crudColumnKey] != this.datagrid.strInsertRowText && row[this.datagrid.crudColumnKey] != value)
				{
					row[this.datagrid.crudColumnKey]=value;
					row[this.datagrid.crudColumnKey + Global.CRUD_KEY]= crudKey;
					//(this.datagrid.dataProvider as ArrayCollection).itemUpdated(row);
					this.datagrid.invalidateList();
				}
				return true;
			}
			return false;
		}
		
		/*************************************************************
		 * get Cell Value Index
		 * ***********************************************************/
		public function getCellValueIndex(nColumnIndex:int, nRow:int):String
		{
			var strResult:String="";
			if (nColumnIndex < 0 || nColumnIndex >= this.datagrid.columns.length)
				err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
			
			if (nRow < 0 || nRow >= this.datagrid.dataProvider.length)
				err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
			
			var fieldName:String=(this.datagrid.columns[nColumnIndex] as ExAdvancedDataGridColumn).dataField;
			strResult=this.getCellHelper(nRow, fieldName ,"getCellValueIndex");					
			return strResult;
		}
		
		/*************************************************************
		 * get multiple cell index
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getCellIndexArray(value:Object, fieldName:String, returnFieldName:String):Array
		{
			var arr:Array=new Array();
			for (var i:int =0; i<this.datagrid._bkDP.length; i++)
			{
				var item:Object=this.datagrid.getItemAt(i);
				if (item[fieldName]==value.toString())
				{
					arr.push(item[returnFieldName]);
				}
				
			}
			return  arr;	
		}
		
		/*************************************************************
		 * get a cell value.
		 * @param rowIndex index of getting row.
		 * @param fieldName field name of getting column.
		 * @return string of cell which we want to get.
		 * ***********************************************************/
		public function getCellHelper(rowIndex:int, fieldName:String , funcName:String):String
		{
			try
			{
				var strResult:String="";
				if (datagrid.dataProvider == null)
				{
					err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				}				
				if (rowIndex < 0 || rowIndex >= datagrid._bkDP.length)
				{
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				}				
				if (this.datagrid.dataFieldIndex[fieldName] == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}				
				if (datagrid.dataProvider is XMLListCollection || datagrid.dataProvider is ArrayCollection )				
				{
					var dataObj:Object=this.datagrid.getBackupItem(rowIndex);
					if(dataObj == null)
						strResult = "";
					else if (dataObj[fieldName] == null || dataObj[fieldName] == "")
					{
						var col:ExAdvancedDataGridColumn = ExAdvancedDataGridColumn(dgManager.getColumnByDataField(fieldName));
						if(col.type == ColumnType.NUMBER && datagrid.bUpdateNullToZero)
							dataObj[fieldName] = strResult = "0";
						else
							strResult="";
					}
					else
					{
						strResult=dataObj[fieldName].toString();
					}
				}
				 
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,funcName);			
			}
			return strResult;
		}
		
		/*************************************************************
		 * set a cell value index.		 
		 * ***********************************************************/
		public function setCellValueIndex(nColumnIndex:int, nRow:int, strValue:String):void
		{
			if (nColumnIndex < 0 || nColumnIndex >= this.datagrid.columns.length)
				err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
			
			if (nRow < 0 || nRow >= this.datagrid.dataProvider.length)
				err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
			
			var fieldName:String=(this.datagrid.columns[nColumnIndex] as ExAdvancedDataGridColumn).dataField;
			this.setCellHelper(fieldName, nRow, strValue , "setCellValueIndex",true);					
		}
		
		/*************************************************************
		 * set a cell value.		 
		 * ***********************************************************/
		public function setCellHelper(columnKey:String, rowIndex:int, value:Object , functionName:String,belongVisibleCol:Boolean):void
		{
			try
			{
				var item:Object=datagrid.getBackupItem(rowIndex);
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if(col == null && !belongVisibleCol)
				{
					item[columnKey] = value;
					setCRUDRowValue(item, this.datagrid.strUpdateRowText, Global.CRUD_UPDATE);
					this.datagrid.invalidateList();
					return;
				}
				if (!gridone.gridoneManager.checkValueEntered(col, value, Global.SET_CELL_FUNCTION))
				{
					err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				}
				if (rowIndex < 0 || rowIndex >= datagrid._bkDP.length)
				{
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				}
			 
				if(item[columnKey]!=value)
				{
					item[columnKey]=value;	
					if(datagrid.columns[datagrid.dataFieldIndex[columnKey]].type == ColumnType.CHECKBOX)
					{
						if(value.toString() == "1")
							datagrid.columns[datagrid.dataFieldIndex[columnKey]].arrSelectedCheckbox.addItem(item);
						else if((datagrid.columns[datagrid.dataFieldIndex[columnKey]] as ExAdvancedDataGridColumn).arrSelectedCheckbox.getItemIndex(item)!=-1)
							(datagrid.columns[datagrid.dataFieldIndex[columnKey]] as ExAdvancedDataGridColumn).arrSelectedCheckbox.removeItemAt((datagrid.columns[datagrid.dataFieldIndex[columnKey]] as ExAdvancedDataGridColumn).arrSelectedCheckbox.getItemIndex(item));
					}
					setCRUDRowValue(item, this.datagrid.strUpdateRowText, Global.CRUD_UPDATE);
					if (isDrawUpdate == true)
						this.datagrid.invalidateList();
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,functionName);		
			}
		}
		
		/*************************************************************
		 * set cell hidden value index	 
		 * ***********************************************************/
		public function getCellHiddenValueIndex(nColumnIndex:int, nRow:int):String
		{
			if (!datagrid.isTree)
			{
				var strResult:String="";
				if (nColumnIndex < 0 || nColumnIndex >= this.datagrid.columns.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				var colField:String=(this.datagrid.columns[nColumnIndex] as ExAdvancedDataGridColumn).dataField;
				strResult=getCellHiddenValueHelper(colField, nRow , "getCellHiddenValueIndex");
			}						
			return strResult;
		}
		
		/*************************************************************
		 * get cell hidden value helper
		 * ***********************************************************/
		public function getCellHiddenValueHelper(strColumnKey:String, nRow:int, funcName:String):String
		{
			try
			{
				var strResult:String="";
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(strColumnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				
				if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				var obj:Object=this.datagrid.getBackupItem(nRow);
				strResult=obj[strColumnKey + "_hidden"];
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,funcName);					
			}
			return strResult;
		}
		
		/*************************************************************
		 * set cell hidden value index	 
		 * ***********************************************************/
		public function setCellHiddenValueIndex(nColumnIndex:int, nRow:int, strValue:String):void
		{
			if (nColumnIndex < 0 || nColumnIndex >= this.datagrid.columns.length)
				err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
			
			if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
				err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
			
			var colField:String=(this.datagrid.columns[nColumnIndex] as ExAdvancedDataGridColumn).dataField;
			setCellHiddenValueHelper(colField, nRow, strValue ,"setCellHiddenValueIndex");
		}
		
		/*************************************************************
		 * set cell hidden value helper
		 * ***********************************************************/
		public function setCellHiddenValueHelper(strColumnKey:String, nRow:int, strValue:String , strFuncName:String):void
		{
			try
			{
				if (!datagrid.isTree)
				{
					if (!this.datagrid.dataFieldIndex.hasOwnProperty(strColumnKey))
						err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
					
					if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
						err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
					
					var obj:Object=this.datagrid.getBackupItem(nRow);
					obj[strColumnKey + "_hidden"]=strValue;
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,strFuncName);					
			}
		}
		
		/*************************************************************
		 * set cell value 
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellValue(columnKey:String, nRow:int, value:String, belongVisibleCol:Boolean):void
		{				
			try
			{
				
				if (value == null)
					value="";
				if(nRow <= -1)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				var item:Object = this.datagrid.getItemAt(nRow);
				
				
				if(item[SummaryBarConstant.SUB_TOTAL]!= null || item[SummaryBarConstant.TOTAL]!= null)
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_VALUE, Global.DEFAULT_LANG);
				this.setCellHelper(columnKey,nRow,value , "setCellValue",belongVisibleCol);
				if(this.datagrid.summaryBarManager.hasSummaryBar() && datagrid.rowCount >0)
				{
					this.datagrid.summaryBarManager.reCreateSummaryBar();
				} 
				
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellValue");					
			}
		}
		
		/*************************************************************
		 * set cell array
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellArray(valueArray:Array, rowIndexArray:Array, fieldName:String):void
		{
			
			if (this.datagrid.dataProvider == null || valueArray == null || rowIndexArray == null)
				return;
			
			for (var i:int=0; i < rowIndexArray.length; i++)
			{
				var rowIndex:int=int(rowIndexArray[i]);
				
				if (rowIndex < 0 || rowIndex >=this.datagrid._bkDP.length)
					continue;
				
				var item:Object = this.datagrid.getItemAt(rowIndex);
				
				item[fieldName]=valueArray[i];
				
				var rowStatus:RowStatus=dgManager.getRowKey(item) as RowStatus;
				if (rowStatus != null)
					rowStatus.currentStatus=RowStatus.STATUS_EDIT;
				
			}
			this.datagrid.invalidateList();
		}
		
		/*************************************************************
		 * get cell value 
		 * @author chheavhun
		 * ***********************************************************/
		public function getCellValue(listColumKey:String, nRow:int):Object
		{			
			if (nRow < 0)
				nRow=0;
			if (nRow >= datagrid._bkDP.length)
				nRow=datagrid._bkDP.length - 1;
			
			var obj:Object=null;
			if (listColumKey.search(",") < 0)
				obj=this.getCellHelper(nRow, listColumKey,"getCellValue");
			else
				obj=this.getMultiCellValue(listColumKey, nRow);					
			return obj;
		}
		
		/*************************************************************
		 * get multiple cells value
		 * @author chheavhun
		 * ***********************************************************/
		public function getMultiCellValue(listColumKey:String, nRow:int):Array
		{
			var arrColumnKey:Array=listColumKey.split(",");
			var arrResult:Array=new Array();
			for each (var columnKey:String in arrColumnKey)
			{
				if (columnKey != null)
				{
					var strTemp:String=this.getCellHelper(nRow, columnKey ,"getCellValue");
					arrResult.push(strTemp);
				}
			}			
			return arrResult;
		}
		
		/*************************************************************
		 * set cell image
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellImage(strColKey:String, nRow:int, nImageIndex:int):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(strColKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(col.type!=ColumnType.IMAGETEXT)
					err.throwError(ErrorMessages.ERROR_WRONG_COLUMN_TYPE, Global.DEFAULT_LANG);
				if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				if(nImageIndex>col.imageList.length-1)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				var obj:Object=this.datagrid.getBackupItem(nRow);
				obj[strColKey + "_index"]=nImageIndex;
				this.datagrid.invalidateList();
				this.datagrid.scrollToIndex(nRow);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellImage");					
			}
		}
		
		/*************************************************************
		 * get cell image
		 * @author chheavhun
		 * ***********************************************************/
		public function getCellImage(strColKey:String, nRow:int):String
		{
			try
			{
				var strResult:String="";
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(strColKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				
				if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				strResult=this.datagrid.getBackupItem(nRow)[strColKey + "_index"];
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getCellImage");					
			}
			return strResult;
		}
		
		/*************************************************************
		 * set cell background color
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellBgColor(columnKey:String, nRow:int, color:String):void
		{				
			try
			{
				this.datagrid.bscrollStart=false;
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(columnKey, nRow, color , "backgroundColor");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellBgColor");					
			}
		}
		
		/*************************************************************
		 * set cell font color
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellFgColor(columnKey:String, nRow:int, color:String):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(columnKey, nRow, color , "color");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellFgColor");					
			}			
		}
 
		/*************************************************************
		 * set cell padding left
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellPaddingLeft(columnKey:String,nRow:int,padding:Number):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(columnKey, nRow, padding, "paddingLeft");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellPaddingLeft");					
			}	
		}
		
		/*************************************************************
		 * set cell padding right
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellPaddingRight(columnKey:String,nRow:int,padding:Number):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(columnKey, nRow, padding, "paddingRight");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellPaddingRight");					
			}	
		}
		
		/*************************************************************
		 * set cell font styles
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellFont(columnKey:String, nRow:int, fontName:String, nSize:Number, bBold:Boolean, bItalic:Boolean, bUnderLine:Boolean, bCenterLine:Boolean):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(columnKey, nRow, fontName, "fontFamily" );
				if (bBold)
					this.datagrid.setCellProperty(columnKey, nRow, "bold" , "fontWeight");
				else
					this.datagrid.setCellProperty(columnKey, nRow, "normal" , "fontWeight");
				if (bItalic)
					this.datagrid.setCellProperty(columnKey, nRow, "italic" , "fontStyle");
				else
					this.datagrid.setCellProperty(columnKey, nRow, "normal" , "fontStyle");
				if (bUnderLine)
					this.datagrid.setCellProperty(columnKey, nRow, "underline", "textDecoration");
				else
					this.datagrid.setCellProperty(columnKey, nRow, "none", "textDecoration");
				if (bCenterLine)			
					this.datagrid.setCellProperty(columnKey, nRow, true, "fontCLine");
				else
					this.datagrid.setCellProperty(columnKey, nRow, false, "fontCLine");
				if (!isNaN(nSize))
					this.datagrid.setCellProperty(columnKey, nRow, nSize, "fontSize");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellFont");					
			}
		}
		
		public function setCellFontBold(columnKey:String, nRow:int, bBold:Boolean):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (bBold)
					this.datagrid.setCellProperty(columnKey, nRow, "bold" , "fontWeight");
				else
					this.datagrid.setCellProperty(columnKey, nRow, "normal" , "fontWeight");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellFontBold");					
			}
		}
		
		public function setCellFontCLine(columnKey:String, nRow:int, bCenterLine:Boolean):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(columnKey, nRow, bCenterLine , "fontCLine");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setCellFontCLine");					
			}
		}
		
		/*************************************************************
		 * set cell font Italic
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellFontItalic(columnKey:String, nRow:int, bItalic:Boolean):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(bItalic)
					this.datagrid.setCellProperty(columnKey, nRow, "italic", "fontStyle");
				else
					this.datagrid.setCellProperty(columnKey, nRow, "normal", "fontStyle");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setCellFontItalic");	
			}
		}
		
		/*************************************************************
		 * set cell font name
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellFontName(columnKey:String, nRow:int, value:String):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(columnKey, nRow, value , "fontFamily");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setCellFontName");	
			}
		}
		
		/*************************************************************
		 * set cell font size
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellFontSize(columnKey:String, nRow:int, value:Number):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				this.datagrid.setCellProperty(columnKey, nRow, value, "fontSize");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setCellFontSize");	
			}
		}
		
		/*************************************************************
		 * set cell font underline 
		 * @author chheavhun
		 * ***********************************************************/
		public function setCellFontULine(columnKey:String, nRow:int, bUnderLine:Boolean):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (bUnderLine)
					this.datagrid.setCellProperty(columnKey, nRow, "underline", "textDecoration");
				else
					this.datagrid.setCellProperty(columnKey, nRow, "none", "textDecoration");
				if (this.isDrawUpdate == true)
					this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setCellFontULine");	
			}
		}
		
		/*************************************************************
		 * allow draw update 
		 * @author chheavhun
		 * ***********************************************************/
		public function allowDrawUpdate(boolDraw:Boolean):void
		{
			if (boolDraw == true || boolDraw == false)
				isDrawUpdate=boolDraw;
			
			if (boolDraw == true)
				this.datagrid.invalidateList();
		}
		
		/*************************************************************
		 * add combo list
		 * @author chheavhun
		 * ***********************************************************/
		public function addComboList(columnKey:String, value:Object):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn= dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(value is String) //case for combo or multicombo column type
				{
					if(value == null)
						value = 'default';
					col.listCombo[value]=new Array();
					col.indexComboKeyArr.push(value);
					col.comboKey=col.indexComboKeyArr[0];
					this.datagrid.invalidateList();
				}
				else if(value is Array) //in case for MultiCombobox column type
				{
					col.multiComboArr=value as Array; //connect to multiComboRender class, by register in dgManager=>setItemRender	
				}
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"addComboList");	
			}
		}
		
		/*************************************************************
		 * add combo list value 
		 * @author chheavhun
		 * ***********************************************************/
		public function addComboListValue(columnKey:String, strText:String, strValue:String, listKey:String="default"):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (strValue == null)
					err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				var obj:Object=new Object();
				obj["label"]=strText;
				obj["value"]=strValue; 
				if (col.listCombo[listKey] == null)
					col.listCombo[listKey]=new Array();
				//verify that value is existed or not in listKey of listCombo of column
				if(!col.checkComboValueWithListKey(strValue,listKey))
				{
					(col.listCombo[listKey] as Array).push(obj);
					this.datagrid.invalidateList();
				}
				
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"addComboListValue");						
			}
		}
		
		/*************************************************************
		 * get combo list key
		 * @author chheavhun
		 * ***********************************************************/
		public function getComboListKey(columnKey:String, listIndex:int):String
		{
			try
			{
				var result:String = 'default';
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				var objectInfo:Object=ObjectUtil.getClassInfo(col.listCombo);
				if (objectInfo.properties[listIndex] != null)
				{
					var qname:QName=objectInfo.properties[listIndex];
					result = qname.localName;
				}					
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getComboListKey");	
			}
			return result;
		}

		/*************************************************************
		 * get combo selected list key
		 * @author chheavhun
		 * ***********************************************************/
		public function getComboSelectedListKey(columnKey:String, rowIndex:int):String
		{
			try
			{
				var result:String = 'default';
				var bStop:Boolean = false;
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (rowIndex >= this.datagrid._bkDP.length || rowIndex < 0)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				var value:String=this.datagrid.getBackupItem(rowIndex)[col.dataField];
				var objectInfo:Object=ObjectUtil.getClassInfo(col.listCombo);
				var i:int=0;
				for each (var arr:Array in col.listCombo)
				{
					for each (var item:Object in arr)
					{
						if (item["value"] == value)
						{
							var qName:QName=objectInfo.properties[i];
							result = qName.localName;
							bStop = true;
							break;
						}
					}
					i++;
					if(bStop)
						break;
				}					
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getComboSelectedListKey");	
			}
			return result;
		}
		
		/*************************************************************
		 * get combo list count 
		 * @author chheavhun
		 * ***********************************************************/
		public function getComboListCount(columnKey:String, listKey:String=Global.DEFAULT_COMBO_KEY):int
		{
			try
			{
				var result:int = 0;
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;			
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (listKey != null && col.listCombo[listKey] != null)
				{
					result = (col.listCombo[listKey] as Array).length;
				}
				/* if (col.comboData != null)
				result = col.comboData.length; */					
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getComboListCount");	
			}
			return result;
		}
		
		/*************************************************************
		 * get combo hidden value
		 * @author chheavhun
		 * ***********************************************************/
		public function getComboHiddenValue(columnKey:String, comboIndex:int, listKey:String=Global.DEFAULT_COMBO_KEY):String
		{
			try
			{
				var result:String = "";
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (col.listCombo[listKey] != null)
				{
					var arr:Array=col.listCombo[listKey];
					result =  arr[comboIndex]["value"];
				}					
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getComboHiddenValue");	
			}
			return result;
		}
		
		/*************************************************************
		 * get combo text
		 * @author chheavhun
		 * ***********************************************************/
		public function getComboText(columnKey:String, comboItemIndex:int, listKey:String=Global.DEFAULT_COMBO_KEY):String
		{
			try
			{
				var result:String = "";
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (listKey != null)
				{
					if (col.listCombo[listKey] != null)
					{
						var arr:Array=col.listCombo[listKey];
						result = arr[comboItemIndex]["label"];
					}
				}					
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getComboText");	
			}
			return result;
		}
		
		/*************************************************************
		 * get combo selected index 
		 * @author chheavhun
		 * ***********************************************************/
		public function getComboSelectedIndex(columnKey:String, rowIndex:int):int
		{
			try
			{
				var result:int = -1;
				var bStop:Boolean = false;
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (rowIndex >= this.datagrid._bkDP.length || rowIndex < 0)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				var value:String=this.datagrid.getBackupItem(rowIndex)[col.dataField];
				for each (var arr:Array in col.listCombo)
				{
					for (var i:int=0; i < arr.length; i++)
					{
						if (arr[i]["value"] == value)
						{
							result = i;
							bStop = true;
							break;
						}
					}
					if(bStop)
						break;
				}
			 					
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getComboSelectedIndex");	
			}
			return result;
		}
		
		/*************************************************************
		 * add combo header value
		 * @author chheavhun
		 * ***********************************************************/
		public function addComboHeaderValue(columnKey:String,label:String,value:String):void
		{
			var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
			var item:Object=new Object();
			item["label"]= label;
			item["value"]=value;
			col.comboHeaderProvider.addItem(item);
		}
		
		/*************************************************************
		 * set combo selected index
		 * @author chheavhun
		 * ***********************************************************/
		public function setComboSelectedIndex(columnKey:String, rowIndex:int, comboIndex:int, listKey:String=Global.DEFAULT_COMBO_KEY):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (rowIndex >= this.datagrid._bkDP.length || rowIndex < 0)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				if (listKey != null)
				{
					if(col.type==ColumnType.COMBOBOX)
					{
						if(!col.listCombo.hasOwnProperty(listKey))
							err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
						col.comboKey=listKey;
					}
					else
					{
						for(var i:int=0;i<col.indexComboKeyArr.length;i++)
						{
							if(listKey==col.indexComboKeyArr[i])
								break;
						}
						
						this.datagrid.getBackupItem(rowIndex)[col.dataField+Global.COMBO_KEY_CELL]=i;
					}
					if(comboIndex!=-1)
					{
						this.datagrid.getBackupItem(rowIndex)[col.dataField]=col.listCombo[listKey][comboIndex]["value"];
						this.datagrid.getBackupItem(rowIndex)[col.dataField+Global.SELECTED_COMBO_INDEX]=comboIndex;
					}
					else
					{
						this.datagrid.getBackupItem(rowIndex)[col.dataField]="";
						this.datagrid.getBackupItem(rowIndex)[col.dataField+Global.SELECTED_COMBO_INDEX]=-1;
					}
				}
			 
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setComboSelectedIndex");					
			}
		}
		
		/*************************************************************
		 * set  combo selected hidden value
		 * @author chheavhun
		 * ***********************************************************/
		public function setComboSelectedHiddenValue(columnKey:String, rowIndex:int, hiddenValue:String, listKey:String=Global.DEFAULT_COMBO_KEY):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (rowIndex < 0 || rowIndex >= this.datagrid.dataProvider.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				if (listKey != null)
				{
					this.datagrid.getBackupItem(rowIndex)[col.dataField]=hiddenValue;
					var flag:Boolean=false;
					var index:int=0;
					for each(var item:Object in col.listCombo[listKey])
					{
						if(item["value"]==hiddenValue)
						{
							flag=true;
							this.datagrid.getBackupItem(rowIndex)[col.dataField+Global.SELECTED_COMBO_INDEX]=index;
							break;
							
						}
						index++;
					}
					if(!flag)
						err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				}
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setComboSelectedHiddenValue");					
			}
		}
		
		/*************************************************************
		 * get combo selected hidden value
		 * @author chheavhun
		 * ***********************************************************/
		public function getComboSelectedHiddenValue(columnKey:String, rowIndex:int, listKey:String=Global.DEFAULT_COMBO_KEY):String
		{
			try
			{
				var hiddenValue:String;
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (rowIndex < 0 || rowIndex >= this.datagrid.dataProvider.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				
				if (listKey != null)
				{
					var valueCombo:String = this.datagrid.getBackupItem(rowIndex)[col.dataField].toString();
					var flag:Boolean=false;
					var index:int=0;
					for each(var item:Object in col.listCombo[listKey])
					{
						if(item["value"]==valueCombo)
						{
							hiddenValue = valueCombo;
							flag=true;
							break;
						}
						index++;
					}
					if(!flag)
						err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getComboSelectedHiddenValue");					
			}
			return hiddenValue;
		}
		
		/*************************************************************
		 * has combo list
		 * @author chheavhun
		 * ***********************************************************/
		public function hasComboList(columnKey:String, listKey:String=Global.DEFAULT_COMBO_KEY):Boolean
		{
			try
			{
				var result:Boolean = false;
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (listKey != null)
				{
					if (col.listCombo[listKey] != null)
						result = true;
				}					
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"hasComboList");					
			}
			return result;
		}
		
		/*************************************************************
		 * clear combo list
		 * @author chheavhun
		 * ***********************************************************/
		public function clearComboList(columnKey:String, listKey:String=Global.DEFAULT_COMBO_KEY):void
		{
			try
			{					
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (listKey != null)
				{
					if (col.listCombo[listKey] != null)
						col.listCombo[listKey] = null;
				}
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"clearComboList");					
			}
		}
		
		/*************************************************************
		 * set combo row count
		 * @author chheavhun
		 * ***********************************************************/
		public function setComboRowCount(columnKey:String, rowCount:int):void{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(col.type.toUpperCase() != ColumnType.COMBOBOX)
					err.throwError(ErrorMessages.ERROR_COMBOBOX_COLUMN_TYPE,Global.DEFAULT_LANG);
				if(rowCount < -1)	
					err.throwError(ErrorMessages.ERROR_COMBO_ROWCOUNT_INVALID,Global.DEFAULT_LANG);
				col.comboRowCount = rowCount;
				
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setComboRowCount");						
			}				
		}
		
		/*************************************************************
		 * get active column key
		 * @author chheavhun
		 * ***********************************************************/
		public function getActiveColKey():String
		{
			var colIndex:int = -1;
			if(!this.datagrid.selectCell)
			{
				if(this.datagrid.selectedItem)
					colIndex = this.datagrid.selectedItem["columnIndex"];
			}
			else
			{
				if(this.datagrid.selectedCells.length > 0)
					colIndex = this.datagrid.selectedCells[0]["columnIndex"];
			}
			if (colIndex == -1)
				return "";
			return getColHDKey(colIndex);
		}
		
		/*************************************************************
		 * add image list 
		 * @author chheavhun
		 * ***********************************************************/
		public function addImageList(columnKey:String, strUrl:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (col.imageList == null)
					col.imageList=new Array();
				col.imageList.push(strUrl);
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"addImageList");
			}
		}
		
		/*************************************************************
		 * remove image list 
		 * @author chheavhun
		 * ***********************************************************/
		public function removeImageList(columnKey:String, imageIndex:int):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(imageIndex < 0 || col.imageList != null && imageIndex >= col.imageList.length )
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				if (col.imageList != null && col.imageList[imageIndex] != null)
				{
					col.imageList[imageIndex]="";
					//col.imageList.splice(imageIndex,1);
				}
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"removeImageList");
			}
		}
		
		/*************************************************************
		 * get image list url
		 * @author chheavhun
		 * ***********************************************************/
		public function getImageListURL(columnKey:String, imageIndex:int):String
		{
			try
			{
				var result:String = "";
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(imageIndex < 0 || col.imageList != null && imageIndex >= col.imageList.length )
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);				
				if (col.imageList != null)
				{
					result = col.imageList[imageIndex];
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getImageListURL");
			}
			return result;
		}
		
		/*************************************************************
		 * set image list size
		 * @author chheavhun
		 * ***********************************************************/
		public function setImageListSize(columnKey:String, iwidth:int, iHeight:int):void
		{
			try
			{					
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(iwidth < 0 || iHeight <0 )
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);	
				col.imageHeight=iHeight;
				col.imageWidth=iwidth;
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setImageListSize");
			}
		}
		
		/*************************************************************
		 * clear image list
		 * @author chheavhun
		 * ***********************************************************/
		public function clearImageList(columnKey:String):void
		{
			try
			{					
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				col.imageList=[];
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"clearImageList");
			}
		}
		
		/*************************************************************
		 * get image list count
		 * @author chheavhun
		 * ***********************************************************/
		public function getImageListCount(columnKey:String):int
		{
			try
			{
				var result:int = 0;
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (col.imageList != null)
				{
					result = col.imageList.length;
				}					
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getImageListCount");
			}
			return result;
		}
		
		/*************************************************************
		 * add grid image list
		 * @author chheavhun
		 * ***********************************************************/
		public function addGridImageList(url:String):void
		{
			this.datagrid.imageList.push(url);			
		}
		
		/*************************************************************
		 * set column cell grid image list
		 * @author chheavhun
		 * ***********************************************************/
		public function setColCellGridImageList(columnKey:String, bValue:Boolean):void
		{
			try
			{					
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				col.isUseGridImage=bValue;
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColCellGridImageList");
			}
		}
		
		/*************************************************************
		 * clear grid image list
		 * @author chheavhun
		 * ***********************************************************/
		public function clearGridImageList():void
		{
			this.datagrid.imageList=[];
			this.datagrid.invalidateList();
		}
		
		/*************************************************************
		 * set grid image list size
		 * @author chheavhun
		 * ***********************************************************/
		public function setGridImageListSize(nWidth:int, nHeight:int):void
		{
			for each (var col:ExAdvancedDataGridColumn in this.datagrid.columns)
			{
				if (col.type == ColumnType.IMAGETEXT)
					setImageListSize(col.dataField, nWidth, nHeight);
			}
		}
		
		/*************************************************************
		 * set column cell activation 
		 * @author chheavhun
		 * ***********************************************************/
		public function setColCellActivation(strColumnKey:String, strValue:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);				
				if(col.merge)
				{
					err.throwError(ErrorMessages.ERROR_ACTIVATION_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				if (strValue != Global.ACTIVATE_EDIT && strValue != Global.ACTIVATE_DISABLE && strValue != Global.ACTIVATE_ONLY)
					err.throwError(ErrorMessages.ERROR_ACTIVATION_INVALID, Global.DEFAULT_LANG);
				col.cellActivation=strValue;							
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColCellActivation");					
			}
		}
		
		/*************************************************************
		 * get column cell activation 
		 * @author chheavhun
		 * ***********************************************************/
		public function getColCellActivation(strColumnKey:String):String
		{
			try
			{
				var result:String = "";
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				result = col.cellActivation;
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"getColCellActivation");
			}
			return result;
		}
		
		/*************************************************************
		 * set column header checkbox renderer value
		 * @author chheavhun
		 * ***********************************************************/
		public function setColHDCheckBoxValue(strColumnKey:String, bValue:Boolean):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if(col==null || col.type != ColumnType.CHECKBOX)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				datagrid.setHeaderCheckBoxValue(col,bValue);
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColHDCheckBoxValue");	
			}
		}
		
		/*************************************************************
		 * set column cell sort
		 * @author chheavhun
		 * ***********************************************************/
		public function setColCellSort(strColumnKey:String, strSort:String):void
		{
			try
			{
				if (this.datagrid.dataFieldIndex[strColumnKey] == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				if(col.type == ColumnType.CHECKBOX)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (strSort == "none")
				{
					col.sortable=false;
				}
				else if (col.type != ColumnType.CHECKBOX)
				{
					col.sortable=true;		
					if(strSort == "descending")
						col.sortDescending = true;
					else
						col.sortDescending = false;
					var nameSort:Sort = new Sort();
					if(col.type == ColumnType.NUMBER)
						nameSort.fields = [new SortField(strColumnKey, false, col.sortDescending, true)];
					else
						nameSort.fields = [new SortField(strColumnKey, false, col.sortDescending)];
					this.datagrid.dataProvider.sort = nameSort;
				}
				this.datagrid.dataProvider.refresh();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setColCellSort");	
			}
		}
		
		/*************************************************************
		 * set column cell radio
		 * @param columnKey:String; bRadio :Boolean.
		 * author: Duong Pham
		 * Modifier:Toan Nguyen
		 * ***********************************************************/
		public function setColCellRadio(columnKey:String, bRadio:Boolean):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (col.type == ColumnType.CHECKBOX)
				{
					col.isSelectSingleCheckbox=bRadio;
					for each (var item:Object in this.datagrid.dataProvider)
					{
						item[columnKey]="0";
					}
					col.arrSelectedCheckbox.removeAll();
					this.datagrid.invalidateList();
				}
				else
				{
					err.throwError(ErrorMessages.ERROR_CHECKBOX_COLUMN_TYPE, Global.DEFAULT_LANG);
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColCellRadio");					
			}
		}
		
		/*************************************************************
		 * check column is visible or not
		 * ***********************************************************/
		public function isColHide(columnKey:String):Boolean
		{
			try
			{					
				var result:Boolean = false;
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				result = !col.visible;
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"isColHide");
			}
			return result;
		}		
		
		/*************************************************************
		 * set column is visible or not
		 * ***********************************************************/
		public function setColHide(dataField:String, isHide: Boolean):void
		{
			try
			{
				var datagridWidth:int=this.gridone.applicationWidth;
				var hiddenColumn:ExAdvancedDataGridColumn = ExAdvancedDataGridColumn(dgManager.getColumnByDataField(dataField,false));
				if(hiddenColumn == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(hiddenColumn.visible != !isHide)
				{
					if(this.datagrid.bExternalScroll)
					{
						if(isHide == false)
							this.datagrid.width = this.datagrid.totalVisibleColumnWidth = this.datagrid.totalVisibleColumnWidth + hiddenColumn.width;
						else
							this.datagrid.width = this.datagrid.totalVisibleColumnWidth = this.datagrid.totalVisibleColumnWidth - hiddenColumn.width;
					}
					hiddenColumn.visible = !isHide;
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColHide");
			}
		}
		
		/*************************************************************
		 * move column to index position
		 * ***********************************************************/
		public function setColIndex(columnKey:String, index:int):void
		{
			try
			{					
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if(index < 0 && index >= this.datagrid.columns.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				var realIndex:int = getRealIndexByVisibleIndex(index);
				if(!this.datagrid._isGroupedColumn)
				{
					var columns:Array = this.datagrid.columns;
					var columnCollection:ArrayCollection=new ArrayCollection(columns);
					columnCollection.removeItemAt(this.datagrid.dataFieldIndex[columnKey]);
					columnCollection.addItemAt(col, realIndex);					
					for (var i:int=0; i < columnCollection.toArray().length; i++)
					{
						var updatedCol:ExAdvancedDataGridColumn = columnCollection.toArray()[i]; 
						this.datagrid.dataFieldIndex[updatedCol.dataField]=i;
					}
					this.datagrid.columns=columnCollection.toArray();
				}
				else
				{
					var sourceCol:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
					updateColumnPositionInGroupColumn(sourceCol, realIndex,true);
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColIndex");
			}
		}
		
		/*************************************************************
		 * update column position in group column
		 * ***********************************************************/
		private function updateColumnPositionInGroupColumn(sourceCol:ExAdvancedDataGridColumn, index:int,isMoveCol:Boolean=true):void
		{
			try
			{
				var sourceIndex:int;
				var remainCols:ArrayCollection;
				if(isMoveCol)
				{
					sourceIndex = this.datagrid.dataFieldIndex[sourceCol.dataField]; 
					remainCols =deleteColumnByDataField(sourceCol.dataField);
				}
				else
				{
					sourceIndex = index;
					remainCols = new ArrayCollection(this.datagrid.groupedColumns);
				}
				var prevCol:ExAdvancedDataGridColumn;
				var nextCol:ExAdvancedDataGridColumn;
				var prevListParentKey:String;
				var nextListParentKey:String;
				var sourceListParentKey:String;
				if(sourceCol.parent != "")
				{
					sourceListParentKey = sourceCol.parent + "%%"; 
					sourceListParentKey = getListParentKey(sourceCol.parent,sourceListParentKey);
					sourceListParentKey = sourceListParentKey.slice(0,sourceListParentKey.length-2);
				}
				if(index == 0)
				{
					nextCol = this.datagrid.columns[0];
				}
				else if(index == this.datagrid.columns.length)
				{
					prevCol = this.datagrid.columns[this.datagrid.columns.length];
				}
				else
				{
					if(sourceIndex < index)
					{
						// preCol: index ; nextCol: index +1
						prevCol = this.datagrid.columns[index];
						nextCol = this.datagrid.columns[index + 1];
					}
					else
					{
						// preCol: index - 1;  nextCol: index
						prevCol = this.datagrid.columns[index - 1];
						nextCol = this.datagrid.columns[index];
					}
				}
				if(prevCol && prevCol.parent != "")
				{
					prevListParentKey = prevCol.parent + "%%"; 
					prevListParentKey = getListParentKey(prevCol.parent,prevListParentKey);
					prevListParentKey = prevListParentKey.slice(0,prevListParentKey.length-2);
				}
				if(nextCol && nextCol.parent != "")
				{
					nextListParentKey = nextCol.parent + "%%"; 
					nextListParentKey = getListParentKey(nextCol.parent,nextListParentKey);
					nextListParentKey = nextListParentKey.slice(0,nextListParentKey.length-2);
				}
				if(sourceCol.parent == "")
				{					
					if( (prevCol == null && nextCol.parent == "") || (prevCol == null && nextCol.parent != "") ||
						(prevCol.parent == "" && nextCol == null) || (prevCol.parent != "" && nextCol == null) ||
						(prevCol && nextCol && (    (prevCol.parent == "" && nextCol.parent == "") || 
													(prevCol.parent == "" && nextCol.parent != "") ||
													(prevCol.parent != "" && nextCol.parent == "")
											   )
						))
					{
						remainCols = addColumnAtIndex(remainCols,sourceCol,index,false);
					}
					else
					{				
						if(prevListParentKey == nextListParentKey)
						{
							// belong one group column
							err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
						}
						else
						{
							// next and previous column belong two different group columns => allow insert
							remainCols = addColumnAtIndex(remainCols,sourceCol,index,false);
						}
					}
				}
				else
				{					
					if( (prevCol == null && nextCol.parent == "") ||
						(prevCol.parent == "" && nextCol == null) ||
						(prevCol && nextCol && ((prevCol.parent == "" && nextCol.parent == "")))
					  )
					{
						err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
					}
					else
					{
						if(prevCol.parent == "" && nextCol.parent != "")
						{
							if(isNotBelongOneColumnGroups(sourceListParentKey,nextListParentKey))
								err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
							else
								remainCols = addColumnAtIndex(remainCols,sourceCol,index,false);
						}
						else if(prevCol.parent != "" && nextCol.parent == "")
						{
							if(isNotBelongOneColumnGroups(prevListParentKey, sourceListParentKey))
								err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
							else
								remainCols = addColumnAtIndex(remainCols,sourceCol,index,true);
						}
						else if(prevCol.parent != "" && nextCol.parent != "")
						{
							var isSourceNotBelongPreviousCol:Boolean = isNotBelongOneColumnGroups(prevListParentKey,sourceListParentKey);
							var isSourceNotBelongNextCol:Boolean = isNotBelongOneColumnGroups(sourceListParentKey,nextListParentKey);
							if(isSourceNotBelongPreviousCol && isSourceNotBelongNextCol)
								err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
							else if(!isSourceNotBelongPreviousCol && isSourceNotBelongNextCol) 
								remainCols = addColumnAtIndex(remainCols,sourceCol,index,true);
							else if (isSourceNotBelongPreviousCol && !isSourceNotBelongNextCol)
								remainCols = addColumnAtIndex(remainCols,sourceCol,index,false);
							else if (!isSourceNotBelongPreviousCol && !isSourceNotBelongNextCol)
								remainCols = addColumnAtIndex(remainCols,sourceCol,index,false);							
						}
					}
				}
				//update grouped column in datagrid
				this.datagrid.groupedColumns = remainCols.toArray();
				var updatedCols:Array = new Array(); 
				updatedCols = convertGroupColumn(remainCols.toArray() , updatedCols)
				this.datagrid.columns = updatedCols;
				for (var i:int=0; i < updatedCols.length; i++)
				{
					this.datagrid.dataFieldIndex[updatedCols[i].dataField]=i;
				}	
			}
			catch (error:Error)
			{
				throw new Error(error.message);
			}
		}
		
		/*************************************************************
		 * delete column by dataField
		 * @author chheavhun
		 * ***********************************************************/
		private function deleteColumnByDataField(dataField:String):ArrayCollection
		{
			var remainCols:ArrayCollection;
			var groupedColumns:Array = this.datagrid.groupedColumns;
			remainCols=new ArrayCollection(groupedColumns);
			for (var i:int=0; i< remainCols.length; i++)
			{
				if(remainCols[i] is ExAdvancedDataGridColumn && ExAdvancedDataGridColumn(remainCols[i]).dataField != null && (remainCols[i] as ExAdvancedDataGridColumn).dataField == dataField)
				{
					remainCols.removeItemAt(i);
					break;
				}
				else if(remainCols[i] is ExAdvancedDataGridColumnGroup && ExAdvancedDataGridColumn(remainCols[i]).dataField == null)
				{
					if(deleteChildrenColByDataField(dataField, remainCols[i]))	
						break;
				}
			}
			var deletedColIndex:int = this.datagrid.dataFieldIndex[dataField];
			this.datagrid.dataFieldIndex = new Object();
			//update index column in datafieldIndex
			for (var j:int=0; j < this.datagrid.columns.length; j++)
			{
				if(j < deletedColIndex)
					this.datagrid.dataFieldIndex[this.datagrid.columns[j].dataField]=j;
				else if(j > deletedColIndex)
				{
					var index:int = j;
					this.datagrid.dataFieldIndex[this.datagrid.columns[j].dataField]=--index;
				}
			}
			return remainCols;		
		}
		
		/*************************************************************
		 * delete children column by dataField
		 * @author chheavhun
		 * ***********************************************************/
		private function deleteChildrenColByDataField(dataField:String, groupCol:ExAdvancedDataGridColumnGroup):Boolean
		{			
			var isBreak:Boolean = false;
			for(var i:int=0; i<groupCol.children.length; i++)
			{
				if(groupCol.children[i] is ExAdvancedDataGridColumn && (groupCol.children[i] as ExAdvancedDataGridColumn).dataField == dataField)
				{
					groupCol.children.splice(i,1);
					isBreak = true;
					break;
				}
				else if(groupCol.children[i] is ExAdvancedDataGridColumnGroup && groupCol.children[i].dataField == "")
				{					
					isBreak = deleteChildrenColByDataField(dataField, groupCol.children[i]);
					if(isBreak)
						break;
				}
			}
			return isBreak;
		}
		
		/*************************************************************
		 * check if is not belong one column groups 
		 * @author chheavhun
		 * ***********************************************************/
		private function isNotBelongOneColumnGroups(prevListParentKey:String, nextListParentKey:String):Boolean
		{
			var result:Boolean = false;
			var arrPrevParent:Array = prevListParentKey.split("%%");
			var arrNextParent:Array = nextListParentKey.split("%%");
			var i:int = 0;
			var end:int;
			if(arrNextParent.length > arrPrevParent.length)
				end = arrNextParent.length;
			else if(arrNextParent.length < arrPrevParent.length)
				end = arrPrevParent.length;
			else
				end = arrPrevParent.length;
					
			for(i = 0 ; i< end; i++)
			{
				if(arrNextParent[i] && arrPrevParent[i] && arrNextParent[i] != arrPrevParent[i])
				{
					result = true;
					break;
				}
			}
			return result;			
		}
		
		/*************************************************************
		 * add column at index 
		 * @author chheavhun
		 * ***********************************************************/
		private function addColumnAtIndex(allColumns:ArrayCollection, insertedCol:ExAdvancedDataGridColumn, index:int, isUsePreviousCol:Boolean):ArrayCollection
		{
			var destDataField:String;
			var curColIndex:int;
			var col:ExAdvancedDataGridColumn;
			var isInsertAfterColAtIndex:Boolean = false; 
			if(isUsePreviousCol)
			{
				//get previous column
				isInsertAfterColAtIndex = true;
				var tmp:int = index - 1;
				destDataField = dgManager.getDataFieldByIndex(tmp);
				col=ExAdvancedDataGridColumn(dgManager.getColumnByDataField(destDataField,true));
			}
			else
			{
				destDataField = dgManager.getDataFieldByIndex(index);
				col=ExAdvancedDataGridColumn(dgManager.getColumnByDataField(destDataField,true));
			}
			
			var j:int = 0;
			var i:int = 0;
			var listParentKey:String;
			var parentKey:Array;
			var parentGroupCol:ExAdvancedDataGridColumnGroup;
			if(insertedCol.parent == "")
			{
				if(col.parent == "")
				{
					for (i =0 ; i < allColumns.length; i++)
					{
						if(allColumns[i] is ExAdvancedDataGridColumn && allColumns[i].dataField == col.dataField)
						{
							allColumns.addItemAt(insertedCol,i);
							break;
						}
					}
				}
				else
				{
					listParentKey = col.parent + "%%"; 
					listParentKey = getListParentKey(col.parent,listParentKey);
					listParentKey = listParentKey.slice(0,listParentKey.length-2);
					parentKey = listParentKey.split("%%");
					for (i =0 ; i < allColumns.length; i++)
					{
						if(allColumns[i] is ExAdvancedDataGridColumnGroup && allColumns[i]._dataFieldGroupCol == parentKey[parentKey.length-1])
						{
							allColumns.addItemAt(insertedCol,i);
							break;
						}
					}
				}
			}
			else 
			{
				if(col.parent == "")
				{
					parentGroupCol = ExAdvancedDataGridColumnGroup(dgManager.getColumnByDataField(insertedCol.parent,true));
					parentGroupCol.children.push(insertedCol);
				}
				else
				{
					parentGroupCol = ExAdvancedDataGridColumnGroup(dgManager.getColumnByDataField(insertedCol.parent));
					if(parentGroupCol)
					{
						for(i = 0; i<parentGroupCol.children.length; i++)
						{
							if(parentGroupCol.children[i] is ExAdvancedDataGridColumn && (parentGroupCol.children[i] as ExAdvancedDataGridColumn).dataField == col.dataField)
							{
								if(i == parentGroupCol.children.length-1)
								{
									if(!isInsertAfterColAtIndex)
										parentGroupCol.children.splice(i,0,insertedCol);
									else
										parentGroupCol.children.push(insertedCol);
								}
								else					
								{
									parentGroupCol.children.splice(i,0,insertedCol);
								}
								break;
							}				
						}
						
							
					}
				}
			}
			return allColumns;
		}
		
		/*************************************************************
		 * add column to children of group
		 * ***********************************************************/
		private function addColumnToChidrenOfGroup(groupCol:ExAdvancedDataGridColumnGroup , col:ExAdvancedDataGridColumn, previousCol:ExAdvancedDataGridColumn,isInsertedInsideGroupCol:Boolean):Boolean
		{			
			var isStop:Boolean = false;
			for(var i:int=0; i<groupCol.children.length; i++)
			{
				if(groupCol.children[i] is ExAdvancedDataGridColumn && (groupCol.children[i] as ExAdvancedDataGridColumn).dataField == previousCol.dataField)
				{
					if(i == groupCol.children.length - 1)
						groupCol.children.push(col);
					else					
					{
						groupCol.children.splice(i,0,col);
					}
					isStop = true;
					break;
				}				
			}
			return isStop;
		}
		
		/*************************************************************
		 * get list parent key
		 * ***********************************************************/
		public function getListParentKey(parentKey:String, result:String):String
		{			
			var groupCol:ExAdvancedDataGridColumnGroup = this.dgManager.getColumnByDataField(parentKey,true) as ExAdvancedDataGridColumnGroup;
			if(groupCol.parent != "")
			{
				result = result + groupCol.parent + "%%";
				getListParentKey(groupCol.parent , result);
			}
			return result;
		}
		
		/*************************************************************
		 * Get max length of column		 
		 * ***********************************************************/
		public function getColMaxLength(columnKey:String):String
		{
			try
			{
				var nResult:String="-1";
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (col.orginalMaxLength.search("-") < 0 || col.orginalMaxLength.search(".") < 0)
					nResult=col.orginalMaxLength;
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getColMaxLength");					
			}
			return nResult;
		}
		
		/*************************************************************
		 * set date format
		 * ***********************************************************/
		public function setDateFormat(columnKey:String, value:String):void
		{
			var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
			if(col != null)
			{
				col.dateOutputFormatString=value;
				this.datagrid.invalidateList();
			}
		}
		
		/*************************************************************
		 * Expand directly children node or all children node of tree 
		 * @param strTreeKey Key of tree
		 * @param bAll Is true if expand all children, Is false if expand only directly children
		 * @param strFuncName Name of called function
		 * @author Thuan
		 * ***********************************************************/
		public function expandAtNode(strTreeKey:String, bAll:Boolean, strFuncName:String):void
		{
			try
			{  
				(((this.datagrid.dataProvider as HierarchicalCollectionView).source as ExIHierarchicalData).source as ArrayCollection).refresh();
				var hd: ExIHierarchicalData = this.dgManager.getTreeDataInHier();
				var cursor:IViewCursor = this.dgManager.getTreeDataInFlatCursor();
				cursor.seek(CursorBookmark.FIRST);
				do
				{
					if (cursor.current[this.datagrid.treeIDField] == strTreeKey)
					{
						if (bAll)
						{
							this.datagrid.expandChildrenOf(cursor.current, true);
						}
						else
						{
							this.datagrid.expandItem(cursor.current, true);
						}
						
						//expand all parent of current node:
						var parent:Object = hd.getParent(cursor.current);
						while (parent)
						{
							this.datagrid.expandItem(parent, true);
							parent = hd.getParent(parent);
						}	
						break;
					}
				}while (cursor.moveNext());
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,strFuncName);
			}
		}
		
		/*************************************************************
		 * Collapse tree node
		 * @param strTreeKey Key of tree
 		 * @param strFuncName Name of called function
		 * @author Thuan
		 * ***********************************************************/
		public function collapseAtNode(strTreeKey:String, strFuncName: String):void
		{
			try
			{
				var cursor:IViewCursor = this.dgManager.getTreeDataInFlatCursor();
				cursor.seek(CursorBookmark.FIRST);
				do
				{
					if (cursor.current[this.datagrid.treeIDField] == strTreeKey)
					{
						this.datagrid.expandItem(cursor.current, false);
					}
				}while (cursor.moveNext());
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
		}
		
		/*************************************************************
		 * Delete tree node and all children of that
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @author Thuan
		 * ***********************************************************/
		public function deleteTreeNode(strTreeKey: String, strFuncName: String):void
		{
			try
			{
				var cursor:IViewCursor = this.dgManager.getTreeDataInFlatCursor();
				do
				{
					if (cursor.current[this.datagrid.treeIDField] == strTreeKey)
					{
						var children:Object = this.dgManager.getChildren(cursor.current);
						setCRUDRowValue(cursor.current,this.datagrid.strDeleteRowText,Global.CRUD_DELETE);
						//delete all child node:
						this.dgManager.deleteChild(cursor.current, children);
						//delete current node:
						var parent:Object = this.dgManager.getNodeByKey(cursor.current[this.datagrid.treePIDField]);
						(this.datagrid.dataProvider as HierarchicalCollectionView).removeChild(parent,cursor.current);
						break;
					}
				}while (cursor.moveNext());
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
		}
		
		/*************************************************************
		 * Get row index from tree key
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @author Thuan
		 * ***********************************************************/
		public function getRowIndexFromTreeKey(strTreeKey: String, strFuncName: String): int
		{
			try
			{
				var cursor:IViewCursor = this.dgManager.getTreeDataInFlatCursor();
				var rowIndex:int = -1;
				do
				{
					rowIndex = rowIndex + 1;
					if (cursor.current[this.datagrid.treeIDField] == strTreeKey)
					{
						break;
					}
				} while(cursor.moveNext());
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return rowIndex;
		}
		
		/*************************************************************
		 * Return the number of child node of the corresponding tree node if true is inputted as bAll value.
		 * @param strTreeKey Key of tree
		 * @param bAll Is true if count all children, Is false if count only directly children
		 * @param strFuncName Name of called function
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeChildNodeCount(strTreeKey:String, bAll:Boolean, strFuncName: String): int
		{
			try
			{
				var node:Object = this.dgManager.getNodeByKey(strTreeKey);
				if (bAll)
				{
					var arrCollection: ArrayCollection;
					var children:Object = this.dgManager.getChildren(node);
					var arrChildren:ArrayCollection = new ArrayCollection();
					arrCollection = this.dgManager.getAllChildren(node, children, arrChildren);
					return arrCollection.length;
				}
				else
				{
					var arr: Array = (this.dgManager.getChildren(node) as Array);
					return arr.length;
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return 0;			
		}
		
		/*************************************************************
		 * Return child node key of the corresponding tree node
		 * @param strTreeKey Key of tree
 	 	 * @param strFuncName Name of called function
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeChildNodeKey(strTreeKey:String, strFuncName: String): Object
		{
			try
			{
				return this.dgManager.getNodeByKey(strTreeKey);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return null;
		}		

		/*************************************************************
		 * Return the first node of tree
		 * @param strFuncName Name of called function
		 * @return The first node of tree
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeFirstNodeKey(strFuncName: String): String
		{
			try
			{
				var firstNode:Object = this.dgManager.getFirstNodeInTree();
				return firstNode[this.datagrid.treeIDField];
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return null;
		}
		
		/*************************************************************
		 * Get tree key from row index
 		 * @param strFuncName Name of called function 
		 * @return String of tree key from row index
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeKeyFromRowIndex(rowIndex: int, strFuncName: String): String
		{
			var strTreeKey: String = "";
			try
			{
				if (this.datagrid.dataProvider == null)
				{
					err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				}
				if(rowIndex < 0 || rowIndex >= this.datagrid._bkDP.length)
				{
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
				}
				var flatData: ArrayCollection = this.dgManager.getTreeDataInFlat();
				strTreeKey = flatData.getItemAt(rowIndex)[this.datagrid.treeIDField];
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return strTreeKey;
		}
		
		/*************************************************************
		 * Get next key
		 * @param strTreeKey Key of tree
 		 * @param strFuncName Name of called function
		 * @param isInBranch True: Next key is in branch with strTreeKey; False: Next key can be key of next branch
		 * @return The next key of strTreeKey
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeNextNodeKey(strTreeKey:String, strFuncName: String, isInBranch:Boolean):String
		{
			var nextKey: String = "";
			try
			{
				nextKey = this.dgManager.getNextNodeByKey(strTreeKey, isInBranch);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return nextKey;
		}
		
		/*************************************************************
		 * Get previous key
		 * @param strTreeKey Key of tree
 		 * @param strFuncName Name of called function
		 * @param isInBranch True: Previous key is in branch with strTreeKey; False: Previous key can be key of next branch
		 * @return The previous key of strTreeKey
		 * @author Thuan
		 * ***********************************************************/
		public function getTreePrevNodeKey(strTreeKey:String, strFuncName: String, isInBranch:Boolean):String
		{
			var previousKey: String = "";
			try
			{
				previousKey = this.dgManager.getPreviousNodeByKey(strTreeKey, isInBranch);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return previousKey;
		}
		
		/*************************************************************
		 * Get depth of tree node
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return The depth of strTreeKey
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeNodeDepth(strTreeKey:String, strFuncName: String):int
		{
			var depth:int = 0;
			
			try
			{
				var flatData: ArrayCollection = this.dgManager.getTreeDataInFlat();
				var hierData: ExIHierarchicalData = this.dgManager.getTreeDataInHier();
				var cur:IViewCursor = flatData.createCursor();
				
				if (cur.current == null)
					return 0;
				do
				{
					if (cur.current[this.datagrid.treeIDField] == strTreeKey)
					{
						var curNode: Object = cur.current;
						while (curNode)
						{	
							depth++;
							curNode = hierData.getParent(curNode);	
						}
						break;
					}
				}
				while (cur.moveNext());
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			
			return depth;
		}

		/*************************************************************
		 * Get parent key of key
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return The parent key of strTreeKey
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeParentNodeKey(strTreeKey:String, strFuncName: String):String
		{
			var parenNodeKey: String = "";
			try
			{
				var node: Object = this.dgManager.getNodeByKey(strTreeKey);
				if (node)
				{
					parenNodeKey = node[this.datagrid.treePIDField];
					if (parenNodeKey == Global.TREE_ROOT_CHAR)
						return Global.TREE_ROOT_STRING;
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}			
			return parenNodeKey;
		}
		
		/*************************************************************
		 * Return the summary of child node of the corresponding tree node
		 * @param strTreeKey Key of tree
		 * @param strSummaryColumnKey Summary applied ColumnKey
		 * @param strFunc Function [ sum | count | avarage ] 
 		 * @param strFuncName Name of called function
		 * @param bAll Whether to apply all subordinate node
		 * @return The Summary of child node of the corresponding tree node
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeSummaryValue(strTreeKey:String, strSummaryColumnKey:String, strFunc:String, strFuncName:String, bAll:Boolean):int
		{
			var result: int = 0;
			try
			{
				if(this.datagrid.dataFieldIndex[strSummaryColumnKey] == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
					return result;
				}
				if (bAll)
				{
					result = this.dgManager.getTreeSummaryValueOfAllSubNode(strTreeKey, strSummaryColumnKey, strFunc);
				}
				else
				{
					result = this.dgManager.getTreeSummaryValueOfSubNode(strTreeKey, strSummaryColumnKey, strFunc);
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return result;
		}
		
		/*************************************************************
		 * Check if the corresponding tree node has child node or not
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return Indicates whether node of strTreeKey has child 
		 * @author Thuan
		 * ***********************************************************/
		public function hasTreeChildNode(strTreeKey: String, strFuncName:String):Boolean
		{
			var hasChild:Boolean = false;

			try
			{
				var cursor:IViewCursor = this.dgManager.getTreeDataInFlatCursor();
				do
				{
					if (cursor.current[this.datagrid.treePIDField] == strTreeKey)
					{
						hasChild = true;
						break;
					}
				}
				while (cursor.moveNext());
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return hasChild;
		}
		
		/*************************************************************
		 * Check if the corresponding tree node has next node or not
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return Indicates whether node of strTreeKey has next node
		 * @author Thuan
		 * ***********************************************************/
		public function hasTreeNextNode(strTreeKey: String, strFuncName:String):Boolean
		{
			var hasNextNode:Boolean = false;
			
			try
			{
				var nextKey:String = this.dgManager.getNextNodeByKey(strTreeKey, true);
				hasNextNode = (nextKey != "");
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return hasNextNode;
		}
		
		/*************************************************************
		 * Check if the corresponding tree node has previous node or not
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return Indicates whether node of strTreeKey has previous node
		 * @author Thuan
		 * ***********************************************************/
		public function hasTreePrevNode(strTreeKey: String, strFuncName:String):Boolean
		{
			var hasPreviousNode:Boolean = false;
			
			try
			{
				var previousKey:String = this.dgManager.getPreviousNodeByKey(strTreeKey, true);
				hasPreviousNode = (previousKey != "");
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
			return hasPreviousNode;		
		}
		
		/*************************************************************
		 * Check if the corresponding tree node has parent node or not
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return Indicates whether node of strTreeKey has parent node
		 * @author Thuan
		 * ***********************************************************/
		public function hasTreeParentNode(strTreeKey: String, strFuncName:String):Boolean
		{
			var parenNodeKey: String = "";
			var hasParent:Boolean = false;

			try
			{
				var node: Object = this.dgManager.getNodeByKey(strTreeKey);
				if (node)
				{
					parenNodeKey = node[this.datagrid.treePIDField];
					hasParent = (parenNodeKey != Global.TREE_ROOT_CHAR && parenNodeKey != "");
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}			
			return hasParent;		
		}
		
		/*************************************************************
		 * Check whether tree node is collapsed
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return True: tree node is collapsed; False: tree node is not collapsed 
		 * @author Thuan
		 * ***********************************************************/
		public function isTreeNodeCollapse(strTreeKey: String, strFuncName: String):Boolean
		{
			try
			{
				var h:HierarchicalCollectionView = (this.datagrid.dataProvider as HierarchicalCollectionView);
				var node: Object = this.dgManager.getNodeByKey(strTreeKey);
				var uid:String = UIDUtil.getUID(node);
				if (h.openNodes[uid] == null)
					return true;			
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}	
			return false;
		}
		
		/*************************************************************
		 * Check whether tree node is expanded
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return True: tree node is expanded; False: tree node is not expanded  
		 * @author Thuan
		 * ***********************************************************/
		public function isTreeNodeExpand(strTreeKey: String, strFuncName: String):Boolean
		{
			try
			{
				var hcv:HierarchicalCollectionView = (this.datagrid.dataProvider as HierarchicalCollectionView);
				var node: Object = this.dgManager.getNodeByKey(strTreeKey);
				var uid:String = UIDUtil.getUID(node);
				if (hcv.openNodes[uid] != null)
					return true;			
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}	
			return false;			
		}
		
		/*************************************************************
		 * Check whether tree key is of tree node
		 * @param strTreeKey Key of tree
		 * @param strFuncName Name of called function
		 * @return True: key is of tree node; False: key is not of tree node 
		 * @author Thuan
		 * ***********************************************************/
		public function isTreeNodeKey(strTreeKey: String, strFuncName: String):Boolean
		{
			try
			{
				var node: Object = this.dgManager.getNodeByKey(strTreeKey);
				return (node != null);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}	
			return false;
		}
		
		/*************************************************************
		 * Insert tree node at last child node of parent node
		 * @param strParentTreeKey Parent key of inserted key
		 * @param strTreeKey Inserted key of tree
		 * @param strText Value of tree data field
		 * @param strFuncName Name of called function
		 * @author Thuan
		 * ***********************************************************/
		public function insertTreeNode(strParentTreeKey: String, strTreeKey: String, strText: String, strFuncName: String):void
		{
			try
			{
				var isExistedKey:Boolean = this.dgManager.isExistedKey(strTreeKey);
				if (isExistedKey == true)
				{
					err.throwError(ErrorMessages.ERROR_TREE_EXISTED_KEY, Global.DEFAULT_LANG);
					return;
				}
				
				//Get all children of strParentTreeKey:
				var arrAllChildren: ArrayCollection = new ArrayCollection(); 
				arrAllChildren = this.dgManager.getAllChildrenByParentKey(strParentTreeKey);
				
				//Get lastChild of strParentTreeKey:
				var lastChild: Object = arrAllChildren.getItemAt(arrAllChildren.length - 1);
				
				//Get insertIndex of last child:
				var insertIndex: int = this.getRowIndexFromTreeKey(lastChild[this.datagrid.treeIDField], strFuncName) + 1;
				
				//Create node to insert:
				var node:Object=new Object();
				node[this.datagrid.treePIDField] = strParentTreeKey;
				node[this.datagrid.treeIDField] = strTreeKey;
				node[this.datagrid.treeDataField] = strText;
				
				//update CRUD mode
				setCRUDRowValue(node, this.datagrid.strInsertRowText, Global.CRUD_INSERT);
				
				//Insert item:
				var hierData:ExIHierarchicalData = this.dgManager.getTreeDataInHier();
				hierData.insertNodeAt(node, insertIndex);
				
				//Update dataProvider:
				var treeData:ExIHierarchicalData = this.dgManager.getTreeData();
				this.datagrid.dataProvider = treeData;
				
				//Expand to see inserted item:
				this.expandAtNode(strParentTreeKey, false, strFuncName);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
		}
		
		/*************************************************************
		 * Move tree node to other parent
		 * @param strParentTreeKey Parent key of moved key
		 * @param strTreeKey Moved key of tree
		 * @param strFuncName Name of called function
		 * @author Thuan
		 * ***********************************************************/
		public function moveTreeNode(strParentTreeKey:String, strTreeKey:String, strFuncName: String):void
		{
			try
			{
				var isParentChild:Boolean = this.dgManager.isParentOf(strParentTreeKey, strTreeKey);
				if (isParentChild == true)
				{
					err.throwError(ErrorMessages.ERROR_TREE_IS_PARENT_CHILD_KEY, Global.DEFAULT_LANG);
					return;
				}
//				Get all nodes:
				var hcvData:ArrayCollection = this.dgManager.getTreeDataInFlat();
//				Get moved node:
				var moveNode:Object = this.dgManager.getNodeByKey(strTreeKey);
				
//				Backup children:
//				-----------------------------------------------------------------------------
//				Backup strTreeKey and children:
				var allChildren:ArrayCollection = new ArrayCollection; 
				allChildren = this.dgManager.getAllChildrenByParentKey(strTreeKey);
				allChildren.addItemAt(moveNode, 0);

//				Change parent of moved node:
				moveNode[this.datagrid.treePIDField] = strParentTreeKey;
				
//				Delete branch of strTreeKey:
//				-----------------------------------------------------------------------------
//				hcvData = this.dgManager.deleteAllChildrenByList(hcvData, allChildren);
				var hier:ExIHierarchicalData = this.dgManager.getTreeDataInHier();
				hier.removeNodes(allChildren);
				
//				Get index to insert:
//				-----------------------------------------------------------------------------
//				Get parent node:
				var parentNode:Object = this.dgManager.getNodeByKey(strParentTreeKey);
				
//				Get all children of parent:
				var allChildrenOfParent:ArrayCollection = this.dgManager.getAllChildrenByParentKey(strParentTreeKey);
//
//				Get lastChild of strParentTreeKey:
				var lastChild: Object = allChildrenOfParent.getItemAt(allChildrenOfParent.length - 1);

//				Get insertIndex of last child:
				var insertIndex: int = this.getRowIndexFromTreeKey(lastChild[this.datagrid.treeIDField], strFuncName) + 1;

//				Add all children:
//				-----------------------------------------------------------------------------
				hier = this.dgManager.getTreeDataInHier();
				hier.insertNodesAt(allChildren, insertIndex);

//				Update dataProvider:
//				-----------------------------------------------------------------------------
				var treeData:ExIHierarchicalData = this.dgManager.getTreeData();
				this.datagrid.dataProvider = treeData;
				
//				Expand to display result:
//				-----------------------------------------------------------------------------				
				this.expandAtNode(strParentTreeKey, false, strFuncName);
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message, strFuncName);
			}
		}
		
		/*************************************************************
		 * Export AdvancedDataGrid to Excel
		 * param bColHideVisible=true allow hidden column include in excel export, bColHideVisible=false not allow hidden column include in excel export.
		 * @author Thuan
		 * ***********************************************************/
		public function excelExport(strPath:String, strListColumnKey:String, bHeaderVisible:Boolean, bDataFormat:Boolean, bHeaderOrdering:Boolean=true,bColHideVisible:Boolean=true,strExcelFileName:String="" , bCharset:Boolean=true):void
		{
			try
			{
				var isError:Boolean=false;
				var listCol:String=strListColumnKey;
				
			 
				if (strExcelFileName !="")
				{
					this.datagrid.strDefaultExportFileName=strExcelFileName;
				}
				
				if(listCol != ""  && bColHideVisible==true)
				{
					var colArr:Array = listCol.split(",");	
					for(var i:int=0;i<colArr.length;i++)
					{
						if (this.datagrid.dataFieldIndex[colArr[i]] == null)
						{
							isError = true;
							break;
						}
					}
				}
				
				if(listCol == ""  && bColHideVisible==false)
				{
					var countCol:int=this.getColCount();
					 
					for (var j:int;j<countCol;j++)
					{
						var visibleCol:String=this.getColHDVisibleKey(j);
						if(!this.isColHide(visibleCol))
						{
							listCol +=visibleCol + ","; 	
						}
						
					}
				}
				
				if(isError)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				
				//save condition to export data
				if(datagrid.excelExportInfo)
					datagrid.excelExportInfo = null;
				
				datagrid.excelExportInfo = new ExcelExportInfo(strPath,listCol,bHeaderVisible,bDataFormat,bHeaderOrdering,bCharset);
				//export
				exportExcel();
				
//				this.datagrid.excelExport(strPath, strListColumnKey, bHeaderVisible, bDataFormat, bHeaderOrdering, bCharset);
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"excelExport");
			}
		}
		
		/*************************************************************
		 * open popup to export excel
		 * @author Thuan
		 * @modify Duong Pham
		 * ***********************************************************/
		private function exportExcel():void
		{  
			// Global.getMessageLang(Global.EXPORT_EXCEL_MESSAGE,Global.DEFAULT_LANG)
			Alert.show(Global.getMessageLang(Global.EXPORT_EXCEL_MESSAGE,Global.DEFAULT_LANG),"", (Alert.OK | Alert.CANCEL), null, chooseFileType, null, Alert.OK);
		}
		
		/*************************************************************
		 * Select kind of file type to export
		 * support CSV and XLS file
		 * @author Thuan
		 * @author Duong Pham
		 * ***********************************************************/
		private function chooseFileType(event:CloseEvent):void
		{
			if (event.detail == Alert.OK)
			{
				var filePopup:ExcelFileType=new ExcelFileType();
				filePopup.strDefaultExportFileFilter = datagrid.strDefaultExportFileFilter;
				PopUpManager.addPopUp(filePopup, datagrid);
				PopUpManager.centerPopUp(filePopup);
				filePopup.addEventListener(SAEvent.SELECT_FILE_TYPE, exportExcelHandler);
			}
		}
		
		/*************************************************************
		 * Select a file type
		 * support CSV and XLS file
		 * @author Thuan
		 * @author Duong Pham
		 * ***********************************************************/
		public function exportExcelHandler(event:SAEvent):void 
		{
			if (datagrid.strDefaultExportFileName != "")
			{
				if (datagrid.strDefaultExportFileName.search(/[~\\\/:\*\?"<>\|]/g) < 0)
					excelFileName=datagrid.strDefaultExportFileName;
			}
			//format number
			var file:FileReference=new FileReference();
			file.addEventListener(Event.COMPLETE, saveFileCompleteHandler)
			file.addEventListener(Event.SELECT, selectSaveFileHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, errorSaveFileHandler);
			var _txtByte:ByteArray = new ByteArray();
			if (event.fileType == "xls")
			{
				var xlsStr:String= datagrid.convertDGToHTMLTable();
				var strFileName:String = excelFileName + ".xls"; 
				file.save(xlsStr, strFileName);		
			}
			else //csv
			{
				var str:String=datagrid.makeCSVData();					
				if(datagrid.excelExportInfo.bCharset)
				{
					_txtByte.writeUTFBytes(str);
					//_txtByte.writeMultiByte(str,"utf8");  //euc-kr  for korean
					file.save(_txtByte, excelFileName + ".csv");
				}
				else
					file.save(str, excelFileName + ".csv");
			}
		}
		
		/*************************************************************
		 * Select to save that file
		 * support CSV and XLS file
		 * @author Thuan
		 * @author Duong Pham
		 * ***********************************************************/
		private function selectSaveFileHandler(event:Event):void
		{
			//this.showBusyBar("waiting");
			CursorManager.setBusyCursor();
		}
		
		/*************************************************************
		 * Save file completed
		 * support CSV and XLS file
		 * @author Thuan
		 * @author Duong Pham
		 * ***********************************************************/
		private function saveFileCompleteHandler(event:Event):void
		{
			//this.closeBusyBar(); 
			CursorManager.removeBusyCursor();
			//			Alert.show("Export successfully.", "Information", Alert.OK);
			if(datagrid.eventArr.hasOwnProperty(SAEvent.ON_END_FILE_EXPORT))
			{
				datagrid.dispatchEvent(new SAEvent(SAEvent.ON_END_FILE_EXPORT, true));
			}
		}
		
		/*************************************************************
		 * save file to see some problems
		 * support CSV and XLS file
		 * @author Thuan
		 * @author Duong Pham
		 * ***********************************************************/
		private function errorSaveFileHandler(event:IOErrorEvent):void
		{
			//this.closeBusyBar();
			CursorManager.removeBusyCursor();
		}
		
		/*************************************************************
		 * Import AdvancedDataGrid to Excel
		 * @author Thuan
		 * ***********************************************************/
		public function excelImport(strPath:String, strColumnKeyList:String, strImportValidate:String, bIgnoreHeader:Boolean, bTrimBottom:Boolean, bCharset:Boolean = true, dateInputFormat:String=""):void
		{
			try
			{
				//save condition to export data
				this.datagrid.strImportColumnKeyList=strColumnKeyList;
				this.datagrid.bTrimBottom=bTrimBottom;
				this.datagrid.bIgnoreHeaderImport=bIgnoreHeader;
				this.datagrid.bCharset = bCharset;
				this.datagrid.dateExcelImportFormat=dateInputFormat;
				//show popup to select file for importting
				Alert.show(Global.getMessageLang(Global.IMPORT_EXCEL_MESSAGE,Global.DEFAULT_LANG), Global.getMessageLang(Global.IMPORT_EXCEL_TITLE,Global.DEFAULT_LANG), Alert.OK | Alert.CANCEL, this.datagrid, selectFileToImport, null, Alert.OK);
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"excelImport");
			}
		}
		
		/*************************************************************
		 * select file to import	 
		 * ***********************************************************/
		public function selectFileToImport(e:CloseEvent):void
		{
			if (e.detail == Alert.OK)
			{
				var fileManager:FileManager=new FileManager(this.datagrid);
				fileManager.strColumnKeyList=this.datagrid.strImportColumnKeyList;
				fileManager.bIgnoreHeader=datagrid.bIgnoreHeaderImport;
				fileManager.bTrimBottom=datagrid.bTrimBottom;
				fileManager.bCharset = this.datagrid.bCharset;
				fileManager.dateImportFormat=this.datagrid.dateExcelImportFormat;
				fileManager.importFile();
			}
		}
		
		/*************************************************************
		 * set text align of image in image text 
		 * @author Duong Pham
		 * ***********************************************************/
		public function setImagetextAlign(strColumnKey:String, strAlign:String):void
		{
			try
			{
				if (this.datagrid.dataFieldIndex[strColumnKey] == null)
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(strColumnKey) as ExAdvancedDataGridColumn;
				col.public::setStyle("imageTextAlign", strAlign);					
				this.datagrid.invalidateList();					
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setImagetextAlign");
			}
		}
		
		/*************************************************************
		 * set focus for specified cell
		 * @author Duong Pham
		 * ***********************************************************/
		public function setCellFocus(strColumnKey:String,nRow:int,bEditmode:Boolean):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(strColumnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				
				if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
					err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);								
				
				// change selection mode to selectCell
				if(!this.datagrid.selectCell)
				{
					this.datagrid.selectCell = true;
					datagrid.selectionMode = "multipleCells";
				}
				
				this.scrollToIndex(nRow);
				this.datagrid.endEditCell(ExAdvancedDataGridEventReason.OTHER);
				
				var item:Object=this.datagrid.getBackupItem(nRow);
				nRow = this.datagrid.getItemIndex(item);	
				var colIndex:int = this.datagrid.dataFieldIndex[strColumnKey];
				var col:ExAdvancedDataGridColumn = this.datagrid.columns[colIndex] as ExAdvancedDataGridColumn;
				this.datagrid._selectedColIndex = colIndex;
				this.datagrid._selectedRowIndex = nRow;
				ExternalInterface.call("setFocusCell");
				if(bEditmode)
				{								
					if(col.editable)
					{
						if(!this.datagrid.isEditable)
						{
							this.datagrid.isEditable = true;
							this.datagrid.editable = "all";
						}
						this.datagrid.editedItemPosition = {columnIndex:colIndex,rowIndex:nRow};
						this.datagrid.setSelectCell(colIndex,nRow);
					}
					else
					{
						this.datagrid.setSelectCell(colIndex,nRow);							
					}
				}
				else
				{					
					this.datagrid.setSelectCell(colIndex,nRow);						
				}
				updateHorizontalScroll(colIndex);
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"setCellFocus");					
			}
		}
		
		/*************************************************************
		 * update horiziontal scroll bar when changing column index
		 * @author Duong Pham
		 * ***********************************************************/
		private function updateHorizontalScroll(colIndex:int):void
		{	
			var numCol:int = 0;
			for each(var col:ExAdvancedDataGridColumn in this.datagrid.columns)
			{
				if(col.visible)
					numCol ++;
			}				 
			var displayNumCol:int = numCol - this.datagrid.maxHorizontalScrollPosition;
			var position:int = colIndex - displayNumCol + 1;				
			if(position > 0)
				this.datagrid.horizontalScrollPosition=position;
			else
				this.datagrid.horizontalScrollPosition=0;				
		}
		
		/*************************************************************
		 * set group merge
		 * @param strColumnKeyList String
		 * @ author Duong Pham
		 * ***********************************************************/
		public function setGroupMerge(strColumnKeyList:String):void
		{
			try
			{
				if(this.datagrid.summaryBarManager.hasSummaryBar()) 
					this.datagrid.summaryBarManager.clearSummaryBar();
				if (!datagrid.isTree)
				{
					if (strColumnKeyList == null || strColumnKeyList == "")
						err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
					
					//save old value before setting group merge 
					
					this.datagrid.isDraggableCol = datagrid.draggableColumns;
					this.datagrid.orignalStrHDClickAction = datagrid.strHDClickAction;
					
					//require condition:
					this.datagrid.draggableColumns = false; 
					this.datagrid.strHDClickAction = "select";
					//set group merge
					var columnKeyList:Array=strColumnKeyList.split(',');	
					var col:ExAdvancedDataGridColumn;
					for each (var columnKey:String in columnKeyList)
					{
						if (StringUtil.trim(columnKey).length > 0)
						{
							col = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
							col.editable = false;//remove icon for combobox when set group merge
							//this.setColCellMerge(columnKey, true);
							col.merge = true;
						}
					}
					//add to list
					this.datagrid.summaryBarManager.columnMergeList=strColumnKeyList;
					this.datagrid.getGroupMergeInfo();
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setGroupMerge");		
			}
		}
		
		/*******************************************************6******
		 * check column is merged or not
		 * @author: Duong Pham
		 * ***********************************************************/
		public function isGroupMergeColumn(columnKey:String): Boolean
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(columnKey))
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);	
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				return col.merge;					
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"isGroupMergeColumn");					
			}
			return false;
		}
		
		
		/*******************************************************6******
		 * get group cell merge infor. it will get mergeOwnerRow index of all columns merge in DataGrid.
		 * @param columnKey String
		 * @author: Chheavhun
		 * ***********************************************************/
		public function  getCellGroupMergeInfo(columnKey:String,row:int):Array
		{
			 
				var selItem:Array=new Array();
				var item:int;
				var colIndex:int=this.datagrid.dataFieldIndex[columnKey];
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col.merge)
				{
					  var mergedCell:MergeCellInfo = this.datagrid.getMergeCell(row,colIndex);
					 if (!mergedCell)
						  selItem.push(row); 
					 else
					 {
						 var i:int=0;
						 for (i;i<mergedCell.mergeNum;i++)
						 {
							 selItem.push( mergedCell.mergeOwnerRow + i);
						 }
					 }
				}
				else
				{
					selItem.push(row);  
				}
			return selItem;
		}
		
		/*******************************************************6******
		 * check grid that has group merge or not
		 * @author Duong Pham
		 * ***********************************************************/
		public function hasGroupMerge(): Boolean
		{
			var result : Boolean = false;
			for each (var col:ExAdvancedDataGridColumn in this.datagrid.columns)
			{
				if (col.merge)
				{
					result =true;
					break;
				}
			}
			return result;
		}
		
		/*******************************************************6******
		 * clear group merge
		 * @author Duong Pham
		 * ***********************************************************/
		public function clearGroupMerge():void  
		{
			try
			{
				if(this.datagrid.summaryBarManager && datagrid.summaryBarManager.hasSummaryBar())
				{
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_EXIST, Global.DEFAULT_LANG);
				}
				for each (var col:ExAdvancedDataGridColumn in this.datagrid.columns)
				{
					if (col.merge)
						col.merge = false;
				}	
				
				datagrid.mergeCells = null;
				datagrid.lstMergeColumn = null;
				this.datagrid.draggableColumns = this.datagrid.isDraggableCol;
				this.datagrid.strHDClickAction = this.datagrid.orignalStrHDClickAction;
				this.datagrid.invalidateList();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"clearGroupMerge");					
			}
		}
		
		/*************************************************************
		 * add summary bar
		 * author Duong Pham
		 * ***********************************************************/
		public function addSummaryBar(strSummaryBarKey:String, strText:String, strMergeColumn:String, strFunc:String, strColumnList:String,position:String="bottom"):void
		{
			try 
			{
				if(datagrid.dataProvider == null)
					err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				if(strColumnList== null || strColumnList.length == 0)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID,Global.DEFAULT_LANG);
				if(strSummaryBarKey.length ==0 ) 
					err.throwError(ErrorMessages.ERROR_SUMMARY_KEY_INVALID,Global.DEFAULT_LANG); 
				
				if(this.datagrid.summaryBarManager.isExistSummaryKey(strSummaryBarKey,this.datagrid.lstSummaryBar))
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_HAS_EXIST,Global.DEFAULT_LANG); 
				
				var listColumn:Array = strColumnList.split(',');
				var t:int;
				if(position == "right")
				{
					if(strMergeColumn  != SummaryBarConstant.SUMMARYALL)
						err.throwError(ErrorMessages.ERROR_MERGE_INVALID,Global.DEFAULT_LANG);
					
					for (t = 0; t < listColumn.length; t++) 
					{
						if(this.datagrid.dataFieldIndex[listColumn[t]] <= -1)
						{
							err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
							break;
						}
						if(this.datagrid.columns[this.datagrid.dataFieldIndex[listColumn[t]]].type != ColumnType.NUMBER)
						{
							err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
							break;
						}
					}
					
					this.datagrid.summaryBarManager.addSummaryBar(strSummaryBarKey, strText, strMergeColumn, strFunc, strColumnList,position);
				}
				else
				{
					//build list column merge
					this.datagrid.summaryBarManager.buildListColMerge();
					
					//check if col merge is valid
					if(strMergeColumn  != SummaryBarConstant.SUMMARYALL)
					{
						if(!this.datagrid.summaryBarManager.isValidColMerge(strMergeColumn,datagrid.lstMergeColumn))
						{
							err.throwError(ErrorMessages.ERROR_MERGE_INVALID,Global.DEFAULT_LANG);
						}
					}
					
					if(strMergeColumn != SummaryBarConstant.SUMMARYALL && datagrid.dataFieldIndex[strMergeColumn]==null)
						err.throwError(ErrorMessages.ERROR_MERGE_INVALID,Global.DEFAULT_LANG);
					
					for (t = 0; t < listColumn.length; t++) 
					{
						if(this.datagrid.dataFieldIndex[listColumn[t]] <= -1)
						{
							err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
							break;
						}
						if(listColumn[t] == strMergeColumn)
						{
							err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
							break;
						}
						
						//prevent merge column in colkey list
						if(strMergeColumn  != SummaryBarConstant.SUMMARYALL)
						{
							for(var j:int=0; j<this.datagrid.lstMergeColumn.length; j ++)
							{
								if(this.datagrid.lstMergeColumn[j] == listColumn[t])
								{									
									var indexOfMergedColOfSummary:int = this.datagrid.lstMergeColumn.getItemIndex(strMergeColumn);
									if(j <= indexOfMergedColOfSummary)
									{
										err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
										break;
									}
								}
							}
						}
						
					}
					//check if column merge of summary bar key has been exist, if yes replace and remove old
					if(strMergeColumn != SummaryBarConstant.SUMMARYALL) 
					{
						this.datagrid.summaryBarManager.removeOldSummarBar(strMergeColumn);
					}
					this.datagrid.summaryBarManager.clearSort();
					this.datagrid.summaryBarManager.addSummaryBar(strSummaryBarKey, strText, strMergeColumn, strFunc, strColumnList,position);
					this.datagrid.summaryBarManager.resetSort();
					if(this.datagrid.hasSubTotal)
					{
						this.datagrid.getGroupMergeInfo();
						this.datagrid.invalidateList();
					}
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"addSummaryBar");					
				return;
			}
		}
		
		/*************************************************************
		 * clear summary bar
		 * @author Duong Pham
		 * ***********************************************************/
		public function clearSummaryBar():void
		{
			if(this.datagrid.summaryBarManager.hasSummaryBar())
				this.datagrid.summaryBarManager.clearSummaryBar();	
		}
		
		/*************************************************************
		 * get summary bar value		 
		 * @author: Duong Pham
		 * ***********************************************************/
		public function getSummaryBarValue(strSummaryBarKey:String, strColumnKey:String, nMergeIndex:Number, bDataFormat:Boolean=true):String
		{
			try
			{
				var returnValue : String ;
				var item : Object;
				if(this.datagrid.lstSummaryBar == null)
					err.throwError(ErrorMessages.ERROR_NO_SUMMARY_BAR, Global.DEFAULT_LANG);
				
				var isExistedSummaryBar : Boolean = this.datagrid.summaryBarManager.isExistSummaryKey(strSummaryBarKey,this.datagrid.lstSummaryBar);
				
				//check if this is a total, subtotal
				if(!isExistedSummaryBar)
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_NOT_EXIST,Global.DEFAULT_LANG);
				
				if(!this.datagrid.summaryBarManager.isInvalidColumnKey(this.datagrid.lstSummaryBar[strSummaryBarKey],strColumnKey))
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				
				var summaryBarType:String = this.datagrid.summaryBarManager.getSummaryBarType(strSummaryBarKey);
				
				var index : int;
				var count : int = -1;
				var column : ExAdvancedDataGridColumn;
				if(summaryBarType == "total")		//total
				{
					returnValue = this.datagrid.summaryBarManager.getSummaryBarValueForTotal(strSummaryBarKey, strColumnKey, nMergeIndex,bDataFormat);
				}
				else if(summaryBarType == "subtotal")		//subtotal
				{
					returnValue = this.datagrid.summaryBarManager.getSummaryBarValueForSubTotal(strSummaryBarKey, strColumnKey, nMergeIndex,bDataFormat);
				}
				else		//total column
				{
					returnValue = this.datagrid.summaryBarManager.getSummaryBarValueForTotalColumn(strSummaryBarKey, strColumnKey, nMergeIndex,bDataFormat);
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getSummaryBarValue");
			}
			return returnValue;
		}
		
		/*************************************************************
		 * set summary bar color
		 * @author Duong Pham
		 * ***********************************************************/
		public function setSummaryBarColor(strSummaryBarKey:String, strFgColor:String, strBgColor:String):void
		{
			try 
			{
				if(this.datagrid.lstSummaryBar == null)
					err.throwError(ErrorMessages.ERROR_NO_SUMMARY_BAR, Global.DEFAULT_LANG);
				
				//check if this is a total, subtotal
				var isExistedSummaryBar : Boolean = this.datagrid.summaryBarManager.isExistSummaryKey(strSummaryBarKey,this.datagrid.lstSummaryBar);
				
				//check if this is a total, subtotal
				if(!isExistedSummaryBar)
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_NOT_EXIST,Global.DEFAULT_LANG);
				
				var summaryBarType:String = this.datagrid.summaryBarManager.getSummaryBarType(strSummaryBarKey);
				
				if(summaryBarType == "total") // total
				{
					this.datagrid.summaryBarManager.setSummaryBarColor(strSummaryBarKey, strFgColor, strBgColor, true);
				}
				else if(summaryBarType == "subtotal")   //sub total
				{
					this.datagrid.summaryBarManager.setSummaryBarColor(strSummaryBarKey, strFgColor, strBgColor , false);
				}
				else
				{
					var summaryBar:SummaryBar = this.datagrid.lstSummaryBar[strSummaryBarKey];
					setColCellBgColor(summaryBar.totalColDataField,strBgColor);
					setColCellFgColor(summaryBar.totalColDataField,strFgColor);
				}
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setSummaryBarColor");					
			}
		}
		
		/*************************************************************
		 * set summary bar font
		 * @author Duong Pham
		 * ***********************************************************/
		public function setSummaryBarFont(strSummaryBarKey:String, strName:String, nSize:Number, bBold:Boolean, bItalic:Boolean, bUnderLine:Boolean, bCenterLine:Boolean, columnKey : String=null):void
		{
			try
			{
				if(this.datagrid.lstSummaryBar == null && this.datagrid.lstSummaryBar == null)
					err.throwError(ErrorMessages.ERROR_NO_SUMMARY_BAR, Global.DEFAULT_LANG);
				
				//check if this is a total, subtotal
				var isExistedSummaryBar : Boolean = this.datagrid.summaryBarManager.isExistSummaryKey(strSummaryBarKey,this.datagrid.lstSummaryBar);
				
				//check if this is a total, subtotal
				if(!isExistedSummaryBar)
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_NOT_EXIST,Global.DEFAULT_LANG);
				
				if(isNaN(nSize))
					err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA,Global.DEFAULT_LANG);
				
				var summaryBarType:String = this.datagrid.summaryBarManager.getSummaryBarType(strSummaryBarKey);
				
				var fontFamily : String;
				var fontSize : String;
				var fontWeight : String;
				var fontStyle : String ;
				var fontULine : String;
				
				if (strName != null || strName != "")
					fontFamily = strName;
				if (!isNaN(nSize))
					fontSize = nSize.toString();
				if (bBold) 
					fontWeight = "bold";
				else
					fontWeight = "normal";
				if (bItalic)
					fontStyle = "italic";
				else
					fontStyle =  "normal";
				
				if (bUnderLine)
					fontULine = "underline"; 
				else
					fontULine = "none";
												
				if(summaryBarType == "total") // total
				{
					this.datagrid.summaryBarManager.setSummaryBarFont(strSummaryBarKey, fontFamily,fontSize,fontWeight,fontStyle,fontULine,bCenterLine , true, columnKey);
				}
				else if(summaryBarType == "subtotal")  //sub total
				{
					this.datagrid.summaryBarManager.setSummaryBarFont(strSummaryBarKey, fontFamily,fontSize,fontWeight,fontStyle,fontULine,bCenterLine ,false, columnKey);
				}
				else
				{
					var summaryBar:SummaryBar = this.datagrid.lstSummaryBar[strSummaryBarKey];
					setColCellFont(summaryBar.totalColDataField,fontFamily,nSize,bBold,bItalic,bUnderLine,bCenterLine);
				}
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setSummaryBarFont");					
			}
		}
		
		/*************************************************************
		 * set summary bar format
		 * @author: Duong Pham
		 * ***********************************************************/
		public function setSummaryBarFormat(strSummaryBarKey:String, strColumnKey:String, strFormat:String):void
		{
			try
			{
				if(this.datagrid.lstSummaryBar == null)
					err.throwError(ErrorMessages.ERROR_NO_SUMMARY_BAR, Global.DEFAULT_LANG);
				
				//check if this is a total, subtotal
				var isExistedSummaryBar : Boolean = this.datagrid.summaryBarManager.isExistSummaryKey(strSummaryBarKey,this.datagrid.lstSummaryBar);
				
				//check if this is a total, subtotal
				if(!isExistedSummaryBar)
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_NOT_EXIST,Global.DEFAULT_LANG);
				
				var summaryBarType:String = this.datagrid.summaryBarManager.getSummaryBarType(strSummaryBarKey);
				
				if(summaryBarType == "total")	//total
					this.datagrid.summaryBarManager.setSummaryBarFormat(strSummaryBarKey, strColumnKey, strFormat);
				else if(summaryBarType == "subtotal")		 //sub total
					this.datagrid.summaryBarManager.setSummaryBarFormat(strSummaryBarKey, strColumnKey, strFormat);
				else
				{
					var summaryBar:SummaryBar = this.datagrid.lstSummaryBar[strSummaryBarKey];
					this.datagrid.summaryBarManager.setSummaryBarFormat(strSummaryBarKey, summaryBar.totalColDataField, strFormat);
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setSummaryBarFormat");					
			} 
		}
		
		/*************************************************************
		 * set summary bar function
		 * @param strSummaryBarKey String
		 * @param strColumnKey String
		 * @param strFormat String
		 * @author Duong Pham
		 * ***********************************************************/
		public function setSummaryBarFunction(strSummaryBarKey:String, strFunc:String, strColumnKey:String):void
		{
			try
			{
				if(this.datagrid.lstSummaryBar == null)
					err.throwError(ErrorMessages.ERROR_NO_SUMMARY_BAR, Global.DEFAULT_LANG);
				//check if this is a total, subtotal, total column
				var isExistedSummaryBar : Boolean = this.datagrid.summaryBarManager.isExistSummaryKey(strSummaryBarKey,this.datagrid.lstSummaryBar);
				//check if this is a total, subtotal, total column
				if(!isExistedSummaryBar)
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_NOT_EXIST,Global.DEFAULT_LANG);
				
				if(!(strFunc.toUpperCase() == "SUMMARRYALL" || strFunc.toUpperCase() == "COUNT" || strFunc.toUpperCase() == "SUM" || strFunc.toUpperCase() == "AVERAGE"))
					err.throwError(ErrorMessages.ERROR_INVALID_SUMMARY_BAR_FUNCTION,Global.DEFAULT_LANG);
				
				var summaryBarType:String = this.datagrid.summaryBarManager.getSummaryBarType(strSummaryBarKey);
				
				if(!((this.datagrid.lstSummaryBar[strSummaryBarKey] as SummaryBar).strFunction == 'custom'))
				{
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_VALUE, Global.DEFAULT_LANG);
				}
				if((this.datagrid.lstSummaryBar[strSummaryBarKey] as SummaryBar).functionList[strColumnKey] == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				
				var summaryBar:SummaryBar = this.datagrid.lstSummaryBar[strSummaryBarKey] as SummaryBar;
				var positionTotalChange : Dictionary;
				if(summaryBar.position == "right")
				{
					summaryBar.strFunction = strFunc;
					positionTotalChange = (datagrid.columns[datagrid.dataFieldIndex[summaryBar.totalColDataField]] as ExAdvancedDataGridColumn).positionTotalChange;
				}
				else
				{
					if(summaryBar.functionList == null)
						summaryBar.functionList = new Dictionary();
					var column:ExAdvancedDataGridColumn =  (datagrid.columns[datagrid.dataFieldIndex[strColumnKey]] as ExAdvancedDataGridColumn);
					if(column.type != ColumnType.NUMBER)
					{
						strFunc = SummaryBarConstant.FUNC_COUNT;
					}
					summaryBar.functionList[strColumnKey] = strFunc;
					positionTotalChange = column.positionTotalChange;
				}
				this.datagrid.summaryBarManager.removeCustomSummaryBarValue(strSummaryBarKey,positionTotalChange);
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setSummaryBarFunction");					
			}
		}
		
		/*************************************************************
		 * set summary bar text
		 * @author Duong Pham
		 * ***********************************************************/
		public function setSummaryBarText(strSummaryBarKey:String, strText:String):void
		{
			try
			{
				if(this.datagrid.lstSummaryBar == null)
					err.throwError(ErrorMessages.ERROR_NO_SUMMARY_BAR, Global.DEFAULT_LANG);
				
				//check if this is a total, subtotal
				var isExistedSummaryBar : Boolean = this.datagrid.summaryBarManager.isExistSummaryKey(strSummaryBarKey,this.datagrid.lstSummaryBar);
				
				//check if this is a total, subtotal
				if(!isExistedSummaryBar)
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_NOT_EXIST,Global.DEFAULT_LANG);
				
				var summaryBarType:String = this.datagrid.summaryBarManager.getSummaryBarType(strSummaryBarKey);
				
				this.datagrid.summaryBarManager.setSummaryBarText(strSummaryBarKey, strText,summaryBarType);
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setSummaryBarText");					
				return;
			}			
		}
		
		/*************************************************************
		 * set summary bar function
		 * @author Duong Pham
		 * ***********************************************************/
		public function setSummaryBarValue(strSummaryBarKey:String, strColumnKey:String, nMergeIndex:Number, strValue:String):void
		{
			try
			{
				if(this.datagrid.lstSummaryBar == null)
					err.throwError(ErrorMessages.ERROR_NO_SUMMARY_BAR, Global.DEFAULT_LANG);
				
				//check if this is a total, subtotal
				var isExistedSummaryBar : Boolean = this.datagrid.summaryBarManager.isExistSummaryKey(strSummaryBarKey,this.datagrid.lstSummaryBar);
				
				//check if this is a total, subtotal
				if(!isExistedSummaryBar)
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_NOT_EXIST,Global.DEFAULT_LANG);
				
				if(!this.datagrid.summaryBarManager.isInvalidColumnKey(this.datagrid.lstSummaryBar[strSummaryBarKey],strColumnKey))
				{
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				if(!((this.datagrid.lstSummaryBar[strSummaryBarKey] as SummaryBar).strFunction == 'custom'))
				{
					err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_VALUE, Global.DEFAULT_LANG);
				}
				
				var summaryBarType:String = this.datagrid.summaryBarManager.getSummaryBarType(strSummaryBarKey);
				
				if(summaryBarType == "subtotal")		//sub total
				{
					if(isNaN(Number(nMergeIndex)))
					{
						err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_INDEX_INVALID, Global.DEFAULT_LANG);
					} 
					if(nMergeIndex < -1)
					{
						err.throwError(ErrorMessages.ERROR_SUMMARY_BAR_INDEX_INVALID, Global.DEFAULT_LANG);
					}
				}
				this.datagrid.summaryBarManager.setSummaryBarValue(strSummaryBarKey, strColumnKey, nMergeIndex, strValue, summaryBarType);
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setSummaryBarValue");					
			}			
		}
		
		/*************************************************************
		 * set column excel with asterisk character file function
		 * @param strColumnKey : String, nStartIndex : int, nCount : int
		 * author: Hoang Pham
		 * ***********************************************************/
		public function setColCellExcelAsterisk(strColumnKey:String, nStartIndex:int, nCount:int):void
		{
			this.setColumnProperty(strColumnKey, "replacedStartIndex", nStartIndex);
			this.setColumnProperty(strColumnKey, "replacedLength", nCount);
		}
		
		/*************************************************************
		 * set header excel file function
		 * @param strTitle : String ,nHeigh : int, nFontSize : int, strAlign : String
		 * author Thuan
		 * ***********************************************************/
		public function setExcelHeader(strTitle:String, nHeigh:int, nFontSize:int, strAlign:String, strBottom:String=''):void
		{
			this.datagrid.styleHeader = new StyleHeader();
			this.datagrid.styleHeader.data = strTitle;
			this.datagrid.styleHeader.row_height = nHeigh;
			this.datagrid.styleHeader.font_size = nFontSize;
			this.datagrid.styleHeader.text_align = strAlign;
			if (strBottom.length > 0)
			{
				var data:Array = strBottom.split('%%');
				this.datagrid.subHeaderStyle = new Array();
				for (var i:int=0; i < data.length; i++)
				{
					var temp:StyleHeader = new StyleHeader();
					temp.data = data[i].toString();
					this.datagrid.subHeaderStyle[i] = temp;
				}
			}
		}
		
		/*************************************************************
		 * set footer excel file function
		 * @param strTitle : String ,nHeigh : int, nFontSize : int, strAlign : String
		 * author Thuan
		 * ***********************************************************/
		public function setExcelFooter(strTitle:String, nHeigh:int, nFontSize:int, strAlign:String):void
		{
			this.datagrid.styleFooter = new StyleFooter();
			this.datagrid.styleFooter.data = strTitle;
			this.datagrid.styleFooter.row_height = nHeigh;
			this.datagrid.styleFooter.font_size = nFontSize;
			this.datagrid.styleFooter.text_align = strAlign;
		}
		
		/*************************************************************
		 * clear excel file info function
		 * author Thuan
		 * ***********************************************************/
		public function clearExcelInfo():void
		{
			this.datagrid.styleHeader=null;
			this.datagrid.styleFooter=null;
		}
		/*************************************************************
		 * lose focus
		 * @author Duong Pham
		 * ***********************************************************/
		public function loseFocus():void
		{
			this.datagrid.endEditCell(ExAdvancedDataGridEventReason.OTHER);
			this.datagrid.focusManager.deactivate();
			this.datagrid.selectedIndex = -1;
 
		}
		
		/*************************************************************
		 * get text data
		 * @author Duong Pham
		 * ***********************************************************/
		public function getTextData(hasColumnDataField:Boolean=false):String
		{
			var returnVal:String='';
			//get column data field
			var cols:Array=this.datagrid.columns;
			var colStr:String='';
			
			for (var i:int=0; i < cols.length; i++)
			{
				var col:ExAdvancedDataGridColumn=cols[i] as ExAdvancedDataGridColumn;
				if (col.type != ColumnType.AUTONUMBER)
				{
					if (i != cols.length - 1)
						colStr=colStr + col.dataField + DataGridManager.columnSeparator;
					else
						colStr=colStr + col.dataField + DataGridManager.rowSeparator;
				}
			}
			
			//get row data
			var datas:Object=this.datagrid.dataProvider;
			var dataStr:String='';
			
			for (var j:int=0; j < datas.length; j++)
			{
				var obj:Object=datas[j];
				for (var jj:int=0; jj < cols.length; jj++)
				{
					var dcol:ExAdvancedDataGridColumn=cols[jj] as ExAdvancedDataGridColumn;
					if (dcol.type != ColumnType.AUTONUMBER)
					{
						if (obj[dcol.dataField] == undefined)
							obj[dcol.dataField]='';
						if(datagrid.bUpdateNullToZero && dcol.type == ColumnType.NUMBER && 
							(obj[dcol.dataField] == undefined || obj[dcol.dataField] == null || obj[dcol.dataField] == ""))
						{
							obj[dcol.dataField]='0';
						}
//						if (dcol.type == ColumnType.CHECKBOX || dcol.type == ColumnType.RADIOBUTTON)
//							obj[dcol.dataField]='N';
						
						if (jj != cols.length - 1)
							dataStr=dataStr + obj[dcol.dataField] + DataGridManager.columnSeparator;
						else
							dataStr=dataStr + obj[dcol.dataField] + DataGridManager.rowSeparator;
					}
					else
					{
						dataStr=dataStr + "" + DataGridManager.columnSeparator;
					}
				}
			}
			
			if (hasColumnDataField)
				returnVal=colStr + dataStr;
			else
				returnVal=dataStr;
			
			return returnVal;

		}
		
		/*************************************************************
		 * get datafield by visible column index
		 * @author Duong Pham
		 * ***********************************************************/
		public function getDataFieldVisibleByIndex(visibleIndex:int):String
		{
			var dataField:String = "";
			var index:int = -1;
			if(this.datagrid.columns.length > 0)
			{
				for each(var col:ExAdvancedDataGridColumn in this. datagrid.columns)
				{
					if(col.visible)
					{
						index++;
						if(index == visibleIndex)
						{
							dataField = col.dataField;
							break;
						}
					}
				}
			}
			return dataField;
		}
		
		/*************************************************************
		 * create row data to test performance
		 * @author Duong Pham
		 * ***********************************************************/
		public function generateTestData(numRows:int,numCols:int,isNormal:Boolean=true):void
		{
			CursorManager.setBusyCursor();
			if(datagrid.dataProvider && datagrid.dataProvider.length > 0)
				datagrid.dataProvider = null;
			//create data
			var rowData:String="";
			var i:int;
			var j:int;
			var index:int=0;
			var provider:ArrayCollection = new ArrayCollection();
			var obj:Object;
			if(isNormal)
			{
				for ( i=0; i < numRows; i++)
				{		
					obj = new Object();
					obj['col0'] = "0";				
					obj['col1'] = "(" + i + ",1)";
					obj['col1_index']= 0;
					obj['col2'] = (i+1)+"000";
					obj['col3'] = (i+1) * 2;
					obj['col4'] = (i+1) * 3;
					for (j = 5; j < numCols; j++)
					{	
						obj['col'+j] = "(" + i + "," + j + ")";
					}
					provider.addItem(obj);
				}
			}
			else
			{
				for ( i=0; i < numRows; i++)
				{		
					obj = new Object();
					obj['col0'] = "0";				
					obj['col1'] = (i+1)*4 +"000";
					obj['col2'] = (i+1)+"000";
					obj['col3'] = (i+1) * 2;
					obj['col4'] = (i+1) * 3;
					for (j = 5; j < numCols; j++)
					{	
						obj['col'+j] = "(" + i + "," + j + ")";
					}
					provider.addItem(obj);
				}
			}
			datagrid.dataProvider = provider;
			gridoneManager.bkDataProvider(provider);
			gridoneManager.updateExternalVerticalScroll(provider.length);
			CursorManager.removeBusyCursor();
		}
		
		/*************************************************************
		 * get real index (include visible index and invisible index) from the visible index
		 * @param visibleIndex int
		 * @return int
		 * @author Duong Pham
		 * ***********************************************************/
		public function getRealIndexByVisibleIndex(visibleIndex:int):int
		{
			var realIndex:int = -1;
			for each(var col:ExAdvancedDataGridColumn in this.datagrid.columns)
			{
				if(col.visible)
					realIndex ++;
				if(realIndex == visibleIndex)
					break;
			}
			return this.datagrid.dataFieldIndex[col.dataField];
		}
		
		/*************************************************************
		 * insert a specified column for grid
		 * @param columnKey column dataField 
		 * @param columnText header text
		 * @param columnType column type: combo, text, calendar...
		 * @param maxLength length of text in a cell, or length of a number
		 * @param columnWidth column width
		 * @param editable indicate whether column is editable or not
		 * @return ExAdvancedDataGridColumn
		 * ***********************************************************/
		public function insertColumn(columnKey:String, columnText:String, columnType:String, maxLength:String, columnwidth:String, editable:Boolean,parentDataField:String,insertAt:String):ExAdvancedDataGridColumn
		{		
			try
			{
				if(this.datagrid.dataFieldIndex[columnKey])
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				var insertedCol:ExAdvancedDataGridColumn=new ExAdvancedDataGridColumn();
				insertedCol.minWidth=0;
				insertedCol.dataField=columnKey;
				insertedCol.headerText=columnText;				
				insertedCol.editable = editable;			
				insertedCol.parent=parentDataField;
				if (editable)
					insertedCol.cellActivation=Global.ACTIVATE_EDIT;
				else
					insertedCol.cellActivation=Global.ACTIVATE_ONLY;
				
				if (columnwidth.charAt(columnwidth.length - 1) == "%")
				{
					insertedCol.percentWidth=columnwidth;
				}
				else
				{
					insertedCol.width=parseInt(columnwidth);
				}
				
				datagrid.totalVisibleColumnWidth += parseInt(columnwidth);
				
				insertedCol.orginalMaxLength=maxLength;		
				
				if (Number(maxLength) < 0 ) //Process for using big number
				{
					if(columnType.toUpperCase() == ColumnType.NUMBER)
					{
						var arr:Array = maxLength.toString().split(".");
						var precLength: int = -1;
						if (arr.length > 1)
							precLength = parseInt(arr[1]);
						insertedCol.precision = precLength;
						insertedCol.checkPrecision = precLength;
						insertedCol.maxValue = Number.MAX_VALUE;	
					}
				}
				else if (parseInt(maxLength) >= 0)
				{
					if(columnType.toUpperCase() == ColumnType.NUMBER)
					{
						var precisionLength:int=parseInt(maxLength.toString().split(".")[1]);
						var numberLength:int=parseInt(maxLength.toString().split(".")[0]);
						if(numberLength==0)
							insertedCol.maxValue = Math.pow(10, numberLength) - Math.pow(0.1, precisionLength+1);
						insertedCol.precision = precisionLength;
						insertedCol.checkPrecision=precisionLength;
					}
					else
					{
						insertedCol.maxLength=parseInt(maxLength);
						insertedCol.editorMaxChars=parseInt(maxLength);	
					}
				}
				insertedCol.type=columnType.toUpperCase();
				dgManager.setItemRenderer(insertedCol,insertedCol.type,false);	
				_columnCount += 1;
				var col:ExAdvancedDataGridColumn;
				var listColumns:ArrayCollection;
				var insertAtPosition:int;
				if(!isNaN(parseInt(insertAt)))
				{
					insertAtPosition = parseInt(insertAt);
				}
				else
				{
					insertAtPosition = this.datagrid.dataFieldIndex[insertAt];
				}
				var realIndex:int = getRealIndexByVisibleIndex(insertAtPosition);
				col = this.datagrid.columns[realIndex];
				var i:int=0;
				//insert column into datagrid
				if(datagrid._isGroupedColumn)
				{
					updateColumnPositionInGroupColumn(insertedCol,realIndex,false);
				}
				else
				{
					listColumns = new ArrayCollection( this.datagrid.columns);
					listColumns.addItemAt(insertedCol,insertAtPosition);
					this.datagrid.columns = listColumns.toArray();
					//update dataFieldIndex
					this.datagrid.dataFieldIndex = new Object();
					for (i=0; i < listColumns.length; i++)
					{
						this.datagrid.dataFieldIndex[listColumns[i].dataField]=i;
					}	
				}
				gridoneManager.updateExternalHorizontalScroll();
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"insertColumn");	
			}
			return insertedCol;	
		}
		
		/*************************************************************
		 * The function get data of client grid 
		 * @param type kind of data which want to get
		 * 		A: all
		 * 		If it has CRUD mode, I: Insert ; U:Update; D:Delete
		 * 		Eg: Type can be "A" ; "A+I"; "I+U+D";...
		 * @param visibleType the status of row
		 * 		A: all ( include visible and invisible rows)
		 * 		I: invisible (include invisible rows)
		 * 		V: visible (include visible rows)
		 * @param dataType kind of data which wants to return (text | json)
		 * @author Duong Pham
		 * ***********************************************************/
		public function getClientDataString(type:String="A",visibleType:String="A",dataType:String="text"):String
		{
			try
			{
				var resultData:String="";
				if(type == "" || type == null)
					return resultData;
				// type is "A" or contain "A" => get all datas
				if((type.indexOf("A") >= 0) || (type.indexOf("+") == -1 && type == "A"))
				{
					//there is no + inside
					if(dataType == "text")
						resultData = getTextDataByCondition(this.datagrid._bkDP,false,"A",visibleType);
					else if(dataType == "json")
						resultData = getGridDataByCondition(this.datagrid._bkDP,"getClientDataString",null,"A",visibleType);
				}
				else 
				{
					//in this case CRUD mode is applied with these types such as "I+U" or "I" or "U" or "D" or "I+U+D" ...
					if(this.datagrid.crudMode)
					{
						if(dataType == "text")
							resultData = getTextDataByCondition(this.datagrid._bkDP,false,type,visibleType);
						else if(dataType == "json")
							resultData = getGridDataByCondition(this.datagrid._bkDP,"getClientDataString",null,type,visibleType);				
					}
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getClientDataString");				
			}
			return resultData;
		}
		
		/*************************************************************
		 * get text data according to specified condition
		 * @author Duong Pham
		 * ***********************************************************/
		public function getTextDataByCondition(datas:Object, hasColumnDataField:Boolean=false,type:String="A",visibleType:String="A"):String
		{			
			var returnVal:String='';
			//get column data field
			var cols:Array=this.datagrid.columns;
			var colStr:String='';
			
			for (var i:int=0; i < cols.length; i++)
			{
				var col:ExAdvancedDataGridColumn=cols[i] as ExAdvancedDataGridColumn;
				if (col.type != ColumnType.AUTONUMBER)
				{
					if (i != cols.length - 1)
						colStr=colStr + col.dataField + DataGridManager.columnSeparator;
					else
						colStr=colStr + col.dataField + DataGridManager.rowSeparator;
				}
			}
			
			//get row data			
			//var datas:Object=this.datagrid.dataProvider;
			var dataStr:String='';
			var obj:Object;
			var isMapped:Boolean = false;
			var arrType:Array;
			
			if(type == "A")
				isMapped = true;
			else
				arrType = type.split("+");
			
			for (var j:int=0; j < datas.length; j++)
			{
				if(arrType && arrType.length > 0)
				{
					isMapped = false;
					for(var k:int=0; k<arrType.length; k++)
					{
						if(datas[j][this.datagrid.crudColumnKey] == arrType[k])
						{
							isMapped = true;
							break;
						}
					}
				}
				if(isMapped)
				{
					obj=datas[j];
					//check visible type according to A : all ; V: visible row only; I :invisible row only
					if((visibleType == "I" && obj[Global.ROW_HIDE] == true) 
						|| (visibleType == "V" && (obj[Global.ROW_HIDE] == false || !obj.hasOwnProperty(Global.ROW_HIDE)))
						|| (visibleType == "A"))
					{
						for (var jj:int=0; jj < cols.length; jj++)
						{
							var dcol:ExAdvancedDataGridColumn=cols[jj] as ExAdvancedDataGridColumn;
							if (dcol.type != ColumnType.AUTONUMBER)
							{
								if (obj[dcol.dataField] == undefined)
									obj[dcol.dataField]='';
								if(datagrid.bUpdateNullToZero && dcol.type == ColumnType.NUMBER && 
									(obj[dcol.dataField] == undefined || obj[dcol.dataField] == null || obj[dcol.dataField] == ""))
								{
									obj[dcol.dataField]='0';
								}
								//if (dcol.type == ColumnType.CHECKBOX || dcol.type == ColumnType.RADIOBUTTON)
								//obj[dcol.dataField]='N';
								
								if (jj != cols.length - 1)
									dataStr=dataStr + obj[dcol.dataField] + DataGridManager.columnSeparator;
								else
									dataStr=dataStr + obj[dcol.dataField] + DataGridManager.rowSeparator;
							}
							else
							{
								dataStr=dataStr + "" + DataGridManager.columnSeparator;
							}
						}
					}
				}
			}
			if (hasColumnDataField)
				returnVal=colStr + dataStr;
			else
				returnVal=dataStr;
			
			if(returnVal != "")
				returnVal = returnVal.substr(0,returnVal.length-2);
			
			return returnVal;
			
		}
		
		/*************************************************************
		 * get json data according to a specified condition
		 * @author Duong Pham
		 * ***********************************************************/		
		public function getGridDataByCondition(datas:Object , functionName:String, columnKey:String=null,type:String="A",visibleType:String="A"):String
		{
			try
			{
				var rowObj:Object;
				if (datas == null)
					return '[]';
				var arrayData:Array=new Array();
				var item:Object;
				var k:int=0;
				var column:ExAdvancedDataGridColumn;
				var isMapped:Boolean = false;
				var arrType:Array;
				if(type == "A")
					isMapped = true;
				else
					arrType = type.split("+");
				if (columnKey == null)
				{
					for each (item in datas)
					{
						if(arrType && arrType.length > 0)
						{
							isMapped = false;
							for(k=0; k<arrType.length; k++)
							{
								if(item[this.datagrid.crudColumnKey] == arrType[k])
								{
									isMapped = true;
									break;
								}
							}
						}
						if(isMapped)
						{
							rowObj=new Object();
							//check visible type according to A : all ; V: visible row only; I :invisible row only
							if((visibleType == "I" && item[Global.ROW_HIDE] == true) 
								|| (visibleType == "V" && (item[Global.ROW_HIDE] == false || !item.hasOwnProperty(Global.ROW_HIDE)))
								|| (visibleType == "A"))
							{
								for each (column in this.datagrid.columns)
								{
									if(datagrid.bUpdateNullToZero && column.type == ColumnType.NUMBER && 
										(item[column.dataField] == undefined || item[column.dataField] == null || item[column.dataField] == ""))
										rowObj[column.dataField]=item[column.dataField]="0";
									rowObj[column.dataField]=item[column.dataField];
								}
								arrayData.push(rowObj);
							}
						}
					}
				}
				else
				{
					var col:ExAdvancedDataGridColumn = this.dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
					if (col == null)
						err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
					if (col.type != ColumnType.CHECKBOX)
						err.throwError(ErrorMessages.ERROR_CHECKBOX_COLUMN_TYPE, Global.DEFAULT_LANG);
					for each (item in datas)
					{
						if (item[columnKey] == "1")
						{
							if(arrType && arrType.length > 0)
							{
								isMapped = false;
								for(k=0; k<arrType.length; k++)
								{
									if(item[this.datagrid.crudColumnKey] == arrType[k])
									{
										isMapped = true;
										break;
									}
								}
							}
							if(isMapped)
							{
								rowObj=new Object();
								//check visible type according to A : all ; V: visible row only; I :invisible row only
								if((visibleType == "I" && item[Global.ROW_HIDE] == true) 
									|| (visibleType == "V" && (item[Global.ROW_HIDE] == false || !item.hasOwnProperty(Global.ROW_HIDE)))
									|| (visibleType == "A"))
								{
									for each (column in this.datagrid.columns)
									{
										if(datagrid.bUpdateNullToZero && column.type == ColumnType.NUMBER && 
											(item[column.dataField] == undefined || item[column.dataField] == null || item[column.dataField] == ""))
											rowObj[column.dataField]=item[column.dataField]="0";
										rowObj[column.dataField]=item[column.dataField];
									}
									arrayData.push(rowObj);
								}
							}
						}
					}
				}
				var newResult:String = "";
				if(arrayData.length > 0)
				{
					var result:String = encodeJson(arrayData);
					newResult = result.replace(/\\/g, "\\\\");
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,functionName);				
			}			
			return newResult;
		}
		
		/*************************************************************
		 * export excel by active X
		 * @author Duong Pham
		 * ***********************************************************/
		public function exportExcelByActiveX():String
		{
			if(datagrid.excelExportInfo)
				datagrid.excelExportInfo = null;
			
			datagrid.excelExportInfo = new ExcelExportInfo("","",true,false,true,true);
			return datagrid.convertDGToHTMLTable();			
		}
		
		/*************************************************************
		 * import excel by active X
		 * @author Duong Pham
		 * ***********************************************************/
		public function importExcelByActiveX(str:String):void
		{
			var columnSep:String = DataGridManager.columnSeparator;
			var rowSep:String = DataGridManager.rowSeparator;
			
			DataGridManager.columnSeparator = "|";
			DataGridManager.rowSeparator = "\n";
			
			gridone.setTextData(str,true,true,false);
			
			DataGridManager.columnSeparator = columnSep;
			DataGridManager.rowSeparator = rowSep;
		}
		
		/*************************************************************
		 * set visible row according to order of setRowHide is reverted
		 * @author Duong Pham
		 * ***********************************************************/
		public function undoRowHide():void
		{
			var i:int;
			if(this.datagrid.invisibleIndexOrder == null || this.datagrid.invisibleIndexOrder.length == 0)
				return;
			if(datagrid.invisibleIndexOrder == null || datagrid.invisibleIndexOrder.length == 0)
				return;
			if(this.datagrid.itemEditorInstance)
				this.datagrid.destroyItemEditor();
			
			if(this.datagrid.nRowHideBuffer < this.datagrid.invisibleIndexOrder.length)
			{
				//remove these element which does not need to undo	
				var index:int=0;
				for(i=this.datagrid.invisibleIndexOrder.length-1; i>=0; i--)
				{
					index ++;
					if(index > this.datagrid.nRowHideBuffer)
					{
						this.datagrid.invisibleIndexOrder.splice(i,1);
					}
				}
			}
			
			var itemArr:Array = this.datagrid.invisibleIndexOrder[this.datagrid.invisibleIndexOrder.length-1];
			var position:Object;
			var item:Object;
			for(i=itemArr.length-1; i>=0; i--)
			{
				item = this.datagrid._bkDP.getItemAt(itemArr[i]);
				position = getPositionOfIndexInArr(itemArr[i],datagrid.invisibleIndexOrder);
				if(position)
				{
					//remove element is not invisible any more
					var detailItemArr:Array = this.datagrid.invisibleIndexOrder[position['row']];
					detailItemArr.splice(position['column'],1);
					if(detailItemArr.length == 0)
					{
						this.datagrid.invisibleIndexOrder.splice(position['row'],1);
					}
				}
				item[Global.ROW_HIDE] = false;					
				setCRUDRowValue(item, this.datagrid.strDeleteRowText, Global.CRUD_DELETE);
			}
			this.datagrid.filter = new FilterDataWithRowHide(this.datagrid.filter,null);	
			(this.datagrid.dataProvider as ArrayCollection).filterFunction = this.datagrid.filter.apply;
			(this.datagrid.dataProvider as ArrayCollection).refresh();
			if(this.datagrid.summaryBarManager.hasSummaryBar() && datagrid.rowCount >0)
			{
				this.datagrid.summaryBarManager.reCreateSummaryBar();
			}
			//update Application height when data is changed
			gridoneManager.updateGridHeight();
			
			gridoneManager.updateExternalVerticalScroll(datagrid.getLength());
			//update group mergeCells of datagrid
			if(hasGroupMerge())
			{
				this.datagrid.getGroupMergeInfo();
			}
			
			if(isDrawUpdate)
				this.datagrid.invalidateList();
		}
		
		/*************************************************************
		 * set multi rows is hidden
		 * @param strListHideIndex String contain list of index to be set invisible rows
		 * @param bHide Boolean
		 * @author Duong Pham
		 * ***********************************************************/
		public function setMultiRowsHide(strListHideIndex:String,bHide:Boolean,isHandleBkDp:Boolean=true):void
		{
			try
			{
				if(strListHideIndex == "" || strListHideIndex == null || strListHideIndex.indexOf(",") == -1)
					err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				
				var arrListHideIndex:Array = strListHideIndex.split(",");
				var i:int=0;
				for(i=0; i<arrListHideIndex.length; i++)
				{
					if(arrListHideIndex[i] < 0 || arrListHideIndex[i] >= this.datagrid.getLength())
					{
						err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
						break;
					}
				}
				
				var indexBk:int=-1;
				var hiddenIndexArr:Array=new Array();
				if(this.datagrid.itemEditorInstance)
					this.datagrid.destroyItemEditor();
				if (!this.datagrid.isTree)
				{
					if(datagrid.invisibleIndexOrder == null)
						datagrid.invisibleIndexOrder = new Array();
					var item:Object;
					var nRow:int = -1;
					for(i=0; i<arrListHideIndex.length; i++)
					{
						nRow = arrListHideIndex[i];
						if(isHandleBkDp)
						{
							if(nRow < 0 || nRow >= this.datagrid._bkDP.length)
								err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
							item = this.datagrid._bkDP.getItemAt(nRow);
							indexBk = nRow;
						}
						else
						{
							//if bHide =true ,nRow will be followed index of dataProvider
							if(bHide)
							{
								if(nRow < 0 || nRow >= this.datagrid.dataProvider.length)
									err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
								item = this.datagrid.getItemAt(nRow);
								indexBk = this.datagrid._bkDP.getItemIndex(item);
							}
							else
							{
								if(nRow < 0 || nRow >= this.datagrid._bkDP.length)
									err.throwError(ErrorMessages.ERROR_INDEX_INVALID, Global.DEFAULT_LANG);
								//ifbHide = false, nRow will be followed index of dataProviderBackup
								item = this.datagrid._bkDP.getItemAt(nRow);
								indexBk = nRow;
							}
						}
						//check indexBk has existed or not in datagrid.invisibleIndexOrder
						var position:Object = getPositionOfIndexInArr(indexBk,datagrid.invisibleIndexOrder);
						if(bHide)
						{
							if(position == null)
							{
								if(datagrid.invisibleIndexOrder.length == datagrid.nRowHideBuffer)
								{
									//remove the first element of array
									datagrid.invisibleIndexOrder.splice(0,1);
								}
								hiddenIndexArr.push(indexBk);
							}
						}
						else
						{
							if(position && position['row'] > -1)
							{
								//remove element is not invisible any more
								var detailItemArr:Array = this.datagrid.invisibleIndexOrder[position['row']];
								detailItemArr.splice(position['column'],1);
								if(detailItemArr.length == 0)
								{
									this.datagrid.invisibleIndexOrder.splice(position['row'],1);
								}
							}
						}
						item[Global.ROW_HIDE] = bHide;					
						setCRUDRowValue(item, this.datagrid.strDeleteRowText, Global.CRUD_DELETE);
					}
					
					if(bHide && hiddenIndexArr.length > 0)
					{
						//add new element into array
						datagrid.invisibleIndexOrder.push(hiddenIndexArr);
					}
					
					//apply filter in rowHide
					this.datagrid.filter = new FilterDataWithRowHide(this.datagrid.filter,null);	
					(this.datagrid.dataProvider as ArrayCollection).filterFunction = this.datagrid.filter.apply;
					(this.datagrid.dataProvider as ArrayCollection).refresh();
					if(this.datagrid.summaryBarManager.hasSummaryBar() && datagrid.rowCount >0)
					{
						this.datagrid.summaryBarManager.reCreateSummaryBar();
					}
					//update Application height when data is changed
					gridoneManager.updateGridHeight();
					
					gridoneManager.updateExternalVerticalScroll(datagrid.getLength());
					//update group mergeCells of datagrid
					if(hasGroupMerge())
					{
						this.datagrid.getGroupMergeInfo();
					}
					
					if(isDrawUpdate)
						this.datagrid.invalidateList();
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setMultiRowsHide");					
			}
		}
		
		/*************************************************************
		 * import array data into datagrid
		 * @author Chheav Hun
		 * ***********************************************************/
		public function setArrayData(arrData:Array,bValidate:Boolean):void
		{
			gridoneManager.checkDataProvider(arrData, bValidate,"setArrayData");	
		}
		
		/*************************************************************
		 *get all data from datagrid as Object
		 * @author Chheav Hun
		 * ***********************************************************/
		public function getAllData():Object
		{
			return this.datagrid.dataProvider;
		}
		
		/*************************************************************
		 * get all data from datagrid as Array
		 * @author Chheav Hun
		 * ***********************************************************/
		public function  getArrayData(isBackup:Boolean = false):Array
		{
			var arr:Array;
			var collection:Object;
			if(isBackup)
				collection = this.datagrid._bkDP;
			else
				collection = this.datagrid.dataProvider;
			
			if(collection == null)
				return []; 
			
			if (this.datagrid.isTree)
			{
				arr = (((collection as HierarchicalCollectionView).source as ExIHierarchicalData).source as ArrayCollection).toArray();	
			}
			else
			{
				if (collection is XMLListCollection)
				{
					arr = (collection as XMLListCollection).toArray();
				}
				else if (collection is ArrayCollection)
				{
					arr = (collection as ArrayCollection).toArray();
				}
			}
			var dataField:String = "";
			var arrDataFieldCheckBox:Array = new Array();
			for(var i:int =0 ; i<this.datagrid.columns.length; i++)
			{
				if(ExAdvancedDataGridColumn(this.datagrid.columns[i]).type == ColumnType.CHECKBOX)
				{
					arrDataFieldCheckBox.push(ExAdvancedDataGridColumn(this.datagrid.columns[i]).dataField);
				}
			}
			if(arrDataFieldCheckBox.length > 0)
			{
				var item:Object;				
				for(var j:int=0; j<arr.length; j++)
				{
					for(i=0; i<arrDataFieldCheckBox.length;i++)
					{
						dataField = arrDataFieldCheckBox[i];
						item = arr[j];
						if(item[dataField] == '1')
							item[dataField] = datagrid.checkboxTrueValue; 
						else if(item[dataField] == '0')
							item[dataField] = datagrid.checkboxFalseValue; 
					}
				}
			}
			return  arr;
		}
		
		/*************************************************************
		 * add json data into comboList
		 * @author Chheav Hun
		 * ***********************************************************/
		public function addComboListJson(columnKey:String,strText:String,strValue:String,jsonData:Object):void
		{
			var arrCol:ArrayCollection=new ArrayCollection(jsonData as Array);
			
			for each(var item:Object in arrCol){				
				addComboListValue(columnKey,item[strText],item[strValue],"default");
			}
		}
		
		/*************************************************************
		 * add json data into dynamic comboList. The comboList will clear all the time call this function. 
		 * @author Chheav Hun
		 * ***********************************************************/
		public function addComboDynamicListJson(columnKey:String,strText:String,strValue:String,jsonData:Object):void
		{
			try
			{
				var arrCol:ArrayCollection=new ArrayCollection(jsonData as Array);
				var col:ExAdvancedDataGridColumn = dgManager.getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				var listKey:String="default";
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				if (strValue == null)
					err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				col.listCombo[listKey]=new Array();
				for each(var item:Object in arrCol){
					
					var obj:Object=new Object();
					obj["label"]=item[strText];
					obj["value"]=item[strValue]; 
					if (col.listCombo[listKey] == null)
						col.listCombo[listKey]=new Array();
					//verify that value is existed or not in listKey of listCombo of column
					if(!col.checkComboValueWithListKey(strValue,listKey))
					{
						(col.listCombo[listKey] as Array).push(obj);
						this.datagrid.invalidateList();
					}
				}
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"addComboListValue");						
			}
			
		}
		
		
		/*************************************************************
		 * get checked row idex  
		 * @author Chheav Hun
		 * ***********************************************************/
		public function getCheckedRowsIndex(columnKey:String):Array
		{
			try
			{
				var arr:Array=new Array();
				
				if (datagrid.dataFieldIndex[columnKey]==null)
				{
					err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				}	
				else 
				{
					for each (var item:Object in datagrid.dataProvider)
					{
						if (item[columnKey]==true || item[columnKey]=='1'){
							arr.push(datagrid.getBackupItemIndex(item));
						} 
					}
				}
			}catch(e:Error)
			{
				throw new Error(e.message);
			}
			return arr;	
		}
	 
		/*************************************************************
		 * insert headers for DataGrid.
		 * @param params object that is defined with multiple properties to create columns likes headerText,dataField.
		 * ***********************************************************/
		public function insertHeader(params:Object):void
		{
			this.datagrid.visible=true;
			var col:ExAdvancedDataGridColumn=new ExAdvancedDataGridColumn();
			var colArr:Array;
			var colgroup:Array;
			if (this.datagrid._isGroupedColumn)
			{
				colArr = new Array();
				colgroup= this.datagrid.groupedColumns;
				colgroup.push(col);
				this.datagrid.groupedColumns=colgroup;
			}
			else
			{
				colArr=this.datagrid.columns;
				colArr.push(col);
				this.datagrid.columns=colArr;
			}	
			
			var objectInfo:Object=ObjectUtil.getClassInfo(params);
			for each (var qname:QName in objectInfo.properties)
			{
				var propertyName:String=qname.localName;
				var propertyValue:String=params[qname.localName];
				if (col.hasOwnProperty(propertyName))
					this.dgManager.setColumnProperty(col, propertyName, propertyValue);
				else
					this.dgManager.setStyleForObject(col, propertyName, propertyValue);
			}	
			if(this.datagrid._isGroupedColumn)
			{
				colArr = convertGroupColumn(colgroup , colArr)
				this.datagrid.columns = colArr;
			}
			this.dgManager.setColumnDataFieldIndex(colArr);
			this.datagrid.invalidateList(); 
		}
		
		/*************************************************************
		 * set logo waiting image  
		 * @author Chheav Hun
		 * ***********************************************************/
		public function setWaitingLogoValue(logoUrl:String, logoWidth:Number=200, logoHeight:Number=50):void
		{
			 this.waitingLogo.source=logoUrl;
			 this.waitingLogo.width=logoWidth;
			 this.waitingLogo.height=logoHeight;
		}
		
		/*************************************************************
		 * show image waiting logo   
		 * @author Chheav Hun
		 * ***********************************************************/
		public function showWaitingLogo():void
		{
		 	PopUpManager.addPopUp(waitingLogo,this.datagrid,true);
			PopUpManager.centerPopUp(waitingLogo);
		}
		
		/*************************************************************
		 * hide image waiting logo  
		 * @author Chheav Hun
		 * ***********************************************************/
		public function hideWaitingLogo():void
		{
		   PopUpManager.removePopUp(waitingLogo);	
		}
		
		/************************************************************* 
		 * set data for commbo box renderer of a given name column.
	 	 * @param colname column fied name.
		 * @param sComboData data for setting combo box in format value1|name1%%value2|name2
		 * @author Chheav Hun
		 * ***********************************************************/
		public function addComboDataAtColumn(colKey:String, sComboData:String):void
		{
	   		 if (this.datagrid.dataFieldIndex[colKey]==null)
			 {
				 err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
			 }
			 else
			 {
				 for(var i:int=0 ; i<=this.datagrid.columns.length;i++)
				 {
					 if (colKey==this.datagrid.columns[i].dataField)
					 {
						 addComboDataAtColumnIndex(i, sComboData);
						 break;
					 }
						 
				 }
			 }
		}
		
		/*************************************************************
		 * set data for commbo box renderer of a given index column.
		 * @param colname column fied name.
		 * @param sComboData data for setting combo box in format value1|name1%%value2|name2
		 * ***********************************************************/
		public function addComboDataAtColumnIndex(colIndex:int, sComboData:String):void
		{
			try
			{
				if (colIndex < 0 || colIndex >= datagrid.columns.length || sComboData == null || sComboData == "")
					err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				
				var cbArr:Array= parseComboData(sComboData);
				
				var col:ExAdvancedDataGridColumn=datagrid.columns[colIndex];
				
				col.listCombo[Global.DEFAULT_COMBO_KEY]=cbArr;
				
				this.datagrid.invalidateList();
			 
			}
			catch(error:Error)
			{
				err.throwMsgError(error.message,"addComboDataAtColumnIndex");	
			}
		}
		
		/*************************************************************
		 * set image for column imagetext 
		 * @columnKey : dataField 
		 * @index: index of image
		 * @athor: Chheav Hun
		 * ***********************************************************/
		public function setColCellImage(columnKey:String, index:int):void
		{
			try
			{					
				var col:ExAdvancedDataGridColumn=this.datagrid.columns[this.datagrid.dataFieldIndex[columnKey]];
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				for each (var item:Object in this.datagrid._bkDP)
				{
					item[columnKey + "_index"]=index;
				}
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setColCellImage");
			}
		}
		
		/*************************************************************
		 * add comboData for column.
		 * ***********************************************************/
		public function parseComboData(sComboData:String):Array
		{
			var itemArr:Array=sComboData.split("%%");
			if (itemArr.length == 1)
				itemArr=sComboData.split(",");
			var cbArr:Array=[];
			for (var i:int=0; i < itemArr.length; i++)
			{
				var pair:Array=String(itemArr[i]).split("|");
				var obj:Object=new Object();
				
				if (pair.length > 1)
				{
					obj.value=pair[0];
					obj.label=pair[1];
				}
				else if (pair.length == 1)
				{
					obj.label=pair[0];
				}
				cbArr[i]=obj;
			}
			return cbArr;
		}
		
		/*************************************************************
		 * delete multi rows which selected or (shift + selected) in DataGrid's row.
		 * Before call this function, must set "selectCell=false", "strCellClickAction=rowselect", and "allowMultipleSelection=true".
		 * @columnKey : dataField 
		 * @index: index of image
		 * @athor: Chheav Hun
		 * ***********************************************************/
		public function deleteRows():void
		{
			if (datagrid.dataProvider == null)
				return;
			
			if (!datagrid.isTree)
			{
				var index:int;
				var item:Object;
				if (datagrid.allowMultipleSelection)
				{
					for (var i:int=(datagrid.selectedItems.length - 1); i >= 0; i--)
					{
						item=datagrid.selectedItems[i];
						index=(datagrid.dataProvider).getItemIndex(item);
						if (rowStatus !=null)
							rowStatus.currentStatus=RowStatus.STATUS_DEL;
						rowStatus._arrRDelete.push(index);
						(datagrid.dataProvider).removeItemAt(index);
					}
				}
				else
				{
					index=datagrid.selectedIndex;
					item=datagrid.dataProvider.getItemAt(index);
					if (rowStatus !=null)
						rowStatus.currentStatus=RowStatus.STATUS_DEL;
					rowStatus._arrRDelete.push(index);
					(datagrid.dataProvider).removeItemAt(index);
				}
				if (this.datagrid.dataProvider.length < this.datagrid.rowCount)
				{
					//this.vScroll.scrollPosition=0;
					//this.datagrid.verticalScrollPosition=0;
					this.gridone.vScroll.maxScrollPosition=this.datagrid.maxVerticalScrollPosition=0;
					
				}
				if(this.datagrid.summaryBarManager.hasSummaryBar() && datagrid.rowCount >0)
					 this.sumManager.reCreateSummaryBar(true);
				this.datagrid.invalidateList();
				
			}	 
		}
		
		/*************************************************************
		 * It will be called before getting data from server			 
		 * Return true: without getting data from server or otherwise
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function doStartQuery(useLoadingBar:Boolean=true):Boolean
		{
			if(useLoadingBar)
			{
				this.gridone.activity.showBusyBar();
			}
			else
			{
				this.gridone.activity.closeBusyBar();				
			}
			this.datagrid.isDoQuery= true;
			var saEvent:SAEvent = new SAEvent(SAEvent.ON_START_QUERY, true);
			this.datagrid.dispatchEvent(saEvent);				
			if(this.datagrid.isGettingData)
				return false;
			else
				return true;
		}
		
		/*************************************************************
		 * get data from one cell as string by setting specific rowIndex and columnKey
		 * @param  rowIndex Row index   
		 * @param  fieldName columnKey	 
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getCell(rowIndex:int, fieldName:String,bname:Boolean=false):String
		{
			var resultData:String;
			try{
				if (this.datagrid.dataProvider==null)
				{
					this.err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				}
				if (rowIndex < 0 || rowIndex >= this.datagrid._bkDP.length)
				{
					this.err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				}
				if (this.datagrid.dataFieldIndex[fieldName]==null)
				{
					this.err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				if (this.datagrid.dataProvider as XMLListCollection)
				{
					var rowXML:XML=XMLListCollection(this.datagrid.dataProvider).getItemAt(rowIndex) as XML;
					if (rowXML.child(fieldName).length() > 0)
					{
						resultData=rowXML.child(fieldName)[0];
					}
					else
					{
						resultData="";
					}
				}
				else
				{
					var rowObject:Object=this.datagrid.getBackupItem(rowIndex) as Object;
					if (rowObject ==null || rowObject[fieldName]==null)
					{
						resultData="";
					}
					else
					{
						if (this.dgManager.getColumnType(fieldName)==ColumnType.COMBOBOX && bname==false)
						{
							resultData=getComboText(fieldName, rowObject[fieldName]); 
						}
						else
						{
							if(rowObject.hasOwnProperty(fieldName))	
								resultData=rowObject[fieldName].toString();
							else
								resultData='';
						}
						
					}
				}
			}catch(e:Error){
				throw new Error(e.message);
			}
			return resultData;	
		}
		
		/*************************************************************
		 * get data from more than one cell in one row as Array by setting specific rowIndex and columnKey list (ex: "name,nation")
		 * @param  listColumKey the list of choosing columnKey as string (ex: "name,nation")  
		 * @param  nRow  The row index 
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getCellValues(listColumKey:String, nRow:int):Array
		{
			 var resultArr:Array=new Array();
			 var listColArr:Array=listColumKey.split(",");
			try
			{
				for each (var colKey:String in listColArr)
				{
					if (colKey==null)
					{
						this.err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG); 
					}
					else 
						resultArr.push(getCell(nRow,colKey));
				}
				
			}catch(e:Error){
				throw new Error(e.message);
			}
			return resultArr;	
		 }
		
		/*************************************************************
		 * set button column in a specific row to visible or not visible. 
		 * @param  strColKey ColumnKey
		 * @param  nRow  The row index 
		 * @param bVisible true=visible or not visible=false
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function setButtonVisible(strColKey:String, nRow:int, bVisible:Boolean):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(strColKey))
				{
					this.err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				if (this.datagrid.columns[this.datagrid.dataFieldIndex[strColKey]].type !=ColumnType.BUTTON)
				{
					err.throwError(ErrorMessages.ERROR_WRONG_COLUMN_TYPE, Global.DEFAULT_LANG);
				}
				if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
				{
					this.err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				}
				var row:Object=this.datagrid.getBackupItem(nRow);
				row[strColKey + Global.SELECTED_BUTTON_INDEX]=bVisible;
				this.datagrid.invalidateList();
			}catch(e:Error)
			{
				throw new Error(e.message);
			}
		}
		
		
		/*************************************************************
		 * set checkbox column in a specific row to visible or not visible. 
		 * @param  strColKey ColumnKey
		 * @param  nRow  The row index 
		 * @param bVisible true=visible or not visible=false
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function setCheckBoxVisible(strColKey:String, nRow:int, bVisible:Boolean):void
		{
			try
			{
				if (!this.datagrid.dataFieldIndex.hasOwnProperty(strColKey))
				{
					this.err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				if (this.datagrid.columns[this.datagrid.dataFieldIndex[strColKey]].type !=ColumnType.CHECKBOX)
				{
					err.throwError(ErrorMessages.ERROR_WRONG_COLUMN_TYPE, Global.DEFAULT_LANG);
				}
				if (nRow < 0 || nRow >= this.datagrid._bkDP.length)
				{
					this.err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				}
		 
				var row:Object=this.datagrid.getBackupItem(nRow);
				row[strColKey + Global.SELECTED_CHECKBOX_INDEX]=bVisible;
				this.datagrid.invalidateList();
			}catch(e:Error)
			{
				throw new Error(e.message);
			}
		}
		
		/*************************************************************
		 * get cell back ground color of specific row and col. 
		 * @param  col Column index
		 * @param  row  The row index 
		 * @Author:Chheav Hun
		 * ***********************************************************/
		private var _celDic:Dictionary=new Dictionary();
		public function getCellBackgroundColor(col:int, row:int):String
		{
			try
			{
				if(this.datagrid._bkDP==null)
				{
					this.err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				}
				if (row <0 ||row >= this.datagrid._bkDP.length)
				{
					this.err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				}
				var uid:String = ""; 
				var rowItem:Object = datagrid.getItemAt(row);
				uid = rowItem[Global.ACTSONE_INTERNAL];
				var dataField:String = "";
				dataField=ExAdvancedDataGridColumn(this.datagrid.columns[col]).dataField;
				var strBgCol:String = this.datagrid.getCellProperty("backgroundColor",uid,dataField);
				if(strBgCol == null)
					strBgCol = "";
			}catch(e:Error)
			{
				throw new Error(e.message);
			}
			return strBgCol;			
		}
		
		/*************************************************************
		 * get cell font color of specific row and col. 
		 * @param  col Column index
		 * @param  row  The row index 
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getCellFontColor(col:int, row:int):String
		{
			try
			{
				if(this.datagrid._bkDP==null)
				{
					this.err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				}
				if (row <0 ||row >= this.datagrid._bkDP.length)
				{
					this.err.throwError(ErrorMessages.ERROR_ROWINDEX_INVALID, Global.DEFAULT_LANG);
				}
				var uid:String = ""; 
				var rowItem:Object = datagrid.getItemAt(row);
				uid = rowItem[Global.ACTSONE_INTERNAL];
				var dataField:String = "";
				dataField=ExAdvancedDataGridColumn(this.datagrid.columns[col]).dataField;
				var strFgCol:String = this.datagrid.getCellProperty("color",uid,dataField);
				if(strFgCol == null)
					strFgCol = "";
			}catch(e:Error)
			{
				throw new Error(e.message);
			}
			return strFgCol;	
		}
		/*************************************************************
		 * set hide column in specific column index; 
		 * @param  colIndex  column index
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function hideColumnIndex(colIndex:int):void
		{
			var col:ExAdvancedDataGridColumn=this.datagrid.columns[colIndex] as ExAdvancedDataGridColumn;
			if (col !=null)
			{
				col.visible=false;
				this.datagrid.invalidateList();
			}
		}
		
		/*************************************************************
		 * set show of hide column in specific column index; 
		 * @param  colIndex  column index
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function showColumnIndex(colIndex:int):void
		{
			var col:ExAdvancedDataGridColumn=this.datagrid.columns[colIndex] as ExAdvancedDataGridColumn;
			if (col !=null)
			{
				col.visible=true;
				this.datagrid.invalidateList();
			}
		}
		 
		/*************************************************************
		 * get name of a cell which using commbo box renderer.
		 * @param colname column fied name.
		 * @param rowIndex row index of the cell.
		 * @return displaying name of the cell.
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getComboNameAtColumn(colname:String, rowIndex:int):String
		{
			try
			{
				if (this.datagrid.columns[this.datagrid.dataFieldIndex[colname]].type !=ColumnType.COMBOBOX)
				{
					err.throwError(ErrorMessages.ERROR_WRONG_COLUMN_TYPE, Global.DEFAULT_LANG);
				}
			}catch(e:Error)
			{
				throw new Error(e.message);
			}
			return getCell(rowIndex,colname,true); 
		}
		
		/*************************************************************
		 * get name of a cell which using commbo box renderer.
		 * @param colIndex column index. if index is not for combobox column, this function still work with the input column index.
		 * @param rowIndex row index of the cell.
		 * @return displaying name of the cell.
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getComboNameAtColumnIndex(colIndex:int, rowIndex:int):String
		{
			var columnKey:String=this.getColHDKey(colIndex);
			return getCell(rowIndex,columnKey,true);
		}
		
		/*************************************************************
		 * get rows deleted by user.
		 * @return array of deleted rows.
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getDeletedRows():Array
		{
			var arrDelRow:Array=new Array();
		   try
		   {
			   if(this.datagrid._bkDP==null)
			   {
				   this.err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
			   }
			   for (var i:int=0; i < this.datagrid._bkDP.length; i++)
			   {
				   var item:Object=this.datagrid._bkDP[i]; 
				   if (rowStatus._arrRDelete !=null)
					   for (var j:int=0;j<=rowStatus._arrRDelete.length;j++)
					   {
						   if (rowStatus._arrRDelete[j]==i)
							   if (item is XML)
								   arrDelRow.push(XML(item).toXMLString());
							   else
								   arrDelRow.push(item);
					   }
			   }  
		   }catch(e:Error)
		   {
			   throw new Error(e.message);
		   }
			return arrDelRow;
		}
		
		/*************************************************************
		 * get data of datagrid in HTML format.
		 * @return string of data in HTML format.
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getDataGridString():String
		{
			datagrid.excelExportInfo = new ExcelExportInfo("","",true,false,true,true);
			return this.datagrid.convertDGToHTMLTable();
		}
		
		/*************************************************************
		 * get yes,no value for checkbox.  
		 * @return columnKey dataField
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getCheckBoxValue(columnKey:String):Array
		{
			try
			{
				var arr:Array = new Array();
				if (datagrid.dataFieldIndex[columnKey]==null)
				{
					err.throwError(ErrorMessages.ERROR_INVALID_INPUT_DATA, Global.DEFAULT_LANG);
				}	
				var val:String;
				for each (var item:Object in datagrid.dataProvider)
				{
					if (item[columnKey]==true || item[columnKey]=='1')
						val = datagrid.checkboxTrueValue;
					else
						val = datagrid.checkboxFalseValue;	
					arr.push(val);
				}
			}
			catch(e:Error)
			{
				throw new Error(e.message);
			}
			return arr;
		}
		
		/*************************************************************
		 * get inserted rows by user.
		 * @return array of inserted rows.
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getInsertedRows():Array
		{
			var insertArr:Array=[];
			try
			{
				if(this.datagrid.dataProvider==null)
				{
					this.err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				}
				for (var i:int=0; i < this.datagrid.dataProvider.length; i++)
				{
					var item:Object=this.datagrid.dataProvider[i]; 
					if (rowStatus._arrRAdd !=null)
						for (var j:int=0;j<=rowStatus._arrRAdd.length;j++)
						{
							if (rowStatus._arrRAdd[j]==i)
								if (item is XML)
									insertArr.push(XML(item).toXMLString());
								else
									insertArr.push(item);
						}
				}  
			}catch(e:Error)
			{
				throw new Error(e.message);
			}
			return  insertArr;
		}
		
		/*************************************************************
		 * get rows at row index by user.
		 * @return array of inserted rows.
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getRow(rowIndex:int,bHidden:Boolean=false):Object
		{
			var rowObj:Object=new Object();
			if (bHidden==true)
			{
				rowObj=this.datagrid._bkDP.getItemAt(rowIndex);
			}
			else
			{
				rowObj=this.datagrid.getItemAt(rowIndex);	
			}
			
			return rowObj;
		}
		
		/*************************************************************
		 * get update rows by user.
		 * @return  array of rows
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getUpdatedRows():Array
		{
			var updateRArr:Array=new Array();
			var row:Object;
			var cellvalue:String="";
			try
			{
				if (this.datagrid.dataProvider == null)
				{
					this.err.throwError(ErrorMessages.ERROR_DATAPROVIDER_NULL, Global.DEFAULT_LANG);
				}
				var colArr:Array=this.datagrid.columns;
				for each(var col:ExAdvancedDataGridColumn in colArr)
				{
					if (col.type==ColumnType.CRUD)
					{
						for (var i:int=0; i < this.datagrid.dataProvider.length; i++)
						{
							row=this.datagrid.dataProvider[i];
							if (this.datagrid.dataProvider[i][col.dataField] == Global.CRUD_UPDATE)
							{
								updateRArr.push(row);
							}
						}
					}
				}
			}catch(e:Error)
			{
				throw new Error(e.message);
			}
			return updateRArr;	
		}
		
		/*************************************************************
		 * get current page
		 * @author chheavhun	 
		 * ***********************************************************/
		public function getCurrentPage():int
		{
 			return  currentpage;
		}
		
		/*************************************************************
		 * get page total  
		 * @return  number of row
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getPageTotal():int
		{
		    return this.datagrid.getVisibleListItem().length;
		}
		/*************************************************************
		 * get page total  count
		 * @return  number of pages
		 * @Author:Chheav Hun
		 * ***********************************************************/
		public function getPagingCount():int
		{
			if (this.datagrid._bkDP.length > this.datagrid.getVisibleListItem().length)
			{
				pageNum= Math.ceil(this.datagrid._bkDP.length/this.datagrid.getVisibleListItem().length);
			}
			else 
				pageNum=1;
			return pageNum;
		}
		
		/*************************************************************
		 * dispatch custom event
		 * @author chheavhun	 
		 * ***********************************************************/
		public function  dispatchCustomEvent(funcName:String):void
		{
			var keyBoardEvent:KeyboardEvent;
			if(funcName == "mouseDown")
			{
				keyBoardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,40,0,false,false,false);
				this.datagrid.dispatchEvent(keyBoardEvent);
			}
			
			else if(funcName == "mouseUp")
			{
				keyBoardEvent = new KeyboardEvent(KeyboardEvent.KEY_UP,true,false,0,38,0,false,false,false);
				this.datagrid.dispatchEvent(keyBoardEvent);
			}
		}
		
		private var funList: Array =[];
		/*************************************************************
		 * register function to external interface
		 * @author chheavhun	 
		 * ***********************************************************/
		public function registerFunc(arrfun:Array,fun:String=""):void
		{
			var invilid :Boolean = false;
			var bFirst :Boolean =false;
			if (funList.length ==0)
			{
				funList.push(fun);
				bFirst=true;
			}
			
			if (funList.length >=1)
			{
				  if (bFirst ==false)
				  {
						for (var i:int=0;i<funList.length ;i++)
						{
							if (funList[i]==fun)
							{
								invilid=true;
							}
						}
				  }
			 }
			
			if (invilid==false)
			{
				funList.push(fun);
				
				if (this.hasOwnProperty(fun))
				{
					ExternalInterface.addCallback(fun,this[fun]); 	
				}
				else if (this.dgManager.hasOwnProperty(fun))
				{
					ExternalInterface.addCallback(fun,this.dgManager[fun]); 	
				}
				else if (this.gridoneManager.hasOwnProperty(fun))
				{
					ExternalInterface.addCallback(fun,this.gridoneManager[fun]); 	
				}
				else if (this.datagrid.hasOwnProperty(fun))
				{
					ExternalInterface.addCallback(fun,this.datagrid[fun]); 
				}
				else{ExternalInterface.addCallback(fun,this.gridone[fun]); }
			}
 
  
		}
		
		public function setXMLRowAt(row:String, rowIndex:int):void
		{
		 
		}
		
		/*************************************************************
		 * set tool tip information
		 * @author chheavhun	 
		 * ***********************************************************/
		public function setToolTipInfor(colKey:String,infor:String):void
		{
			try
			{
				var col:ExAdvancedDataGridColumn=dgManager.getColumnByDataField(colKey) as ExAdvancedDataGridColumn;
				if(col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				
				this.datagrid.toolTipData=infor;
				col.toolTipData=infor;
			 
				this.datagrid.invalidateList();
			 
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"setToolTipInfo");					
			}
		}
	}
}