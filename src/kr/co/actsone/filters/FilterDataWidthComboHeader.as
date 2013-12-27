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

package kr.co.actsone.filters
{
	import kr.co.actsone.common.IFilter;
	
	public class FilterDataWidthComboHeader extends FilterData
	{
		public function FilterDataWidthComboHeader(target:IFilter, value:Object)
		{
			super(target, value);
		}
		
		override public function apply(item:Object):Boolean
		{
			var searchString:String = this._value["selectedLabel"];
			var dataField:String = this._value["dataField"];
			var itemName:String = item[dataField].toString();
			if(this._value["selectedValue"] == "")
			{
				//if combo header has value is "" , all datas will be displayed
				return true;
			}
			else
				return itemName.indexOf(searchString) > -1;
		}
	}
}