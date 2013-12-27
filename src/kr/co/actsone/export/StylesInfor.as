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
	public final class StylesInfor
	{
		private var _headerRowStyles:String;
		private var _headerColumnStyles:String;
		private var _dataRowStyles:String;
		private var _dataColumnStyles:String;
		
		public function StylesInfor()
		{
			
		}
		
		public function get headerRowStyles():String
		{
			return _headerRowStyles;
		}

		public function set headerRowStyles(value:String):void
		{
			_headerRowStyles = value;
		}

		public function get headerColumnStyles():String
		{
			return _headerColumnStyles;
		}

		public function set headerColumnStyles(value:String):void
		{
			_headerColumnStyles = value;
		}

		public function get dataRowStyles():String
		{
			return _dataRowStyles;
		}

		public function set dataRowStyles(value:String):void
		{
			_dataRowStyles = value;
		}

		public function get dataColumnStyles():String
		{
			return _dataColumnStyles;
		}

		public function set dataColumnStyles(value:String):void
		{
			_dataColumnStyles = value;
		}
	}
}