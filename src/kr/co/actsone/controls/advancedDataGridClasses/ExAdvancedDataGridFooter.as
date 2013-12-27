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

package kr.co.actsone.controls.advancedDataGridClasses
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;

import kr.co.actsone.controls.ExAdvancedDataGrid;
import kr.co.actsone.events.ExAdvancedDataGridEvent;

import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.styles.IStyleClient;

use namespace mx_internal;

public class ExAdvancedDataGridFooter extends UIComponent
{

	public function ExAdvancedDataGridFooter()
	{
		super();
	}

	protected var overlayFixed:Sprite;
	protected var overlayScrollable:Sprite;

	protected var dataGrid:ExAdvancedDataGrid;
	
	/**
	 *  create the actual border here
	 */
	override protected function createChildren():void
	{
		dataGrid = parent as ExAdvancedDataGrid;
		
		overlayFixed = new Sprite();
		addChild(overlayFixed);
		
		overlayScrollable = new Sprite();
		addChild(overlayScrollable);
		//
		dataGrid.addEventListener(ExAdvancedDataGridEvent.COLUMN_STRETCH, _handleColumnStretch);
	}
	
	private function _handleColumnStretch (e : ExAdvancedDataGridEvent) : void 
	{
		_drawFixedColumns = false;
	}
	//you only need to draw the fixed columns on init and when the columns
	//are resized
	private var _drawFixedColumns : Boolean = false;
	/**
	 *	lay it out
	 */
	override protected function updateDisplayList(w:Number, h:Number):void
	{
		overlayScrollable.graphics.clear();
		if (!_drawFixedColumns){
    		overlayFixed.graphics.clear();
		}
      	var lockedColumns : int = dataGrid.lockedColumnCount;

		// destroy the old children - except the grid lines and the mask
		// if there is no mask, only keep the the grid lines (level 0),
		// if there is a mask, keep mask (level 0) and grid lines (level 1)
		var childrenToKeep : int = 2;
		if (_drawFixedColumns) childrenToKeep += lockedColumns;
		if (dataGrid.getStyle("horizontalScrollPolicy") != "off") {
			childrenToKeep ++;
			_updateMask (w, h);
		}
		while (numChildren > childrenToKeep) removeChildAt(childrenToKeep);
     
		// make new ones
		var cols:Array = dataGrid.columns;
		

      	var lineCol:uint = dataGrid.getStyle("verticalGridLineColor");
      	var vlines:Boolean = dataGrid.getStyle("verticalGridLines");
		overlayFixed.graphics.lineStyle(1, lineCol);
		overlayScrollable.graphics.lineStyle(1, lineCol);
    
		var xx:Number = 0;
		var yy:Number = 0;
		var i : int = 0;
		var col:ExAdvancedDataGridColumn;
		//draw the locked columns if there are any
		while (xx < w && i < lockedColumns)
		{
			col = cols[i++];
         if (!_drawFixedColumns) {
    			_drawColumn(col, overlayFixed, i, xx, yy, h);	
			}
			xx += col.width;
			
		}
		_drawFixedColumns = true;
		//draw the scrollable columns
		i = dataGrid.horizontalScrollPosition + lockedColumns;
		while (xx < w && i < cols.length )
		{
			col = cols[i++];
			_drawColumn(col, overlayScrollable, i, xx, yy, h);
			xx += col.width;
		}
		
      lineCol = dataGrid.getStyle("horizontalGridLineColor");
      if (dataGrid.getStyle("horizontalGridLines")) {
			overlayFixed.graphics.lineStyle(1, lineCol);
			overlayFixed.graphics.moveTo(0, yy);
			overlayFixed.graphics.lineTo(w, yy);
		}

		// draw separator at top of footer
      lineCol = dataGrid.getStyle("borderColor");
		overlayFixed.graphics.lineStyle(1, lineCol);
		overlayFixed.graphics.moveTo(0, 0);
		overlayFixed.graphics.lineTo(w, 0);

	}
	private function _drawColumn (col:ExAdvancedDataGridColumn, drawSprite : Sprite, i : int, xx : Number, yy : Number, h : Number) : void 
	{
	    if (col is ExAdvancedDataGridColumn) {
			var fdgc:ExAdvancedDataGridColumn = col as ExAdvancedDataGridColumn;
			fdgc.footerColumn.owner = fdgc.owner;
			var itemRenderer:IListItemRenderer;
			if(fdgc.footerColumn.itemRenderer)
				itemRenderer = fdgc.footerColumn.itemRenderer.newInstance();
			else			
			{
//				var tmp:IFactory = (new ClassFactory(ExAdvancedDataGridItemRenderer)).newInstance();
				itemRenderer =  (new ClassFactory(ExAdvancedDataGridItemRenderer)).newInstance();
			}
//			var itemRenderer:IListItemRenderer = (fdgc.footerColumn.itemRenderer) ? 
//				fdgc.footerColumn.itemRenderer.newInstance() : dataGrid.itemRenderer.newInstance();
			(itemRenderer as IStyleClient).styleName = fdgc.footerColumn;
			(itemRenderer as IStyleClient).setStyle('color','#2B333C');
			if (itemRenderer is IDropInListItemRenderer) 
			{
				IDropInListItemRenderer(itemRenderer).listData = new ExAdvancedDataGridListData(
					(fdgc.footerColumn.labelFunction != null) ? fdgc.footerColumn.labelFunction(col) : fdgc.footerText, 
					fdgc.dataField, i - 1, null, dataGrid, -1);
			}
			itemRenderer.data = fdgc;
			addChild(DisplayObject(itemRenderer));
			itemRenderer.x = xx;
			itemRenderer.y = yy;
			itemRenderer.setActualSize(col.width - 1, this.dataGrid.footerHeight);
			if (dataGrid.getStyle("verticalGridLines"))
			{
				drawSprite.graphics.moveTo(xx + col.width, yy);
				drawSprite.graphics.lineTo(xx + col.width, h);
			}
		}
	}
	private var _myMask : Sprite;
	/**
	 * Does two things : creates the mask if it's needed
	 * Updates the mask size based on the new size properties
	 */
	private function _updateMask (w : Number, h : Number) : void {
		//if the mask hasn't been created, create it
		if (_myMask == null) {
			_myMask = new Sprite();
			//need to add it at 1 because horizontal scroll policy could 
			//change at run time, and the removal of the text is based on
			//child index
			addChildAt(_myMask, 1);
			mask = _myMask;
		}
		var g : Graphics = _myMask.graphics;
		g.clear();
		g.beginFill(0xffffff, 0);
		g.drawRect(0, 0, w, h);
		g.endFill();
	}
}

}