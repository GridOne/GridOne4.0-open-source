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

package kr.co.actsone.export
{
	public final class ColumnInfor
	{
		private var _dataFieldIndex:int;
		private var _dataField:String;
		private var _dataFieldType:String;
		private var _formatIn:String;
		private var _formatOut:String;
		private var _isMergedColumn:Boolean;
		private var _replacedStartIndex:int;
		private var _replacedLength:int;
		private var _headerText:String;
		
		public function ColumnInfor(dFieldIndex:int, dField:String, dFieldType:String, formatIn:String, formatOut:String, 
									replacedStartIndex:int, replacedLength:int,
									isMerged:Boolean,headerText:String)
		{
			_dataFieldIndex = dFieldIndex;
			_dataField = dField;
			_dataFieldType = dFieldType;
			_formatIn = formatIn;
			_formatOut = formatOut;
			_replacedStartIndex = replacedStartIndex;
			_replacedLength = replacedLength;
			_isMergedColumn = isMerged;
			_headerText = headerText;
		}

		public function get dataFieldIndex():int
		{
			return _dataFieldIndex;
		}

		public function set dataFieldIndex(value:int):void
		{
			_dataFieldIndex = value;
		}

		public function get dataField():String
		{
			return _dataField;
		}

		public function set dataField(value:String):void
		{
			_dataField = value;
		}

		public function get dataFieldType():String
		{
			return _dataFieldType;
		}

		public function set dataFieldType(value:String):void
		{
			_dataFieldType = value;
		}

		public function get formatIn():String
		{
			return _formatIn;
		}
		
		public function set formatIn(value:String):void
		{
			_formatIn = value;
		}
		
		public function get formatOut():String
		{
			return _formatOut;
		}
		
		public function set formatOut(value:String):void
		{
			_formatOut = value;
		}
		
		public function get replacedStartIndex():int
		{
			return _replacedStartIndex;
		}
		
		public function set replacedStartIndex(value:int):void
		{
			_replacedStartIndex = value;
		}
		
		public function get replacedLength():int
		{
			return _replacedLength;
		}
		
		public function set replacedLength(value:int):void
		{
			_replacedLength = value;
		}
		
		public function get isMergedColumn():Boolean
		{
			return _isMergedColumn;
		}

		public function set isMergedColumn(value:Boolean):void
		{
			_isMergedColumn = value;
		}
		
		public function set headerText(value:String):void
		{
			_headerText = value;
		}
		
		public function get headerText():String
		{
			return _headerText;
		}
	}
}