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

package mx.skins.halo
{

import flash.display.Graphics;
import mx.skins.ProgrammaticSkin;

/**
 *  The skin for the separator between column headers in an AdvancedDataGrid control.
 *
 *  @see mx.controls.AdvancedDataGrid
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AdvancedDataGridHeaderHorizontalSeparator extends ProgrammaticSkin
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
    public function AdvancedDataGridHeaderHorizontalSeparator()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  measuredWidth
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get measuredWidth():Number
    {
        return 10;
    }
    
    //----------------------------------
    //  measuredHeight
    //----------------------------------

    /**
     *  @private
     */
    override public function get measuredHeight():Number
    {
        return 2;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function updateDisplayList(w:Number, h:Number):void
    {
        super.updateDisplayList(w, h);
        var g:Graphics = graphics;
        
        g.clear();
        
        g.moveTo(0, 0);
        g.lineTo(w, 0);
        g.lineStyle(1, getStyle("borderColor")); 
        g.moveTo(0, 1);
        g.lineTo(w, 1);
    }
}

}