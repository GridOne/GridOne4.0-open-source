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

package kr.co.actsone.utils
{
	import flash.external.ExternalInterface;


	public class LogManager
	{

		public static const FUNCTION_NAME:String="writeLog";

		public static const GRID_NAME:String="GridOne";

		public var bDebugMode:Boolean=false;

		private var _dateTime:Date;

		private var _debugType:String;

		private var _value:String;

		private var flexApp:Object=null;
		
		public static var debugStr:String="";
		
		public function LogManager(flexApp:Object=null)
		{
			this.flexApp=flexApp;
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(obj:String):void
		{
			this._value=obj;
		}

		public function get dateTime():Date
		{
			return _dateTime;
		}

		public function set dateTime(value:Date):void
		{
			this._dateTime=value;
		}

		/*************************************************************
		 * write log
		 * *******************************************************/
		public function writeLog(value:String):void
		{
			if (bDebugMode)
			{
				var startDate:Date=new Date();
				var str:String=GRID_NAME + "|" + startDate.toLocaleDateString()+" "+startDate.getMilliseconds().toString()+ "ms|" + value+"<br/>";
				debugStr=debugStr+str+"<br/>";
				ExternalInterface.call(FUNCTION_NAME, str);
			}
		}
	}
}