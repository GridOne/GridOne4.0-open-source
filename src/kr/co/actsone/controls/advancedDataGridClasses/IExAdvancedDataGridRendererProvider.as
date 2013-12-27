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
    
/**
 *  The IAdvancedDataGridRendererProvider interface defines the interface 
 *  implemented by the ExAdvancedDataGridRendererProvider class, 
 *  which defines the item renderer for the ExAdvancedDataGrid control. 
 *
 *  @see kr.co.actsone.controls.ExAdvancedDataGrid
 *  @see kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridRendererProvider
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */    
public interface IExAdvancedDataGridRendererProvider
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /** 
     *  Updates the IExAdvancedDataGridRendererProvider instance with 
     *  information about this IAdvancedDataGridRendererProvider.
     * 
     *  @param data The data item to display.
     * 
     *  @param dataDepth The depth of the data item in the ExAdvancedDataGrid control.
     * 
     *  @param column The column associated with the item.
     * 
     *  @param description The ExAdvancedDataGridRendererDescription object 
     *  populated with the renderer and column span information.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function describeRendererForItem(data:Object, 
                                       dataDepth:int, 
                                       column:ExAdvancedDataGridColumn,
                                       description:ExAdvancedDataGridRendererDescription):void;
}
}