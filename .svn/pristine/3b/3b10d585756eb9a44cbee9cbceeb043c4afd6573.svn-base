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

package kr.co.actsone.protocol
{	
	import kr.co.actsone.controls.ExAdvancedDataGrid;

	public class ProtocolBase implements IProtocol
	{
		private var _protocolStr:String;
		
		public static const ID:String="id";
		
		public static const TEXT:String="text";
		
		public static const PARENT:String="parent";
		
		protected var gridOne:GridOne;
		
		public function get protocolStr():String
		{
			return _protocolStr;
		}
		
		public function set protocolStr(value:String):void
		{
			this._protocolStr=value;
		}
		
		public function ProtocolBase(app:Object)
		{
			this.gridOne = app as GridOne;
		}
		
		public function decode(value:String):Object
		{
			return null;		
		}
		
		public function encode(obj:Object):String
		{
			return"";
		}	

		protected function get datagrid():ExAdvancedDataGrid
		{
			return this.gridOne.datagrid;
		}
	}
}