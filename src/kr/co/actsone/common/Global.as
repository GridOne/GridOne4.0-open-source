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
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	
	public class Global
	{
		public static const CURRENT_VERSION:String="4.0";
		
		//For Developer:
	 	 public static const BUILD_VERSION:String="developer";
		
		//For Release:
//	 	 public static const BUILD_VERSION:String="release";
		
		public static const DEVELOPER_VERSION:String="developer";
		public static const RELEASE_VERSION:String="release";
		
		public static var grioneHomeURL:String="http://www.actsone.co.kr/menu010101.cfm";
		
		public static const STR_ENTER_NAVIGATE_NEXT: String = "nextcell";
		public static const STR_ENTER_NAVIGATE_BELOW: String = "belowcell";
		
		public static const ACTSONE_INTERNAL:String = "actsone_internal_uid";
		
		public static const TREE_ROOT_CHAR: String = "*";
		public static const TREE_ROOT_STRING: String = "root";
		public static const ACCESS_READER_GRIDONE_NAME: String = "GridOne3";
		public static const ACCESS_READER_COLUMN_DEFAULT: String = "[...]";
		public static const ACCESS_READER_HEADER:String = "Header text is ";
		public static const ACCESS_READER_COLUMN:String = "Column type is ";
		public static const ACCESS_READER_CONTROL:String = "Control type is ";
		public static const ACCESS_READER_CELLLABEL:String = "Label is ";
		public static const ACCESS_READER_CELL:String = "Value is ";
		
		public static const ACCESS_READER_HEADERTEXT:String = "%HEADERTEXT%";
		public static const ACCESS_READER_COLUMNTYPE:String = "%COLUMNTYPE%";
		public static const ACCESS_READER_CONTROLTYPE:String = "%CONTROLTYPE%";
		public static const ACCESS_READER_CELLVALUE:String = "%CELLVALUE%";
		
		public static const ACCESS_READER_LABEL:String = "Label";
		public static const ACCESS_READER_DATEFIELD:String = "DateField";
		public static const ACCESS_READER_BUTTON:String = "Button";
		public static const ACCESS_READER_COMBOBOX:String = "ComboBox";
		public static const ACCESS_READER_MULTICOMBOBOX:String = "MultiComboBox";
		public static const ACCESS_READER_CHECKBOX:String = "CheckBox";
		public static const ACCESS_READER_RADIOBUTTON:String = "RadioButton";
		public static const ACCESS_READER_CALENDAR:String = "Calendar";
		public static const ACCESS_READER_LINKBUTTON:String = "LinkButton";
		public static const ACCESS_READER_IMAGE:String = "Image";
		public static const ACCESS_READER_IMAGETEXT:String = "ImageText";
		public static const ACCESS_READER_MASKEDINPUT:String = "MaskedInput";
		public static const ACCESS_READER_NUMBER:String = "Number";
		public static const ACCESS_READER_SUBTOTAL:String = "Subtotal";
		public static const ACCESS_READER_TOTAL:String = "Total";
		public static const ACCESS_READER_COLUMNTOTAL:String = "ColumnTotal";
		
		
		public static const HIDDEN_VALUE:String = "HIDDENVALUE";
		public static const TREE_SUM_NODE:String = "SUM";
		public static const TREE_COUNT_NODE:String = "COUNT";
		public static const TREE_AVERAGE_NODE:String = "AVERAGE";
		public static const DEFAULT_COMBO_KEY:String="default";
		public static const MODE:String="MODE";
		public static const INSERT_MODE:String="I";
		public static const UPDATE_MODE:String="U";
		public static const DELETE_MODE:String="D";
		public static const WISEGRIDDATA_ALL:String ='WISEGRIDDATA_ALL';
		
		public static const SELECTED_IMAGE_INDEX:String="_index";
		
		public static const SELECTED_COMBO_INDEX:String="_index";		
		
		public static const SELECTED_BUTTON_INDEX:String="_index";
		
		public static const SELECTED_CHECKBOX_INDEX:String="_index";
		
		public static const COMBO_KEY_CELL:String="_comboKey";
		
		//for strMouseWheelAction
		public static const MOUSE_WHEEL_DEFAULT:String="default";
		public static const MOUSE_WHEEL_PAGE:String="page";
		
		//for strCellClickAction
		
		public static const EDIT:String="edit";
		public static const ROWSELECT:String="rowselect";
		public static const CELLSELECT:String="cellselect";
		
		//for cell activation
		public static const ACTIVATE_EDIT:String="edit";		
		public static const ACTIVATE_ONLY:String="activateonly";		
		public static const ACTIVATE_DISABLE:String="disable";
		
		//context menu
		
		public static const MENU_ADDROW:String="menuAddRow";
		public static const MENU_EDITROW:String="menuEditRow";
		public static const MENU_DELETEROW:String="menuDeleteRow";
		
		public static const ROW_HIDE:String = "_isRowHide";
		//live scrolling
		public static const LIVE_SCROLL_DEFAULT:String="default";		
		public static const LIVE_SCROLL_SYNCSCREEN:String="syncscreen";
		
		//Alert warning for setCellValue
		
		public static const CHECKBOX_WARNING:String="wrong type value, just accept values: true|false|1|0";
		
		public static const COMBOBOX_WARNING:String="wrong data, check data in combo list";
		
		public static const NUMBER_WARNING:String="wrong data type entered, be sure value is a number type";
		
		public static const DATE_WARNING:String="wrong data type entered, be sure value is a date type";
		
		public static const TEXT_WARNING:String="length of text is too large";
		
		public static const SET_CELL_FUNCTION:String="setCell";
		
		public static var DEFAULT_LANG:String =  "EN"; //"EN", "CH";
		
		public static const GRIDDATA_ALL:String = "GRIDDATA_ALL";
		
		public static const CRUD_KEY:String="_crudKey";
		
		public static const TOTAL_DATAFIELD:String="_totalField";
		
		//version for customers
		
		public static const BUSAN_BANK:String="BusanBank";
		
		public static const ICOMPIA_WISEGRID:String="IcompiaWisegrid";
		
		public static const CRUD_UPDATE:String="U";
		public static const CRUD_DELETE:String="D";
		public static const CRUD_INSERT:String="C";	
		
		
		
		public static const MODAL_MODE = "ModalMode";
		
		public static const EXPORT_EXCEL_TITLE:Object = {EN:"Export excel",KR:"Export excel"};
		
		public static const EXPORT_EXCEL_MESSAGE:Object = {EN:"Are you sure you want to save excel file?",KR:"엑셀파일로 저장하시겠습니까?",CH:"您确定要保存excel文件？"};
		
		public static const IMPORT_EXCEL_TITLE:Object = {EN:"Import excel",KR:"Import excel"};
		
		public static const IMPORT_EXCEL_MESSAGE:Object = {EN:"Do you want to access local computer?",KR:"엑셀파일을 불러오시겠습니까?",CH:"你要访问本地计算机？"};
		
		public static function getMessageLang(msg:Object,lang:String):String
		{
			if(msg.hasOwnProperty(lang))
				return msg[lang];
			else
				return msg[Global.DEFAULT_LANG];
		}
		
		/*************************************************************
		 * register function with external interface
		 * @param flex gridone object
		 * ***********************************************************/
		public static function initCallback(flex:GridOne):void
		{			
			if (ExternalInterface.available)
			{	
				ExternalInterface.addCallback("setProperty", flex.setProperty);
				ExternalInterface.addCallback("setDataGridProperty", flex.setDataGridProperty);
				ExternalInterface.addCallback("addHeader", flex.addHeader);
				ExternalInterface.addCallback("boundHeader", flex.boundHeader);
				ExternalInterface.addCallback("addTextData", flex.addTextData);
				ExternalInterface.addCallback("setTextData", flex.setTextData);
				ExternalInterface.addCallback("setGridData", flex.setGridData);
				ExternalInterface.addCallback("createEvent", flex.createEvent);
				ExternalInterface.addCallback("registerFunc",flex.registerFunc);
				ExternalInterface.addCallback("handleWheel",flex.handleWheel);
				ExternalInterface.addCallback("setJSonData", flex.setJSonData);
				ExternalInterface.addCallback("setColumnProperty", flex.setColumnProperty);
				
				//				ExternalInterface.addCallback("loadGridData", flex.loadGridData);
				ExternalInterface.addCallback("getGridData", flex.getGridData);
				ExternalInterface.addCallback("getDataGridProperty", flex.getDataGridProperty);
				ExternalInterface.addCallback("setJSonData", flex.setJSonData);
				ExternalInterface.addCallback("refresh",flex.refresh);
				ExternalInterface.addCallback("setColHide", flex.setColHide);
				ExternalInterface.addCallback("isColHide", flex.isColHide);
				ExternalInterface.addCallback("setColWidth", flex.setColWidth);
				ExternalInterface.addCallback("getColWidth", flex.getColWidth);
				ExternalInterface.addCallback("setColFix", flex.setColFix);
				ExternalInterface.addCallback("setRowFix", flex.setRowFix);
				ExternalInterface.addCallback("resetColFix", flex.resetColFix);
				ExternalInterface.addCallback("resetRowFix", flex.resetRowFix);
				ExternalInterface.addCallback("getColCount", flex.getColCount);
				ExternalInterface.addCallback("setColCellAlign", flex.setColCellAlign);
				ExternalInterface.addCallback("getColType", flex.getColType);
				ExternalInterface.addCallback("setColCellBgColor", flex.setColCellBgColor);
				ExternalInterface.addCallback("setColCellFgColor", flex.setColCellFgColor);
				ExternalInterface.addCallback("setColCellFont", flex.setColCellFont);
				ExternalInterface.addCallback("setColCellFontBold", flex.setColCellFontBold);
				ExternalInterface.addCallback("setColCellFontItalic", flex.setColCellFontItalic);
				ExternalInterface.addCallback("setColCellFontName", flex.setColCellFontName);
				ExternalInterface.addCallback("setColCellFontSize", flex.setColCellFontSize);
				ExternalInterface.addCallback("setColCellFontULine", flex.setColCellFontULine);	
				ExternalInterface.addCallback("setColCellActivation", flex.setColCellActivation);
				ExternalInterface.addCallback("getColCellActivation", flex.getColCellActivation);	
				ExternalInterface.addCallback("changeColumnSeparator", flex.changeColumnSeparator);
				ExternalInterface.addCallback("addDefaultContextMenuItem", flex.addDefaultContextMenuItem);
				ExternalInterface.addCallback("addUserContextMenuItem", flex.addUserContextMenuItem);
				ExternalInterface.addCallback("addContextMenuSeparator", flex.addContextMenuSeparator);
				ExternalInterface.addCallback("removeAllContextMenuItem", flex.removeAllContextMenuItem);
				
				ExternalInterface.addCallback("setColHDCheckBoxVisible", flex.setColHDCheckBoxVisible);
				ExternalInterface.addCallback("addGroup", flex.addGroup);
				ExternalInterface.addCallback("appendHeader", flex.appendHeader);
				ExternalInterface.addCallback("appendGroup", flex.appendGroup);
				ExternalInterface.addCallback("setGroupHDText", flex.setGroupHDText);
				ExternalInterface.addCallback("getGroupHDText", flex.getGroupHDText);
				ExternalInterface.addCallback("setColHDAlign", flex.setColHDAlign);
				ExternalInterface.addCallback("getColHDKey", flex.getColHDKey);
				ExternalInterface.addCallback("getColHDVisibleIndex", flex.getColHDVisibleIndex);
				ExternalInterface.addCallback("setColHDCheckBoxValue", flex.setColHDCheckBoxValue);
				ExternalInterface.addCallback("getColHDVisibleKey", flex.getColHDVisibleKey);
				ExternalInterface.addCallback("getColHDText", flex.getColHDText);
				ExternalInterface.addCallback("setColHDText", flex.setColHDText);
				ExternalInterface.addCallback("getColHDIndex", flex.getColHDIndex);
				ExternalInterface.addCallback("setColHDBgColor", flex.setColHDBgColor);
				ExternalInterface.addCallback("setColHDFgColor", flex.setColHDFgColor);
				ExternalInterface.addCallback("setGroupHDColor", flex.setGroupHDColor);
				ExternalInterface.addCallback("setGroupHDFont", flex.setGroupHDFont);								
				ExternalInterface.addCallback("setTreeMode", flex.setTreeMode);	
				ExternalInterface.addCallback("addRow", flex.addRow);
				ExternalInterface.addCallback("insertRow", flex.insertRow);
				ExternalInterface.addCallback("addRowAt", flex.addRowAt);
				ExternalInterface.addCallback("deleteRow", flex.deleteRow);
				ExternalInterface.addCallback("moveRow", flex.moveRow);
				ExternalInterface.addCallback("getRowCount", flex.getRowCount);
				ExternalInterface.addCallback("setActiveRowIndex", flex.setActiveRowIndex);
				ExternalInterface.addCallback("getActiveRowIndex", flex.getActiveRowIndex);
				ExternalInterface.addCallback("setRowActivation", flex.setRowActivation);
				ExternalInterface.addCallback("setRowBgColor", flex.setRowBgColor);
				ExternalInterface.addCallback("setRowFgColor", flex.setRowFgColor);	
				ExternalInterface.addCallback("setRowHide", flex.setRowHide);
				ExternalInterface.addCallback("isRowHide", flex.isRowHide);
				ExternalInterface.addCallback("filter", flex.filter);
				ExternalInterface.addCallback("search", flex.search);
				ExternalInterface.addCallback("setNumberFormat", flex.setNumberFormat);
				
				ExternalInterface.addCallback("getColumnProperty", flex.getColumnProperty);
				ExternalInterface.addCallback("setCRUDMode", flex.setCRUDMode);
				ExternalInterface.addCallback("cancelCRUD", flex.cancelCRUD);
				ExternalInterface.addCallback("clearCRUDMode", flex.clearCRUDMode);
				ExternalInterface.addCallback("cancelCRUDRow", flex.cancelCRUDRow);
				ExternalInterface.addCallback("getCellValueIndex", flex.getCellValueIndex);
				ExternalInterface.addCallback("setCellValueIndex", flex.setCellValueIndex);
				ExternalInterface.addCallback("getCellValue", flex.getCellValue);
				ExternalInterface.addCallback("setCellValue", flex.setCellValue);
				ExternalInterface.addCallback("getCellHiddenValueIndex", flex.getCellHiddenValueIndex);
				ExternalInterface.addCallback("setCellHiddenValueIndex", flex.setCellHiddenValueIndex);
				ExternalInterface.addCallback("getCellHiddenValue", flex.getCellHiddenValue);
				ExternalInterface.addCallback("setCellHiddenValue", flex.setCellHiddenValue);
				ExternalInterface.addCallback("setCellImage", flex.setCellImage);
				ExternalInterface.addCallback("getCellImage", flex.getCellImage);
				ExternalInterface.addCallback("setCellBgColor", flex.setCellBgColor);
				ExternalInterface.addCallback("setCellFgColor", flex.setCellFgColor);
				ExternalInterface.addCallback("setCellFont", flex.setCellFont);
				ExternalInterface.addCallback("setCellFontBold", flex.setCellFontBold);
				ExternalInterface.addCallback("setCellFontCLine", flex.setCellFontCLine);
				ExternalInterface.addCallback("setCellFontItalic", flex.setCellFontItalic);
				ExternalInterface.addCallback("setCellFontName", flex.setCellFontName);
				ExternalInterface.addCallback("setCellFontSize", flex.setCellFontSize);
				ExternalInterface.addCallback("setCellFontULine", flex.setCellFontULine);
				ExternalInterface.addCallback("allowDrawUpdate", flex.allowDrawUpdate);
				ExternalInterface.addCallback("addComboList", flex.addComboList);
				ExternalInterface.addCallback("setMultiComboData", flex.setMultiComboData);
				
				ExternalInterface.addCallback("getComboListKey", flex.getComboListKey);
				ExternalInterface.addCallback("getComboSelectedListKey", flex.getComboSelectedListKey);
				ExternalInterface.addCallback("getComboListCount", flex.getComboListCount);
				ExternalInterface.addCallback("getComboHiddenValue", flex.getComboHiddenValue);
				ExternalInterface.addCallback("getComboText", flex.getComboText);
				ExternalInterface.addCallback("getComboSelectedIndex", flex.getComboSelectedIndex);
				ExternalInterface.addCallback("setComboSelectedIndex", flex.setComboSelectedIndex);
				ExternalInterface.addCallback("setComboSelectedHiddenValue", flex.setComboSelectedHiddenValue);
				ExternalInterface.addCallback("getComboSelectedHiddenValue", flex.getComboSelectedHiddenValue);
				ExternalInterface.addCallback("addComboHeaderValue", flex.addComboHeaderValue);
				ExternalInterface.addCallback("hasComboList", flex.hasComboList);
				ExternalInterface.addCallback("clearComboList", flex.clearComboList);		
				ExternalInterface.addCallback("setComboRowCount", flex.setComboRowCount);	
				ExternalInterface.addCallback("getActiveColKey", flex.getActiveColKey);
				ExternalInterface.addCallback("addImageList", flex.addImageList);
				ExternalInterface.addCallback("removeImageList", flex.removeImageList);
				ExternalInterface.addCallback("getImageListURL", flex.getImageListURL);
				ExternalInterface.addCallback("setImageListSize", flex.setImageListSize);
				ExternalInterface.addCallback("clearImageList", flex.clearImageList);
				ExternalInterface.addCallback("getImageListCount", flex.getImageListCount);
				ExternalInterface.addCallback("addGridImageList", flex.addGridImageList);
				ExternalInterface.addCallback("setColCellGridImageList", flex.setColCellGridImageList);
				ExternalInterface.addCallback("clearGridImageList", flex.clearGridImageList);
				ExternalInterface.addCallback("setGridImageListSize", flex.setGridImageListSize);
				ExternalInterface.addCallback("clearGrid", flex.clearGrid);	
				ExternalInterface.addCallback("setDateFormat", flex.setDateFormat);
				ExternalInterface.addCallback("getTreeMode", flex.getTreeMode);
				ExternalInterface.addCallback("collapseTreeAll", flex.collapseTreeAll);
				ExternalInterface.addCallback("expandTreeAll", flex.expandTreeAll);
				ExternalInterface.addCallback("expandTreeNode", flex.expandTreeNode);
				ExternalInterface.addCallback("collapseTreeNode", flex.collapseTreeNode);
				ExternalInterface.addCallback("deleteTreeNode", flex.deleteTreeNode);
				ExternalInterface.addCallback("getRowIndexFromTreeKey", flex.getRowIndexFromTreeKey);
				ExternalInterface.addCallback("getTreeChildNodeCount", flex.getTreeChildNodeCount);
				ExternalInterface.addCallback("getTreeChildNodeKey", flex.getTreeChildNodeKey);
				ExternalInterface.addCallback("getTreeFirstNodeKey", flex.getTreeFirstNodeKey);
				ExternalInterface.addCallback("getTreeKeyFromRowIndex", flex.getTreeKeyFromRowIndex);
				ExternalInterface.addCallback("getTreeNextNodeKey", flex.getTreeNextNodeKey);
				ExternalInterface.addCallback("getTreeNodeDepth", flex.getTreeNodeDepth);
				ExternalInterface.addCallback("getTreeParentNodeKey", flex.getTreeParentNodeKey);
				ExternalInterface.addCallback("getTreePrevNodeKey", flex.getTreePrevNodeKey);
				ExternalInterface.addCallback("getTreeSummaryValue", flex.getTreeSummaryValue);
				ExternalInterface.addCallback("hasTreeChildNode", flex.hasTreeChildNode);				
				ExternalInterface.addCallback("hasTreeNextNode", flex.hasTreeNextNode);
				ExternalInterface.addCallback("hasTreeParentNode", flex.hasTreeParentNode);
				ExternalInterface.addCallback("hasTreePrevNode", flex.hasTreePrevNode);				
				ExternalInterface.addCallback("insertTreeNode", flex.insertTreeNode);
				ExternalInterface.addCallback("isTreeNodeCollapse", flex.isTreeNodeCollapse);
				ExternalInterface.addCallback("isTreeNodeExpand", flex.isTreeNodeExpand);
				ExternalInterface.addCallback("isTreeNodeKey", flex.isTreeNodeKey);
				ExternalInterface.addCallback("moveTreeNode", flex.moveTreeNode);
				ExternalInterface.addCallback("setTreeClickAction", flex.setTreeClickAction);		
				ExternalInterface.addCallback("excelExport", flex.excelExport);
				ExternalInterface.addCallback("excelImport", flex.excelImport);
				ExternalInterface.addCallback("setImagetextAlign", flex.setImagetextAlign);
				ExternalInterface.addCallback("setColCellFontCLine", flex.setColCellFontCLine);
				ExternalInterface.addCallback("setColCellMerge", flex.setColCellMerge);
				ExternalInterface.addCallback("getColMaxLength", flex.getColMaxLength);
				ExternalInterface.addCallback("setCellFocus",flex.setCellFocus);
				ExternalInterface.addCallback("setGroupMerge", flex.setGroupMerge);
				ExternalInterface.addCallback("clearGroupMerge", flex.clearGroupMerge);
				ExternalInterface.addCallback("isGroupMergeColumn",flex.isGroupMergeColumn);
				ExternalInterface.addCallback("hasGroupMerge",flex.hasGroupMerge);
				ExternalInterface.addCallback("addSummaryBar", flex.addSummaryBar);
				ExternalInterface.addCallback("clearSummaryBar", flex.clearSummaryBar);
				ExternalInterface.addCallback("getSummaryBarValue", flex.getSummaryBarValue);
				ExternalInterface.addCallback("hasSummaryBar", flex.hasSummaryBar);
				ExternalInterface.addCallback("setSummaryBarColor", flex.setSummaryBarColor);
				ExternalInterface.addCallback("setSummaryBarFont", flex.setSummaryBarFont);
				ExternalInterface.addCallback("setSummaryBarFormat", flex.setSummaryBarFormat);
				ExternalInterface.addCallback("setSummaryBarFunction", flex.setSummaryBarFunction);
				ExternalInterface.addCallback("setSummaryBarText", flex.setSummaryBarText);
				ExternalInterface.addCallback("setSummaryBarValue", flex.setSummaryBarValue);
				ExternalInterface.addCallback("setColCellExcelAsterisk", flex.setColCellExcelAsterisk);
				ExternalInterface.addCallback("clearExcelInfo", flex.clearExcelInfo);
				ExternalInterface.addCallback("setExcelFooter", flex.setExcelFooter);
				ExternalInterface.addCallback("setExcelHeader", flex.setExcelHeader);	
				ExternalInterface.addCallback("setAccessReader", flex.setAccessReader);	
				ExternalInterface.addCallback("setAccessReaderHeader", flex.setAccessReaderHeader);	
				ExternalInterface.addCallback("setColCellSort", flex.setColCellSort);
				ExternalInterface.addCallback("setColIndex", flex.setColIndex);
				ExternalInterface.addCallback("setColCellRadio", flex.setColCellRadio);
				ExternalInterface.addCallback("clearData", flex.clearData);
				ExternalInterface.addCallback("showBusyBar", flex.showBusyBar);
				ExternalInterface.addCallback("closeBusyBar", flex.closeBusyBar);
				ExternalInterface.addCallback("setProtocolData",flex.setProtocolData);
				ExternalInterface.addCallback("setDataObject",flex.setDataObject);
				ExternalInterface.addCallback("addEvent", flex.addEvent);
				ExternalInterface.addCallback("removeEvent", flex.removeEvent);
				ExternalInterface.addCallback("loseFocus", flex.loseFocus);
				ExternalInterface.addCallback("getDataObject",flex.getDataObject);
				ExternalInterface.addCallback("getProtocolData",flex.getProtocolData);
				ExternalInterface.addCallback("setXMLData", flex.setXMLData);
				ExternalInterface.addCallback("getXMLData", flex.getXMLData);
				ExternalInterface.addCallback("addFooter", flex.addFooter);
				ExternalInterface.addCallback("clearFooter", flex.clearFooter);
				ExternalInterface.addCallback("hasFooter", flex.hasFooter);
				// 				ExternalInterface.addCallback("rightClickSelectedCell",flex.rightClickSelectedCell);
				
				ExternalInterface.addCallback("setStatus", flex.setStatus);	
				ExternalInterface.addCallback("getStatus", flex.getStatus);
				ExternalInterface.addCallback("setParams", flex.setParams);
				ExternalInterface.addCallback("getParams", flex.getParams);
				ExternalInterface.addCallback("getParamCount", flex.getParamCount);
				ExternalInterface.addCallback("getParamKey", flex.getParamKey);
				ExternalInterface.addCallback("setMessage", flex.setMessage);
				ExternalInterface.addCallback("getMessage", flex.getMessage);
				ExternalInterface.addCallback("doQuery", flex.doQuery);
				ExternalInterface.addCallback("isDoQuery", flex.isDoQuery);
				
				ExternalInterface.addCallback("addComboListJson",flex.addComboListJson);
//				ExternalInterface.addCallback("addMulticomboListValue",flex.addMulticomboListValue);
				ExternalInterface.addCallback("getCheckedRowsIndex",flex.getCheckedRowsIndex);
				ExternalInterface.addCallback("setComboJSONData",flex.setComboJSONData);
				ExternalInterface.addCallback("refreshGrid",flex.refreshGrid);
				ExternalInterface.addCallback("setColCellImage",flex.setColCellImage);
				ExternalInterface.addCallback("getColumn",flex.getColumn);
				ExternalInterface.addCallback("insertHeader",flex.insertHeader);
				ExternalInterface.addCallback("addHeaders",flex.addHeaders);
				ExternalInterface.addCallback("createGroup",flex.createGroup);
				ExternalInterface.addCallback("getColumnIndex",flex.getColumnIndex);
				ExternalInterface.addCallback("getColumnType",flex.getColumnType);
				ExternalInterface.addCallback("setWaitingLogoValue",flex.setWaitingLogoValue);
				ExternalInterface.addCallback("showWaitingLogo",flex.showWaitingLogo);
				ExternalInterface.addCallback("hideWaitingLogo",flex.hideWaitingLogo);
				ExternalInterface.addCallback("addComboDataAtColumn",flex.addComboDataAtColumn);
				ExternalInterface.addCallback("addComboDataAtColumnIndex",flex.addComboDataAtColumnIndex);
				ExternalInterface.addCallback("destroyEventListener",flex.destroyEventListener);
				ExternalInterface.addCallback("changeRowSeparator",flex.changeRowSeparator);
				ExternalInterface.addCallback("setTextDataByService",flex.setTextDataByService);
//				ExternalInterface.addCallback("addXMLData",flex.addXMLData);
//				ExternalInterface.addCallback("addXMLRow",flex.addXMLRow);
//				ExternalInterface.addCallback("addXMLRowAt",flex.addXMLRowAt);
//				ExternalInterface.addCallback("applyChange",flex.applyChange);
				ExternalInterface.addCallback("getAllData",flex.getAllData);
				ExternalInterface.addCallback("removeAllData",flex.removeAllData);
				ExternalInterface.addCallback("deleteRows",flex.deleteRows);
				ExternalInterface.addCallback("doStartQuery",flex.doStartQuery);
				ExternalInterface.addCallback("getGridProtocolText",flex.getGridProtocolText);
				ExternalInterface.addCallback("loadGridData",flex.loadGridData);
//				ExternalInterface.addCallback("loadGridStringData",flex.loadGridStringData);
				ExternalInterface.addCallback("queryTextData",flex.queryTextData);
				ExternalInterface.addCallback("queryComboTextData",flex.queryComboTextData);
				ExternalInterface.addCallback("getCell",flex.getCell);
				ExternalInterface.addCallback("getCellValues",flex.getCellValues);
				ExternalInterface.addCallback("setButtonVisible",flex.setButtonVisible);
				ExternalInterface.addCallback("setCheckBoxVisible",flex.setCheckBoxVisible);
				ExternalInterface.addCallback("getCellBackgroundColor",flex.getCellBackgroundColor);
//				ExternalInterface.addCallback("getCellFontColor",flex.getCellFontColor);
				ExternalInterface.addCallback("hideColumnIndex",flex.hideColumnIndex);
				ExternalInterface.addCallback("showColumnIndex",flex.showColumnIndex);
				ExternalInterface.addCallback("getColumnProperty",flex.getColumnProperty);
				ExternalInterface.addCallback("getComboNameAtColumn",flex.getComboNameAtColumn);
				ExternalInterface.addCallback("getComboNameAtColumnIndex",flex.getComboNameAtColumnIndex);
				ExternalInterface.addCallback("getDataGridString",flex.getDataGridString);
				ExternalInterface.addCallback("getDeletedRows",flex.getDeletedRows);
				ExternalInterface.addCallback("getInsertedRows",flex.getInsertedRows);
				ExternalInterface.addCallback("getRow",flex.getRow);
				ExternalInterface.addCallback("getUpdatedRows",flex.getUpdatedRows);
				ExternalInterface.addCallback("getCurrentPage",flex.getCurrentPage);
				ExternalInterface.addCallback("getPageTotal",flex.getPageTotal);
//				ExternalInterface.addCallback("getPagingIndex",flex.getPagingIndex);
				ExternalInterface.addCallback("getPagingCount",flex.getPagingCount);
//				ExternalInterface.addCallback("setPagingIndex",flex.setPagingIndex);
//				ExternalInterface.addCallback("nextNavigate",flex.nextNavigate);
				
				ExternalInterface.addCallback("scrollToRow",flex.scrollToRow);
				ExternalInterface.addCallback("setCell",flex.setCell);
				ExternalInterface.addCallback("getCellIndexArray",flex.getCellIndexArray);
				ExternalInterface.addCallback("setCellArray",flex.setCellArray);
				ExternalInterface.addCallback("setCellPaddingLeft",flex.setCellPaddingLeft);
				ExternalInterface.addCallback("setCellPaddingRight",flex.setCellPaddingRight);
				ExternalInterface.addCallback("setCellBorderColor",flex.setCellBorderColor);
//				ExternalInterface.addCallback("setRowPaddingLeft",flex.setRowPaddingLeft);
//				ExternalInterface.addCallback("setRowPaddingRight",flex.setRowPaddingRight);
//				ExternalInterface.addCallback("setCellAlign",flex.setCellAlign);
//				ExternalInterface.addCallback("setRowAlign",flex.setRowAlign);
//				ExternalInterface.addCallback("setRowFontBold",flex.setRowFontBold);
//				ExternalInterface.addCallback("setCellBackgroundColorDefault",flex.setCellBackgroundColorDefault);
//				ExternalInterface.addCallback("setCellFontColorArray",flex.setCellFontColorArray);
//				ExternalInterface.addCallback("setCellFontColorDefault",flex.setCellFontColorDefault);
//				ExternalInterface.addCallback("setColumnProperties",flex.setColumnProperties);
//				ExternalInterface.addCallback("setDataGridProperties",flex.setDataGridProperties);
//				ExternalInterface.addCallback("setDataGridToClipboard",flex.setDataGridToClipboard);
//				ExternalInterface.addCallback("setPDFConfiguration",flex.setPDFConfiguration);
//				ExternalInterface.addCallback("setRowAt",flex.setRowAt);
//				ExternalInterface.addCallback("setRowBackgroundColorArray",flex.setRowBackgroundColorArray);
//				ExternalInterface.addCallback("setRowBackgroundColorDefault",flex.setRowBackgroundColorDefault);
				ExternalInterface.addCallback("setXMLRowAt",flex.setXMLRowAt);
//				ExternalInterface.addCallback("getExcelString",flex.getExcelString);
//				ExternalInterface.addCallback("createJSONGrid",flex.createJSONGrid);
//				ExternalInterface.addCallback("initGrid",flex.initGrid);
				ExternalInterface.addCallback("handleWheel",flex.handleWheel);
//				ExternalInterface.addCallback("setRowFgColorDefault",flex.setRowFgColorDefault);
				ExternalInterface.addCallback("showProgressBar",flex.showProgressBar);
				ExternalInterface.addCallback("hideProgressBar",flex.hideProgressBar);
//				ExternalInterface.addCallback("changeScrollBar",flex.changeScrollBar);
//				ExternalInterface.addCallback("getRowValues",flex.getRowValues);
//				ExternalInterface.addCallback("getVersion",flex.getVersion);
//				ExternalInterface.addCallback("setGridAMFData",flex.setGridAMFData);
				ExternalInterface.addCallback("getSelectedIndex",flex.getSelectedIndex);
				ExternalInterface.addCallback("getSelectedItem",flex.getSelectedItem);
				ExternalInterface.addCallback("getColumns",flex.getColumns);
				ExternalInterface.addCallback("getColumnCount",flex.getColumnCount);
//				ExternalInterface.addCallback("setStatusbarHide",flex.setStatusbarHide);
//				ExternalInterface.addCallback("setColCellRolloverFgColor",flex.setColCellRolloverFgColor);
//				ExternalInterface.addCallback("getColumnKeys",flex.getColumnKeys);
//				ExternalInterface.addCallback("getCRUDJsonData",flex.getCRUDJsonData);
//				ExternalInterface.addCallback("getCheckedItems",flex.getCheckedItems);
//				ExternalInterface.addCallback("setHandCursor",flex.setHandCursor);
//				ExternalInterface.addCallback("reverseAutoNumber",flex.reverseAutoNumber);
				//				ExternalInterface.addCallback("setLanguage",flex.setLanguage);
				ExternalInterface.addCallback("addComboHeaderValue",flex.addComboHeaderValue);
				//				ExternalInterface.addCallback("bStatusbarBorderVisible",flex.bStatusbarBorderVisible);
				//				ExternalInterface.addCallback("headerBorderColor",flex.headerBorderColor);
				//				ExternalInterface.addCallback("selectedIndexChanged",flex.selectedIndexChanged);
				//				ExternalInterface.addCallback("onStartQuery",flex.onStartQuery);
				//				ExternalInterface.addCallback("importExcelComplete",flex.importExcelComplete);
				ExternalInterface.addCallback("importExcelByActiveX",flex.importExcelByActiveX);
				ExternalInterface.addCallback("exportExcelByActiveX",flex.exportExcelByActiveX);
				ExternalInterface.addCallback("setDataObject",flex.setDataObject);
				ExternalInterface.addCallback("getDataObject",flex.getDataObject);
				ExternalInterface.addCallback("setProtocolData",flex.setProtocolData);
				ExternalInterface.addCallback("getProtocolData",flex.getProtocolData);
				ExternalInterface.addCallback("setStatus",flex.setStatus);
				ExternalInterface.addCallback("getStatus",flex.getStatus);
				ExternalInterface.addCallback("setParams",flex.setParams);
				ExternalInterface.addCallback("getParams",flex.getParams);
				ExternalInterface.addCallback("getParamCount",flex.getParamCount);
				ExternalInterface.addCallback("getParamKey",flex.getParamKey);
				ExternalInterface.addCallback("setMessage",flex.setMessage);
				ExternalInterface.addCallback("getMessage",flex.getMessage);
				ExternalInterface.addCallback("doQuery",flex.doQuery);
				ExternalInterface.addCallback("isDoQuery",flex.isDoQuery);
				ExternalInterface.addCallback("doEndQuery",flex.doEndQuery);
				ExternalInterface.addCallback("setCellActivation", flex.setCellActivation);
				ExternalInterface.addCallback("getCellActivation", flex.getCellActivation);
				ExternalInterface.addCallback("handleWheel", flex.handleWheel);
				ExternalInterface.addCallback("getTextData", flex.getTextData);		
				ExternalInterface.addCallback("handlePressOutOfGridOne", flex.handlePressOutOfGridOne);
				ExternalInterface.addCallback("generateTestData", flex.generateTestData);
				ExternalInterface.addCallback("insertColumn",flex.insertColumn);
				ExternalInterface.addCallback("getClientDataString",flex.getClientDataString);
				ExternalInterface.addCallback("undoRowHide",flex.undoRowHide);
				ExternalInterface.addCallback("setMultiRowsHide",flex.setMultiRowsHide);
				ExternalInterface.addCallback("setArrayData",flex.setArrayData);
				ExternalInterface.addCallback("getArrayData",flex.getArrayData);
				ExternalInterface.addCallback("getItemAt",flex.getItemAt);
				ExternalInterface.addCallback("setItemAt",flex.setItemAt);
				ExternalInterface.addCallback("getCheckBoxValue",flex.getCheckBoxValue);
				ExternalInterface.addCallback("getSelectedIndexs",flex.getSelectedIndexs);
				ExternalInterface.addCallback("getCellGroupMergeInfo",flex.getCellGroupMergeInfo);
				ExternalInterface.addCallback("dispatchCustomEvent",flex.dispatchCustomEvent);
				ExternalInterface.addCallback("setHeaderContent",flex.setHeaderContent);
				ExternalInterface.addCallback("addDynamicComboList",flex.addDynamicComboList);
				ExternalInterface.addCallback("setGridOneHeaderVisible",flex.setGridOneHeaderVisible);
				ExternalInterface.addCallback("setGridOneHeaderImage",flex.setGridOneHeaderImage);
				ExternalInterface.addCallback("setGridOneHeaderTitle",flex.setGridOneHeaderTitle);
				ExternalInterface.addCallback("getDataFieldIndex",flex.getDataFieldIndex);
				ExternalInterface.addCallback("endEditWithReason",flex.endEditWithReason);
				ExternalInterface.addCallback("enableDataGrid",flex.enableDataGrid);
				ExternalInterface.addCallback("setRowHeight",flex.setRowHeight);
				ExternalInterface.addCallback("addComboListValue",flex.addComboListValue);
				ExternalInterface.addCallback("setJsonDataUrl",flex.setJsonDataUrl);
				ExternalInterface.addCallback("printPDF",flex.printPDF);
				ExternalInterface.addCallback("setToolTipInfor",flex.setToolTipInfor);
				ExternalInterface.addCallback("setLanguage",flex.setLanguage);
				ExternalInterface.addCallback("setHeaderRightPadding",flex.setHeaderRightPadding);
				ExternalInterface.addCallback("setCellBorderColor",flex.setCellBorderColor);
				ExternalInterface.addCallback("removeCellBorder",flex.removeCellBorder);
				ExternalInterface.addCallback("removeCellBorderAll",flex.removeCellBorderAll);
 
			}			
		}
		
	}
}

