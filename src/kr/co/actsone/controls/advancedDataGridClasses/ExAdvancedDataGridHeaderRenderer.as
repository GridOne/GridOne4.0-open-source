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

package kr.co.actsone.controls.advancedDataGridClasses
{
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	
	import kr.co.actsone.common.ColumnType;
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.events.SAEvent;
	
	import mx.controls.Alert;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IInvalidating;
	import mx.core.IToolTip;
	import mx.core.IUITextField;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	import mx.styles.CSSStyleDeclaration;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the <code>data</code> property changes.
	 *
	 *  <p>When you use a component as an item renderer,
	 *  the <code>data</code> property contains the data to display.
	 *  You can listen for this event and update the component
	 *  when the <code>data</code> property changes.</p>
	 * 
	 *  @eventType mx.events.FlexEvent.DATA_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  Text color of a component label.
	 *  @default 0x0B333C
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="color", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Color of the separator between the text part and icon part.
	 *  @default 0xCCCCCC
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="separatorColor", type="uint", format="Color", inherit="yes")]
	
	
	/**
	 *  Horizontal alignment of the header text.
	 *  Possible values are <code>"left"</code>, <code>"center"</code>,
	 *  and <code>"right"</code>.
	 *
	 *  @default "center"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
	
	/**
	 *  Vertical alignment of the header text.
	 *  Possible values are <code>"top"</code>, <code>"middle"</code>,
	 *  and <code>"bottom"</code>.
	 *
	 *  @default "middle"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="verticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]
	
	/** 
	 *  The ExAdvancedDataGridHeaderRenderer class defines the default header
	 *  renderer for a AdvancedDataGrid control.  
	 *  By default, the header renderer
	 *  draws the text associated with each header in the list, and an optional
	 *  sort arrow (if sorted by that column).
	 *
	 *  <p> By default, the custom header renderer uses the default 
	 *  sort item renderer defined by the ExAdvancedDataGridSortItemRenderer class. 
	 *  The sort item renderer controls the display of the 
	 *  sort icon and sort sequence number.  
	 *  You can specify a custom sort item renderer by using 
	 *  the <code>sortItemRenderer</code> property.</p>
	 *
	 *  <p>You can override the default header renderer by creating a custom
	 *  header renderer.
	 *  The only requirement for a custom header renderer is that it
	 *  must include the size of the <code>sortItemRenderer</code> 
	 *  in any size calculations performed by an override of the 
	 *  <code>measure()</code> and <code>updateDisplayList()</code> methods.</p>
	 *
	 *  <p>You can customize when the sorting gets triggered by
	 *  handling or dispatching the <code>ExAdvancedDataGridEvent.SORT</code> event.</p>
	 *
	 *  @see kr.co.actsone.controls.ExAdvancedDataGrid
	 *  @see kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridSortItemRenderer
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class ExAdvancedDataGridHeaderRenderer
		extends UIComponent
		implements IDataRenderer,
		IDropInListItemRenderer,
		IListItemRenderer
	{
		include "../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ExAdvancedDataGridHeaderRenderer()
		{
			super();
			
			// InteractiveObject variables.
			tabEnabled   = false;
			
			addEventListener(ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler);
			
			this.doubleClickEnabled=true;			
			this.setStyle('backgroundAlpha',0);
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT ,mouseOutHandler);	
			this.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickHandler);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,createCompleteHandler);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var grid:ExAdvancedDataGrid;
		
		/**
		 *  @private
		 *  The value of the unscaledWidth parameter during the most recent
		 *  call to updateDisplayList
		 */
		private var oldUnscaledWidth:Number = -1;
		
		/**
		 *  @private
		 *  header separator skin
		 */
		private var partsSeparatorSkinClass:Class;
		private var partsSeparatorSkin:DisplayObject;
		
		/**
		 *  @private
		 *  Storage for the sortItemRenderer property
		 */
		private var sortItemRendererInstance:UIComponent;
		private var sortItemRendererChanged:Boolean = false;
		
		/**
		 *  The internal UITextField that displays the text in this renderer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var label:IUITextField;
		
		/**
		 *  This background is used as a mouseShield so that the mouse clicks do not pass
		 *  through to the parent component, but all mouse events within the header area
		 *  are handled by the header itself.
		 *
		 *  Inspired by mouseShield in mx/core/Container.as and mx/skins/halo/HaloBorder.as.
		 *
		 *  @private
		 */
		protected var background:Sprite;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties: UIComponent
		//
		//--------------------------------------------------------------------------
	 
		//----------------------------------
		//  baselinePosition
		//----------------------------------
		 
		/**
		 *  @private
		 */
		override public function get baselinePosition():Number
		{
			return label.baselinePosition;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property.
		 */
		private var _data:Object;
		
		[Bindable("dataChange")]
		
		/**
		 *  The implementation of the <code>data</code> property
		 *  as defined by the IDataRenderer interface.
		 *  When set, it stores the value and invalidates the component 
		 *  to trigger a relayout of the component.
		 *
		 *  @see mx.core.IDataRenderer
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 *  @private
		 */
		public function set data(value:Object):void
		{
			if(value && value.width == 0)
				return;
			
			_data = value;
			
			invalidateProperties();
			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		//----------------------------------
		//  sortItemRenderer
		//----------------------------------
		
		private var _sortItemRenderer:IFactory;
		
		[Inspectable(category="Data")]
		/**
		 *  Specifies a custom sort item renderer.
		 *  By default, the ExAdvancedDataGridHeaderRenderer class uses 
		 *  ExAdvancedDataGridSortItemRenderer as the sort item renderer.
		 *
		 *  <p>Note that the sort item renderer controls the display of the
		 *  sort icon and sort sequence number. 
		 *  A custom header renderer must include code to display the
		 *  sort item renderer, regardless of whether it is the default or custom
		 *  sort item renderer.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get sortItemRenderer():IFactory
		{
			return _sortItemRenderer;
		}
		
		/**
		 *  @private
		 */
		public function set sortItemRenderer(value:IFactory):void
		{
			_sortItemRenderer = value;
			
			sortItemRendererChanged = true;
			invalidateSize();
			invalidateDisplayList();
			
			dispatchEvent(new Event("sortItemRendererChanged"));
		}
		
		//----------------------------------
		//  listData
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the listData property.
		 */
		private var _listData:ExAdvancedDataGridListData;
		
		[Bindable("dataChange")]
		
		/**
		 *  The implementation of the <code>listData</code> property
		 *  as defined by the IDropInListItemRenderer interface.
		 *
		 *  @see mx.controls.listClasses.IDropInListItemRenderer
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get listData():BaseListData
		{
			return _listData;
		}
		
		/**
		 *  @private
		 */
		public function set listData(value:BaseListData):void
		{
			_listData = ExAdvancedDataGridListData(value);
			if(_listData)
			{
				grid = ExAdvancedDataGrid(_listData.owner);
			}
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!label)
			{			
				label = IUITextField(createInFontContext(UITextField));
				addChild(DisplayObject(label));
			}
			
			if (!background)
			{
				background = new UIComponent();
				addChild(background);
			}
		}
		
		/**
		 *  @private
		 *  Apply the data and listData.
		 *  Create an instance of the sort item renderer if specified,
		 *  and set the text into the text field.
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (!initialized)
				label.styleName = this;
			
			if (!sortItemRendererInstance || sortItemRendererChanged)
			{
				if (!sortItemRenderer)
					sortItemRenderer = ClassFactory(grid.sortItemRenderer);
				
				if (sortItemRenderer)
				{
					sortItemRendererInstance = sortItemRenderer.newInstance();
					
					// TODO Ideally, we should be doing this, but commenting out
					// now because of Bug 204187:
					//
					// sortItemRendererInstance.owner = grid;
					
					addChild( DisplayObject(sortItemRendererInstance) );
				}
				
				sortItemRendererChanged = false;
			}
			
			// Handle skin for the separator between the text and icon parts
			var oldPartsSeparatorSkinClass:Class = partsSeparatorSkinClass;
			if (!partsSeparatorSkinClass
				|| partsSeparatorSkinClass != grid.getStyle("headerSortSeparatorSkin"))
			{
				partsSeparatorSkinClass = grid.getStyle("headerSortSeparatorSkin");
			}
			if (grid.sortExpertMode || partsSeparatorSkinClass != oldPartsSeparatorSkinClass)
			{
				if (partsSeparatorSkin)
					removeChild(partsSeparatorSkin);
				if (!grid.sortExpertMode)
				{
					partsSeparatorSkin = new partsSeparatorSkinClass();
					addChild(partsSeparatorSkin);
				}
			}
			if (partsSeparatorSkin)
				partsSeparatorSkin.visible = !(_data is ExAdvancedDataGridColumnGroup);
			
			if (_data != null)
			{
				label.text      = listData.label ? listData.label : " ";
				label.multiline = grid.variableRowHeight;
				if( _data is ExAdvancedDataGridColumn)
					label.wordWrap = grid.columnHeaderWordWrap(_data as ExAdvancedDataGridColumn);
					
					
					//             if (listData.columnIndex > -1)
					//                 label.wordWrap = grid.columnHeaderWordWrap(grid.columns[listData.columnIndex]);
				else
					label.wordWrap = grid.wordWrap;
				
				if (_data is ExAdvancedDataGridColumn)
				{
					var column:ExAdvancedDataGridColumn =
						_data as ExAdvancedDataGridColumn;
					
					var dataTips:Boolean = grid.showDataTips;
					if (column.showDataTips == true)
						dataTips = true;
					if (column.showDataTips == false)
						dataTips = false;
					if (dataTips)
					{
						if (label.textWidth > label.width 
							|| column.dataTipFunction || column.dataTipField 
							|| grid.dataTipFunction || grid.dataTipField)
						{
							toolTip = column.itemToDataTip(_data);
						}
						else
						{
							toolTip = null;
						}
					}
					else
					{
						toolTip = null;
					}
				}
			}
			else
			{
				label.text = " ";
				toolTip = null;
			}
			
			//Duong modify to apply style before validate header 
			applyStyle();
			
			if (sortItemRendererInstance is IInvalidating)
				IInvalidating(sortItemRendererInstance).invalidateProperties();
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			// Cache padding values
			var paddingLeft:int   = getStyle("paddingLeft");
			var paddingRight:int  = getStyle("paddingRight");
			var paddingTop:int    = getStyle("paddingTop");
			var paddingBottom:int = getStyle("paddingBottom");
			
			// Measure sortItemRenderer
			var sortItemRendererWidth:Number  = sortItemRendererInstance ?
				sortItemRendererInstance.getExplicitOrMeasuredWidth()  : 0;
			var sortItemRendererHeight:Number = sortItemRendererInstance ?
				sortItemRendererInstance.getExplicitOrMeasuredHeight() : 0;
			if (grid.sortExpertMode && getFieldSortInfo() == null)
			{
				sortItemRendererWidth  = 0;
				sortItemRendererHeight = 0;
			}
			
			var horizontalGap:Number = getStyle("horizontalGap");
			if (sortItemRendererWidth == 0)
				horizontalGap = 0;
			
			// Measure text
			var labelWidth:Number  = 0;
			var labelHeight:Number = 0;
			var w:Number = 0;
			var h:Number = 0;
			
			// By default, we already get the column's width
			if (!isNaN(explicitWidth))
			{
				w = explicitWidth;
				labelWidth = w - sortItemRendererWidth
					- horizontalGap
					- (partsSeparatorSkin ? partsSeparatorSkin.width + 10 : 0)
					- paddingLeft - paddingRight;
				label.width = labelWidth;
				// Inspired by mx.controls.Label#measureTextFieldBounds():
				// In order to display the text completely,
				// a TextField must be 4-5 pixels larger.
				labelHeight = label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
			}
			else
			{
				var lineMetrics:TextLineMetrics = measureText(label.text);
				labelWidth  = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
				labelHeight = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
				w = labelWidth + horizontalGap
					+ (partsSeparatorSkin ? partsSeparatorSkin.width : 0)
					+ sortItemRendererWidth
			}
			
			h = Math.max(labelHeight, sortItemRendererHeight);
			h = Math.max(h, (partsSeparatorSkin ? partsSeparatorSkin.height : 0));
			
			// Add padding
			w += paddingLeft + paddingRight;
			h += paddingTop  + paddingBottom;
			
			// Set required width and height
			measuredMinWidth  = measuredWidth  = w;
			measuredMinHeight = measuredHeight = h;
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (unscaledWidth == 0)
				return;
			
			// Cache padding values
			var paddingLeft:int   = getStyle("paddingLeft");
			var paddingRight:int  = getStyle("paddingRight");
			var paddingTop:int    = getStyle("paddingTop");
			var paddingBottom:int = getStyle("paddingBottom");
			
			// Size of sortItemRenderer
			var sortItemRendererWidth:Number  = sortItemRendererInstance ?
				sortItemRendererInstance.getExplicitOrMeasuredWidth()  : 0;
			var sortItemRendererHeight:Number = sortItemRendererInstance ?
				sortItemRendererInstance.getExplicitOrMeasuredHeight() : 0;
			if (sortItemRendererInstance)
				sortItemRendererInstance.setActualSize(sortItemRendererWidth,
					sortItemRendererHeight);
			if (grid.sortExpertMode && getFieldSortInfo() == null)
			{
				sortItemRendererWidth  = 0;
				sortItemRendererHeight = 0;
			}
			
			var horizontalGap:Number = getStyle("horizontalGap");
			if (sortItemRendererWidth == 0)
				horizontalGap = 0;
			
			// Size of label
			const MINIMUM_SIZE:TextLineMetrics = measureText("w");
			
			// Adjust to given width
			var lineMetrics:TextLineMetrics = measureText(label.text);
			var labelWidth:Number  = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
			var maxLabelWidth:int = unscaledWidth - sortItemRendererWidth
				- horizontalGap - paddingLeft - paddingRight;
			if (maxLabelWidth < 0)
				maxLabelWidth = 0; // set the max width to 0, if its < 0
			
			var truncate:Boolean = false;
			
			if (maxLabelWidth < labelWidth)
			{
				truncate = true;
				labelWidth = maxLabelWidth;
			}
			
			// Adjust to given height
			var labelHeight:Number = label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
			var maxLabelHeight:int = unscaledHeight - paddingTop - paddingBottom;
			
			if (maxLabelHeight < labelHeight)
			{
				truncate = true;
				labelHeight = maxLabelHeight;
			}
			
			// Size of label
			label.setActualSize(labelWidth, labelHeight);
			
			// truncate only if the truncate flag is set
			if (truncate && !label.multiline)
				label.truncateToFit();
			
			// Calculate position of label, by default center it
			var labelX:Number;
			var horizontalAlign:String = getStyle("horizontalAlign");
			if (horizontalAlign == "left")
			{
				labelX = paddingLeft;
			}
			else if (horizontalAlign == "right")
			{
			 
				//chheahun add for customer require set padding
				if (this.sortItemRendererInstance.visible==false )
				{
					if (grid.headerRightPadding > 15)
					{
						grid.headerRightPadding=15;
					}
					if (grid.headerRightPadding <0)
					{
						grid.headerRightPadding=0;
					}
					
					labelX = unscaledWidth - paddingRight - grid.headerRightPadding
						- horizontalGap - labelWidth  ;
					
				}
				else 
				{
					labelX = unscaledWidth  - sortItemRendererWidth - paddingRight
						- horizontalGap - labelWidth;
				}
				
			}
			else // if (horizontalAlign == "center")
			{
//				labelX = (unscaledWidth - labelWidth - paddingLeft
//					- paddingRight - horizontalGap
//					- sortItemRendererWidth)/2 + paddingLeft;
				labelX = (unscaledWidth - labelWidth)/2;
			}
			labelX = Math.max(labelX, 0);
			
			var labelY:Number;
			var verticalAlign:String = getStyle("verticalAlign");
			if (verticalAlign == "top")
			{
				labelY = paddingTop;
			}
			else if (verticalAlign == "bottom")
			{
				labelY = unscaledHeight - labelHeight - paddingBottom + 2; // 2 for gutter
			}
			else // if (verticalAlign == "middle")
			{
				labelY = (unscaledHeight - labelHeight - paddingBottom - paddingTop)/2
					+ paddingTop;
			}
			labelY = Math.max(labelY, 0);
			
			// Set positions
			label.x = Math.round(labelX);
			label.y = Math.round(labelY);
			
			if (sortItemRendererInstance)
			{
				// Calculate position of sortItemRenderer (to the right of the headerRenderer)
				var sortItemRendererX:Number = unscaledWidth
					- sortItemRendererWidth
					- paddingRight
					;
				var sortItemRendererY:Number = (unscaledHeight - sortItemRendererHeight
					- paddingTop - paddingBottom
				) / 2
					+ paddingTop;
				
				sortItemRendererInstance.x = Math.round(sortItemRendererX);
				sortItemRendererInstance.y = Math.round(sortItemRendererY);
			}
			
			// Draw the separator
			graphics.clear();
			if (sortItemRendererInstance && !grid.sortExpertMode
				&&  !(_data is ExAdvancedDataGridColumnGroup))
			{
				if (!partsSeparatorSkinClass)
				{
//					graphics.lineStyle(1, getStyle("separatorColor") !== undefined
//						? getStyle("separatorColor") : 0xCCCCCC);
//					graphics.moveTo(sortItemRendererInstance.x - 1, 1);
//					graphics.lineTo(sortItemRendererInstance.x - 1, unscaledHeight - 1);
				}
				else
				{
					partsSeparatorSkin.x = sortItemRendererInstance.x
						- horizontalGap - partsSeparatorSkin.width;
					partsSeparatorSkin.y = (unscaledHeight - partsSeparatorSkin.height) / 2;
				}
			}
			
			// Set text color
			setHDColor();
			
			//draw header background
			drawHDBgColor();		
			
			//draw center line in header
			drawStrikeThroughText();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/** 
		 *  Indicates if the mouse pointer was over the text part or icon part 
		 *  of the header when the mouse event occurred.
		 *
		 *  <p>This method has to be implemented in custom header renderers for sorting
		 *  to work. Note that this implicitly means you will need to display both
		 *  text (which can be displayed any way the custom header renderer
		 *  wants; by default, Flex display text) and an icon (which is the
		 *  default or custom sort item renderer).</p>
		 *
		 *  @param event The mouse event.
		 *
		 *  @return <code>AdvancedDataGrid.HEADERTEXTPART</code> if the mouse was over the header text, 
		 *  and <code>AdvancedDataGrid.HEADERICONPART</code> if the mouse was over the header icon.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function mouseEventToHeaderPart(event:MouseEvent):String
		{
			var point:Point = new Point(event.stageX, event.stageY);
			point = globalToLocal(point);
		 
			// Needs to be in sync with the logic in measure() and updateDisplayList()
			return point.x < sortItemRendererInstance.x
				? ExAdvancedDataGrid.HEADER_TEXT_PART
				: ExAdvancedDataGrid.HEADER_ICON_PART;
		}
		
		/**
		 *  Returns the sort information for this column from the ExAdvancedDataGrid control
		 *  so that the control can display the column's number in the sort sequence,
		 *  and whether the sort is ascending or descending. 
		 *  The sorting information is represented by an instance of the ExSortInfo class,
		 *  where each column in the ExAdvancedDataGrid control has an associated 
		 *  ExSortInfo instance.
		 *
		 *  @return A ExSortInfo instance.
		 *
		 *  @see kr.co.actsone.controls.advancedDataGridClasses.ExSortInfo
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function getFieldSortInfo():ExSortInfo
		{
			return grid.getFieldSortInfo(grid.columns[listData.columnIndex]);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Positions the tooltip in the header.
		 *
		 *  @param The Event object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function toolTipShowHandler(event:ToolTipEvent):void
		{
			var toolTip:IToolTip = event.toolTip;
			var xPos:int = DisplayObject(systemManager).mouseX + 11;
			var yPos:int = DisplayObject(systemManager).mouseY + 22;
			// Calculate global position of label.
			var pt:Point = new Point(xPos, yPos);
			pt = DisplayObject(systemManager).localToGlobal(pt);
			pt = DisplayObject(systemManager.getSandboxRoot()).globalToLocal(pt);           
			
			toolTip.move(pt.x, pt.y + (height - toolTip.height) / 2);
			
			var screen:Rectangle = toolTip.screen;
			var screenRight:Number = screen.x + screen.width;
			if (toolTip.x + toolTip.width > screenRight)
				toolTip.move(screenRight - toolTip.width, toolTip.y);
			
		}
		
		/**
		 *  @private
		 */
		mx_internal function getLabel():IUITextField
		{
			return label;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private var strike:UIComponent = new UIComponent();
		
		private function createCompleteHandler(event:FlexEvent):void
		{
			this.setStyle('backgroundAlpha',1);
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			if (this.data && this.listData)
			{
				var dg:ExAdvancedDataGrid=this.listData.owner as ExAdvancedDataGrid;
				/* draw header background color according to roll over color */
				var bgColor:uint = this.getStyle("rollOverColor");
				if(bgColor)
					drawHDBackgroundColorHelper(bgColor);
				
				/* on mouse over event */
				if(dg.eventArr.hasOwnProperty(SAEvent.ON_MOUSE_OVER))
				{
					var mouseOverHeader : SAEvent = new SAEvent(SAEvent.ON_MOUSE_OVER,true);
					mouseOverHeader.nRow = -1;
					if(data is ExAdvancedDataGridColumn)
						mouseOverHeader.columnKey = (data as ExAdvancedDataGridColumn).dataField;
					else if (data is ExAdvancedDataGridColumnGroup)
						mouseOverHeader.columnKey = (data as ExAdvancedDataGridColumnGroup)._dataFieldGroupCol;
					dg.dispatchEvent(mouseOverHeader);
				}
				
			}
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			graphics.clear();
			var dg:ExAdvancedDataGrid=this.listData.owner as ExAdvancedDataGrid;
			if(dg.eventArr.hasOwnProperty(SAEvent.ON_MOUSE_OUT))
			{
				var mouseOutHeader : SAEvent = new SAEvent(SAEvent.ON_MOUSE_OUT,true);
				mouseOutHeader.nRow = -1;			
				if (this.data && this.listData)
				{
					if(data is ExAdvancedDataGridColumn)
						mouseOutHeader.columnKey = (data as ExAdvancedDataGridColumn).dataField;
					else if (data is ExAdvancedDataGridColumnGroup)
						mouseOutHeader.columnKey = (data as ExAdvancedDataGridColumnGroup)._dataFieldGroupCol;				
					dg.dispatchEvent(mouseOutHeader);
				}
			}
			
			/* draw header background color when mouse run out of header */
			drawHDBgColor();
		}
		
		private function doubleClickHandler(event:MouseEvent):void
		{
			if(data is ExAdvancedDataGridColumn)
			{
				var dg:ExAdvancedDataGrid=this.listData.owner as ExAdvancedDataGrid;
				if (data.type == ColumnType.CHECKBOX && dg.bHDDblClickAction)
				{
					var bValue:Boolean = !data.isSelectedCheckboxAll;
					dg.setHeaderCheckBoxValue(ExAdvancedDataGridColumn(data), bValue);
				}
			}
		}
		
		private function setHDColor():void
		{
			// Set text color
			var labelColor:Number;
			
			if (data && parent)
			{
				if (!enabled)
					labelColor = getStyle("disabledColor");
				else if (grid.isItemHighlighted(listData.uid))
					labelColor = getStyle("textRollOverColor");
				else if (grid.isItemSelected(listData.uid))
					labelColor = getStyle("textSelectedColor");
				else
				{
					labelColor = getStyle("color");
					var sName:String = "." + grid.getStyle("headerStyleName");					
					var myHeaderStyles:CSSStyleDeclaration = grid.styleManager.getStyleDeclaration(sName);
					if(data.getStyle('headerColor') != undefined)
						labelColor = data.getStyle('headerColor');
					else if(grid.getStyle('headerColor') != undefined)
						labelColor = grid.getStyle('headerColor');
					else if((myHeaderStyles is CSSStyleDeclaration) && myHeaderStyles.getStyle("color") != undefined)							
						labelColor = myHeaderStyles.getStyle("color");
				}			
				label.setColor(labelColor);
			}
		}
		
		private function applyStyle():void
		{
			if(this.data && this.listData)
			{
				var sName:String = "." + grid.getStyle("headerStyleName");					
				var myHeaderStyles:CSSStyleDeclaration = grid.styleManager.getStyleDeclaration(sName);
				var headerTextAlign:String = this.getStyle('textAlign');
				if(data.getStyle('headerTextAlign') != undefined)
					headerTextAlign = data.getStyle('headerTextAlign');
				else if(grid.getStyle('headerTextAlign') != undefined)
					headerTextAlign = grid.getStyle('headerTextAlign');
				else if((myHeaderStyles is CSSStyleDeclaration) && myHeaderStyles.getStyle("textAlign") != undefined)							
					headerTextAlign = myHeaderStyles.getStyle("textAlign");
				var oldTextAlign:* = this.getStyle('horizontalAlign');
				if(headerTextAlign != oldTextAlign)
				{
					this.setStyle('horizontalAlign',headerTextAlign);
					invalidateDisplayList();
				}
				/* apply style for grid first */
				if (myHeaderStyles is CSSStyleDeclaration)
				{
					label.styleName = myHeaderStyles;
				}
			}
		}
		
		private function drawHDBgColor():void
		{
			var bgColor:uint;		
			if(data == null || grid == null)
				return;
			if(data.getStyle("headerBackgroundColor") != undefined)
				bgColor = data.getStyle("headerBackgroundColor");
			else if (grid.getStyle("headerBackgroundColor") != undefined)
				bgColor = grid.getStyle("headerBackgroundColor");				
			if(bgColor)
			{
				//Remove separator in case set headerBackgroundColor
				if(data.width == 0)
				{
					this.graphics.clear();
					if(grid.getStyle("headerColors") != null)
						this.clearStyle('headerColors');
				}
				else
					drawHDBackgroundColorHelper(bgColor);
			}
			else if(grid.getStyle('headerColors') != undefined)
			{
				// Set background size, position, color
				if (background)
				{
					var colors:Array=grid.getStyle('headerColors');	
					background.graphics.clear();
					var bgMatrix:Matrix=new Matrix();
					bgMatrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
					background.graphics.beginGradientFill(GradientType.LINEAR, colors, [1, 1], [0, 60, 255], bgMatrix);
					background.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
					background.graphics.endFill();
				}
			}
		}
		
		private function drawHDBackgroundColorHelper(sColor:uint):void
		{			
			// Set background size, position, color
			if (background)
			{
				background.graphics.clear();
				background.graphics.beginFill(sColor, this.getStyle('backgroundAlpha')); // transparent
				background.graphics.drawRect(0, -2, unscaledWidth, unscaledHeight + 3);
				background.graphics.endFill();
				setChildIndex( DisplayObject(background), 0 );
			}
		}
		
		//		private var sortItemRendererInstance:UIComponent;
		
		private function drawStrikeThroughText():void
		{
			this.strike.graphics.clear();
			if(this.data && this.listData)
			{
				if(grid.bHDFontCLine && data.bHDFontCLine) 
				{                             
					if(!strike.parent)
						this.addChild(strike);
					//this.strike.graphics.moveTo(textField.x, textField.y);
					this.strike.graphics.lineStyle(1, this.getStyle("color"), 1);
					
					var y:int = 0;
					for(var i:int = 0; i < this.label.numLines; i++) {
						var metrics:TextLineMetrics = this.label.getLineMetrics(i);
						if(i == 0) {
							y += (label.y + (metrics.ascent*0.66)+2);
						}
						else {
							y += metrics.height;
						}	                       
						
						var xx:Number = 0; 
						var align:String = this.getStyle("horizontalAlign");
						var sortInfo:ExSortInfo = getFieldSortInfo();
						if( align =="center")
						{
							if(sortInfo)
								xx = this.width/2 - metrics.width/2 - sortItemRendererInstance.width/2 + 2;  	//remove sort width 22/2 = 11
							else
								xx = this.width/2 - metrics.width/2;
						}
							
						else if(align =="left")
						{
							xx = label.x;
						}
						else
						{
							if(sortInfo)
								xx = this.width - metrics.width - sortItemRendererInstance.width + 4; //Thuan update - 22 on 2012 October 19
							else
								xx = this.width - metrics.width - 4; 
						}
						
						this.strike.graphics.moveTo(xx, y);                      
						this.strike.graphics.lineTo(xx+metrics.width, y);						
					}
				}
			}
		}
		
	} // end class
	
} // end package