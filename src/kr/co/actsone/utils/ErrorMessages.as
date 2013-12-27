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
	import kr.co.actsone.common.Global;
	public class ErrorMessages
	{				
		public static const ERROR_TREE_IS_PARENT_CHILD_KEY:Object = {EN:"The relation Parent/Child is existed",KR:"The relation Parent/Child is existed"};

		public static const ERROR_TREE_EXISTED_KEY:Object = {EN:"Key is existed",KR:"Key is existed"};

		public static const ERROR_ROWINDEX_INVALID:Object = {EN:"Invalid row index",KR:"Invalid row index."};
		
		public static const ERROR_COLKEY_INVALID:Object = {EN:"Invalid column key",KR:"해당 컬럼이 존재하지 않습니다."};
		
		public static const ERROR_ACTIVATION_COLKEY_INVALID:Object = {EN:"The merged column can not be set activation",KR:"병합된 컬럼은 activation을 설정할수 없습니다."};
		
		public static const ERROR_TEXT:Object = {EN:"Text's length is too large",KR:"텍스트의 길이가 깁니다."};
		 
		public static const ERROR_CHECKBOX:Object = {EN:"Wrong type value, just accept values: true|false|1|0",KR:"잘못된 타입값입니다. true|false|1|0으로만 설정가능합니다."};
		
		public static const ERROR_COMBOBOX:Object = {EN:"Wrong data, check data in combo list",KR:"잘못된 데이터입니다. 콤보박스 리스트 데이터를 다시 확인해주세요."};
		
		public static const ERROR_DATE:Object = {EN:"Wrong data type entered, be sure value is a date type",KR:"잘못된 데이터입니다. 날짜 형식의 데이터만 가능합니다."};
		
		public static const ERROR_NUMBER:Object = {EN:"Wrong data type entered, be sure value is a number type",KR:"잘못된 데이터입니다. 숫자 데이터만 가능합니다."};
		
		public static const ERROR_COLKEY_ROWINDEX_COLINDEX:Object = {EN: "Invalid data; ColumnKey: %s; Row: %s; Column: %s",KR:"데이터가 유효하지 않습니다. 컬럼키: %s; 로우: %s; 컬럼: %s"};
				
		public static const ERROR_DATAPROVIDER_NULL:Object = {EN:"Data inside datagrid is null",KR:"그리드에 데이터가 없습니다."};
		
		public static const ERROR_ACTIVATION_INVALID:Object = {EN:"Wrong data, check these values in activation",KR:"잘못된 데이터입니다. activation 설정값을 다시 확인해주세요."};
		
		public static const ERROR_INDEX_INVALID:Object = {EN:"Invalid index value",KR:"잘못된 인덱스값입니다."};
		
		public static const ERROR_CHECKBOX_COLUMN_TYPE:Object = {EN:"Wrong column,be sure value is checkbox type",KR:"체크박스 타입이 아닙니다."};
		
		public static const ERROR_WRONG_ACTIVATION_TYPE:Object = {EN:"Wrong type activation",KR:"잘못된 activation 타입입니다."};
		
		public static const ERROR_NO_SUMMARY_BAR:Object = {EN:"No summary bar",KR:"summary bar가 없습니다."};
		
		public static const ERROR_INVALID_INPUT_DATA:Object = {EN:"Invalid input data",KR:"잘못된 데이터가 설정되었습니다."};				
		
		public static const ERROR_NEXT_NODE_NOT_EXIST:Object = {EN:"Next Node is not exist",KR:"다음 노드가 존재하지 않습니다."};
		
		public static const ERROR_NODE_NOT_EXIST:Object = {EN:"Node is not exist",KR:"노드가 존재하지 않습니다."};
				
		public static const ERROR_DELIMETER_INVALID:Object = {EN:"The delimiter is invalid at Row: %s",KR:"구분자가 유효하지 않습니다."};
		
		public static const ERROR_DELIMETER_INVALID_ROWINDEX:Object = {EN:"The delimiter is invalid at Row: %s",KR:"구분자가 유효하지 않습니다. 로우: %s"};
		
		public static const ERROR_CAN_NOT_MOVED : Object = {EN:"Can not move node",KR:"노드를 이동할 수 없습니다."};
		
		public static const ERROR_CAN_NOT_MERGE : Object = {EN:"Can not merge this column",KR:"컬럼을 병합 할 수 없습니다."};
		
		public static const ERROR_SUMMARY_BAR_NOT_EXIST:Object = {EN:"This summary bar is not exist",KR:"summary bar 가 존재하지 않습니다."};
		
		public static const ERROR_SUMMARY_BAR_HAS_EXIST:Object = {EN:"This summary bar has been exist",KR:"summary bar가 이미 존재합니다."};
		
		public static const ERROR_SUMMARY_VALUE_NOT_EXIST:Object = {EN:"This summary value is not exist",KR:"summary 값이 존재하지 않습니다."};
		
		public static const ERROR_WRONG_COLUMN_TYPE: Object = {EN:"Column type is wrong",KR:"컬럼 타입을 다시 확인해 주세요."};

		public static const ERROR_SUMMARY_BAR_TEXT: Object = {EN:"Can not set text for summary all",KR:"summary all에 텍스트를 설정 할 수 없습니다."};
		
		public static const ERROR_SUMMARY_BAR_FUNCTION: Object = {EN:"Can not set function for summary bar",KR:"summary bar function을 설정 할 수 없습니다."};
		
		public static const ERROR_SUMMARY_BAR_VALUE: Object = {EN:"Can not set value for summary bar",KR:"summary bar 에 값을 설정 할 수 없습니다."};
		
		public static const ERROR_INVALID_SUMMARY_BAR_FUNCTION: Object = {EN:"Invalid summary bar function",KR:"summary bar function이 유효하지 않습니다."};
		
		public static const ERROR_MERGE_INVALID:Object = {EN:"Invalid column merge",KR:"컬럼 병합이 유효하지 않습니다."};
		
		public static const ERROR_SUMMARY_BAR_FORMAT: Object = {EN:"Can not set format for custom summary bar",KR:"사용자 summary bar를 위한 포멧을 설정 할 수 없습니다."};
		
		public static const ERROR_SUMMARY_BAR_EXIST:Object = {EN:"Unable to clear group merge while summary bar has existed",KR:"Unable to clear group merge while summary bar has existed."};
		
		public static const ERROR_COLTYPE_INVALID:Object = {EN:"Invalid column type",KR:"컬럼 타입이 유효하지 않습니다."};
		
		public static const ERROR_SUMMARY_KEY_INVALID:Object = {EN:"Invalid summary bar key",KR:"summary bar 키가 유효하지 않습니다."};
		
		public static const ERROR_SUMMARY_BAR_INDEX_INVALID:Object = {EN:"Invalid summary bar index",KR:"summary bar 인덱스가 유효하지 않습니다."};				

		public static const ERROR_COMBO_ROWCOUNT_INVALID:Object = {EN:"Invalid combo rowcount",KR:"콤보박스에 설정할 row count가 유효하지 않습니다."};				

		public static const ERROR_COMBOBOX_COLUMN_TYPE:Object = {EN:"Wrong column,be sure value is combobox type",KR:"잘못된 데이터입니다. 콤보박스 타입이여야만 합니다."};				
		
		public static const ERROR_MENU_COLKEY_INVALID:Object = {EN:"Invalid menu item key",KR:""};
		public static const ERROR_MENU_KEY_INVALID:Object = {EN:"Invalid menu key",KR:""};
		public static const ERROR_FOOTER_INVALID:Object = {EN:"This footer is not exist",KR:""};
		
		
		public function ErrorMessages():void
		{			
		}
		
		/**************************************************************
		 * get error message language
		 * ****************************************************/
		public function getErrorMessageLang(msg:Object,lang:String):String
		{
			if(msg.hasOwnProperty(lang))
				return msg[lang];
			else
				return msg[Global.DEFAULT_LANG];
		}
		
		/**************************************************************
		 * get error language 
		 * ****************************************************/
		public function getStringErrorLang(msg:Object,lang:String,...args):String
		{
			var strTmp:String = getErrorMessageLang(msg,lang);
			var arr:Array = strTmp.split("%s");
			var result:String = "";
			if(arr.length > args.length)
			{
				for (var i:int = 0; i < args.length; i++) 
				{ 
					result += arr[i] + args[i];
				}
				result += arr[arr.length -1];
			}
			return result;
		}
		
		/**************************************************************
		 * throw error
		 * ****************************************************/
		public function throwError(errorMsg:Object,lang:String):void
		{			
			throw new Error(getErrorMessageLang(errorMsg,lang));			
		}
		
		/**************************************************************
		 * throw message error
		 * ****************************************************/
		public function throwMsgError(message:String,funcName:String):void
		{
			message = "ASFunction " + funcName + ": " + message;
			ExternalInterface.call("catchError",message);			
		}
	}
}