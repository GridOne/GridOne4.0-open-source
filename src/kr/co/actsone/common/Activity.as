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

package kr.co.actsone.common
{
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	
	import mx.controls.Image;
	import mx.managers.PopUpManager;
	import mx.utils.URLUtil;

	public class Activity
	{
		private var gridone:GridOne;
		public function Activity(app:Object)
		{
			gridone=app as GridOne;
		}
	
		public function get datagrid():ExAdvancedDataGrid
		{
			return gridone.datagrid;
		}	
		
		public var isModalMode:Boolean = false;
		
		[Embed(source="/assets/loading04.swf")]
		private var loadingBar:Class;
		private var clip:Image;	
		
		/*************************************************************
		 * show busy bar
		 * @author Toan Nguyen
		 * ***********************************************************/
		public function showBusyBar(text:String=""):void
		{
			var currentURL:String = "";	
			var imgPath:String = "";
			if(clip != null)
			{
				closeBusyBar();
			}
			else if(datagrid && datagrid.strLoadingbarUrl != "")
			{					
				if(gridone.loaderInfo != null)
				{			
					currentURL = gridone.loaderInfo.loaderURL;
					if(URLUtil.getPort(currentURL) == 0)
						imgPath = URLUtil.getProtocol(currentURL) + "://" + URLUtil.getServerName(currentURL) + "/" + datagrid.strLoadingbarUrl;
					else
						imgPath = URLUtil.getProtocol(currentURL) + "://" + URLUtil.getServerName(currentURL) + ":" + URLUtil.getPort(currentURL) + "/" + datagrid.strLoadingbarUrl;						
				}					
				if(clip==null)
				{
					clip=new Image();						
					clip.source=imgPath;
					PopUpManager.addPopUp(clip,gridone,true);
					PopUpManager.centerPopUp(clip);
				}	
			}
			else if(clip==null)
			{
				clip=new Image();
				clip.source=loadingBar;
				PopUpManager.addPopUp(clip,gridone,true);
				PopUpManager.centerPopUp(clip);
			}	
		}
		
		/*************************************************************
		 * close busy bar
		 * @author Toan Nguyen
		 * ***********************************************************/
		public function closeBusyBar():void
		{
			if (clip!= null)
			{
				PopUpManager.removePopUp(clip);
				clip=null;
			}				
		}
	}
}