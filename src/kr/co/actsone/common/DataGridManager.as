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
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.controls.ExVScrollBar;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumnGroup;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridGroupItemRenderer;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridHeaderRenderer;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridSortItemRenderer;
	import kr.co.actsone.custom.PopContextMenu;
	import kr.co.actsone.editor.ComboDynamicEditor;
	import kr.co.actsone.editor.ComboEditor;
	import kr.co.actsone.editor.DateFieldEditor;
	import kr.co.actsone.editor.ImageTextEditor;
	import kr.co.actsone.editor.ImageTextRightEditor;
	import kr.co.actsone.editor.NumberEditor;
	import kr.co.actsone.editor.TextAreaEditor;
	import kr.co.actsone.events.ExAdvancedDataGridEvent;
	import kr.co.actsone.events.ExAdvancedDataGridEventReason;
	import kr.co.actsone.events.SAEvent;
	import kr.co.actsone.itemRenderers.ButtonRenderer;
	import kr.co.actsone.itemRenderers.CalendarRenderer;
	import kr.co.actsone.itemRenderers.CheckBoxRenderer;
	import kr.co.actsone.itemRenderers.ComboDynamicRenderer;
	import kr.co.actsone.itemRenderers.ComboHeaderRenderer;
	import kr.co.actsone.itemRenderers.ComboRendrerer;
	import kr.co.actsone.itemRenderers.HeaderCheckBoxRenderer;
	import kr.co.actsone.itemRenderers.HideImageTextRightRenderer;
	import kr.co.actsone.itemRenderers.HtmlHeaderRenderer;
	import kr.co.actsone.itemRenderers.HtmlRenderer;
	import kr.co.actsone.itemRenderers.ImageRenderer;
	import kr.co.actsone.itemRenderers.ImageTextRenderer;
	import kr.co.actsone.itemRenderers.ImageTextRightRenderer;
	import kr.co.actsone.itemRenderers.LabelItemRenderer;
	import kr.co.actsone.itemRenderers.LinkButtonRenderer;
	import kr.co.actsone.itemRenderers.MaskedInput;
	import kr.co.actsone.itemRenderers.MultiComboRenderer;
	import kr.co.actsone.itemRenderers.NumberItemRenderer;
	import kr.co.actsone.itemRenderers.RadioButtonRenderer;
	import kr.co.actsone.itemRenderers.TextAreaRenderer;
	import kr.co.actsone.itemRenderers.TotalColumnRenderer;
	import kr.co.actsone.popup.FindPopup;
	import kr.co.actsone.protocol.GridProtocol;
	import kr.co.actsone.utils.ConvertProperty;
	import kr.co.actsone.utils.ErrorMessages;
	import kr.co.actsone.utils.MenuConstants;
	import kr.co.actsone.utils.MouseWheelTrap;
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.IViewCursor;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.scrollClasses.ScrollBar;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ResizeEvent;
	import mx.events.ScrollEvent;
	import mx.managers.PopUpManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.utils.StringUtil;
	import mx.utils.UIDUtil;
	
	use namespace mx_internal;
	
	public  class DataGridManager
	{
		/*************************************************************
		 *  private variables
		 * ***********************************************************/	
		private var err:ErrorMessages=new ErrorMessages();
		protected var gridone:GridOne;			
		protected var labelFuncLib:LabelFunctionLib;
		private var rowDict:Dictionary=new Dictionary();
		public var gridProtocol:GridProtocol;
		private var _lockedColumnCount:int=0;
		public function DataGridManager(app:Object)
		{
			gridone=app as GridOne;
			labelFuncLib = new LabelFunctionLib(gridone);
			gridProtocol=new GridProtocol(app);
		}
		
		protected function get datagrid():ExAdvancedDataGrid
		{
			return gridone.datagrid;
		}
		
		protected function get gridoneImpl():GridOneImpl
		{
			return gridone.gridoneImpl;
		}
		
		protected function get gridoneManager():GridOneManager
		{
			return gridone.gridoneManager;
		}
		
		/**
		 * define column separator in case using text data.
		 */
		public static var columnSeparator:String="|";
		
		/**
		 * define row separator in case using text data.
		 */
		public static var rowSeparator:String="%%";
		
		private var sourceCellValue:String;
		private var sourceColType:String;		
		
		
		/*************************************************************
		 * set item renderer for a column.
		 * @param col column need to be updated item renderer
		 * @param value type of column
		 * @param isHeaderRenderer provide information that item renderer is used in header
		 * ***********************************************************/
		public function setItemRenderer(col:ExAdvancedDataGridColumn, value:String , isHeaderRenderer:Boolean = false):void
		{			
			registerItemRenderer(col,value,isHeaderRenderer);
		}
		
		/*************************************************************
		 * register itemRenderer
		 * @param col column need to be updated item renderer
		 * @param value type of column
		 * @param isHeaderRenderer provide information that item renderer is used in header
		 * ***********************************************************/
		public function registerItemRenderer(col:ExAdvancedDataGridColumn, value:String , isHeaderRenderer:Boolean = false):void
		{
			var itemRendererCls:ClassFactory;
			var itemEditorCls:ClassFactory;
			var editDataField:String="";
			
			if (!col is ExAdvancedDataGridColumn)
				return;
			if(isHeaderRenderer)
			{
				if (value == ColumnType.CHECKBOX)
				{
					itemRendererCls= new ClassFactory(HeaderCheckBoxRenderer);
					col.sortable=false;
					col.isCheckBoxHeaderRenderer=true;
				}
				if (value ==ColumnType.COMBOHEADER)
				{
					itemRendererCls= new ClassFactory(ComboHeaderRenderer);
					(col as ExAdvancedDataGridColumn).sortable=false;
				}
				if (value ==ColumnType.HTMLHEADER)
				{
					itemRendererCls= new ClassFactory(HeaderCheckBoxRenderer);
				}
				
				(col as ExAdvancedDataGridColumn).headerRenderer=itemRendererCls;
			}
			else
			{
				if (value == ColumnType.NUMBER)
				{
					
					if(!datagrid.performanceMode)
					{
						itemRendererCls=new ClassFactory(NumberItemRenderer);
					}
					(col as ExAdvancedDataGridColumn).labelFunction = labelFuncLib.renderLabelFuncOfNumberColumn;
					itemEditorCls=new ClassFactory(NumberEditor);
					editDataField="myNumberString";
					(col as ExAdvancedDataGridColumn).public::setStyle("textAlign", "right");
					(col as ExAdvancedDataGridColumn).editorRestrict="0-9.,";
				}
				else if (value == ColumnType.AUTONUMBER)
				{
					if(!datagrid.performanceMode)
					{
						itemRendererCls=new ClassFactory(LabelItemRenderer);
					}
					(col as ExAdvancedDataGridColumn).labelFunction=labelFuncLib.autoSeqLabelFunc;
					(col as ExAdvancedDataGridColumn).editable=false;
					(col as ExAdvancedDataGridColumn).cellActivation=Global.ACTIVATE_ONLY;
				}
				else if (value==ColumnType.TEXT  || value == ColumnType.TIME)
				{
					if (this.datagrid.variableRowHeight==false)
					{
						
						if(!datagrid.performanceMode)
						{
							
							itemRendererCls = new ClassFactory(LabelItemRenderer);
							
						}	
						else
							(col as ExAdvancedDataGridColumn).labelFunction=labelFuncLib.renderLabelFuncOfTextColumn;
					}
					else
					{
						// support automatically row height change based on input content
						(col as ExAdvancedDataGridColumn).wordWrap = true; 
						
					}
				}
					
				else if (value == ColumnType.CHECKBOX)
				{
					itemRendererCls=new ClassFactory(CheckBoxRenderer);
					(col as ExAdvancedDataGridColumn).showEditor = false;						
					(col as ExAdvancedDataGridColumn).public::setStyle("textAlign", "center");
				}
				else if (value == ColumnType.COMBOBOX)
				{
					itemRendererCls=new ClassFactory(ComboRendrerer);
					itemEditorCls=new ClassFactory(ComboEditor);
					editDataField="myComboString";
				}
				else if (value == ColumnType.DATE)
				{
					itemRendererCls=new ClassFactory(CalendarRenderer);
					itemEditorCls=new ClassFactory(DateFieldEditor);
					editDataField="myDateFieldString";
					
				}
				else if (value == ColumnType.IMAGE)
				{
					itemRendererCls=new ClassFactory(ImageRenderer);
					(col as ExAdvancedDataGridColumn).showEditor=false;	
				}
				else if (value == ColumnType.CRUD)
				{
					this.datagrid.crudMode=true;
					this.datagrid.strInsertRowText=Global.CRUD_INSERT;
					this.datagrid.strUpdateRowText=Global.CRUD_UPDATE;
					this.datagrid.strDeleteRowText=Global.CRUD_DELETE;
					this.datagrid.crudColumnKey=col.dataField;
					(col as ExAdvancedDataGridColumn).public::setStyle("textAlign", "center");
					(col as ExAdvancedDataGridColumn).editable=false;
					(col as ExAdvancedDataGridColumn).cellActivation=Global.ACTIVATE_ONLY;
					
				}
				else if (value == ColumnType.BUTTON)
				{
					itemRendererCls=new ClassFactory(ButtonRenderer);
					col.cellActivation=Global.ACTIVATE_ONLY;
					(col as ExAdvancedDataGridColumn).showEditor = false;
				}
				else if (value == ColumnType.TREE)
				{
					itemRendererCls=new ClassFactory(ExAdvancedDataGridGroupItemRenderer);
					(col as ExAdvancedDataGridColumn).public::setStyle("textAlign", "left");
				}
					
				else if (value == ColumnType.RADIOBUTTON)
				{
					itemRendererCls=new ClassFactory(RadioButtonRenderer);
					(col as ExAdvancedDataGridColumn).showEditor=false;
					(col as ExAdvancedDataGridColumn).sortable=false;
					(col as ExAdvancedDataGridColumn).public::setStyle("textAlign", "center");
				}
					
				else if (value == ColumnType.COMBODYNAMIC)
				{
					itemRendererCls=new ClassFactory(ComboDynamicRenderer);
					itemEditorCls=new ClassFactory(ComboEditor);
					editDataField="myComboString";
				}
				else if (value == ColumnType.MULTICOMBO)
				{
					itemRendererCls=new ClassFactory(ComboRendrerer);
					itemEditorCls=new ClassFactory(ComboEditor);
					editDataField="myComboString";
				}
					
				else if (value == ColumnType.TEXTAREA)
				{
					itemRendererCls=new ClassFactory(TextAreaRenderer);
					itemEditorCls=new ClassFactory(TextAreaEditor);
					
					editDataField="textAreaValue";
					this.datagrid.variableRowHeight=true;
					(col as ExAdvancedDataGridColumn).wordWrap = true; 
					
				}
				else if (value == ColumnType.IMAGETEXT)
				{
					itemRendererCls=new ClassFactory(ImageTextRenderer);
					itemEditorCls=new ClassFactory(ImageTextEditor);
					editDataField="imageTextValue";
					(col as ExAdvancedDataGridColumn).public::setStyle("color", "#0404B4");
				}
				else if (value == ColumnType.IMAGETEXTRIGHT)
				{
					
					itemRendererCls=new ClassFactory(ImageTextRightRenderer);
					itemEditorCls=new ClassFactory(ImageTextRightEditor);
					(col as ExAdvancedDataGridColumn).editorDataField="imageTextValue";
					(col as ExAdvancedDataGridColumn).public::setStyle("color", "#0404B4");
				}
				else if (value == ColumnType.HIDEIMAGETEXTRIGHT)
				{
					
					itemRendererCls=new ClassFactory(HideImageTextRightRenderer);
					itemEditorCls=new ClassFactory(ImageTextRightEditor);
					editDataField="imageTextValue";
					(col as ExAdvancedDataGridColumn).public::setStyle("color", "#0404B4");
				}
					
				else if (value == ColumnType.TOTAL)
				{
					itemRendererCls=new ClassFactory(TotalColumnRenderer);
					(col as ExAdvancedDataGridColumn).labelFunction = labelFuncLib.renderLabelFuncOfTotalColumn;
					(col as ExAdvancedDataGridColumn).public::setStyle("textAlign", "right");
					(col as ExAdvancedDataGridColumn).editable=false;
					(col as ExAdvancedDataGridColumn).cellActivation=Global.ACTIVATE_ONLY;
					
				}
				else if (value == ColumnType.HTML)
				{
					itemRendererCls=new ClassFactory(HtmlRenderer);
					(col as ExAdvancedDataGridColumn).showEditor=false;
				}
				else if (value == ColumnType.MULTICOMBOBOX)
				{
					itemRendererCls=new ClassFactory(MultiComboRenderer);
					(col as ExAdvancedDataGridColumn).showEditor=false;		
				}
				else if (value == ColumnType.LINK)
				{
					itemRendererCls=new ClassFactory(LinkButtonRenderer);
					col.showEditor=false;
					
				}
					
				else
				{
					
				}
				
				(col as ExAdvancedDataGridColumn).itemRenderer= itemRendererCls;
				if (itemEditorCls !=null)
					(col as ExAdvancedDataGridColumn).itemEditor=itemEditorCls;
				if (editDataField !="")
					(col as ExAdvancedDataGridColumn).editorDataField=editDataField;
			}
			
		}
		
		/*************************************************************
		 * set dataGrid property
		 * @param proName  property name
		 * @param value  value of property
		 * ***********************************************************/
		public function setDataGridProperty(proName:String, value:Object):void
		{
			switch (proName)
			{
				case "wordWrap":
					break;
				case "selectCell":
					datagrid[proName]=changeType(datagrid[proName], value);
					datagrid.selectionMode = (this.datagrid.selectCell ? "multipleCells" : "multipleRows");
					break;			
				case "editable":
					datagrid[proName]=value as Boolean ? "all" : ""; 
					this.datagrid.isEditable = this.datagrid.editable != "" ? true : false;
					break;	
				case "strAlternateRowsFgColor":
					if(this.datagrid.strAlternateRowsFgColor.length > 0)
						this.datagrid.strAlternateRowsFgColor = [];
					var tmp:Array = (value as String).split(',');
					var color1:String ; 
					var color2:String;
					color1 = color2 = this.datagrid.getStyle('color');
					if(tmp.length > 0)
					{
						color1 = (tmp[0] as String).slice(1,tmp[0].length);
						color2 = (tmp[1] as String).slice(0,tmp[1].length -1);
					}
					this.datagrid.strAlternateRowsFgColor.push(color1.toString().replace("#", "0x"));
					this.datagrid.strAlternateRowsFgColor.push(color2.toString().replace("#", "0x"));
					if(this.datagrid.dataProvider.length > 0)
					{
						for (var i:int = 0 ; i<this.datagrid.dataProvider.length; i++)
						{
							if(i%2 == 0)
								this.datagrid.setRowStyle(i,"color",datagrid.strAlternateRowsFgColor[0]);
							else
								this.datagrid.setRowStyle(i,"color",datagrid.strAlternateRowsFgColor[1]);
						}
					}
					break;
				case "strRowScrollDragAction":
					if (value == "syncscreen" || value == "default")
					{
						(gridone.vScroll as ExVScrollBar).strRowScrollDragAction=datagrid.strRowScrollDragAction=value.toString();
					}
					break;
				case "liveScrolling":
					datagrid[proName]=changeType(datagrid[proName], value);	 
					if (value == true)
						(gridone.vScroll as ExVScrollBar).strRowScrollDragAction=datagrid.strRowScrollDragAction="syncscreen";
					else
						(gridone.vScroll as ExVScrollBar).strRowScrollDragAction=datagrid.strRowScrollDragAction="default";
					break;
				case "bHDFontCLine":
					updateHeaderCLine(value);
					break;
				case "bCellFontCLine":						
					for each(var exCol:ExAdvancedDataGridColumn in datagrid.columns)
				{
					exCol.bCellFontCLine=value as Boolean;
				}
					break;
				case "strCellClickAction":
					if(value == Global.ROWSELECT)
						this.datagrid.selectCell = false;
					else if(value == Global.EDIT)
					{
						if(!datagrid.isEditable)
						{
							datagrid['editable']="all"; 
							this.datagrid.isEditable = true;
						}
					}
					if(datagrid.bItemEditBegin)
						datagrid.bItemEditBegin = false;
					datagrid[proName]=changeType(datagrid[proName], value);	 
					break;
				case "selectionMode":
					if(value == "singleRow" || value == "multipleRows")
						this.datagrid.selectCell = false;
					else if(value == "singleCell" || value == "multipleCells")
						this.datagrid.selectCell = true;
					datagrid[proName]=changeType(datagrid[proName], value);
					break;
				case "allowResizeLastColumn":	
					datagrid[proName]=changeType(datagrid[proName], value);
					if(datagrid.bExternalScroll)
						datagrid.allowResizeLastColumn = false;
					if(this.datagrid.columns.length > 0)
					{
						verifyResizeLastColumn();
					}
					break;
				case "bExternalScroll":
					datagrid[proName]=changeType(datagrid[proName], value);
					if(this.datagrid.bAutoWidthColumn)
						datagrid.bExternalScroll = false;
					if(this._lockedColumnCount > 0)
					{
						datagrid.bOriginalExternalScroll = datagrid.bExternalScroll;
						datagrid.bExternalScroll = false;
					}
					updateExternalScrollBar();
					if(this.datagrid.selectCell)
					{
						this.datagrid.selectedCells = [];
					}
					else
						this.datagrid.selectedIndex = -1;
					break;
				case "fixedLastColumn":
					gridone.callLater(updatePropertyLater,[datagrid,proName,value]);
					break;
				case "lockedColumnCount":
					datagrid[proName]=changeType(datagrid[proName], value);
					this._lockedColumnCount = int(value);
					if(value > 0 && this.datagrid.bExternalScroll == true)
					{
						//use horizontal inside datagrid and disable horizontal outside
						this.datagrid.bOriginalExternalScroll = this.datagrid.bExternalScroll;
						this.datagrid.bExternalScroll = false;
						updateExternalScrollBar();
					}
					else if(value == 0 && this.datagrid.bOriginalExternalScroll == true)
					{
						//use horizontal inside datagrid and disable horizontal outside
						this.datagrid.bExternalScroll = this.datagrid.bOriginalExternalScroll;
						this.datagrid.bOriginalExternalScroll = false;
						updateExternalScrollBar();
					}
					break;
				case "showScrollTips":
					(gridone.vScroll as ExVScrollBar).showScrollTips=datagrid.showScrollTips=value as Boolean;
					break;
				case "bAutoWidthColumn":
					datagrid[proName]=changeType(datagrid[proName], value);					
					if(datagrid.bAutoWidthColumn)
					{
						datagrid.bExternalScroll = false;
						datagrid.fixedLastColumn = false;
						datagrid.allowResizeLastColumn = false;
					}
					break;
				case "bAllowResizeDgHeight":
				case "nMinContentHeight":
				case "nMinVisibleRow":
				case "isResizeDgHeightByPixel":
				case "bResizeHeightByApp":
					datagrid[proName]=changeType(datagrid[proName], value);
					gridoneManager.updateGridHeight();
					break;
				default:
					datagrid[proName]=changeType(datagrid[proName], value);
					break;
			}
		}
		
		/*************************************************************
		 * update fixed last column when changing value in bExternalScroll property
		 * @param proName name of property
		 * @param value data of that property
		 * @author Duong Pham
		 * ***********************************************************/
		private function updatePropertyLater(objName:Object,proName:String,value:Object):void
		{
			objName[proName]=changeType(objName[proName], value);
			if(objName is ExAdvancedDataGrid && proName =="fixedLastColumn" && (datagrid.bExternalScroll || datagrid.bAutoWidthColumn))
			{
				datagrid.fixedLastColumn = false;
				datagrid.allowResizeLastColumn = false;
			}
			this.datagrid.invalidateList();
		}
		
		/*************************************************************
		 * update header center line in column and group column
		 * @param value data of property
		 * @author Duong Pham
		 * ***********************************************************/
		private function updateHeaderCLine(value:Object):void
		{		
			if(this.datagrid._isGroupedColumn)
			{
				for (var i:int=0; i<this.datagrid.groupedColumns.length; i++)
				{
					if(this.datagrid.groupedColumns[i] is ExAdvancedDataGridColumn && ExAdvancedDataGridColumn(this.datagrid.groupedColumns[i]).dataField != null)
					{
						(this.datagrid.groupedColumns[i] as ExAdvancedDataGridColumn).bHDFontCLine = value as Boolean;
					}
					else if(this.datagrid.groupedColumns[i] is ExAdvancedDataGridColumnGroup && ExAdvancedDataGridColumnGroup(this.datagrid.groupedColumns[i]).dataField == null)
					{
						(this.datagrid.groupedColumns[i] as ExAdvancedDataGridColumnGroup).bHDFontCLine = value as Boolean;	
						updateSubHeaderCLine(this.datagrid.groupedColumns[i], value);
					}
				}	
			}
			else
			{
				for each(var exCol:ExAdvancedDataGridColumn in datagrid.columns)
				{
					exCol.bHDFontCLine = value as Boolean;
				}
			}
		}
		
		/*************************************************************
		 * update header center line in group column
		 * @param groupCol group column
		 * @param value data of property
		 * @author Duong Pham
		 * ***********************************************************/
		public function updateSubHeaderCLine(groupCol:ExAdvancedDataGridColumnGroup, value:Object):void
		{			
			for(var i:int=0; i<groupCol.children.length; i++)
			{
				if(groupCol.children[i] is ExAdvancedDataGridColumn && ExAdvancedDataGridColumn(groupCol.children[i]).dataField != null)
					(groupCol.children[i] as ExAdvancedDataGridColumn).bHDFontCLine = value as Boolean;
				else if(groupCol.children[i] is ExAdvancedDataGridColumnGroup && ExAdvancedDataGridColumnGroup(groupCol.children[i]).dataField == null)
				{
					(groupCol.children[i] as ExAdvancedDataGridColumnGroup).bHDFontCLine = value as Boolean;
					updateSubHeaderCLine(groupCol.children[i], value);
				}
			}					
		}
		
		/*************************************************************
		 * update property for all column kinds
		 * @param propertyName name of property
		 * @param value data of property
		 * @author Duong Pham
		 * ***********************************************************/
		private function updatePropertyValueOfAllTypeCols(propertyName:String , value:Object):void
		{		
			if(this.datagrid._isGroupedColumn)
			{
				for (var i:int=0; i<this.datagrid.groupedColumns.length; i++)
				{
					if(this.datagrid.groupedColumns[i] is ExAdvancedDataGridColumn)
					{
						(this.datagrid.groupedColumns[i] as ExAdvancedDataGridColumn)[propertyName] = changeType(this.datagrid[propertyName],value);
					}
					else if(this.datagrid.groupedColumns[i] is ExAdvancedDataGridColumnGroup)
					{
						(this.datagrid.groupedColumns[i] as ExAdvancedDataGridColumnGroup)[propertyName] = changeType(this.datagrid[propertyName],value);	
						updateChildrenProperty(this.datagrid.groupedColumns[i], propertyName, value);
					}
				}	
			}
			else
			{
				for each(var exCol:ExAdvancedDataGridColumn in datagrid.columns)
				{
					exCol[propertyName]=value as Boolean;
				}
			}
		}
		
		/*************************************************************
		 * update chidren property of these columns inside Group column
		 * @param groupCol group column contains these columns which are needed to update property
		 * @param propertyName name of property
		 * @param value data of property
		 * @author Duong Pham
		 * ***********************************************************/
		public function updateChildrenProperty(groupCol:ExAdvancedDataGridColumnGroup, propertyName:String, value:Object):void
		{			
			for(var i:int=0; i<groupCol.children.length; i++)
			{
				if(groupCol.children[i] is ExAdvancedDataGridColumn)
					(groupCol.children[i] as ExAdvancedDataGridColumn)[propertyName] = changeType(this.datagrid[propertyName], value);
				else if(groupCol.children[i] is ExAdvancedDataGridColumnGroup)
				{
					(groupCol.children[i] as ExAdvancedDataGridColumnGroup)[propertyName] = changeType(this.datagrid[propertyName], value);
					updateChildrenProperty(groupCol.children[i],propertyName, value);
				}
			}					
		}
		
		/*************************************************************
		 * set column property
		 * @param col object 
		 * @param proName property name
		 * @param value of property
		 * ***********************************************************/
		public function setColumnProperty(col:Object,proName:String,value:Object):void
		{
			switch(proName)
			{
				case "wordWrap":
					break;
				case "headerRenderer":
					if(col is ExAdvancedDataGridColumn)
						this.setItemRenderer(col as ExAdvancedDataGridColumn,value.toString().toUpperCase(),true);
					break;
				case "itemRenderer":
					this.setItemRenderer(col as ExAdvancedDataGridColumn,value.toString().toUpperCase(),false);
					break;
				case "replacedStartIndex":
					col.replacedStartIndex = value;
					break;
				case "replacedLength":
					col.replacedLength = value;
					break;
				case "editable":
					col[proName] = changeType(col[proName], value);
					if(col[proName])
						col.cellActivation=Global.ACTIVATE_EDIT;
					else
						col.cellActivation=Global.ACTIVATE_ONLY;
					break;
				case "visible":
					var datagridWidth:Number = 0;
					col[proName]=changeType(col[proName], value);
					if(this.datagrid.bExternalScroll)
					{
						//remove width of hidden column inside this.datagrid.totalVisibleColumnWidth
						if(value == false)
							this.datagrid.totalVisibleColumnWidth = this.datagrid.totalVisibleColumnWidth - col.width;
						else
							this.datagrid.totalVisibleColumnWidth = this.datagrid.totalVisibleColumnWidth + col.width;
						//update width of datagrid
						datagridWidth = this.datagrid.totalVisibleColumnWidth;
						if(gridone.vScroll.visible)
							this.datagrid.width = datagridWidth - gridone.vScroll.width - 2;
						else
							this.datagrid.width = datagridWidth;
					}
					break;
				case "editorInputMask":
					col[proName] = col['inputMask'] = value;
					break;
				case "inputMask":
					col[proName] = col['editorInputMask'] = value;
					break;
				case "width":
					updateWidthColumn(col,value);
					if(value > 0 && col.visible == true)
						gridone.callLater(updatePropertyLater,[col,proName,value]);		//need to wait until column visible is actually displayed
					else
						col[proName]=changeType(col[proName], value);
					datagrid.bFlagIgnoreAutoWidthColumn = false;
					break;
				default:
					col[proName]=changeType(col[proName], value);
					break;
			}
		}
		
		/*************************************************************
		 * update column width
		 * @param col column need to be updated item renderer
		 * @param value of column width
		 *  
		 * ***********************************************************/
		private function updateWidthColumn(col:Object,value:Object):void
		{
			var visible:Boolean = false;
			var colWidth:Number;
			if(value == 0 && ExAdvancedDataGridColumn(col).visible == true)
			{
				ExAdvancedDataGridColumn(col).visible = false;
				colWidth = col.width;
			}
			else if(value > 0 && ExAdvancedDataGridColumn(col).visible == false)
			{
				ExAdvancedDataGridColumn(col).visible = true;
				colWidth = Number(value);
			}
			if(this.datagrid.bExternalScroll)
			{
				//subtract width of hidden column inside this.datagrid.totalVisibleColumnWidth
				if(col.visible == false)
					this.datagrid.width = this.datagrid.totalVisibleColumnWidth = this.datagrid.totalVisibleColumnWidth - colWidth;
				else
					this.datagrid.width = this.datagrid.totalVisibleColumnWidth = this.datagrid.totalVisibleColumnWidth + colWidth;
			}
			
		}
		
		/*************************************************************
		 * cast value into type of object
		 * @param obj Variable
		 * @param value Value of variable
		 * ***********************************************************/
		private function changeType(obj:Object, value:Object):Object
		{
			if (obj is Number)
				return Number(value);
			else if (obj is int)
				return int(value);
			else if (obj is Boolean)
			{
				switch(value)
				{
					case "false": 
					case "none": value = false; break;
					case "true":
					case "free": value = true; break;
				}
				return value;
				//return ((value.toString().search("true") == 0) ? true : false);
			}
			return value;
		}
		
		/*************************************************************
		 * set style for an object.
		 * ***********************************************************/
		public function setStyleForObject(obj:Object, styleName:String, value:Object):void
		{
			var arr:Array;			
			if(styleName=="headerColors") 
			{		
				var tmp:Array = (value as String).split(',');
				var bgColor1:String ; 
				var bgColor2:String;
				bgColor1 = bgColor2 = this.datagrid.getStyle('headerBackgroundColor');
				if(tmp.length > 0)
				{
					bgColor1 = (tmp[0] as String).slice(1,tmp[0].length);
					bgColor2 = (tmp[1] as String).slice(0,tmp[1].length -1);
				}
				var newValue:Array = new Array();
				newValue.push(bgColor1.toString().replace("#", "0x"));
				newValue.push(bgColor2.toString().replace("#", "0x"));				
				(obj as ExAdvancedDataGrid).setStyle("headerColors",newValue);				
				return;
			}
			else if(styleName == "headerBorderColor")
			{	
				obj.setStyle("borderColor",value.toString().replace("#", "0x"));			
			}				
			else if (styleName == "strCellBgColor")
			{				
				styleName="alternatingItemColors";
				var strValue:String="";
				if (value.toString().search("#") == 0)
					strValue=value.toString().replace("#", "0x");
				else
					strValue=value.toString();
				arr=[strValue, strValue];				
				obj.setStyle(styleName, arr);
				return;
			}
			else if (styleName == "borderColor" || styleName == "backgroundColor")
			{
				if(obj is ExAdvancedDataGrid)
				{
					gridone.subVbDg.setStyle(styleName, value.toString().replace("#", "0x"));	
					if(styleName == "borderColor")
					{
						obj.setStyle("horizontalGridLineColor",value.toString().replace("#", "0x"));
						obj.setStyle("verticalGridLineColor",value.toString().replace("#", "0x"));	
						obj.setStyle(styleName, value.toString().replace("#", "0x"));	
						gridone.hbDg.setStyle(styleName, value.toString().replace("#", "0x"));
					}
					if(datagrid.bExternalScroll)
					{
						gridone.vScroll.setStyle(styleName, value.toString().replace("#", "0x"));
						gridone.mainContain.setStyle(styleName, value.toString().replace("#", "0x"));
					}
				}
				else 
				{
					obj.setStyle(styleName, value.toString().replace("#", "0x"));	
				}
				
			}			
			else if (ConvertProperty.headerStyleObj.hasOwnProperty(styleName))
			{
				setHeaderStyle(obj, styleName, value.toString());
			}	
			else if (value.toString().search("#") == 0)
			{
				obj.setStyle(styleName, value.toString().replace("#", "0x"));
			}
			else if (value.toString().search(/\[.*\]/) >= 0)
			{
				value=value.toString().replace(/[\[\]]/gi, "");
				arr=value.toString().split(",");
				for (var i:int=0; i < arr.length; i++)
					if (arr[i].toString().search("#") == 0)
						arr[i]=arr[i].replace("#", "0x");
				
				obj.setStyle(styleName, arr);
				
			}
			else if (styleName == "nAlphaLevel")
			{
				var alphaValue:Number=parseFloat(value.toString());
				if (isNaN(alphaValue))
					return;
				if (alphaValue >= 1 && alphaValue <= 255)
				{
					alphaValue=Math.ceil((alphaValue / 255) * 100) / 100;
					obj.setStyle("backgroundAlpha", alphaValue.toString());
				}
				else
					return;
			}
			else if(styleName == "strBgImage")
				gridone.hbDg.setStyle("backgroundImage", value.toString());				
			else if(styleName == "strBgImageStyle")
			{
				var strType:String = "";
				if(StringUtil.trim(value.toString()) == "stretched")
					strType = "100%";
				else if (StringUtil.trim(value.toString()) == "relative")
					strType = "auto";		
				if(strType != "")
					this.gridone.hbDg.setStyle("backgroundSize", strType);
			}					
			else
			{				
				switch(styleName)
				{
					case "fontWeight":
						value=(value.toString()=="true")?"bold":"normal";
						break;
					case "fontStyle":
						value=(value.toString()=="true")?"italic":"normal";
						break;
					case "textDecoration":
						value=(value.toString()=="true")?"underline":"none";
						break;					
				}				
				obj.setStyle(styleName, value);		
			}						
		}
		
		/*************************************************************
		 * Set all header style for AdvancedDataGrid
		 * @author Thuan
		 * ***********************************************************/	
		public function setHeaderStyle(obj:Object, selector:String, value:String):void
		{
			switch(selector)
			{
				case "bHDFontBold":
					value=(value.toString()=="true")?"bold":"normal";
					break;
				case "bHDFontItalic":
					value=(value.toString()=="true")?"italic":"normal";
					break;
				case "bHDFontULine":
					value=(value.toString()=="true")?"underline":"none";
					break;
			}
			if (value.search("#") == 0)
				value=value.replace("#", "0x");
			
			var sName:String = "." + this.datagrid.getStyle("headerStyleName");
			var cssDecl:CSSStyleDeclaration = this.datagrid.styleManager.getStyleDeclaration(sName);
			cssDecl.setStyle(ConvertProperty.headerStyleObj[selector], value);			
		}
		
		/*************************************************************
		 * popup in context menu
		 * @author Duong Pham
		 * ***********************************************************/		
		public var popContextMenu:PopContextMenu;
		
		/*************************************************************
		 * register all events in advanced datagrid
		 * @author Duong Pham
		 * ***********************************************************/
		public function registerAdvancedDataGridEvents():void
		{
			
			this.datagrid.addEventListener(ListEvent.ITEM_CLICK,dg_itemClickHandler);
			this.datagrid.addEventListener(ListEvent.ITEM_ROLL_OVER,dg_itemRollOverHandler);
			this.datagrid.addEventListener(ListEvent.ITEM_ROLL_OUT,dg_itemRollOutHandler);
			this.datagrid.addEventListener(MouseEvent.RIGHT_CLICK,dg_rightClickDataGridHandler);	
			this.datagrid.addEventListener("columnsChanged",dg_columnsChangedHandler);
			this.datagrid.addEventListener(ExAdvancedDataGridEvent.HEADER_RELEASE,dg_headerReleaseHandler);
			this.datagrid.addEventListener(ExAdvancedDataGridEvent.ITEM_EDIT_END,dg_itemEditEndHandler);
			this.datagrid.addEventListener(SAEvent.CHECKBOX_CLICK, checkBoxClickHandler);
			this.datagrid.addEventListener(SAEvent.ON_COMBO_CHANGE, onComboChangeHandler);
			this.datagrid.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,dg_itemDoubleClickHandler);
			this.datagrid.addEventListener(ScrollEvent.SCROLL,dg_scrollDatagridHandler);
			this.datagrid.addEventListener(ExAdvancedDataGridEvent.ITEM_OPEN, dg_onExpandCollapseHandler);
			this.datagrid.addEventListener(ExAdvancedDataGridEvent.ITEM_CLOSE, dg_onExpandCollapseHandler);
			this.datagrid.addEventListener(MouseEvent.MOUSE_UP, dg_onMouseUpHandler);
			//			this.datagrid.addEventListener(MouseEvent.MOUSE_WHEEL, dg_onMouseWheelDGHandler);
			this.datagrid.addEventListener(ExAdvancedDataGridEvent.UPDATE_EXTERNAL_HORIZONTAL_SCROLL,updateExternalHorizontalScrollHandler);
			this.datagrid.addEventListener(ExAdvancedDataGridEvent.ITEM_EDIT_BEGINNING,dg_onItemEditBeginningHandler);
		}
		
		/*************************************************************
		 * Add event ITEM_EDIT_BEGINNING EVENT when moving by tab, enter or click 
		 * @author Duong Pham
		 * ***********************************************************/
		protected function dg_onItemEditBeginningHandler(event:ExAdvancedDataGridEvent):void
		{
			//dispatch ON_CELL_MODE event (in case using ENTER or TAB)
			if((event.keyCode == Keyboard.TAB || event.keyCode == Keyboard.ENTER)&& this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_CELL_MODE))
			{
				var saEvent:SAEvent = new SAEvent(SAEvent.ON_CELL_MODE,true);
				var item:Object = this.datagrid.getBackupItem(event.rowIndex);
				var uid:String = item[Global.ACTSONE_INTERNAL];
				var col:ExAdvancedDataGridColumn = this.datagrid.columns[event.columnIndex];
				saEvent.strMode = this.datagrid.getCellProperty('activation',uid,col.dataField);
				if(saEvent.strMode == null)
					saEvent.strMode = col.cellActivation;
				saEvent.columnKey = col.dataField;
				saEvent.nRow = event.rowIndex;
				this.datagrid.dispatchEvent(saEvent);
			}
		}
		
		/*************************************************************
		 * Add event MOUSE_UP when click on TreeColumn
		 * @author Thuan
		 * ***********************************************************/
		protected function dg_onMouseUpHandler(event:MouseEvent):void
		{
			try
			{
				var treeNodeClickEvent:SAEvent;
				if (this.datagrid.isTree && this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_TREE_NODE_CLICK)) 
				{ 
					if (this.datagrid.columns[event.currentTarget._selectedColIndex].type == "TREE")
					{
						treeNodeClickEvent = new SAEvent(SAEvent.ON_TREE_NODE_CLICK, true);
						
						if (event.target.name.search("SpriteAsset") > -1)
						{
							treeNodeClickEvent.strTreeKey = (event.currentTarget as ExAdvancedDataGrid).selectedItem.TREEIDFIELD;
							treeNodeClickEvent.nRow= this.datagrid.selectedIndex;
						}
						else
						{
							treeNodeClickEvent.strTreeKey = event.target.parent.listData.item.TREEIDFIELD;
							treeNodeClickEvent.nRow= this.datagrid.selectedIndex;
						}
						if (event.target.name.search("DisclosureOpen") > -1)
						{  
							//Is signbox open
							treeNodeClickEvent.strArea = 'signbox open';
							this.datagrid.dispatchEvent(treeNodeClickEvent);
						}
						else if (event.target.name.search("DisclosureClose") > -1)
						{	
							//Is signbox close
							treeNodeClickEvent.strArea = 'signbox close';
							this.datagrid.dispatchEvent(treeNodeClickEvent);
						}
						else if (event.target.name.search("TreeFolderClosed") > -1)
						{
							//Is image close
							treeNodeClickEvent.strArea='image closed';
							this.datagrid.dispatchEvent(treeNodeClickEvent);					
						}
						else if (event.target.name.search("TreeFolderOpen") > -1)
						{
							//Is image open
							treeNodeClickEvent.strArea='image open';
							this.datagrid.dispatchEvent(treeNodeClickEvent);					
						}
						else if (event.target.name.search("TreeNodeIcon") > -1)
						{
							//Is icon
							treeNodeClickEvent.strArea='icon';
							this.datagrid.dispatchEvent(treeNodeClickEvent);					
						} 
						else if (event.target.name.search("UITextField") > -1)
						{
							//Is text
							treeNodeClickEvent.strArea='text';
							this.datagrid.dispatchEvent(treeNodeClickEvent);					
						}
						else
						{
							//Is back
							treeNodeClickEvent.strArea='back';
							this.datagrid.dispatchEvent(treeNodeClickEvent);				
						}
					}
				}
			}
			catch(err:Error)
			{  
				trace(err.message);
			}
		}
		
		/*************************************************************
		 * Dispatch Event when expand/collapse is occur in treecolumn of advanceddatagrid
		 * @param event Event of advanceddatagrid
		 * @author Thuan
		 * ***********************************************************/
		private function dg_onExpandCollapseHandler(event: ExAdvancedDataGridEvent):void
		{
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_EXPAND) || this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_COLLAPSE))
			{
				if(event.type == ExAdvancedDataGridEvent.ITEM_OPEN)
					setTimeout(dispatchEventOnTree, 200, event.item.TREEIDFIELD, SAEvent.ON_EXPAND);
				else
					setTimeout(dispatchEventOnTree, 200, event.item.TREEIDFIELD, SAEvent.ON_COLLAPSE);
			}
		}
		
		/*************************************************************
		 * Dispatch Event when event is occur in treecolumn of advanceddatagrid
		 * @param event Event of advanceddatagrid
		 * @author Thuan
		 * ***********************************************************/
		private function dispatchEventOnTree(strTreeKey:String, type:String):void
		{
			var saEventExpand: SAEvent = new SAEvent(type, true);
			saEventExpand.strTreeKey = strTreeKey;
			this.datagrid.dispatchEvent(saEventExpand);
		}
		
		/************************************************
		 * Handler of item click event: advanced datagrid.
		 *
		 * @param event ListEvent.
		 * @author Duong Pham		 
		 ***********************************************/
		private function dg_itemClickHandler(event:ListEvent):void
		{
			/* on cell click event */
			var dataField:String;	
			var saEvent:SAEvent;
			var item:Object;
			
			// Author: Thuan
			// Lock collapse or expand based on variable "enableTreeClickAction":
			//===================================================================
			if (this.datagrid.columns[event.columnIndex].type == ColumnType.TREE &&
				!this.datagrid.enableTreeClickAction)
			{
				event.preventDefault();   
				event.stopImmediatePropagation();
			}
			
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_CELL_CLICK))
			{
				if(datagrid.selectCell)
				{
					for each(item in datagrid.selectedCells)
					{
						saEvent = new SAEvent(SAEvent.ON_CELL_CLICK, true);
						dataField = getDataFieldByIndex(item.columnIndex);
						saEvent.columnKey=dataField;
						saEvent.editable=this.datagrid.columns[this.datagrid.dataFieldIndex[dataField]].editable;	
						saEvent.nRow = item.rowIndex;
						//get current item
						item =  this.datagrid.getItemAt(saEvent.nRow);
						//get the original index
						saEvent.nRowBk= this.datagrid._bkDP.getItemIndex(item);
						this.datagrid.dispatchEvent(saEvent);
					}
				}
				else
				{
					saEvent = new SAEvent(SAEvent.ON_CELL_CLICK, true);
					dataField = gridoneImpl.getDataFieldVisibleByIndex(event.columnIndex);
					saEvent.columnKey=dataField;
					saEvent.editable=this.datagrid.columns[this.datagrid.dataFieldIndex[saEvent.columnKey]].editable;	
					saEvent.nRow=datagrid.getItemIndex(datagrid.selectedItem);
					//get current item
					item =  this.datagrid.getItemAt(saEvent.nRow);
					//get the original index
					saEvent.nRowBk= this.datagrid._bkDP.getItemIndex(item);
					this.datagrid.dispatchEvent(saEvent);
				}
				
			}
			
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_CELL_MODE))
			{
				saEvent = new SAEvent(SAEvent.ON_CELL_MODE,true);
				item = this.datagrid.getBackupItem(event.rowIndex);
				var uid:String = item[Global.ACTSONE_INTERNAL];
				var index:int = -1;
				for each(var col:ExAdvancedDataGridColumn in this.datagrid.columns)
				{
					if(col.visible)
						index ++;
					if(index == event.columnIndex)
						break;
				}
				saEvent.strMode = this.datagrid.getCellProperty('activation',uid,col.dataField);
				if(saEvent.strMode == null)
					saEvent.strMode = col.cellActivation;
				saEvent.columnKey = col.dataField;
				saEvent.nRow = event.rowIndex;
				this.datagrid.dispatchEvent(saEvent);
			}
	 
		}
		
		/************************************************
		 * Handler of item roll over event: advanced datagrid.
		 * @param event ListEvent.
		 * @author Duong Pham
		 ***********************************************/
		private function dg_itemRollOverHandler(event:ListEvent):void
		{
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_MOUSE_OVER))
			{
				this.datagrid._selectedColIndex = event.columnIndex;
				this.datagrid._selectedRowIndex = event.rowIndex;
				var mouseOverEvent:SAEvent=new SAEvent(SAEvent.ON_MOUSE_OVER, true);
				var dataField:String=event.itemRenderer["listData"].dataField;
				mouseOverEvent.nRow=event.rowIndex;
				mouseOverEvent.columnKey=dataField;
				this.datagrid.dispatchEvent(mouseOverEvent);								
				event.preventDefault();
			}
		}			
		
		/************************************************
		 * Handler of item roll out event: advanced datagrid.
		 * @param event ListEvent.
		 * @author Duong Pham
		 ***********************************************/
		private function dg_itemRollOutHandler(event:ListEvent):void
		{
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_MOUSE_OUT))
			{
				var mouseOutEvent:SAEvent=new SAEvent(SAEvent.ON_MOUSE_OUT, true);
				mouseOutEvent.nRow=event.rowIndex;
				mouseOutEvent.columnKey=this.datagrid.dataFieldIndex[event.columnIndex];
				this.datagrid.dispatchEvent(mouseOutEvent);	
			}
		}
		
		/************************************************
		 * Handler of right click event: advanced datagrid.
		 * @param event MouseEvent.
		 * @author Duong Pham
		 ***********************************************/
		private function dg_rightClickDataGridHandler(event:MouseEvent):void
		{	
			var positionObj:Object = datagrid.getPositionItemRendererUnderPointer(event);
			if(positionObj)
			{
				this.datagrid._selectedColIndex = positionObj["columnIndex"];
				this.datagrid._selectedRowIndex = positionObj["rowIndex"];
			}
			var columnIndex:int;
			var dataFieldColumn:String = "";			
			if(popContextMenu)
			{
				PopUpManager.removePopUp(popContextMenu);
				popContextMenu = null;
			}		
			/* on cell right click event */
			if( event.target.hasOwnProperty("owner") && 				
				!(event.target.owner is ExAdvancedDataGridHeaderRenderer) && 
				!(event.target.document is HeaderCheckBoxRenderer) &&
				!(event.target.owner is ExAdvancedDataGridSortItemRenderer)
			) 
			{	
				columnIndex = this.datagrid._selectedColIndex;
				if(columnIndex >= 0 )
					dataFieldColumn = ExAdvancedDataGridColumn(this.datagrid.columns[columnIndex]).dataField;
				var saEvent:SAEvent=new SAEvent(SAEvent.ON_CELL_RIGHT_CLICK, true);
				if (this.datagrid._selectedColIndex >= 0 && this.datagrid._selectedRowIndex >= 0)
				{
					saEvent.columnKey=ExAdvancedDataGridColumn(this.datagrid.columns[columnIndex]).dataField;
					saEvent.nRow=this.datagrid._selectedRowIndex;
					this.datagrid.dispatchEvent(saEvent);
				}
			}
			else if( event.target.hasOwnProperty("owner") && (event.target.owner is ExAdvancedDataGridHeaderRenderer))
			{
				if (ExAdvancedDataGridHeaderRenderer(event.target.owner).data is ExAdvancedDataGridColumn)
				{
					dataFieldColumn = (ExAdvancedDataGridHeaderRenderer(event.target.owner).data as ExAdvancedDataGridColumn).dataField;
				}
				else if(ExAdvancedDataGridHeaderRenderer(event.target.owner).data is ExAdvancedDataGridColumnGroup)
					dataFieldColumn = (ExAdvancedDataGridHeaderRenderer(event.target.owner).data as ExAdvancedDataGridColumnGroup)._dataFieldGroupCol;
			}
			
			var listMenu:ArrayCollection;
	 
			if(!this.datagrid.selectCell)
			{
				this.datagrid.selectedIndex = this.datagrid._selectedRowIndex;
			}
			else
			{
				this.datagrid.setSelectCell(this.datagrid._selectedColIndex,this.datagrid._selectedRowIndex);
			}
			if (this.datagrid.bContextMenuVisible)
			{		
				var e:SAEvent=new SAEvent(SAEvent.BEFORE_SHOW_USER_CONTEXT_MENU, true);
				if((event.target.hasOwnProperty("owner") && event.target.owner is ExAdvancedDataGridHeaderRenderer))
				{
					e.strMenuKey=MenuConstants.MENU_HEADER;
					e.nRow=-1;
					listMenu = addContextMenuItems(new ArrayCollection(this.datagrid.headerContextMenu.toArray()));
				}
				else if(event.currentTarget is ExAdvancedDataGrid && ( event.target.hasOwnProperty("parent")) && ( event.target.parent.hasOwnProperty("parent")) && (event.target.parent.parent is ComboRendrerer))
				{
					return;
				}
				else if(event.currentTarget is ExAdvancedDataGrid || ( event.target.hasOwnProperty("owner") && event.target.owner.automationOwner is VBox))
				{					
					e.strMenuKey=MenuConstants.MENU_CELL;
					e.nRow=this.datagrid._selectedRowIndex;
					listMenu = addContextMenuItems(new ArrayCollection(this.datagrid.cellContextMenu.toArray()));
				}
				if(popContextMenu == null) 
					popContextMenu = new PopContextMenu();	
				popContextMenu.height = popContextMenu.rowHeight * listMenu.length;
				if(event.stageY + popContextMenu.height + this.datagrid.rowHeight  > this.gridone.height)
				{
					popContextMenu.x = event.stageX;
					popContextMenu.y = event.stageY - (event.stageY + popContextMenu.height + this.datagrid.rowHeight - this.gridone.height) - 5;
				}
				else
				{
					popContextMenu.x = event.stageX;
					popContextMenu.y = event.stageY;
				}			
				if(listMenu.length > 0)
				{
					//dispatch event
					if ((!this.datagrid.bUseDefaultContextMenu) && this.datagrid.bUserContextMenu)
					{
						e.columnKey=this.datagrid.columns[this.datagrid._selectedColIndex].dataField;
						if(this.datagrid.eventArr.hasOwnProperty(SAEvent.BEFORE_SHOW_USER_CONTEXT_MENU))
						{
							this.datagrid.dispatchEvent(e);
						}
					}
					
					// show context menu
					popContextMenu.addEventListener(SAEvent.ON_SELECT_RIGHT_CLICK, contextMenuHandler);					
					popContextMenu.dataFieldCol = dataFieldColumn;
					popContextMenu.rowIndex = this.datagrid._selectedRowIndex;				
					popContextMenu.updateGrid(listMenu);
					PopUpManager.addPopUp(popContextMenu,gridone);
					popContextMenu.setFocus();	
					
					//Set style for contextMenu
					popContextMenu.dgContextMenu.setStyle("color", datagrid.getStyle("contextMenuColor"));
					
					popContextMenu.dgContextMenu.setStyle("fontFamily", datagrid.getStyle("contextMenuFontFamily"));
					
					popContextMenu.dgContextMenu.setStyle("fontSize", datagrid.getStyle("contextMenuFontSize"));
					
					if (datagrid.getStyle("contextMenuFontStyle") == "normal" || datagrid.getStyle("contextMenuFontStyle") == "italic")
						popContextMenu.dgContextMenu.setStyle("fontStyle", datagrid.getStyle("contextMenuFontStyle"));
					
					if (datagrid.getStyle("contextMenuFontWeight") == "normal" || datagrid.getStyle("contextMenuFontWeight") == "bold")
						popContextMenu.dgContextMenu.setStyle("fontWeight", datagrid.getStyle("contextMenuFontWeight"));
				}
			}			
		}				
		
		/*************************************************************
		 * add context menu
		 * author: Duong Pham
		 * ***********************************************************/
		private function addContextMenuItems(menuItems:ArrayCollection):ArrayCollection
		{
			var displayItems:ArrayCollection = new ArrayCollection();
			if(menuItems.length > 0)
			{
				menuItems = checkVisibleContextMenuItem(menuItems);
				displayItems = filterMenuItem(menuItems);				
			}
			return displayItems;
		}
		
		/*************************************************************
		 * get context menu item
		 * @author: Duong Pham
		 * ***********************************************************/
		private function getContextMenuItem(menuItemKey:String, menuArr:ArrayCollection):Object
		{
			for each (var item:Object in menuArr)
			{
				if (item.value == menuItemKey)
					return item;
			}
			return null;
		}
		
		/*************************************************************
		 * Check visible context menu item
		 * @author: Duong Pham
		 * ***********************************************************/
		private function checkVisibleContextMenuItem(items:ArrayCollection):ArrayCollection
		{
			var hideHeader:Object = getContextMenuItem(MenuConstants.MENUITEM_HD_HIDEHEADER, items);
			var col:ExAdvancedDataGridColumn;
			if (hideHeader)
			{
				if (getVisibleColumnNumber() > 1)
					hideHeader.isEnabled=true;
				else
					hideHeader.isEnabled=false;
			}
			var menuItemPaste:Object=getContextMenuItem(MenuConstants.MENUITEM_CELL_PASTE, items);
			if (menuItemPaste)
			{
				if (sourceCellValue == null)
					menuItemPaste.isEnabled=false;
				else
					menuItemPaste.isEnabled=true;
				col = (this.datagrid.columns[this.datagrid._selectedColIndex] as ExAdvancedDataGridColumn);
				if(col != null && (col.type == ColumnType.CHECKBOX || col.type == ColumnType.COMBOBOX))
					menuItemPaste.isEnabled = false;
			}
			var menuItemUnfixedHeader:Object=getContextMenuItem(MenuConstants.MENUITEM_HD_CANCELFIXHEADER, items);
			if (menuItemUnfixedHeader)
			{
				if (this.datagrid.lockedColumnCount > 0)
					menuItemUnfixedHeader.isEnabled=true;
				else
					menuItemUnfixedHeader.isEnabled=false;
			}
			var menuItemCancelHideHeader:Object=getContextMenuItem(MenuConstants.MENUITEM_HD_CANCELHIDEHEADER, items);
			if (menuItemCancelHideHeader)
			{
				var flag:Boolean=findColHiddenByContextMenu();
				if (flag)
					menuItemCancelHideHeader.isEnabled=true;
				else
					menuItemCancelHideHeader.isEnabled=false;				
			}			
			return items;
		}
		
		/*************************************************************
		 * find column which is hidden by context menu or not
		 * @author Duong Pham
		 * ***********************************************************/		
		private function findColHiddenByContextMenu():Boolean
		{
			var flag:Boolean=false;
			if(datagrid._isGroupedColumn)
			{
				for each (var col:Object in datagrid.groupedColumns)
				{
					if(col is ExAdvancedDataGridColumn && (col as ExAdvancedDataGridColumn).isHideByMenu)
					{
						flag=true;
						break;
					}
					if(col is ExAdvancedDataGridColumnGroup)
					{
						if((col as ExAdvancedDataGridColumnGroup).isHideByMenu)
						{
							flag=true;
							break;
						}
						else
						{
							if(findColHiddenByContextMenuInsideGroupCols(col as ExAdvancedDataGridColumnGroup))
							{
								flag=true;
								break;
							}
						}
					}
				}
			}
			else
			{
				for each (var column:ExAdvancedDataGridColumn in datagrid.columns)
				{
					if (column.isHideByMenu)
					{
						flag=true;
						break;
					}
				}
			}
			return flag;
		}
		
		/*************************************************************
		 * find inside group column with column which is hidden by context menu or not
		 * @author Duong Pham
		 * ***********************************************************/		
		private function findColHiddenByContextMenuInsideGroupCols(groupCol:ExAdvancedDataGridColumnGroup):Boolean
		{
			var flag:Boolean=false;
			for each (var col:Object in groupCol.children)
			{
				if(col is ExAdvancedDataGridColumn && (col as ExAdvancedDataGridColumn).isHideByMenu)
				{
					flag=true;
					break;
				}
				if(col is ExAdvancedDataGridColumnGroup)
				{
					if((col as ExAdvancedDataGridColumnGroup).isHideByMenu)
					{
						flag=true;
						break;
					}
					else if(findColHiddenByContextMenuInsideGroupCols(col as ExAdvancedDataGridColumnGroup))
					{
						flag=true;
						break;
					}
				}
			}
			return flag;
		}
		
		/*************************************************************
		 * filter menu item according to variable bUseDefaultContextMenu and bUserContextMenu
		 * @author: Duong Pham
		 * ***********************************************************/		
		private function filterMenuItem(inputData:ArrayCollection):ArrayCollection
		{
			var outputData:ArrayCollection = new ArrayCollection();
			var item:Object;
			if (this.datagrid.bUseDefaultContextMenu && !this.datagrid.bUserContextMenu)
			{
				for each(item in inputData)
				{
					if(!item.isUserMenu)
						outputData.addItem(item);
				}
			}
			else if (this.datagrid.bUserContextMenu && this.datagrid.bUseDefaultContextMenu)
			{
				for each(item in inputData)
				outputData.addItem(item);
			}
			else if (this.datagrid.bUserContextMenu && !this.datagrid.bUseDefaultContextMenu)
			{
				for each(item in inputData)
				{
					if(item.isUserMenu)
						outputData.addItem(item);
				}
			} 
			return outputData;
		}				
		
		/*************************************************************
		 * context menu handler
		 *
		 * ***********************************************************/
		private function contextMenuHandler(event:SAEvent):void
		{
			this.datagrid.setFocus();
			if(event.data)
			{
				var menuItemKey:String = event.data.value as String;
				var itemMenuType:String = MenuConstants.getMenuType(menuItemKey);
				var isUserMenu:Boolean = event.data.isUserMenu as Boolean;
				if(isUserMenu)
				{
					this.userContextMenuHandler(event);
				}
				else
				{
					if (itemMenuType == MenuConstants.MENU_CELL)
					{
						switch (menuItemKey)
						{
							case MenuConstants.MENUITEM_CELL_INSERT_ROW:
								this.menuItemInsertRowHandler();		
								break;
							case MenuConstants.MENUITEM_CELL_DELETE_ROW:
								this.menuItemDeleteRowHandler();					
								break;
							case MenuConstants.MENUITEM_CELL_REMOVE_ALL:
								this.menuItemRemoveAllHandler();					
								break;
							case MenuConstants.MENUITEM_CELL_COPY:
								this.menuItemCopyHandler();
								break;
							case MenuConstants.MENUITEM_CELL_EXCELEXPORT:
								this.menuItemExcelExportHandler();		
								break;
							case MenuConstants.MENUITEM_CELL_FIND:
								this.menuItemSearchHandler();			
								break;
							case MenuConstants.MENUITEM_CELL_FIND_COLUMN:
								this.menuItemSearchSpecifiedColumnHandler(event.columnKey);			
								break;
							case MenuConstants.MENUITEM_CELL_FONTDOWN:
								this.menuItemFontSizeDownHandler();
								break;
							case MenuConstants.MENUITEM_CELL_FONTUP:
								this.menuItemFontSizeUpHandler();
								break;
							case MenuConstants.MENUITEM_CELL_PASTE:
								this.menuItemPasteHandler();											
								break;
						}
					}
					else if (itemMenuType == MenuConstants.MENU_HEADER)
					{
						switch (menuItemKey)
						{
							case MenuConstants.MENUITEM_HD_CANCELFIXHEADER:
								this.menuItemCancelFixHeaderHandler();
								break;
							case MenuConstants.MENUITEM_HD_CANCELHIDEHEADER:
								this.menuItemCancelHideHeaderHandler();			
								break;
							case MenuConstants.MENUITEM_HD_FIXHEADER:
								this.menuItemFixHeaderHandler(event.columnKey);
								break;
							case MenuConstants.MENUITEM_HD_HIDEHEADER:
								this.menuItemHideHeaderHandler(event.columnKey);				
								break;
						}
					}
					else if (itemMenuType == MenuConstants.MENU_ROW_SELECTOR)
					{
						if (menuItemKey == MenuConstants.MENUITEM_ROW_COPY)
						{
							this.menuItemRowCopyHandler(event.nRow);			
						}
					}
				}
			}				
		}
		
		/*************************************************************************
		 * search data in the specified column when right click
		 * @param dataField String data of column which need to be searched
		 * @author Duong Pham
		 *************************************************************************/
		private function menuItemSearchSpecifiedColumnHandler(dataField:String):void
		{
			var pop:FindPopup=new FindPopup();
			pop.setStyle("color",datagrid.getStyle("ctxMenuCellFindColumnColor"));
			pop.setStyle("fontSize",datagrid.getStyle("ctxMenuCellFindColumnSize"));
			pop.setStyle("fontFamily",datagrid.getStyle("ctxMenuCellFindColumnFontFamily"));
			
			pop.kindOfSearch = dataField;
			PopUpManager.addPopUp(pop, gridone,true);
			pop.addEventListener(SAEvent.POP_SEARCH_DATA, searchDataHandler);
			PopUpManager.centerPopUp(pop);
		}
		
		/*************************************************************************
		 * insert row in menu item
		 * @param none
		 * @author Duong Pham
		 *************************************************************************/
		public function menuItemInsertRowHandler():void
		{
			this.gridone.gridoneImpl.addRowAt(null, this.datagrid._selectedRowIndex);
			 
		}
		
		/*************************************************************************
		 * delete row in menu item
		 * @param none
		 *************************************************************************/
		public function menuItemDeleteRowHandler():void
		{			
			this.gridone.gridoneImpl.deleteRow(this.datagrid._selectedRowIndex);
			 
		}
		
		/*************************************************************************
		 * remove all in menu item
		 * @param none
		 *************************************************************************/
		public function menuItemRemoveAllHandler():void
		{
			this.gridone.gridoneManager.clearData();
		}
		
		/*************************************************************************
		 * search in menu item
		 * @param none
		 *************************************************************************/
		public function menuItemSearchHandler():void
		{			
			var pop:FindPopup=new FindPopup();
			pop.setStyle("color",datagrid.getStyle("ctxMenuCellFindColumnColor"));
			pop.setStyle("fontSize",datagrid.getStyle("ctxMenuCellFindColumnSize"));
			pop.setStyle("fontFamily",datagrid.getStyle("ctxMenuCellFindColumnFontFamily"));
			
			pop.kindOfSearch = "all";
			PopUpManager.addPopUp(pop, gridone,true);
			pop.addEventListener(SAEvent.POP_SEARCH_DATA, searchDataHandler);
			PopUpManager.centerPopUp(pop);
		}
		
		/*************************************************************
		 * search all cells in all columns which is matched the search condition
		 * @param event SaEvent handle parameter in search popup
		 * @author Duong Pham
		 * ***********************************************************/
		public function searchDataHandler(event:SAEvent):void
		{
			var rs:Object;
			var stop:Boolean=false;
			var index:int=0;
			if(event.data["kindOfSearch"].toString() == "all")
			{
				if (event.data["newCondition"].toString() == event.data["oldCondition"].toString())
				{
					index=datagrid.selectedIndex;
					index++;
				}
				if (index == this.datagrid.dataProvider.length - 1)
					index=0;
				
				rs=this.datagrid.search(event.data["newCondition"].toString(), "down", index, "" , event.data["sensitive"]);
				if (rs != null)
				{
					if(!this.datagrid.selectCell)
						gridone.gridoneImpl.scrollToIndex(rs.rowIndex);
					else
					{
						gridone.gridoneImpl.scrollToIndex(rs.rowIndex);
						this.datagrid.setSelectCell(rs.colIndex,rs.rowIndex);	
					}
				}
			}
			else
			{
				var dataField:String = event.data["kindOfSearch"].toString();
				if (event.data["newCondition"].toString() == event.data["oldCondition"].toString())
				{
					index=datagrid.selectedIndex;
					index++;
				}
				if (index == this.datagrid.dataProvider.length - 1)
					index=0;
				
				rs=this.datagrid.search(event.data["newCondition"].toString(), "down", index, dataField , event.data["sensitive"]);
				if (rs != null)
				{
					if(!this.datagrid.selectCell)
						gridone.gridoneImpl.scrollToIndex(rs.rowIndex);
					else
					{
						gridone.gridoneImpl.scrollToIndex(rs.rowIndex);
						this.datagrid.setSelectCell(rs.colIndex,rs.rowIndex);	
					}
				}
			}
		}
		
		/*************************************************************************
		 * copy menu item 
		 * @author Duong Pham
		 *************************************************************************/
		private function menuItemCopyHandler():void
		{			
			var col:ExAdvancedDataGridColumn=this.datagrid.columns[this.datagrid._selectedColIndex] as ExAdvancedDataGridColumn;
			if(this.datagrid.selectCell)
			{
				if(this.datagrid.selectedCells.length > 0)
				{
					var item:Object = this.datagrid.selectedCells[0];
					if (col.type == ColumnType.COMBOBOX)
						sourceCellValue=col.getLabelFromCombo(this.datagrid.dataProvider[item["rowIndex"]][item["columnIndex"]].toString());
					else
						sourceCellValue = this.datagrid.dataProvider[item["rowIndex"]][ExAdvancedDataGridColumn(this.datagrid.columns[item["columnIndex"]]).dataField];					
				}
			}
			else
			{
				if (col.type == ColumnType.COMBOBOX)
					sourceCellValue=col.getLabelFromCombo(this.datagrid.selectedItem[col.dataField].toString());
				else
					sourceCellValue=this.datagrid.selectedItem[col.dataField].toString();			
				sourceColType=(this.datagrid.columns[this.datagrid._selectedColIndex] as ExAdvancedDataGridColumn).type;
			}			
			if(sourceCellValue)
				System.setClipboard(sourceCellValue);
		}
		
		/*************************************************************
		 * function paste in menu item
		 * @author Duong Pham
		 * ***********************************************************/
		private function menuItemPasteHandler():void
		{		
			try
			{
				var col:ExAdvancedDataGridColumn=(this.datagrid.columns[this.datagrid._selectedColIndex] as ExAdvancedDataGridColumn);
				var destColType:String=col.type;			
				var maxLength:int=col.maxLength
				var dataField:String=col.dataField;
				var date:Date;
				var err:ErrorMessages=new ErrorMessages();
				//ignore if column type has one of these type
				if (destColType == ColumnType.COMBOBOX || destColType == ColumnType.CHECKBOX || destColType == ColumnType.IMAGE 
					|| destColType == ColumnType.MULTICOMBO || destColType == ColumnType.BUTTON
					|| destColType == ColumnType.CRUD || destColType == ColumnType.RADIOBUTTON)
				{
					return;
				}
				if (destColType == sourceColType)
				{
					this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=sourceCellValue;				
				}
				else
				{
					if (sourceColType == ColumnType.NUMBER)
					{
						if (destColType == ColumnType.DATE)
						{
							date=DateField.stringToDate(sourceCellValue.toString(), col.dateInputFormatString);
							if(date != null)
							{
								this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=sourceCellValue;							
							}
							else
								return;
						}
						else
						{
							if (sourceCellValue.length > maxLength)
							{
								err.throwError(ErrorMessages.ERROR_TEXT, Global.DEFAULT_LANG);
								return;
							}
							this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=sourceCellValue;						
						}
					}
					else if (sourceColType == ColumnType.DATE)
					{					
						if (destColType == ColumnType.NUMBER)
						{
							if (isNaN(Number(sourceCellValue)) || Number(sourceCellValue) > col.maxValue)
								return;
							else
							{
								this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=Number(sourceCellValue);							
							}						
						}
						else
						{
							if (sourceCellValue.length > maxLength)
							{
								err.throwError(ErrorMessages.ERROR_TEXT, Global.DEFAULT_LANG);
								return;
							}
							this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=sourceCellValue;						
						}					
					}
					else if (sourceColType == ColumnType.TEXT)
					{
						if (destColType == ColumnType.NUMBER)
						{
							if (isNaN(Number(sourceCellValue)) || Number(sourceCellValue) > col.maxValue)
								return;
							else
							{
								this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=Number(sourceCellValue);							
							}						
						}
						else if (destColType == ColumnType.DATE)
						{
							date=DateField.stringToDate(sourceCellValue.toString(), col.dateInputFormatString);
							if(date != null)
							{
								this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=sourceCellValue;							
							}
							else
								return;					
						}
						else
						{
							if (sourceCellValue.length > maxLength)
							{
								err.throwError(ErrorMessages.ERROR_TEXT, Global.DEFAULT_LANG);
								return;
							}
							this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=sourceCellValue;						
						}
					}
					else
					{
						if (destColType == ColumnType.NUMBER)
						{
							if (isNaN(Number(sourceCellValue)) || Number(sourceCellValue) > col.maxValue)
								return;
							else
							{
								this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=Number(sourceCellValue);							
							}						
						}
						else if (destColType == ColumnType.DATE)
						{						
							date=DateField.stringToDate(sourceCellValue.toString(), col.dateInputFormatString);
							if(date != null)
							{
								this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=sourceCellValue;
							}
							else
								return;
						}
						else
						{						
							if (sourceCellValue.length > maxLength)
							{
								err.throwError(ErrorMessages.ERROR_TEXT, Global.DEFAULT_LANG);
								return;
							}
							this.datagrid.getItemAt(this.datagrid._selectedRowIndex)[dataField]=sourceCellValue;
						}
					}
				}
				this.datagrid.invalidateList();
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"pasteItemHandler");					
			}
		}
		
		/*************************************************************
		 * handle export excel in menu item
		 * ***********************************************************/
		private function menuItemExcelExportHandler():void
		{
			gridone.excelExport("", "", true, false, false);
		}
		
		/*************************************************************
		 * handle font size up in menu item
		 * ***********************************************************/
		private function menuItemFontSizeUpHandler():void
		{			
			var fontSize:Number=this.datagrid.getStyle("fontSize");
			this.datagrid.setStyle("fontSize", fontSize + 2);			
		}
		
		/*************************************************************
		 * handle font size down in menu item
		 * ***********************************************************/
		private function menuItemFontSizeDownHandler():void
		{			
			var fontSize:Number=this.datagrid.getStyle("fontSize");
			this.datagrid.setStyle("fontSize", fontSize - 2);
		}
		
		/*************************************************************
		 * handle lock header in menu item
		 * ***********************************************************/
		private function menuItemCancelFixHeaderHandler():void
		{
			this.datagrid.lockedColumnCount=0;
		}
		
		/*************************************************************
		 * handle unlock header in menu item
		 * ***********************************************************/
		private function menuItemFixHeaderHandler(dataFieldCol:String):void
		{			
			this.gridoneImpl.setColFix(dataFieldCol);
		}
		
		/*************************************************************
		 * handle hide header in menu item
		 * ***********************************************************/
		private function menuItemHideHeaderHandler(dataFieldCol:String):void
		{			
			var col:Object= this.getColumnByDataField(dataFieldCol);
			if(col)
			{
				col.visible=false;
				col.isHideByMenu=true;
			}
		}
		
		/*************************************************************
		 * handle cancel hide header in menu item
		 * ***********************************************************/
		private function menuItemCancelHideHeaderHandler():void
		{
			if(datagrid._isGroupedColumn)
			{
				for each (var col:Object in this.datagrid.groupedColumns)
				{
					if(col is ExAdvancedDataGridColumn)
					{
						ExAdvancedDataGridColumn(col).visible = true;
						ExAdvancedDataGridColumn(col).isHideByMenu=false;
					}
					if(col is ExAdvancedDataGridColumnGroup)
					{
						ExAdvancedDataGridColumnGroup(col).visible = true;
						ExAdvancedDataGridColumnGroup(col).isHideByMenu=false;
						updateVisibleColumnInsideGroupCols(ExAdvancedDataGridColumnGroup(col));
					}
				}
			}
			else
			{
				for each (var column:ExAdvancedDataGridColumn in this.datagrid.columns)
				{
					if(column.isHideByMenu)
					{
						column.visible=true;
						column.isHideByMenu=false;
					}	
				}
			}
		}
		
		/*************************************************************
		 * update visible all columns inside group columns
		 * ***********************************************************/
		private function updateVisibleColumnInsideGroupCols(groupColumn:ExAdvancedDataGridColumnGroup):void
		{
			for each (var col:Object in groupColumn.children)
			{
				if(col is ExAdvancedDataGridColumn)
				{
					ExAdvancedDataGridColumn(col).visible = true;
					ExAdvancedDataGridColumn(col).isHideByMenu=false;
				}
				if(col is ExAdvancedDataGridColumnGroup)
				{
					ExAdvancedDataGridColumnGroup(col).visible = true;
					ExAdvancedDataGridColumnGroup(col).isHideByMenu=false;
					updateVisibleColumnInsideGroupCols(ExAdvancedDataGridColumnGroup(col));
				}
			}
		}
		/*************************************************************
		 * handle copy row in menu item
		 * ***********************************************************/
		private function menuItemRowCopyHandler(rowIndex:int):void
		{			
			var item:Object=this.datagrid.dataProvider[datagrid._selectedRowIndex];
			var tmp:String="";
			
			for each (var col:ExAdvancedDataGridColumn in datagrid.columns)
			{
				tmp+=item[col.dataField] + "\t";
			}
			
			var result:String=tmp.substring(0, tmp.length - 2);
			System.setClipboard(result);
		}
		
		/*************************************************************
		 * handle user context menu in menu item
		 * author: Duong Pham
		 * ***********************************************************/
		private function userContextMenuHandler(event:SAEvent):void
		{
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.USER_CONTEXT_MENU_CLICK))
			{
				var menuItemKey:String = event.data.value as String;
				var itemMenuType:String = MenuConstants.getMenuType(menuItemKey);			
				if ((!this.datagrid.bUseDefaultContextMenu) && this.datagrid.bUserContextMenu)
				{
					var userContextMenuClickEvent:SAEvent=new SAEvent(SAEvent.USER_CONTEXT_MENU_CLICK, true);
					if(itemMenuType == MenuConstants.MENU_HEADER)
					{
						userContextMenuClickEvent.columnKey=event.columnKey;
						userContextMenuClickEvent.nRow=-1;
						userContextMenuClickEvent.strMenuKey=MenuConstants.MENU_HEADER;
						userContextMenuClickEvent.strMenuItemKey=menuItemKey;
						this.datagrid.dispatchEvent(userContextMenuClickEvent);
					}				
					else
					{
						userContextMenuClickEvent.columnKey= event.columnKey;
						userContextMenuClickEvent.nRow=event.nRow;
						userContextMenuClickEvent.strMenuKey=MenuConstants.MENU_CELL;
						userContextMenuClickEvent.strMenuItemKey=menuItemKey;
						this.datagrid.dispatchEvent(userContextMenuClickEvent);
					}
				}
			}
		}
		
		/*************************************************************
		 * getColumnByDataField
		 * ***********************************************************/		
		public function getColumnByDataField(dataField:String, isUseGroupColumn:Boolean = false):Object
		{
			var result:Object;
			if(this.datagrid._isGroupedColumn)
			{
				if(this.datagrid.columns.length > 0 && !isUseGroupColumn && this.datagrid.dataFieldIndex.hasOwnProperty(dataField))
				{
					result = this.datagrid.columns[this.datagrid.dataFieldIndex[dataField]];
				}
				if(result == null)
				{
					var tmpCol:Object;
					for (var i:int=0; i<this.datagrid.groupedColumns.length; i++)
					{
						tmpCol = this.datagrid.groupedColumns[i];
						if(tmpCol is ExAdvancedDataGridColumn && ExAdvancedDataGridColumn(tmpCol).dataField != null)
						{
							if(ExAdvancedDataGridColumn(tmpCol).dataField == dataField)
							{
								result = tmpCol;
								break;
							}
						}
						else if(tmpCol is ExAdvancedDataGridColumnGroup && ExAdvancedDataGridColumnGroup(tmpCol).dataField == null)
						{
							result = getChildrenColByGroupCol(dataField, ExAdvancedDataGridColumnGroup(tmpCol));	
							if(result)
								break;
						}
					}		
				}
			}
			else
			{
				if(this.datagrid.columns.length == 0 && this.gridoneImpl.tempCols.length > 0)
					result = this.gridoneImpl.tempCols[this.datagrid.dataFieldIndex[dataField]];
				else
					result = this.datagrid.columns[this.datagrid.dataFieldIndex[dataField]];				
			}			
			return result;
		}	
		
		/*************************************************************
		 * get column index by datafield
		 * ***********************************************************/		
		public function getColumnIndexByDataField(dataField:String):Object
		{
			var result:Object;
			if(this.datagrid._isGroupedColumn)
			{
				for (var i:int=0; i<this.datagrid.groupedColumns.length; i++)
				{
					if(this.datagrid.groupedColumns[i] is ExAdvancedDataGridColumn)
					{
						var tmpCol:ExAdvancedDataGridColumn = this.datagrid.groupedColumns[i] as ExAdvancedDataGridColumn;
						if(tmpCol.dataField == dataField)
						{
							result = tmpCol;
							break;
						}
					}
					else if(this.datagrid.groupedColumns[i] is ExAdvancedDataGridColumnGroup)
					{
						result = getChildrenColByGroupCol(dataField, this.datagrid.groupedColumns[i]);	
						if(result)
							break;
					}
				}				
			}
			else
			{
				if(this.datagrid.columns.length == 0 && this.gridoneImpl.tempCols.length > 0)
					result = this.gridoneImpl.tempCols[this.datagrid.dataFieldIndex[dataField]];
				else
					result = this.datagrid.columns[this.datagrid.dataFieldIndex[dataField]];				
			}			
			return result;
		}
		
		
		/*************************************************************
		 * get child of grouped column
		 * ***********************************************************/			
		public function getChildrenColByGroupCol(dataField:String, groupCol:ExAdvancedDataGridColumnGroup):Object
		{
			var result:Object;
			var tmpGroupCol:ExAdvancedDataGridColumnGroup = groupCol as ExAdvancedDataGridColumnGroup;
			if(tmpGroupCol._dataFieldGroupCol == dataField)
				result = tmpGroupCol;
			else
			{
				for(var i:int=0; i<groupCol.children.length; i++)
				{
					if(groupCol.children[i] is ExAdvancedDataGridColumn && (groupCol.children[i] as ExAdvancedDataGridColumn).dataField == dataField)
					{
						result = groupCol.children[i];
						break;
					}
					else if(groupCol.children[i] is ExAdvancedDataGridColumnGroup)
					{
						if(result != null)
							break;
						result = getChildrenColByGroupCol(dataField, groupCol.children[i]);
					}
				}
			}
			return result;			
		}
		
		/*************************************************************
		 * getColumn
		 * ***********************************************************/			
		public function getColumn(dataField:String):Object
		{
			return this.getColumnByDataField(dataField);
		}
 
		
		/*************************************************************
		 * getColumnType
		 * ***********************************************************/				
		public function getColumnType(columnKey:String):String
		{
			var result:String = '';
			try
			{
				var col:ExAdvancedDataGridColumn= getColumnByDataField(columnKey) as ExAdvancedDataGridColumn;
				if (col == null)
					err.throwError(ErrorMessages.ERROR_COLKEY_INVALID, Global.DEFAULT_LANG);
				result = col.type;
			}
			catch (error:Error)
			{
				err.throwMsgError(error.message,"getColumnType");
			}
			return result.toLowerCase();
		}
		
		/*************************************************************
		 * get the number of visible column
		 * ***********************************************************/	
		public function getVisibleColumnNumber():int
		{
			var result:int=0;
			for each (var col:ExAdvancedDataGridColumn in this.datagrid.columns)
			{
				if (col.visible)
					result++;
			}
			return result;
		}
		
		/*************************************************************
		 * column changed event of datagrid
		 * ***********************************************************/	
		private function dg_columnsChangedHandler(event:Event):void
		{
			if(gridProtocol.drawType)
			{
				if(gridProtocol.drawType==GridProtocol.DRAW_TYPE_A && this.datagrid.isTree)
					this.gridoneImpl.setTreeMode(this.datagrid.treeDataField,this.datagrid.treeInfo[0],this.datagrid.treeInfo[1]);
			}
			if(this.gridone.gridoneImpl.tempCols.length > 0)				
				this.gridone.gridoneImpl.tempCols.removeAll();	
			if(this.datagrid.columns.length > 0)
				verifyResizeLastColumn();
		}
		
		/*************************************************************
		 * verify resize last column
		 * ***********************************************************/	
		private function verifyResizeLastColumn():void
		{
			if(datagrid.bExternalScroll)
			{
				datagrid.allowResizeLastColumn = true;
				return;
			}
			if (datagrid.bAutoWidthColumn)
			{
				datagrid.allowResizeLastColumn = false;
				return;
			}
			var i:int=this.datagrid.columns.length-1;
			while (this.datagrid.columns[i].visible == false)
			{
				i --;
			}
			var lastVisibleColumn:ExAdvancedDataGridColumn = ExAdvancedDataGridColumn(this.datagrid.columns[i]);
			if(!this.datagrid.fixedLastColumn)
				lastVisibleColumn.resizable = true;
			else
				lastVisibleColumn.resizable = this.datagrid.allowResizeLastColumn;
		}
		
		/*************************************************************
		 * set column data field index
		 * ***********************************************************/
		public function setColumnDataFieldIndex(columns:Array):void
		{
			for (var i:int=0; i < columns.length; i++)
			{
				var col:ExAdvancedDataGridColumn = columns[i]; 
				this.datagrid.defaultDataFieldIndex[col.dataField]=i;
				this.datagrid.dataFieldIndex[col.dataField]=i;
			}			
		}
		
		/*************************************************************
		 * add key to dictionary which represent for a row.
		 * ***********************************************************/
		public function addRowKey(key:Object, value:Object):void
		{
			var strKey:String=UIDUtil.getUID(key);
			rowDict[strKey]=value;
		}
		
		
		/*************************************************************
		 * get a key in dictionary from a row.
		 * ***********************************************************/
		public function getRowKey(key:Object):Object
		{
			var strKey:String=UIDUtil.getUID(key);
			return rowDict[strKey];
		}
		
		/*************************************************************
		 * clear all key in dictionary.
		 * ***********************************************************/
		public function clearRowKey():void
		{
			for each (var key:Object in rowDict)
			delete rowDict[key];
			
			rowDict=new Dictionary();
		}
		
		
		/*************************************************************
		 * clear a key in dictionary which represent for a row.
		 * ***********************************************************/
		public function clearRowKeyAt(key:Object):void
		{
			delete rowDict[key];
		}
		
		/************************************************
		 * Handler of header release event: advanced datagrid.
		 * @param event ExAdvancedDataGridEvent.
		 * @author Duong Pham		 
		 ***********************************************/
		private function dg_headerReleaseHandler(evt:ExAdvancedDataGridEvent):void
		{
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_HEADER_CLICK))
			{
				var saEvent:SAEvent=new SAEvent(SAEvent.ON_HEADER_CLICK);
				var col:ExAdvancedDataGridColumn=this.datagrid.columns[evt.columnIndex];
				if(col)
				{
					saEvent.columnKey= col.dataField;		
					this.datagrid.dispatchEvent(saEvent);
				}	
			}
		}
		
		/************************************************
		 * Handler of item edit end event: advanced datagrid.
		 * @param event ExAdvancedDataGridEvent.
		 * @author Duong Pham		 
		 ***********************************************/
		private function dg_itemEditEndHandler(e:ExAdvancedDataGridEvent):void
		{
			if (datagrid.dataProvider == null || (datagrid.dataProvider && datagrid.dataProvider.length == 0))
				return;
			if(e.rowIndex < 0 || e.rowIndex >= this.datagrid.dataProvider.length)
				return;
			this.datagrid.bItemEditBegin=false;
			
			//////////////////////////////////////////////////////////	
			var item:Object = this.datagrid.getBackupItem(e.rowIndex);	
			
			var col:ExAdvancedDataGridColumn=e.currentTarget.columns[e.columnIndex];
			if(col.type != ColumnType.COMBOBOX && col.type != ColumnType.MULTICOMBO && col.type != ColumnType.MULTICOMBOBOX)
			{
				var rowStatus:RowStatus = getRowKey(item) as RowStatus;
				if (e.reason == ExAdvancedDataGridEventReason.NEW_ROW || e.reason == ExAdvancedDataGridEventReason.NEW_COLUMN || e.reason == ExAdvancedDataGridEventReason.OTHER)
				{
					var saEvent:SAEvent=new SAEvent(SAEvent.ON_CELL_CHANGE, true);
					saEvent.columnKey=e.dataField;
					saEvent.nRow=this.datagrid.getBackupItemIndex(item);
					saEvent.strOldValue=item[e.dataField];
					if (col.type == ColumnType.TEXT)
					{
						if ((e.currentTarget as ExAdvancedDataGrid).itemEditorInstance is MaskedInput)
							saEvent.strNewValue=((e.currentTarget as ExAdvancedDataGrid).itemEditorInstance as MaskedInput).text; //Masked2
					}
					else if (col.type == ColumnType.DATE && (e.currentTarget as ExAdvancedDataGrid).itemEditorInstance is DateFieldEditor)
					{
						saEvent.strNewValue=((e.currentTarget as ExAdvancedDataGrid).itemEditorInstance as DateFieldEditor).dateField.text;
						((e.currentTarget as ExAdvancedDataGrid).itemEditorInstance as DateFieldEditor).myDateFieldString=saEvent.strNewValue.toString();
					}
					else if (col.type == ColumnType.NUMBER && (e.currentTarget as ExAdvancedDataGrid).itemEditorInstance is NumberEditor)
					{
						if(datagrid.bDisplayZeroToNull && ((e.currentTarget as ExAdvancedDataGrid).itemEditorInstance as NumberEditor)[datagrid.columns[e.columnIndex].editorDataField] == "" && item[e.dataField] == "0")
						{
							saEvent.strNewValue="0";
						}
						else
							saEvent.strNewValue=((e.currentTarget as ExAdvancedDataGrid).itemEditorInstance as NumberEditor).numberEditor.text;
					} 
					else if(col.type==ColumnType.IMAGETEXT)
					{
						saEvent.strNewValue=((e.currentTarget as ExAdvancedDataGrid).itemEditorInstance as ImageTextEditor).txtImageText.text;
					}					
					
					if (saEvent.strOldValue != saEvent.strNewValue)
					{
						this.gridone.gridoneImpl.setCRUDRowValue(item, this.datagrid.strUpdateRowText , Global.CRUD_UPDATE);
						if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_CELL_CHANGE))
						{
							setTimeout(dispatchOnCellChange, 100, saEvent);
						}
					}
				}
			}
		}
		
		/*************************************************************
		 * dispatch one cell change data
		 * 
		 * ***********************************************************/
		public function dispatchOnCellChange(saEvent:SAEvent):void
		{
			datagrid.dispatchEvent(saEvent);
		}
		
		/*************************************************************
		 * checkBox event click handler
		 *
		 * ***********************************************************/
		private function checkBoxClickHandler(event:SAEvent):void
		{
			var item:Object=datagrid.dataProvider.getItemAt(event.nRow);
			this.gridone.gridoneImpl.setCRUDRowValue(item, datagrid.strUpdateRowText , Global.CRUD_UPDATE);
		}
		
		/*************************************************************
		 * on combo event change item handler
		 * ***********************************************************/
		private function onComboChangeHandler(event:SAEvent):void
		{
			var item:Object=datagrid.dataProvider.getItemAt(event.nRow);
			this.gridone.gridoneImpl.setCRUDRowValue(item, datagrid.strUpdateRowText , Global.CRUD_UPDATE);
		}
		
		/*************************************************************
		 * set item renderer for a column.
		 * ***********************************************************/
		private function dg_itemDoubleClickHandler(event:ListEvent):void
		{			
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_CELL_DBL_CLICK))
			{
				this.datagrid._selectedColIndex = event.columnIndex;
				this.datagrid._selectedRowIndex = event.rowIndex;
				var saEvent:SAEvent=new SAEvent(SAEvent.ON_CELL_DBL_CLICK, true);
				saEvent.columnKey=this.datagrid.columns[event.columnIndex].dataField;
				saEvent.nRow=event.rowIndex;
				datagrid.dispatchEvent(saEvent);	
			}
		}
	 
		/*************************************************************
		 * event scroll datagrid handler
		 * ***********************************************************/
		public function dg_scrollDatagridHandler(event:ScrollEvent):void
		{
			this.datagrid.bscrollStart=true;
			 
			if(datagrid.bExternalScroll && event.direction == "vertical" && event.currentTarget is ExVScrollBar)
				datagrid.verticalScrollPosition=event.currentTarget.scrollPosition;
			if (event.direction == "vertical")
			{
				if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_ROW_SCROLL))
				{
					var saVEvent:SAEvent=new SAEvent(SAEvent.ON_ROW_SCROLL, true);
					var arrRowIndex:Array=getIndexOfRows(event.position);
					saVEvent.nFirstVisibleRowIndex=arrRowIndex["firstRow"];
					saVEvent.nLastVisibleRowIndex=arrRowIndex["lastRow"];
					this.datagrid.dispatchEvent(saVEvent);
				}
			}
			else if (event.direction == "horizontal")
			{
				if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_COL_SCROLL))
				{
					var saHEvent:SAEvent=new SAEvent(SAEvent.ON_COL_SCROLL, true);
					if(!datagrid.bExternalScroll)
					{
						saHEvent.nWidth=this.datagrid.width;
						saHEvent.nLeft=this.datagrid.getHorizontalPostionInPixels();
						saHEvent.nRange=this.datagrid.getHorizontalTrackInPixels();
						this.datagrid.dispatchEvent(saHEvent);
					}
					else
					{
						if(gridone.hbDg.horizontalScrollBar.visible)
						{
							saHEvent.nWidth=this.gridone.applicationWidth;
							saHEvent.nLeft=Math.ceil(this.gridone.hbDg.horizontalScrollBar.scrollThumb.y - 16);
							saHEvent.nRange=this.gridone.hbDg.horizontalScrollBar.scrollTrack.height;
							this.datagrid.dispatchEvent(saHEvent);
						}
					}
				}
			}
			 
		}
		
		/*************************************************************
		 * get index of rows
		 * ***********************************************************/
		private function getIndexOfRows(position:Number):Array
		{
			var result:Array=new Array();
			var count:int=-1;
			for (var i:int=0; i < this.datagrid.dataProvider.length; i++)
			{
				if (count < position)
				{
					count++;
					result["firstRow"]=i;
					result["lastRow"]=i + this.datagrid.rowCount;
				}
				else
				{
					if (result["lastRow"] > this.datagrid.dataProvider.length)
						result["lastRow"]=this.datagrid.dataProvider.length - 1;
					break;
				}
			}
			return result;
		}
		
		/*************************************************************
		 * Get node by key
		 * @param strKey Key of tree
		 * @return The node cointains key if found
		 * @author Thuan
		 * ***********************************************************/
		public function getNodeByKey(strKey: String):Object
		{
			var cur:IViewCursor = this.getTreeDataInFlatCursor();
			do
			{
				if (cur.current[this.datagrid.treeIDField] == strKey)
					return cur.current;
			}
			while (cur.moveNext());
			return null;
		}
		
		/*************************************************************
		 * Get next key
		 * @param strKey Key of tree
		 * @param isInBranch True: Next key is in branch with strKey; False: Next key can be key of next branch
		 * @return The next key of strKey
		 * @author Thuan
		 * ***********************************************************/
		public function getNextNodeByKey(strKey: String, isInBranch:Boolean): String
		{
			var cur:IViewCursor = this.getTreeDataInFlatCursor();
			var parentKey: String = "";
			var nextKey: String = "";
			
			do
			{
				if (cur.current[this.datagrid.treeIDField] == strKey)
				{
					parentKey = cur.current[this.datagrid.treePIDField];
					if (cur.moveNext())
					{
						if (isInBranch) //next key is in branch with strKey
						{
							if (cur.current[this.datagrid.treePIDField] == parentKey)
							{
								nextKey = cur.current[this.datagrid.treeIDField];
							}
						}
						else //next key is in next branch
						{
							nextKey = cur.current[this.datagrid.treeIDField];
						}
					}
					break;
				}
			} while (cur.moveNext());
			
			return nextKey;
		}
		
		/*************************************************************
		 * Get previous key
		 * @param strTreeKey Key of tree
		 * @param isInBranch True: Previous key is in branch with strTreeKey; False: Previous key can be key of next branch
		 * @return The previous key of strTreeKey
		 * @author Thuan
		 * ***********************************************************/
		public function getPreviousNodeByKey(strKey: String, isInBranch:Boolean): String
		{
			var cur:IViewCursor = this.getTreeDataInFlatCursor();
			var parentKey: String = "";
			var previousKey: String = "";
			
			do
			{
				if (cur.current[this.datagrid.treeIDField] == strKey)
				{
					parentKey = cur.current[this.datagrid.treePIDField];
					if (cur.movePrevious())
					{
						if (isInBranch) //next key is in branch with strKey
						{
							if (cur.current[this.datagrid.treePIDField] == parentKey)
							{
								previousKey = cur.current[this.datagrid.treeIDField];
							}
						}
						else //next key is in next branch
						{
							previousKey = cur.current[this.datagrid.treeIDField];
						}
					}
					break;
				}
			} while (cur.moveNext());
			
			return previousKey;
		}
		
		/*************************************************************
		 * Indicates whether the key is found
		 * @param strTreeKey Tree key to find
		 * @return True if found; False if not found
		 * @author Thuan
		 * ***********************************************************/
		public function isExistedKey(strTreeKey: String):Boolean
		{
			var cur:IViewCursor = this.getTreeDataInFlatCursor();
			var found:Boolean = false;
			cur.seek(CursorBookmark.FIRST);
			do
			{
				if (cur.current[this.datagrid.treeIDField] == strTreeKey)
				{
					found = true;
					break;				
				}
			} 
			while (cur.moveNext());
			return found;
		}
		
		/*************************************************************
		 * Indicates whether the parent key is found
		 * @param strTreeKey Tree parent key to find
		 * @return True if found; False if not found
		 * @author Thuan
		 * ***********************************************************/
		public function isExistedParentKey(strTreeParentKey: String):Boolean
		{
			var cur:IViewCursor = this.getTreeDataInFlatCursor();
			var found:Boolean = false;
			cur.seek(CursorBookmark.FIRST);
			do
			{
				if (cur.current[this.datagrid.treePIDField] == strTreeParentKey)
				{
					found = true;
					break;
				}
			} 
			while (cur.moveNext());
			return found;
		}
		
		/*************************************************************
		 * Indicates whether the parent key is parent of child key
		 * @param strTreeParentKey Parent key
		 * @param strTreeKey Child key
		 * @return True when the relation is parent/child; False when not parent/child
		 * @author Thuan
		 * ***********************************************************/
		public function isParentOf(strTreeParentKey: String, strTreeKey: String):Boolean
		{
			var cur:IViewCursor = this.getTreeDataInFlatCursor();
			cur.seek(CursorBookmark.FIRST);
			do
			{
				if (cur.current[this.datagrid.treeIDField] == strTreeKey 
					&& cur.current[this.datagrid.treePIDField] == strTreeParentKey)
				{
					return true;
				}
			} 
			while (cur.moveNext());
			return false;
		}
		
		/*************************************************************
		 * Return the first node of tree
		 * @return The first node of tree
		 * @author Thuan
		 * ***********************************************************/
		public function getFirstNodeInTree():Object
		{
			var cur:IViewCursor = this.getTreeDataInFlatCursor();
			return cur.current;
		}
		
		/*************************************************************
		 * Get Tree Data in Flat Data
		 * @return Flat data as ArrayCollection
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeData():ExIHierarchicalData
		{
			return (this.datagrid.dataProvider as HierarchicalCollectionView).source as ExIHierarchicalData;	
		}
		
		/*************************************************************
		 * Get Tree Data in Flat Data
		 * @return Flat data as ArrayCollection
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeDataInFlat():ArrayCollection
		{
			return (((this.datagrid.dataProvider as HierarchicalCollectionView).source as ExIHierarchicalData).source as ArrayCollection);	
		}
		
		/*************************************************************
		 * Get Tree Data in Flat Cursor
		 * @return Flat data as IViewCursor
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeDataInFlatCursor():IViewCursor
		{
			var ex: ExIHierarchicalData = (this.datagrid.dataProvider as HierarchicalCollectionView).source as ExIHierarchicalData;
			var arr: ArrayCollection = ex.source as ArrayCollection;
			var cursor: IViewCursor = arr.createCursor();
			return cursor;	
		}
		
		/*************************************************************
		 * Get Tree Data in Hierachical Data
		 * @return Flat data as ExIHierarchicalData
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeDataInHier():ExIHierarchicalData
		{
			return (this.datagrid.dataProvider as HierarchicalCollectionView).source as ExIHierarchicalData;
		}
		
		/*************************************************************
		 * Get nearest children of parent node
		 * @return Flat data as ExIHierarchicalData
		 * @author Thuan
		 * ***********************************************************/
		public function getChildren(parentNode: Object):Object
		{
			return ((this.datagrid.dataProvider as HierarchicalCollectionView).source 
				as ExIHierarchicalData).getChildren(parentNode);
		}
		
		/*************************************************************
		 * Delete all children of tree using recursive
		 * @param parent Parent node
		 * @param children Array of child of parent
		 * @author Thuan
		 * ***********************************************************/
		public function deleteChild(parent: Object, children: Object):void
		{
			if (children)
			{ 
				var arrChild:Array = children as Array;
				var arrChildLen:int = arrChild.length;
				if (arrChildLen > 0)
				{
					for (var i:int = 0; i < arrChildLen; i++)
					{
						var arr:Object = this.getChildren(arrChild[i]);
						var arrLen:int = (arr as Array).length;
						deleteChild(arrChild[i], arr);
						for (var j:int = 0; j < arrLen; j++)
						{
							(this.datagrid.dataProvider as HierarchicalCollectionView).removeChild(arrChild[i],(arr as Array)[j]);
						}
					}
				}
			}
		}
		
		/*************************************************************
		 * Get all children using recursive
		 * @param parent Parent node
		 * @param children Directly children of parent
		 * @param arr The arrayCollection that contains all children of parent
		 * @return The arrayCollection that contains all children of parent
		 * @author Thuan
		 * ***********************************************************/
		public function getAllChildren(parent: Object, children: Object, arr: ArrayCollection): ArrayCollection
		{
			var arrChildren:Array = children as Array;
			for (var i:int = 0; i < arrChildren.length; i++)
			{
				arr.addItem(arrChildren[i]);
				var children: Object = this.getChildren(arrChildren[i]);
				if ((children as Array).length > 0)
				{
					this.getAllChildren(arrChildren[i], children, arr);
				}
			}
			return arr;
		}
		
		/*************************************************************
		 * Get all children indexs using recursive
		 * @param parent Parent node
		 * @param children Directly children of parent
		 * @param arr The arrayCollection that contains all children of parent
		 * @return The arrayCollection that contains all children indexs of parent
		 * @author Thuan
		 * ***********************************************************/
		public function getAllChildrenIndexes(parent: Object, children: Object, arr: ArrayCollection): ArrayCollection
		{
			var arrChildren:Array = children as Array;
			for (var i:int = 0; i < arrChildren.length; i++)
			{
				arr.addItem(i);
				var children: Object = this.getChildren(arrChildren[i]);
				if ((children as Array).length > 0)
				{
					this.getAllChildren(arrChildren[i], children, arr);
				}
			}
			return arr;
		}
		
		/*************************************************************
		 * Get all children using recursive
		 * @param strTreeParentKey Parent key
		 * @return The arrayCollection that contains all children of parent
		 * @author Thuan
		 * ***********************************************************/
		public function getAllChildrenByParentKey(strTreeParentKey: String): ArrayCollection
		{
			var parentNode:Object = this.getNodeByKey(strTreeParentKey);
			var children: Object = this.getChildren(parentNode);
			var allChildren: ArrayCollection = new ArrayCollection();
			allChildren = this.getAllChildren(parentNode, children, allChildren);
			return allChildren;
		}
		
		/*************************************************************
		 * Get all children indexs using recursive
		 * @param strTreeParentKey Parent key
		 * @return The arrayCollection that contains all children indexs of parent
		 * @author Thuan
		 * ***********************************************************/
		public function getAllChildrenIndexesByParentKey(strTreeParentKey: String): ArrayCollection
		{
			var parentNode:Object = this.getNodeByKey(strTreeParentKey);
			var children: Object = this.getChildren(parentNode);
			var allChildrenIndexs: ArrayCollection = new ArrayCollection();
			allChildrenIndexs = this.getAllChildrenIndexes(parentNode, children, allChildrenIndexs);
			return allChildrenIndexs;
		}
		
		/*************************************************************
		 * Return the sum or count or average of value
		 * @param strFunc Function [ sum | count | avarage ] 
		 * @param sum Sum of value
		 * @param count Count of node for sum
		 * @return Sum | Count | Average
		 * @author Thuan
		 * ***********************************************************/
		private function getTreeSummaryValue(strFunc:String, sum:Number, count:int):int
		{
			var ret:int = 0;
			switch(strFunc)
			{
				case Global.TREE_SUM_NODE: ret = sum; break;
				case Global.TREE_COUNT_NODE: ret = count; break;
				case Global.TREE_AVERAGE_NODE: ret = (count <= 0) ? 0:(sum/count);
			}
			return ret;
		}
		
		/*************************************************************
		 * Get the summary value for children
		 * @param allChildren Children will be calculated the summary value 
		 * @param strTreeColumnName Summary applied ColumnKey
		 * @return The summary value for children
		 * @author Thuan
		 * ***********************************************************/		
		private function calcSummaryChildren(allChildren:ArrayCollection, strTreeSummaryColumn:String): Array
		{
			var cursor:IViewCursor = allChildren.createCursor();
			var sum:int = 0;
			var count:int = 0;
			var val:int;
			var result:Array = [0, 0];
			
			do
			{
				val = cursor.current[strTreeSummaryColumn];
				sum = sum + val;
				count++;
			} while (cursor.moveNext());
			
			result[0] = sum;
			result[1] = count;
			
			return result;
		}
		
		/*************************************************************
		 * Return the summary value of sub nodes
		 * @param strTreeKey Key of tree
		 * @param strTreeSummaryColumn Summary applied ColumnKey
		 * @param strFunc Function [ sum | count | avarage ] 
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeSummaryValueOfSubNode(strTreeKey:String, strTreeSummaryColumn:String, strFunc:String):int
		{
			var currentNode:Object = this.getNodeByKey(strTreeKey);
			var children:Object;
			var acChildren: ArrayCollection;
			var result:Array = [0, 0];
			
			if (currentNode)
			{
				children = this.getChildren(currentNode);
				acChildren = new ArrayCollection(children as Array);
				result = this.calcSummaryChildren(acChildren, strTreeSummaryColumn);
			}
			return this.getTreeSummaryValue(strFunc, result[0], result[1]);
		}
		
		/*************************************************************
		 * Return the summary value of all sub nodes
		 * @param strTreeKey Key of tree
		 * @param strTreeColumnName Summary applied ColumnKey
		 * @param strFunc Function [ sum | count | avarage ] 
		 * @author Thuan
		 * ***********************************************************/
		public function getTreeSummaryValueOfAllSubNode(strTreeKey:String, strTreeSummaryColumn:String, strFunc:String):int
		{
			var currentNode:Object = this.getNodeByKey(strTreeKey);
			var allChildren: ArrayCollection = new ArrayCollection();
			var children:Object;
			var result:Array = [0, 0];
			
			if (currentNode)
			{
				children = this.getChildren(currentNode);
				allChildren = this.getAllChildren(currentNode, children, allChildren);
				result = this.calcSummaryChildren(allChildren, strTreeSummaryColumn);
			}
			return this.getTreeSummaryValue(strFunc, result[0], result[1]);
		}
		
		/*************************************************************
		 * get datafield by index
		 * @param index
		 * @return data field
		 * @author Duong Pham
		 * ***********************************************************/
		public function getDataFieldByIndex(index:int):String
		{
			var dataField:String = "";
			for (var q:String in this.datagrid.dataFieldIndex)
			{
				if(this.datagrid.dataFieldIndex[q] == index)
				{
					dataField = q;
					break;
				}
			}
			return dataField;
		}
		
		/*************************************************************
		 * check serial key is valid or not
		 * @param szPidKey serial key
		 * @return the status of serial key
		 * @author Duong Pham
		 * ***********************************************************/
		public function checkValidate(szPidKey:String):Boolean
		{
			//the template we use is <C#C#C#C#-######-######> = <ABCDEFGH-IJKLMN-OPQRST>;
			//# digit between 0 and 9, C is character
			//the algorithm is IJKLMN = (BD*FH + 11)*13 +5 
			//OPQRST = ((99-BD)*(99-FH) + 7)*17 +3
			var snIsValid:Boolean=false;
			if (szPidKey.length >= 22)
			{
				var BD:int=int(szPidKey.charAt(1)) * 10 + int(szPidKey.charAt(3));
				var FH:int=int(szPidKey.charAt(5)) * 10 + int(szPidKey.charAt(7));
				
				var IJKLMN:int=int(szPidKey.charAt(9)) * 100000 + int(szPidKey.charAt(10)) * 10000 + int(szPidKey.charAt(11)) * 1000 + int(szPidKey.charAt(12)) * 100 + int(szPidKey.charAt(13)) * 10 + int(szPidKey.charAt(14));
				
				var OPQRST:int=int(szPidKey.charAt(16)) * 100000 + int(szPidKey.charAt(17)) * 10000 + int(szPidKey.charAt(18)) * 1000 + int(szPidKey.charAt(19)) * 100 + int(szPidKey.charAt(20)) * 10 + int(szPidKey.charAt(21));
				
				snIsValid=(IJKLMN == (BD * FH + 11) * 13 + 5) && (OPQRST == ((99 - BD) * (99 - FH) + 7) * 17 + 3);
			}
	 	 
			return snIsValid;
		}
		
		/*************************************************************
		 * update horizontal scroll bar
		 * bExternalScrollBar = true => horizontal of HBox will be used.
		 * bExternalScrollBar = false => horizontal of ExAdvancedDataGrid will be used.
		 * @author Duong Pham
		 * ***********************************************************/
		public function updateExternalScrollBar():void
		{
			if(datagrid.bExternalScroll)
			{
				var datagridWidth:Number;
				//enable horizontal in HBox
				gridone.hbDg.verticalScrollPolicy = ScrollPolicy.OFF;
				gridone.hbDg.horizontalScrollPolicy = ScrollPolicy.AUTO;
				//disable horizontal and vertical in datagrid
				this.datagrid.verticalScrollPolicy=ScrollPolicy.OFF;
				this.datagrid.horizontalScrollPolicy=ScrollPolicy.OFF;
				
				gridoneManager.updateExternalHorizontalScroll();
				
				this.gridone.vScroll.pageSize = this.datagrid.getPageSize();
				//enable resize lastColumn
				// datagrid.allowResizeLastColumn = true;
				
			}
			else
			{
				//enable horizontal in HBox				
				gridone.hbDg.verticalScrollPolicy = ScrollPolicy.OFF;
				gridone.hbDg.horizontalScrollPolicy = ScrollPolicy.OFF;
				//disable horizontal and vertical in datagrid
				this.datagrid.percentWidth=100;
				this.datagrid.verticalScrollPolicy=ScrollPolicy.AUTO;
				if(datagrid.bAutoWidthColumn)
					this.datagrid.horizontalScrollPolicy=ScrollPolicy.OFF;
				else
					this.datagrid.horizontalScrollPolicy=ScrollPolicy.AUTO;
				
			} 
			//if(this.datagrid.fixedLastColumn)
			//	this.datagrid.fixedLastColumn = false;
			//if(this.datagrid.allowResizeLastColumn)
			//	setDataGridProperty('allowResizeLastColumn',false);
			
			//update horizontal scroll position and vertical scroll position when changing this property
			this.datagrid.verticalScrollPosition = gridone.vScroll.scrollPosition = 0;
			this.datagrid.horizontalScrollPosition = 0;
		}
		
		/*************************************************************
		 * mouse wheel datagrid handler
		 * ***********************************************************/
		public function dg_onMouseWheelDGHandler(event:MouseEvent):void
		{
		 
			if(datagrid.bExternalScroll)
			{
				var num:int=event.delta / Math.abs(event.delta) * datagrid.mouseWheelPageSize;
				if (datagrid.verticalScrollPosition == 0 && num > 0)
				{
					MouseWheelTrap.allowBrowserScroll(true);
					return;
				}
				if (datagrid.verticalScrollPosition == datagrid.maxVerticalScrollPosition && num < 0)
				{
					MouseWheelTrap.allowBrowserScroll(true);
					return;
				}
				MouseWheelTrap.allowBrowserScroll(false);
				var position:int = datagrid.verticalScrollPosition-num;
				if(position > datagrid.maxVerticalScrollPosition)
					position = datagrid.maxVerticalScrollPosition;
				else
				{
					if(position < 0)
						position = 0;
				}
				datagrid.verticalScrollPosition = position;
				gridone.vScroll.scrollPosition=position;
			}
		}
		
		/*************************************************************
		 * update external horizontal scroll when using keyboard
		 * @param event ExAdvancedDataGridEvent
		 * @author Duong Pham
		 * ***********************************************************/
		protected function updateExternalHorizontalScrollHandler(event:ExAdvancedDataGridEvent):void
		{
			if(datagrid.bExternalScroll)
			{
				var totalWidthOfVisibleIndexCol:int=0;
				var col:ExAdvancedDataGridColumn;
				for each(col in this.datagrid.columns)
				{				
					if(col.visible)
					{
						totalWidthOfVisibleIndexCol += col.width;
					}
					if(col.dataField == event.dataField)
						break;
				}
				if(gridone.vScroll.visible)
					
					totalWidthOfVisibleIndexCol += 18;
				if(this.gridone.applicationWidth + this.gridone.hbDg.horizontalScrollPosition <= totalWidthOfVisibleIndexCol)
				{
					this.gridone.hbDg.horizontalScrollPosition = totalWidthOfVisibleIndexCol - this.gridone.applicationWidth;
				}
				else
				{				
					var totalWidthOfPreviousCol:int;
					if(this.gridone.vScroll.visible)
						totalWidthOfVisibleIndexCol -= 18;
					totalWidthOfPreviousCol = totalWidthOfVisibleIndexCol - col.width;
					if(totalWidthOfPreviousCol < this.gridone.hbDg.horizontalScrollPosition)
						this.gridone.hbDg.horizontalScrollPosition = totalWidthOfPreviousCol;				
				}
			}
		}
		
		/*************************************************************
		 * mouse focus in datagrid handler
		 * ***********************************************************/
		public function datagrid_focusInHandler(event:FocusEvent):void
		{
			if(this.datagrid.eventArr.hasOwnProperty(SAEvent.ON_DG_FOCUS))
			{
				var saVEvent:SAEvent=new SAEvent(SAEvent.ON_DG_FOCUS, true);
				saVEvent.bridgeName=this.gridone.bridgeName;
				this.datagrid.dispatchEvent(saVEvent);
			}
		}
		
	}
}

