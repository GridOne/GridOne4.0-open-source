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

import mx.controls.listClasses.IListItemRenderer;
/**                                                                                                                                                                         
  *  The ExAdvancedDataGridHeaderInfo class contains information that describes the 
  *  hierarchy of the columns of the ExAdvancedDataGrid control.
  *  
  *  @langversion 3.0
  *  @playerversion Flash 9
  *  @playerversion AIR 1.1
  *  @productversion Flex 3
  */                                        
public class ExAdvancedDataGridHeaderInfo
{
	include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
    /**                                                                                                                                                                         
     *  Constructor.
     *
     *  @param column A reference to the ExAdvancedDataGridColumn instance 
     *  that this ExAdvancedDataGridHeaderInfo instance corresponds to.
     *
     *  @param parent The parent ExAdvancedDataGridHeaderInfo instance 
     *  of this ExAdvancedDataGridHeaderInfo instance.
     *
     *  @param index The index of this ExAdvancedDataGridHeaderInfo instance 
     *  in the AdvancedDataGrid control.
     *
     *  @param depth The depth of this ExAdvancedDataGridHeaderInfo instance 
     *  in the columns hierarchy of the ExAdvancedDataGrid control.
     *
     *  @param children An Array of all of the child ExAdvancedDataGridHeaderInfo instances 
     *  of this ExAdvancedDataGridHeaderInfo instance.
     *
     *  @param internalLabelFunction A function that gets created if the column grouping 
     *  requires extracting data from nested objects.
     *
     *  @param headerItem A reference to IListItemRenderer instance used to 
     *  render the column header.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */                                        
    public function ExAdvancedDataGridHeaderInfo(column:ExAdvancedDataGridColumn,
                                      parent:ExAdvancedDataGridHeaderInfo,
                                      index:int,
                                      depth:int,
                                      children:Array = null,
                                      internalLabelFunction:Function = null,
                                      headerItem:IListItemRenderer = null)
    {
       this.column = column;
       this.parent = parent;
       this.index = index;
       this.depth = depth;
       this.children = children;
       this.internalLabelFunction = internalLabelFunction;
       this.headerItem = headerItem;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------   
    
    //----------------------------------
    // column
    //----------------------------------

    /**
    *  A reference to the ExAdvancedDataGridColumn instance 
    *  corresponding to this ExAdvancedDataGridHeaderInfo instance.                                                                                         
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var column:ExAdvancedDataGridColumn;
    
    //----------------------------------
    // parent
    //----------------------------------
    
    /**
    *  The parent ExAdvancedDataGridHeaderInfo instance 
    *  of this ExAdvancedDataGridHeaderInfo instance 
    *  if this column is part of a column group.
    *
    *  @default null
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var parent:ExAdvancedDataGridHeaderInfo;
    
    //----------------------------------
    // index
    //----------------------------------
    
    /**
    *  The index of this ExAdvancedDataGridHeaderInfo instance 
    *  in the ExAdvancedDataGrid control.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var index:int;
    
    //----------------------------------
    // depth
    //----------------------------------
    
    /**
    *  The depth of this ExAdvancedDataGridHeaderInfo instance 
    *  in the columns hierarchy of the ExAdvancedDataGrid control,
    *  if this column is part of a column group.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var depth:int;
    
    //----------------------------------
    // children
    //----------------------------------
    
    /**
    *  An Array of all of the child ExAdvancedDataGridHeaderInfo instances
    *  of this ExAdvancedDataGridHeaderInfo instance,
    *  if this column is part of a column group.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var children:Array;
    
    //----------------------------------
    // headerItem
    //----------------------------------
    
    /**
    *  A reference to IListItemRenderer instance used to render the column header.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var headerItem:IListItemRenderer;
    
    //----------------------------------
    // internalLabelFunction
    //----------------------------------
    
    /**
    *  A function that gets created if the 
    *  column grouping requires extracting data from nested objects.
    *
    *  <p>For example, if each data row appears as: </p>
    *  <pre>row = {.., .., Q1: { y2005: 241, y2006:353}};</pre>
    *
    *  <p>and you define a column group as:</p>
    *  <pre>     &lt;mx:ExAdvancedDataGridColumnGroup dataField="Q1"&gt;
    *     &lt;mx:ExAdvancedDataGridColumn dataField="y2005"&gt;
    *     &lt;mx:ExAdvancedDataGridColumn dataField="y2006"&gt;
    *  &lt;/mx:ExAdvancedDataGridColumnGroup&gt;</pre>
    *
    * <p>The function for the column corresponding to y2005 is defined as:</p>
    * <pre>     function foo():String
    *  {
    *     return row["Q1"]["2005"];
    *  }</pre>
    * 
    *  <p>The function also handles the case when any of the column or column groups
    *  uses a label function instead of a data field.</p>
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var internalLabelFunction:Function;
    
    //----------------------------------
    // columnSpan
    //----------------------------------
    
    /**
    *  Number of actual columns spanned by the column header when using column groups.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var columnSpan:int;
    
    //----------------------------------
    // actualColNum
    //----------------------------------
    
    /**
    *  The actual column index at which the header starts,
    *  relative to the currently displayed columns.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var actualColNum:int;
    
    //----------------------------------
    // visible
    //----------------------------------
    
    /**
    *  Contains <code>true</code> if the column is currently visible.
    *
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var visible:Boolean;
    
    //----------------------------------
    // visibleChildren
    //----------------------------------
    
    /**
    *  An Array of the currently visible child ExAdvancedDataGridHeaderInfo instances. 
    *  if this column is part of a column group.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var visibleChildren:Array;
    
    //----------------------------------
    // visibleIndex
    //----------------------------------
    
    /**
    *  The index of this column in the list of visible children of its parent
    *  ExAdvancedDataGridHeaderInfo instance,
    *  if this column is part of a column group.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public var visibleIndex:int;
}

}