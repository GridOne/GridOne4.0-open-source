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

package kr.co.actsone.events
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author actsonecomputer
	 */
	public class SAEvent extends Event
	{
		/**
		 *  The SAEvent.OLAP_OPENDATA constant defines the value of the 
	     *  <code>type</code> property of the event object for a 
	     *  <code>OlapOpenData</code> event, which indicates that an 
	     *  item has opened the data.
		 * 	@eventType OlapOpenData
		 */
		public static const OLAP_OPENDATA:String = "OlapOpenData";
		/**
		 *  The SAEvent.OLAP_CLOSEDATA constant defines the value of the 
	     *  <code>type</code> property of the event object for a 
	     *  <code>OlapCloseData</code> event, which indicates that an 
	     *  item has closed the data.
		 * 	@eventType OlapCloseData
		 */
		public static const OLAP_CLOSEDATA:String = "OlapCloseData";
		
		/**
		 *  The SAEvent.ADD_ROW constant defines the value of the 
	     *  <code>type</code> property of the event object for a 
	     *  <code>AddRow</code> event, which indicates that the 
	     *  DataGrid has added a new row.
		 * 	@eventType AddRow
		 */
		public static const ADD_ROW:String = "AddRow";
		/**
		 *  The SAEvent.DEL_ROW constant defines the value of the 
	     *  <code>type</code> property of the event object for a 
	     *  <code>DelRow</code> event, which indicates that the 
	     *  DataGrid has deleted a row.
		 * 	@eventType DelRow
		 */
		public static const DEL_ROW:String = "DelRow";
		/**
		 *  The SAEvent.UPDATE_DISPLAY constant defines the value of the 
	     *  <code>type</code> property of the event object for a 
	     *  <code>UpdateDisplay</code> event, which indicates that the 
	     *  DataGrid has updated display.
		 * 	@eventType UpdateDisplay
		 */
		public static const UPDATE_DISPLAY:String = "UpdateDisplay"; //20101005 park jeong soo add
				
		/**
		 * 
		 * @default 
		 */
		public var data:Object;		
		
		/**
		 *  The SAEvent.INSERT_SUCCESS constant indicates that the DataGrid has inserted successfully
		 * 	@eventType InsertSuccess
		 */
		public static const INSERT_SUCCESS:String="InsertSuccess";
		
		/**
		 *  The SAEvent.INSERT_SUCCESS constant indicates that the DataGrid has inserted unsuccessfully
		 * 	@eventType InsertFault
		 */
		public static const INSERT_FAULT:String="InsertFault";
		
		/**
		 *  The SAEvent.INSERT_SUCCESS constant indicates that the DataGrid has updated successfully
		 * 	@eventType UpdateSuccess
		 */
		public static const UPDATE_SUCCESS:String="UpdateSuccess";
		
		/**
		 *  The SAEvent.INSERT_SUCCESS constant indicates that the DataGrid has updated unsuccessfully
		 * 	@eventType UpdateFault
		 */
		public static const UPDATE_FAULT:String="UpdateFault";
		
		/**
		 *  The SAEvent.INSERT_SUCCESS constant indicates that the DataGrid has deleted successfully
		 * 	@eventType DeleteSuccess
		 */
		public static const DELETE_SUCCESS:String="DeleteSuccess";
		
		/**
		 *  The SAEvent.INSERT_SUCCESS constant indicates that the DataGrid has deleted unsuccessfully
		 * 	@eventType DeteteFault
		 */
		public static const DELETE_FAULT:String="DeleteFault";
		
		/**
		 *  The SAEvent.POP_CLOSE constant indicates that the popup close
		 * 	@eventType DeteteFault
		 */
		public static const POP_CLOSE:String="PopClose";
		public static const POP_SEARCH_DATA:String="SearchData";
		
		/**
		 *  The SAEvent.BOUND_HEADER_COMPLETE constant indicates that the grid created completely
		 * 	@eventType
		 */
		public static const BOUND_HEADER_COMPLETE:String="boundHeaderComplete";
		
		public static const LOAD_DATA_COMPLETED:String="loadDataCompleted";
		
		public static const THUMB_MOUSE_UP:String="thumbMouseUp";
		
		public static const THUMB_MOUSE_MOVE:String="thumbMouseMove";
		
		public static const DATAPROVIDE_TO_PARENT:String="dataprovide_to_parent";

		public static const CHECKBOX_CLICK:String="onCheckboxClick";
		
		public static const RADIOBUTTON_CLICK:String="onRadiobuttonClick";
		
		public static const CLOSE_EXCEL_POPUP:String="close_excel_popup";
		
		public static const IMAGE_ICON_CLICK:String = 'imageIconClick';	//20110414 Ma Yong Ho add

		public static const MASSAGE_POPUP_CLOSE:String = 'massage_popup_close';	//20110419 Ma Yong Ho Add
		
		public static const PRINT_OPTION_POPUP_CLOSE:String = 'print_option_popup_close';	//20110504 Ma Yong Ho Add		
		
		public static const SELECT_FILE_TYPE:String="SelectFileType";
		
		public static const ON_CELL_CLICK:String="onCellClick";
		
		public static const ON_CELL_CHANGE:String="onCellChange";
		
		public static const ON_COMBO_CHANGE:String="onComboChange";
		
		public static const ON_HD_CHECKBOX_CLICK:String="onHDCheckBoxClick";
		
		public static const ON_INITIALIZE:String="onInitialize";
		
		public static const ON_HEADER_CLICK:String="onHeaderClick";
		
		public static const ON_ROW_VISIBLE:String="onRowVisible";
		
		public static const INIT_GRID_COMPLETED:String="initGridCompleted";
		
		public static const ON_CELL_DBL_CLICK:String="onCellDblClick";			
		
		public static const ON_CELL_RIGHT_CLICK:String="onCellRClick";
		
		public static const ON_COLLAPSE:String="onCollapse";
		
		public static const ON_EXPAND :String="onExpand";
		
		public static const ON_ROW_SCROLL:String = "onRowScroll";
		
		public static const ON_COL_SCROLL:String = "onColScroll";
		
		public static const ON_ROW_ACTIVATE:String = "onRowActivate";
		
		public static const END_QUERY:String="endQuery";
		
		public static const ON_TREE_NODE_CLICK :String="onTreeNodeClick";
		
		public static const ON_MOUSE_OVER :String="onMouseOver";
		
		public static const ON_MOUSE_OUT :String="onMouseOut";
		
		public static const ON_END_FILE_EXPORT :String="onEndFileExport";		
		
		public static const BEFORE_SHOW_USER_CONTEXT_MENU : String="beforeShowUserContextMenu";
		
		public static const USER_CONTEXT_MENU_CLICK : String="userContextMenuClick";
		
		public static const ON_ENTER:String="onEnter";
		
		public static const ON_START_QUERY:String="onStartQuery";
		
		public static const ON_BUTTON_CLICK:String="onButtonClick";
		
		public static const ON_BLANK_CLICK:String="onBlankClick";
		
		public static const SELECTED_INDEX_CHANGED:String="selectedIndexChanged";
		
		public static const IMPORT_EXCEL_COMPLETED:String="importExcelComplete";
		
		public static const ON_SELECT_RIGHT_CLICK:String="onSelectRClick";
		
		public static const UPDATE_STATE_HEADER_CHECK_BOX:String="updateStateHeaderCheckBox";
		
		public static const UPDATE_EXTERNAL_SCROLL:String="updateExternalScroll";
		
		public static const TEXT_INPUT_DATE_KEY_DOWN:String="textInputDateKeyDown";
		
		public static const ON_RESIZE_GRID_HEIGHT:String ="onResizeGridHeight";
		
		public static const TEXT_INPUT_KEY_UP:String ="textInputKeyUp";
		
		public static const ON_CELL_MODE:String ="onCellMode";
		
		public static const ON_DG_FOCUS:String ="onDgFocus";
		
		public static const COLLECTION_CHANGE:String ="dgcollectionChange";
		public static const GRIDONE_CLICK:String ="onClick";
		public static const ON_ROW_KEYMOVE:String="onRowKeyMove";
		
		private var _bridgeName:String;
		private var _beginRowIndex:int;
		private var _totalRow:Number;
		private var _dataProviderChange:Object;

		public function get dataProviderChange():Object
		{
			return _dataProviderChange;
		}

		public function set dataProviderChange(value:Object):void
		{
			_dataProviderChange = value;
			eventResult["dataProviderChange"]=value;
		}

		public function get bridgeName():String
		{
			return _bridgeName;
		}
       
		public function set bridgeName(value:String):void
		{
			_bridgeName = value;
			eventResult["bridgeName"]=value;
		}
        
		public function get totalRow():Number
		{
			return _totalRow;
		}
		
		public function set totalRow(value:Number):void
		{
			_totalRow = value;
			eventResult["totalRow"]=value;
		}
		
		public function get beginRowIndex():int
		{
			return _beginRowIndex;
		}
		
		public function set beginRowIndex(value:int):void
		{
			_beginRowIndex=value;
			eventResult["beginRowIndex"]=value;
		} 
		
		private var _endRowIndex:int;
		
		public function get endRowIndex():int
		{
			return _endRowIndex;
		}
		
		public function set endRowIndex(value:int):void
		{
			_endRowIndex=value;
			eventResult["endRowIndex"]=value;
		}
		
		private var _popupContents:Array;
		
		public function get popupContents():Array
		{
			return _popupContents;
		}
		
		public function set popupContents(value:Array):void
		{
			_popupContents=value;
			eventResult["popupContents"]=value;
		}
		
		private var _saveMssageBool:Boolean;
		
		public function get saveMssageBool():Boolean
		{
			return _saveMssageBool;
		}
		
		public function set saveMssageBool(value:Boolean):void
		{
			_saveMssageBool=value;
			eventResult["saveMssageBool"]=value;
		}
		
		private var _fileType:String="xlsx";
		
		public function get fileType():String
		{
			return _fileType;
		}
		
		public function set fileType(value:String):void
		{
			_fileType=value;
			eventResult["fileType"]=value;
		}
		
		private var _columnKey:String = "";
		
		public function get columnKey():String
		{
			return _columnKey;
		}
		
		public function set columnKey(value:String):void
		{
			_columnKey=value;
			eventResult["columnKey"]=value;
		}
		
		private var _nRow:int=0;
		
		public function get nRow():int
		{
			return _nRow;
		}
		
		public function set nRow(value:int):void
		{
			_nRow=value;
			eventResult["nRow"]=value;
		}
			
		private var _columnIndex:int;
		
		public function get columnIndex():int
		{
			return _columnIndex;
		}
		
		public function set columnIndex(value:int):void
		{
			_columnIndex=value;
			eventResult["columnIndex"]=value;
		}
		
		private var _strOldValue:String = "";
		
		public function get strOldValue():String
		{
			return _strOldValue;
		}
		
		public function set strOldValue(value:String):void
		{
			_strOldValue=value;
			eventResult["strOldValue"]=value;
		}
		
		private var _strNewValue:Object = "";
		
		public function get strNewValue():Object
		{
			return _strNewValue;
		}
		
		public function set strNewValue(value:Object):void
		{
			_strNewValue=value;
			eventResult["strNewValue"]=value;
		}
		
		private var _oldIndex:int;
		
		public function get oldIndex():int
		{
			return _oldIndex;
		}
		
		public function set oldIndex(value:int):void
		{
			_oldIndex=value;
			eventResult["oldIndex"]=value;
		}
		
		private var _newIndex:int;
		
		public function get newIndex():int
		{
			return _newIndex;
		}
		
		public function set newIndex(value:int):void
		{
			_newIndex=value;
			eventResult["newIndex"]=value;
		}
		
		private var _strTreeKey :String = "";
		
		public function get strTreeKey():String
		{
			return _strTreeKey;
		}
		
		public function set strTreeKey(value:String):void
		{
			_strTreeKey=value;
			eventResult["strTreeKey"]=value;
		}
		
		private var _nFirstVisibleRowIndex:int;
		
		public function get nFirstVisibleRowIndex():int
		{
			return _nFirstVisibleRowIndex;
		}
		
		public function set nFirstVisibleRowIndex(value:int):void
		{
			_nFirstVisibleRowIndex=value;
			eventResult["nFirstVisibleRowIndex"]=value;
		}
		
		
		private var _nLastVisibleRowIndex:int;
		
		public function get nLastVisibleRowIndex():int
		{
			return _nLastVisibleRowIndex;
		}
		
		public function set nLastVisibleRowIndex(value:int):void
		{
			_nLastVisibleRowIndex=value;
			eventResult["nLastVisibleRowIndex"]=value;
		}
		
		private var _nLeft:Number;
		
		public function get nLeft():Number
		{
			return _nLeft;
		}
		
		public function set nLeft(value:Number):void
		{
			_nLeft=value;
			eventResult["nLeft"]=value;
		}
		
		private var _nWidth:Number;
		
		public function get nWidth():Number
		{
			return _nWidth;
		}
		
		public function set nWidth(value:Number):void
		{
			_nWidth=value;
			eventResult["nWidth"]=value;
		}
		
		private var _nRange:Number;
		
		public function get nRange():Number
		{
			return _nRange;
		}
		
		public function set nRange(value:Number):void
		{
			_nRange=value;
			eventResult["nRange"]=value;
			
		}
		
		private var _nScrollIndex:Number = 0;
		
		public function get nScrollIndex():Number
		{
			return _nScrollIndex;
		}
		
		public function set nScrollIndex(value:Number):void
		{
			_nScrollIndex=value;
			eventResult["nScrollIndex"]=value;
		}
		
		private var _strArea :String = "";
		
		public function get strArea():String
		{
			return _strArea;
		}
		
		public function set strArea(value:String):void
		{
			_strArea=value;
			eventResult["strArea"]=value;
		}
		
		private var _strMenuKey : String; 
		
		public function get strMenuKey():String
		{
			return _strMenuKey;
		}
		
		public function set strMenuKey(value:String):void
		{
			_strMenuKey = value;
			eventResult["strMenuKey"]=value;
		}
		
		private var _strMenuItemKey : String;
		
		public function get strMenuItemKey():String
		{
			return _strMenuItemKey;
		}
		
		public function set strMenuItemKey(value:String):void
		{
			_strMenuItemKey = value;
			eventResult["strMenuItemKey"]=value;
		}
		
		private var _editable:Boolean;
		
		public function get editable():Boolean
		{
			return _editable;
		}
		
		public function set editable(value:Boolean):void
		{
			this._editable=value;
			eventResult["editable"]=value;
		}

		private var _isLeaf:Boolean;
		
		public function get isLeaf():Boolean
		{
			return _isLeaf;
		}
		
		public function set isLeaf(value:Boolean):void
		{
			this._isLeaf=value;
			eventResult["isLeaf"]=value;
		}
		
		private var _oldPosition:Number;
		
		public function get oldPosition():Number
		{
			return _oldPosition;
		}
		
		public function set oldPosition(value:Number):void
		{
			this._oldPosition=value;
			eventResult["oldPosition"]=value;
		}
		
		private var _detail:String;
		
		public function get detail():String
		{
			return _detail;
		}
		
		public function set detail(value:String):void
		{
			this._detail=value;
			eventResult["detail"]=value;
		}
		
		private var _nGridHeight:Number;
		
		public function get nGridHeight():Number
		{
			return _nGridHeight;
		}
		
		public function set nGridHeight(value:Number):void
		{
			this._nGridHeight=value;
			eventResult["nGridHeight"]=value;
		}
		
		private var _strMode:String;
		
		public function get strMode():String
		{
			return _strMode;
		}
		
		public function set strMode(value:String):void
		{
			this._strMode=value;
			eventResult["strMode"]=value;
		}
		
		private var _strText:String;
		
		public function get strText():String
		{
			return _strText;
		}
		
		public function set strText(value:String):void
		{
			this._strText=value;
			eventResult["strText"]=value;
		}
		
		private var _keyCode:uint;
		
		public function get keyCode():uint
		{
			return _keyCode;
		}
		
		public function set keyCode(value:uint):void
		{
			this._keyCode=value;
			eventResult["keyCode"]=value;
		}
		
		private var _nRowBk:int=0;		//this property is used in onCellClickEvent
		
		public function get nRowBk():int
		{
			return _nRowBk;
		}
		
		public function set nRowBk(value:int):void
		{
			_nRowBk=value;
			eventResult["nRowBk"]=value;
		}
		
		public var eventResult:Object;
				
		/**
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function SAEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			eventResult=new Object();
		}
		
	}
}