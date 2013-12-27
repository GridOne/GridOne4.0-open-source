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
	
	import kr.co.actsone.common.Global;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.events.SAEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	
	public class CheckBoxRenderer extends ExUIComponent
	{
		protected var cb:CheckBox;
		public var trueValue:*=1;
		public var falseValue:*=0;
		public function CheckBoxRenderer()
		{
			super();
			
			tabEnabled = false;
		}
		
		/******************************************************************************************
		 * Create child objects of the component.
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!cb)
			{
				cb = new CheckBox();
				this.cb.styleName = this;
				this.cb.addEventListener(MouseEvent.CLICK,selectThis);
				addChild(DisplayObject(cb));
			}
		}
		
		/******************************************************************************************
		 * Processes the properties set on the component
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (data && column)
			{
				if(data[dataField+Global.SELECTED_CHECKBOX_INDEX]==true){
					cb.visible = false;
				}else{
					cb.visible = true;
				}
				if (data != null && dataField != "" && cb != null)
				{
					if (data[dataField] != null && data[dataField] != "")
					{
						cb.selected=(data[dataField].toString().toLowerCase().search("true") == 0 || data[dataField].toString() == "1") ? true : false;
					}
					else
					{
						cb.selected=false;
						data[dataField]=0;
					}
				}
			}
			invalidateDisplayList();
		}
		
		/******************************************************************************************
		 * handle mouse click event when selecting check box.
		 * dispatch event in case check box is changed state.
		 * @author Duong Pham
		 ******************************************************************************************/
		public function selectThis(event:MouseEvent):void
		{
			var col:ExAdvancedDataGridColumn=this.listOwner.columns[this.listData.columnIndex] as ExAdvancedDataGridColumn;
			var activation:String=this.listOwner.getCellProperty('activation',data[Global.ACTSONE_INTERNAL],dataField);
			if (listOwner.strCellClickAction == Global.ROWSELECT || col.cellActivation!=Global.ACTIVATE_EDIT || activation==Global.ACTIVATE_ONLY || activation==Global.ACTIVATE_DISABLE)
			{
				cb.selected=!cb.selected;
				return;
			}
			else
			{ 
				if ((this.listOwner.columns[this.listData.columnIndex] as ExAdvancedDataGridColumn).isSelectSingleCheckbox)
				{
					if ((this.listOwner.columns[this.listData.columnIndex] as ExAdvancedDataGridColumn).selectedRadioItem != null)
					{
						(listOwner.columns[this.listData.columnIndex] as ExAdvancedDataGridColumn).selectedRadioItem[this.dataField]="0";
						(this.listOwner.dataProvider as ArrayCollection).itemUpdated((this.listOwner.columns[this.listData.columnIndex] as ExAdvancedDataGridColumn).selectedRadioItem);
					}
					(listOwner.columns[this.listData.columnIndex] as ExAdvancedDataGridColumn).selectedRadioItem=data;
				} 					
				data[dataField]=cb.selected ? "1" : "0";
				
				var saEvent:SAEvent=new SAEvent(SAEvent.CHECKBOX_CLICK, true);
				saEvent.nRow=this.listOwner.getItemIndex(this.data);
				saEvent.columnIndex=this.listData.columnIndex;
				saEvent.strNewValue=data[dataField];
				saEvent.columnKey=this.dataField;
				this.listOwner.dispatchEvent(saEvent);
				
				var changeEvent:SAEvent=new SAEvent(SAEvent.ON_CELL_CHANGE, true);
				changeEvent.columnKey=this.dataField;
				changeEvent.nRow=saEvent.nRow;
				
				changeEvent.strOldValue=cb.selected ? "0" : "1";
				changeEvent.strNewValue=cb.selected ? "1" : "0";
				this.listOwner.dispatchEvent(changeEvent);
				
				this.listOwner.addRemvoveSelectedCheckBox(col,cb.selected,data);
				
				// remove this code because it is invalid in case bHDDblClickAction
				col.isSelectedCheckboxAll=(col.arrSelectedCheckbox.length == this.listOwner.dataProvider.length) ? true : false;
				var updateStateHeaderCheckbox:SAEvent = new SAEvent(SAEvent.UPDATE_STATE_HEADER_CHECK_BOX,true);
				updateStateHeaderCheckbox.data = new Object();
				updateStateHeaderCheckbox.data["isCheckedAll"] = col.isSelectedCheckboxAll;
				updateStateHeaderCheckbox.columnKey = dataField;
				this.listOwner.dispatchEvent(updateStateHeaderCheckbox);
			}
		}
		
		/******************************************************************************************
		 * Draws the object and/or sizes and positions its children.
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var startX:Number = 0;
			if(this.listOwner && this.listOwner.nCellPadding)
			{
				startX += this.listOwner.nCellPadding;
			}
			
			var textAlign:String = getStyle("textAlign");
			if (textAlign == "left")
			{
				cb.x = startX;
			}
			else if (textAlign == "right")
			{
				cb.x=0;
			}
			else
			{
 	
			}		
			this.cb.setActualSize(unscaledWidth - startX, unscaledHeight);
	 
	 }
 
		/******************************************************************************************
		 * Get accessibility name for screen reader
		 * @author Thuan
		 ******************************************************************************************/
		override public function getAccessibilityName():String
		{
			//return "Component is Checkbox. Value is " + this.cb.selected;
			
			var sChecked:String = this.cb.selected ? "true":"false";
			var strReader:String = this.column.strAccessReader;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_CHECKBOX);
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, sChecked);
				}
				else // don't have control type in strAccessReader
				{
					if (strReader.indexOf(Global.ACCESS_READER_CELLVALUE) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_CELLVALUE, sChecked);
				}
				//				trace("Label Renderer strReader != null: " + strReader);
			}
			else // make column default information
			{
				strReader = Global.ACCESS_READER_COLUMN_DEFAULT + " " + Global.ACCESS_READER_CONTROL + " " + 
					Global.ACCESS_READER_CHECKBOX + " " + Global.ACCESS_READER_CELL + " " + sChecked;
				//				trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;			
		}
	}
}