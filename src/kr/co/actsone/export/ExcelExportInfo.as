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
	public class ExcelExportInfo
	{
		private var _strPath : String;
		private var _strColumnKeyList  : String ;
		private var _bHeaderVisible : Boolean = true;
		private var _bDataFormat : Boolean = true;
		private var _bHeaderOrdering : Boolean = true;
		private var _bCharset : Boolean = true;		//support korean (ANSI): euc-kr and UTF8
		
		public function ExcelExportInfo(strPath:String,strColumnKeyList:String,bHeaderVisible:Boolean,bDataFormat:Boolean,bHeaderOrdering:Boolean,bCharset:Boolean)
		{
			_strPath = strPath;
			_strColumnKeyList = strColumnKeyList;
			_bHeaderOrdering = bHeaderOrdering;
			_bDataFormat = bDataFormat;
			_bHeaderVisible = bHeaderVisible;
			_bCharset = bCharset;
		}
		
		public function get strPath():String
		{
			return _strPath;
		}
		
		public function set strPath(value:String):void
		{
			_strPath = value;
		}
		
		public function get strColumnKeyList():String
		{
			return _strColumnKeyList;
		}
		
		public function set strColumnKeyList(value:String):void
		{
			_strColumnKeyList = value;
		}
		
		public function get bHeaderOrdering():Boolean
		{
			return _bHeaderOrdering;
		}
		
		public function set bHeaderOrdering(value:Boolean):void
		{
			_bHeaderOrdering = value;
		}
		
		public function get bDataFormat():Boolean
		{
			return _bDataFormat;
		}
		
		public function set bDataFormat(value:Boolean):void
		{
			_bDataFormat = value;
		}
		
		public function get bHeaderVisible():Boolean
		{
			return _bHeaderVisible;
		}
		
		public function set bHeaderVisible(value:Boolean):void
		{
			_bHeaderVisible = value;
		}
		
		public function get bCharset():Boolean
		{
			return _bCharset;
		}
		
		public function set bCharset(value:Boolean):void
		{
			_bCharset = value;
		}
	}
}