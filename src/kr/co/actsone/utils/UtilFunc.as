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
	public final class UtilFunc
	{
		static public function stringToDateTime(sDate:String):String
		{
			try
			{
				if(sDate.length==12)
					return sDate.substr(0, 4) +"/" +sDate.substr(4, 2) + "/" + sDate.substr(6, 2) + " " + sDate.substr(8, 2) + ":" + sDate.substr(10, 2) ;
				return "";
			}
			catch(err:Error)
			{
				trace(err.message);
			}
			return "";
		}
		
		/**
		 * Make thousand separator in number
		 * @author Thuan
		 */
		static public function makeThousandSeparator(sValue: String):String
		{
			if (sValue.length <= 3)
				return sValue;
			
			var valueLen: int  = sValue.length;
			var commaPosition: int = valueLen % 3;
			var sResult: String;
			
			sResult = sValue.substring(0, commaPosition);
			
			do
			{
				sResult += ",";
				sResult += sValue.substring(commaPosition, commaPosition + 3);
				commaPosition += 3;
			} while (commaPosition < valueLen);
			
			return sResult;
		}
	}
}