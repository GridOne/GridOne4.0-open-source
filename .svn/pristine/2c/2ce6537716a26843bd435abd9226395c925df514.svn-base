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

package kr.co.actsone.importcsv
{
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.events.SAEvent;
	

	public class FileManager
	{
		
		public var fr:FileReference;
		
		private var _grid:ExAdvancedDataGrid;
		public var bIgnoreHeader:Boolean=false;
		public var bTrimBottom:Boolean=true;
		public var strColumnKeyList:String = "";
		public var bCharset:Boolean = false;
		public var dateImportFormat:String="";
		
		public function FileManager(grid:ExAdvancedDataGrid)
		{
			_grid=grid;
			fr=new FileReference();

			//listen for when they select a file
			fr.addEventListener(Event.SELECT, onFileSelect);

			//listen for when then cancel out of the browse dialog
			fr.addEventListener(Event.CANCEL, onCancel);

			
		}
		
		public function importFile():void
		{
			var allTypes:Array = new Array();
			var fileFilter:FileFilter;
			if(_grid.strDefaultImportFileFilter != "" && _grid.strDefaultImportFileFilter == "csv")
			{
				fileFilter = new FileFilter("CSV File (*.csv)", "*.csv");
				allTypes.push(fileFilter);
			}
			else
				allTypes = [new FileFilter("CSV File (*.csv)", "*.csv")];
			//open a native browse dialog that filters for text files
			fr.browse(allTypes);
		}
		//File types which we want the user to open
		//private static const FILE_TYPES:Array=[new FileFilter("CSV File (*.csv)", "*.csv")];


		/************ Browse Event Handlers **************/

		//called when the user selects a file from the browse dialog
		private function onFileSelect(e:Event):void
		{
			//listen for when the file has loaded
			fr.addEventListener(Event.COMPLETE, onLoadComplete);
		
			//listen for any errors reading the file
			fr.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);

			//load the content of the file
			fr.load(); 
			
		}

		//called when the user cancels out of the browser dialog
		private function onCancel(e:Event):void
		{
//			trace("File Browse Canceled");
			fr.removeEventListener(Event.SELECT, onFileSelect);
			fr.removeEventListener(Event.CANCEL,onCancel);	
			fr=null;
		}

		/************ Select Event Handlers **************/

		//called when the file has completed loading
		private function onLoadComplete(e:Event):void
		{
			//get the data from the file as a ByteArray
			var data:ByteArray=fr.data;
			var s:String="";
			
			if(_grid.bCharset)			
				s = data.readMultiByte(data.bytesAvailable,"utf-8"); //Thuan updated on 2012 November 02
			else
				s = data.readUTFBytes(data.bytesAvailable);
			
			//call import from GridOne
			if(_grid.strImportColumnKeyList.toLowerCase() == "importall")
			{			
				_grid.importExcelData(s, "", ",", _grid.bIgnoreHeaderImport, false, _grid.bTrimBottom);
			}
			else if(_grid.strImportColumnKeyList.toLowerCase() == "importselectcolumn")
			{
				_grid.importExcelData(s, "", ",", _grid.bIgnoreHeaderImport, false, _grid.bTrimBottom);
			} 
			else if(_grid.strImportColumnKeyList.toLowerCase() == "importvisiblecolumn")
			{
				var sVisibleHeaders:String = "";
				for(var i:int=0; i<_grid.columns.length; i++)
				{
					if(_grid.columns[i].visible)
						sVisibleHeaders +=  _grid.columns[i].dataField  + ",";
				}
				
				if (sVisibleHeaders.length > 0)
					sVisibleHeaders = sVisibleHeaders.substring(0, sVisibleHeaders.length-1);
					
				_grid.importExcelData(s, sVisibleHeaders, ",", _grid.bIgnoreHeaderImport, false, _grid.bTrimBottom);				
			}
			else if(StringUtil.trim(strColumnKeyList).length==0)
			{
				_grid.importExcelData(s, "", ",", _grid.bIgnoreHeaderImport, false, _grid.bTrimBottom, _grid.dateExcelImportFormat);				
			}
			else
			{				
				_grid.importExcelData(s, _grid.strImportColumnKeyList, ",", _grid.bIgnoreHeaderImport, false, _grid.bTrimBottom, _grid.dateExcelImportFormat);	
			}
						
			//clean up the FileReference instance
			fr.removeEventListener(Event.SELECT, onFileSelect);
			fr.removeEventListener(Event.COMPLETE, onLoadComplete);
			fr.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			fr=null;
			if(_grid.eventArr.hasOwnProperty(SAEvent.IMPORT_EXCEL_COMPLETED))
			{
				var saEvent:SAEvent=new SAEvent(SAEvent.IMPORT_EXCEL_COMPLETED);
				_grid.dispatchEvent(saEvent);
			}
		}

		//called if an error occurs while loading the file contents
		private function onLoadError(e:IOErrorEvent):void
		{
//			trace("Error loading file : " + e.text);
			/*
			//clean up the FileReference instance
			fr.removeEventListener(Event.SELECT, onFileSelect);
			fr.removeEventListener(Event.COMPLETE, onLoadComplete);
			fr.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			fr=null;
			*/
		}

	}
}