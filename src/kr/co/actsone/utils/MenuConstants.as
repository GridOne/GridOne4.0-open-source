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
	import kr.co.actsone.common.Global;
	
	public class MenuConstants
	{
		public static const MENU_HEADER:String="MENU_HEADER";
		public static const MENU_CELL:String="MENU_CELL";
		public static const MENU_ROW_SELECTOR:String="MENU_ROWSELECTOR";
		
		///
		public static const MENUITEM_CELL_INSERT_ROW:String="MENUITEM_CELL_INSERT_ROW";
		public static const MENUITEM_CELL_DELETE_ROW:String="MENUITEM_CELL_DELETE_ROW";
		public static const MENUITEM_CELL_REMOVE_ALL:String="MENUITEM_CELL_REMOVE_ALL";
		///
		public static const MENUITEM_CELL_COPY:String="MENUITEM_CELL_COPY";
		public static const MENUITEM_CELL_PASTE:String="MENUITEM_CELL_PASTE";
		public static const MENUITEM_CELL_EXCELEXPORT:String="MENUITEM_CELL_EXCELEXPORT";
		public static const MENUITEM_CELL_FONTUP:String="MENUITEM_CELL_FONTUP";
		public static const MENUITEM_CELL_FONTDOWN:String="MENUITEM_CELL_FONTDOWN";
		public static const MENUITEM_CELL_FIND:String="MENUITEM_CELL_FIND";
		public static const MENUITEM_CELL_FIND_COLUMN:String="MENUITEM_CELL_FIND_COLUMN";
		public static const MENUITEM_HD_FIXHEADER:String="MENUITEM_HD_FIXHEADER";
		public static const MENUITEM_HD_CANCELFIXHEADER:String="MENUITEM_HD_CANCELFIXHEADER";
		public static const MENUITEM_HD_HIDEHEADER:String="MENUITEM_HD_HIDEHEADER";
		public static const MENUITEM_HD_CANCELHIDEHEADER:String="MENUITEM_HD_CANCELHIDEHEADER";
		public static const MENUITEM_ROW_COPY:String="MENUITEM_ROW_COPY";
		/*Menu names*/
		
		public static const MENU_NAME_INSERT_ROW:String="Insert row"+MENU_SPECIAL_CHARACTER;
		public static const MENU_NAME_DELETE_ROW:String="Delete row"+MENU_SPECIAL_CHARACTER;
		public static const MENU_NAME_REMOVE_ALL:String="Remove all"+MENU_SPECIAL_CHARACTER;
		
		public static const MENU_NAME_INSERT_ROW_CH:String="插排" + MENU_SPECIAL_CHARACTER;
		public static const MENU_NAME_DELETE_ROW_CH:String="删除一行"+MENU_SPECIAL_CHARACTER;
		public static const MENU_NAME_REMOVE_ALL_CH:String="删除所有"+MENU_SPECIAL_CHARACTER;
		
		public static const MENU_NAME_INSERT_ROW_KR:String="행을 삽입" + MENU_SPECIAL_CHARACTER;
		public static const MENU_NAME_DELETE_ROW_KR:String="행 삭제"+MENU_SPECIAL_CHARACTER;
		public static const MENU_NAME_REMOVE_ALL_KR:String="모두 제거"+MENU_SPECIAL_CHARACTER;
		
		public static const MENU_SPECIAL_CHARACTER:String="";			//"\u00A0";
		
		//		public static const MENU_NAME_CELL_COPY:String="Copy cell"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_CELL_PASTE:String="Paste cell"+MENU_SPECIAL_CHARACTER;
		//		
		//		public static const MENU_NAME_CELL_EXCELEXPORT:String="Export excel"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_CELL_FONTUP:String="Cell font up"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_CELL_FONTDOWN:String="Cell font down"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_CELL_FIND_COLUMN:String="Find cell in column"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_CELL_FIND:String="Find cell"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_HD_FIXHEADER:String="Lock header"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_HD_CANCELFIXHEADER:String="Unlocked headers"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_HD_HIDEHEADER:String="Hide header"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_HD_CANCELHIDEHEADER:String="Unhide headers"+MENU_SPECIAL_CHARACTER;
		//		public static const MENU_NAME_ROW_COPY:String="Copy row"+MENU_SPECIAL_CHARACTER;
		 
		
		public static var MENU_NAME_CELL_COPY:String="Copy cell"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_PASTE:String="Paste cell"+MENU_SPECIAL_CHARACTER;
		
		public static var MENU_NAME_CELL_EXCELEXPORT:String="Export excel"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FONTUP:String="Cell font up"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FONTDOWN:String="Cell font down"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FIND:String="Find cell"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FIND_COLUMN:String="Find cell in column"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_FIXHEADER:String="Lock header"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_CANCELFIXHEADER:String="Unlocked headers"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_HIDEHEADER:String="Hide header"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_CANCELHIDEHEADER:String="Unhide headers"+MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_ROW_COPY:String="Copy row"+MENU_SPECIAL_CHARACTER;
		
		public static var MENU_NAME_CELL_COPY_KR:String="셀 복사" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_PASTE_KR:String="붙여넣기" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_EXCELEXPORT_KR:String= "엑셀 파일 저장" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FONTUP_KR:String= "글자 크기 크게" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FONTDOWN_KR:String= "글자 크기 작게" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FIND_KR:String= "찾기" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FIND_COLUMN_KR:String= "열에서 찾기" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_FIXHEADER_KR:String= "컬럼 고정" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_CANCELFIXHEADER_KR:String= "컬럼 고정 해제" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_HIDEHEADER_KR:String= "숨기기" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_CANCELHIDEHEADER_KR:String= "숨기기 취소" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_ROW_COPY_KR:String="행복사" + MENU_SPECIAL_CHARACTER;
		
		
		public static var MENU_NAME_CELL_COPY_CH:String="复制单元格" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_PASTE_CH:String="粘贴单元格" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_EXCELEXPORT_CH:String= "导出Excel" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FONTUP_CH:String= "单元格字体了" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FONTDOWN_CH:String= "单元格字体下来" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FIND_CH:String= "发现细胞" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_CELL_FIND_COLUMN_CH:String= "发现在列单元格" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_FIXHEADER_CH:String= "锁头" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_CANCELFIXHEADER_CH:String= "开锁头" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_HIDEHEADER_CH:String= "隐藏标题" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_HD_CANCELHIDEHEADER_CH:String= "取消隐藏标题" + MENU_SPECIAL_CHARACTER;
		public static var MENU_NAME_ROW_COPY_CH:String="复制行" + MENU_SPECIAL_CHARACTER;
			
		public static function getMenuType(menuItemKey:String):String
		{
			if (menuItemKey.search("MENUITEM_CELL") != -1)
				return MENU_CELL;
			if (menuItemKey.search("MENUITEM_HD") != -1)
				return MENU_HEADER;
			if (menuItemKey.search("MENUITEM_ROW") != -1)
				return MENU_ROW_SELECTOR;
			return "";
		}	
	}
}