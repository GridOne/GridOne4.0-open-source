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

package kr.co.actsone.summarybar
{
	import flash.utils.Dictionary;

	public class SummaryBar
	{
		//dataField of merged column in subtotal and summaryall if it is total
		public var colMerge : String;	
		//public var indexColMerge : int;
		public var type : String; //subtotal or total
		public var strColumnList : String;
		public var strText : String;
		public var strFunction : String;
		public var summaryBarKey : String;
		public var functionList : Dictionary;
		public var numberFormat : String;
		public var positionTotalChange : Dictionary;
		public var position:String;
		public var totalColDataField:String = "";

		public function SummaryBar()
		{
			functionList = new Dictionary();
			positionTotalChange = new Dictionary ();
		}
	}
}