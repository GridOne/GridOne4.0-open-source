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

import mx.core.IFactory;
import mx.core.mx_internal;

use namespace mx_internal;
    
/**
 *  An ExAdvancedDataGridRendererProvider instance defines the characteristics for 
 *  a single item renderer used by the ExAdvancedDataGrid control. 
 *  Use properties of the ExAdvancedDataGridRendererProvider class to 
 *  configure where an item renderer is used in an ExAdvancedDataGrid control.
 *
 *  <p>The following example uses the ExAdvancedDataGridRendererProvider class to 
 *  configure a custom item renderer named EstimateRenderer.mxml in the 
 *  myComponents subdirectory.</p>
 *
 *  <pre>
 *  &lt;mx:ExAdvancedDataGrid&gt;
 *      &lt;mx:columns&gt;
 *          &lt;mx:ExAdvancedDataGridColumn dataField="Region"/&gt;
 *          &lt;mx:ExAdvancedDataGridColumn dataField="Territory_Rep"
 *              headerText="Territory Rep"/&gt;
 *          &lt;mx:ExAdvancedDataGridColumn dataField="Actual"/&gt;
 *          &lt;mx:ExAdvancedDataGridColumn dataField="Estimate"/&gt;
 *      &lt;/mx:columns&gt;
 *  
 *      &lt;mx:rendererProviders&gt;
 *          &lt;mx:ExAdvancedDataGridRendererProvider 
 *              columnIndex="3"
 *              columnSpan="1" 
 *              renderer="myComponents.EstimateRenderer"/&gt;
 *      &lt;/mx:rendererProviders&gt;
 *  &lt;/mx:AdvancedDataGrid&gt;
 *  </pre>
 *  
 *  @mxml
 *  <p>The <code>&lt;mx:ExAdvancedDataGridRendererProvider&gt;</code> tag 
 *  defines the following tag attributes:</p>
 *  <pre>
 *  &lt;mx:ExAdvancedDataGridRendererProvider
 *    <b>Properties</b>
 *    column="<i>Not defined</i>"
 *    columnIndex="-1"
 *    columnSpan="1"
 *    dataField="<i>No default</i>"
 *    depth="<i>All depths of the tree</i>"
 *    renderer="null"
 *    rowSpan="1"
 *  /&gt;
 *
 *  @see kr.co.actsone.controls.ExAdvancedDataGrid
 *
 *  @includeExample examples/AdvancedDataGridChartRendererExample.mxml
 *  @includeExample examples/ChartRenderer.mxml -noswf
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ExAdvancedDataGridRendererProvider implements IExAdvancedDataGridRendererProvider
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
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function ExAdvancedDataGridRendererProvider()
    {
        super();
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
     *  The <code>id</code> of the column for which the renderer is used. 
     *  If you omit this property, 
     *  you can use the <code>columnIndex</code> property to specify the column. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var column:ExAdvancedDataGridColumn;
    
    //----------------------------------
    // columnIndex
    //----------------------------------
    
    /** 
     *  The column index for which the renderer is used, 
     *  where the first column is at an index of 0.
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var columnIndex:int = -1;
    
    //----------------------------------
    // columnSpan
    //----------------------------------
       
    /**
     *  Specifies how many columns the renderer should span. 
     *  Set this property to 0 to span all columns.
     *  The ExAdvancedDataGrid control uses this information to set the width 
     *  of the item renderer.
     * 
     *  @default 1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var columnSpan:int = 1;
    
    //----------------------------------
    // dataField
    //----------------------------------
       
    /** 
     *  The data field in the data provider for the renderer. 
     *  This property is optional. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var dataField:String;
       
    //----------------------------------
    // depth
    //----------------------------------
    
    /**
     *  Depth in the tree at which the renderer is used, 
     *  where the top-most node of the tree is at a depth of 1. 
     *  Use this property if the renderer should only be used when the tree 
     *  is expanded to a certain depth, but not for all nodes in the tree. 
     *  By default, the control uses the renderer for all levels of the tree.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var depth:int = -1;
    
    //----------------------------------
    // renderer
    //----------------------------------
    
    /**
     * The ItemRenderer IFactory used to create an instance of the item renderer. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var renderer:IFactory;
    
    //----------------------------------
    // rowSpan
    //----------------------------------
    
    /**
     *  Specifies how many rows the renderer should span.
     *  The ExAdvancedDataGrid control uses this information to set the height of the renderer.
     *
     *  <p>Currently, this property is not implemented in the ExAdvancedDataGrid control.</p>
     *  
     *  @default 1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var rowSpan:int = 1;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
       
    /**
     *  @private
     *  Method which compares property values to given values to determine whether the 
     *  renderer should be used for the given data, depth and column.
     */
    protected function checkMatch(data:Object, dataDepth:int, column:ExAdvancedDataGridColumn):Boolean
    {
        var matching:Boolean = true;
        
        // check if the data object has the specified dataField
        if(dataField && (!data || !data.hasOwnProperty(dataField)))
            matching = false;
        
        // check if the column has the same columnIndex as specified in the rendererProvider
        if(columnIndex != -1 && columnIndex != column.colNum)
            matching = false;
        
        // check if the data has the same depth as specified in the rendererProvider
        if(depth != -1 && dataDepth != depth)
            matching = false;
        
        // check if this is the same column as specified in the rendererProvider
        if(this.column && this.column != column)
            matching = false;
        
        return matching;    
    }
       
    /**
     *  Updates the ExAdvancedDataGridRendererDescription instance with information about 
     *  this ExAdvancedDataGridRendererProvider instance.
     * 
     *  @param data The data item to display.
     * 
     *  @param dataDepth The depth of the data item in the ExAdvancedDataGrid control.
     * 
     *  @param column The column associated with the item.
     * 
     *  @param description The ExAdvancedDataGridRendererDescription object populated 
     *  with the renderer and column span information.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function describeRendererForItem(data:Object, 
                                   dataDepth:int, 
                                   column:ExAdvancedDataGridColumn,
                                   description:ExAdvancedDataGridRendererDescription):void
    {
        // check for matching properties
        if(checkMatch(data,dataDepth,column))
        {
            description.columnSpan = this.columnSpan;
            description.renderer = this.renderer;
        }
    }
}

}