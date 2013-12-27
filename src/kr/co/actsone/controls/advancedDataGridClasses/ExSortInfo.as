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
 *  The ExSortInfo class defines information about the sorting of a column
 *  of the ExAdvancedDataGrid control.
 *  Each column in the ExAdvancedDataGrid control has an associated 
 *  ExSortInfo instance. 
 *  The ExAdvancedDataGridSortItemRenderer class uses the 
 *  information in the ExSortInfo instance to create the item renderer 
 *  for the sort icon and text field in the column header of each column in 
 *  the ExAdvancedDataGrid control.
 *
 *  @see kr.co.actsone.controls.ExAdvancedDataGrid
 *  @see kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridSortItemRenderer 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ExSortInfo
{
    include "../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Specifies that the sort is only a visual
     *  indication of the proposed sort.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const PROPOSEDSORT:String = "proposedSort";

    /**
     *  Specifies that the sort is the actual current sort.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const ACTUALSORT:String   = "actualSort";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param sequenceNumber The number of this column in the sort order sequence.
     *
     *  @param descending <code>true</code> when the column is sorted in descending order.
     *
     *  @param status <code>PROPOSEDSORT</code> if the sort is only a visual
     *  indication of the proposed sort, or <code>ACTUALSORT</code>
     *  if the sort is the actual current sort.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function ExSortInfo(sequenceNumber:int = -1, descending:Boolean = false,
                                status:String = ACTUALSORT)
    {
        this.sequenceNumber = sequenceNumber;
        this.descending     = descending;
        this.status         = status;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    // sequenceNumber
    //--------------------------------------------------------------------------

    /**
     *  The number of this column in the sort order sequence. 
     *  This number is used when sorting by multiple columns.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var sequenceNumber:int;

    //--------------------------------------------------------------------------
    // descending
    //--------------------------------------------------------------------------

    /**
     *  Contains <code>true</code> when the column is sorted in descending order,
     *  and <code>false</code> when the column is sorted in ascending order.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var descending:Boolean;

    //--------------------------------------------------------------------------
    // status
    //--------------------------------------------------------------------------

    /**
     *  Contains <code>PROPOSEDSORT</code> if the sort is only a visual
     *  indication of the proposed sort, or contains <code>ACTUALSORT</code>
     *  if the sort is the actual current sort.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var status:String;
    
} // end class ExSortInfo

} // end package kr.co.actsone.controls.advancedDataGridClasses