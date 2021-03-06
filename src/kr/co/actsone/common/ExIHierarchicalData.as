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
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.IHierarchicalData;
	import mx.collections.IViewCursor;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	[DefaultProperty("source")]
	public class ExIHierarchicalData extends EventDispatcher implements IHierarchicalData
	{	
		private var _source:Object;
		public function ExIHierarchicalData(){}

		public function get source():Object
		{
			return _source;
		}
		
		public function set source( value:Object ):void
		{
			_source = value;
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.RESET;
			dispatchEvent(event);
		}
		
		private var _strRootKey:String= "";
		
		public function get strRootKey():String
		{
			return _strRootKey;
		}
		
		public function set strRootKey(value:String):void
		{
			_strRootKey=value;			
		} 
		
		private var _treePIDField:String= "";
		
		public function get treePIDField():String
		{
			return _treePIDField;
		}
		
		public function set treePIDField(value:String):void
		{
			_treePIDField=value;			
		}
		
		private var _treeIDField:String= "";
		
		public function get treeIDField():String
		{
			return _treePIDField;
		}
		
		public function set treeIDField(value:String):void
		{
			_treeIDField=value;			
		}
		
		private var _treeTypeField:String= "";
		
		public function get treeTypeField():String
		{
			return _treeTypeField;
		}
		
		public function set treeTypeField(value:String):void
		{
			_treeTypeField=value;			
		}
		
		/*************************************************************
		 * can have children
		 * ***********************************************************/
		public function canHaveChildren(node:Object):Boolean
		{
			return ( node[_treeTypeField] == "parent" );
		}
		
		/*************************************************************
		 * has children
		 * ***********************************************************/
		public function hasChildren(node:Object):Boolean
		{
			var obj:Object;
			for each( obj in source )
			{
				if( obj[_treePIDField] == node[_treeIDField] )
					return true;
			}
			return false;
		}
		
		/*************************************************************
		 * get children
		 * ***********************************************************/
		//Thuan update this function: Using cursor
		public function getChildren(node:Object):Object
		{
			var parentId:String = node[_treeIDField];
			var children:Array = [];
			var cursor:IViewCursor = (source as ArrayCollection).createCursor();
			
			cursor.seek(CursorBookmark.FIRST);
			while (cursor.current)
			{
				if (cursor.current[_treePIDField] == parentId)
				{
					children.push(cursor.current);
				}
				cursor.moveNext();
			}
			return children;
		}
		
		/*************************************************************
		 * get data
		 * ***********************************************************/
		public function getData(node:Object):Object
		{
			var obj:Object;
			var prop:String;
			for each( obj in source )
			{
				for each( prop in node )
				{
					if( obj[prop] == node[prop] )
						return obj;
					else 
						break;
				}
			}
			return null;
		}
		
		/*************************************************************
		 * get parent
		 * ***********************************************************/
		public function getParent(node:Object):*
		{
			var obj:Object;
			for each( obj in source ) 
			{
				if( obj[_treeIDField] == node[_treePIDField] ) 
					return obj;
			}
			return null;
		}
		
		/*************************************************************
		 * get root
		 * ***********************************************************/
		public function getRoot():Object
		{
			var rootsArr:Array = [];
			var obj:Object;
			for each( obj in source ) 
			{
				if( obj[_treePIDField] == _strRootKey ) 
				{
					rootsArr.push( obj );
				}
			}
			return rootsArr;
		}
		
		/*************************************************************
		 * Insert a node to treecolumn
		 * @param nodes Node is inserted to treecolumn
		 * @param index Position of inserting
		 * @author Thuan
		 * ***********************************************************/
		public function insertNodeAt(node:Object, index:int):void
		{
			var cursorData:IViewCursor = (source as ArrayCollection).createCursor();
			cursorData.seek(CursorBookmark.FIRST, index);
			cursorData.insert(node);
		}
		
		/*************************************************************
		 * Insert nodes to treecolumn
		 * @param nodes Nodes is inserted to treecolumn
		 * @param index Position of inserting
		 * @author Thuan
		 * ***********************************************************/
		public function insertNodesAt(nodes:ArrayCollection, index:int):void
		{
			var cursor:IViewCursor = (source as ArrayCollection).createCursor();
			var curNodes:IViewCursor = nodes.createCursor();
			var nodesLen:int = nodes.length;
			curNodes.seek(CursorBookmark.FIRST);
			while (curNodes.current)
			{				
				cursor.seek(CursorBookmark.FIRST, index);
				cursor.insert(curNodes.current);
				index++;
				curNodes.moveNext();
			}
		}
		
		/*************************************************************
		 * Remove node in treecolumn
		 * @param nodes Nodes is removed
		 * @author Thuan
		 * ***********************************************************/
		public function removeNodes(nodes:ArrayCollection):void
		{
			var cursor:IViewCursor = (source as ArrayCollection).createCursor();
			var nodesLen:int = nodes.length;
			var index:int = 0;
			cursor.seek(CursorBookmark.FIRST);
			while (cursor.current)
			{
				for (var i:int = 0; i<nodesLen; i++)
				{
					if (cursor.current[_treeIDField] == nodes.getItemAt(i)[_treeIDField])
					{
						cursor.remove();
					}
				}
				index++;
				cursor.moveNext();
				if (cursor.afterLast)
					break;
			}
		}
	}
}