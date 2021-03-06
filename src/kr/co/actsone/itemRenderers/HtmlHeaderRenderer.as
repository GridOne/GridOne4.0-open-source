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

package kr.co.actsone.itemRenderers
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
	
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumnGroup;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridListData;
	import kr.co.actsone.controls.advancedDataGridClasses.ExSortInfo;
	
	import mx.controls.AdvancedDataGrid;
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

	public class HtmlHeaderRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
	{
		public var listOwner:ExAdvancedDataGrid;
		public var column:ExAdvancedDataGridColumn;
		private var _listData:ExAdvancedDataGridListData;
		private var _data:Object;
		public var toolTipSet:Boolean = false;
		
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
		
		public var strike:UIComponent = new UIComponent();
		public var _isStrikeThrough:Boolean;
		
		public function HtmlHeaderRenderer()
		{
			super();
			tabEnabled = false;
			mouseEnabled = true;
			mouseChildren = true;
			mouseFocusEnabled = true;
			
			addEventListener(ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler);
			
			this.setStyle('verticalAlign','middle');
			this.setStyle('horizontalGap',0);
		}
		
		/**************************************************************************
		 * The event handler to position the tooltip.
		 * @param event The event object.
		 * @author Duong Pham 
		 **************************************************************************/
		private function toolTipShowHandler(event:ToolTipEvent):void
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
		
		/**************************************************************************
		 * set tooltip value
		 * @param value of tool tip
		 * @author Duong Pham 
		 **************************************************************************/
		override public function set toolTip(value:String):void
		{
			super.toolTip = value;
			
			toolTipSet = value != null;
		}
		
		[Bindable("dataChange")]
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			
			invalidateProperties();
			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		[Bindable("dataChange")]
		public function get listData():BaseListData
		{
			return _listData;
		}		
		
		/**************************************************************************
		 * get datagrid and column from list data
		 * @param value of list data
		 * @author Duong Pham 
		 **************************************************************************/
		public function set listData(value:BaseListData):void
		{
			_listData = ExAdvancedDataGridListData(value);
			if (listData)
			{
				listOwner=this.listData.owner as ExAdvancedDataGrid;	
				column=listOwner.columns[this.listData.columnIndex];	
			}
			invalidateProperties();
		}
		
		/**************************************************************************
		 * Get data field of column
		 * @author Duong Pham 
		 **************************************************************************/
		public function get dataField():String
		{
			return listOwner.columns[this.listData.columnIndex].dataField;
		}
		
		/**
		 *  @private
		 */
		override public function get baselinePosition():Number
		{
			return label.baselinePosition;
		}
		
		//----------------------------------
		//  sortItemRenderer
		//----------------------------------
		
		private var _sortItemRenderer:IFactory;
		
		[Inspectable(category="Data")]
		/**
		 *  Specifies a custom sort item renderer.
		 *  By default, the AdvancedDataGridHeaderRenderer class uses 
		 *  AdvancedDataGridSortItemRenderer as the sort item renderer.
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
					sortItemRenderer = ClassFactory(listOwner.sortItemRenderer);
				
				if (sortItemRenderer)
				{
					sortItemRendererInstance = sortItemRenderer.newInstance();
					addChild( DisplayObject(sortItemRendererInstance) );
				}
				
				sortItemRendererChanged = false;
			}
			
			// Handle skin for the separator between the text and icon parts
			var oldPartsSeparatorSkinClass:Class = partsSeparatorSkinClass;
			if (!partsSeparatorSkinClass
				|| partsSeparatorSkinClass != listOwner.getStyle("headerSortSeparatorSkin"))
			{
				partsSeparatorSkinClass = listOwner.getStyle("headerSortSeparatorSkin");
			}
			if (listOwner.sortExpertMode || partsSeparatorSkinClass != oldPartsSeparatorSkinClass)
			{
				if (partsSeparatorSkin)
					removeChild(partsSeparatorSkin);
				if (!listOwner.sortExpertMode)
				{
					partsSeparatorSkin = new partsSeparatorSkinClass();
					addChild(partsSeparatorSkin);
				}
			}
			if (partsSeparatorSkin)
				partsSeparatorSkin.visible = !(_data is ExAdvancedDataGridColumnGroup);
			
			if (_data != null)
			{
				label.htmlText      = listData.label ? listData.label : " ";
				label.multiline = true;
				if( _data is ExAdvancedDataGridColumn)
					label.wordWrap = listOwner.columnHeaderWordWrap(_data as ExAdvancedDataGridColumn);
				else
					label.wordWrap = listOwner.wordWrap;
				
				if (_data is ExAdvancedDataGridColumn)
				{
					var column:ExAdvancedDataGridColumn = _data as ExAdvancedDataGridColumn;
					
					var dataTips:Boolean = listOwner.showDataTips;
					if (column.showDataTips == true)
						dataTips = true;
					if (column.showDataTips == false)
						dataTips = false;
					if (dataTips)
					{
						if (label.textWidth > label.width 
							|| column.dataTipFunction || column.dataTipField 
							|| listOwner.dataTipFunction || listOwner.dataTipField)
						{
							toolTip = column.itemToDataTip(_data);
						}
						else
						{
							toolTip = null;
						}
					}
					else if (listOwner.toolTipData !="" && column.toolTipData !="")
					{
						toolTip = listOwner.toolTipData;
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
			if (listOwner.sortExpertMode && getFieldSortInfo() == null)
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
				var lineMetrics:TextLineMetrics = measureHTMLText(label.htmlText);
				labelWidth  = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
				labelHeight = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
				w = labelWidth + horizontalGap
					+ (partsSeparatorSkin ? partsSeparatorSkin.width : 0)
					+ sortItemRendererWidth;
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
		
		protected function getFieldSortInfo():ExSortInfo
		{
			return listOwner.getFieldSortInfo(listOwner.columns[listData.columnIndex]);
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
			if (listOwner.sortExpertMode && getFieldSortInfo() == null)
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
			var lineMetrics:TextLineMetrics = measureHTMLText(label.htmlText);
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
			
			label.truncateToFit();
			
			// Calculate position of label, by default center it
			var labelX:Number;
			var headerTextAlign:String="center";
			if(data.getStyle('headerTextAlign') != undefined)
				headerTextAlign = data.getStyle('headerTextAlign');
			else if(listOwner.getStyle('headerTextAlign') != undefined)
				headerTextAlign = listOwner.getStyle('headerTextAlign');
			if (headerTextAlign == "left")
			{
				labelX = paddingLeft;
			}
			else if (headerTextAlign == "right")
			{
				labelX = unscaledWidth - paddingRight - sortItemRendererWidth
					- horizontalGap - labelWidth;
			}
			else // if (headerTextAlign == "center")
			{
				labelX = (unscaledWidth - labelWidth - paddingLeft
					- paddingRight - horizontalGap
					- sortItemRendererWidth)/2 + paddingLeft;
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
			if (sortItemRendererInstance && !listOwner.sortExpertMode
				&&  !(_data is ExAdvancedDataGridColumnGroup))
			{
				if (!partsSeparatorSkinClass)
				{
					graphics.lineStyle(1, getStyle("separatorColor") !== undefined
						? getStyle("separatorColor") : 0xCCCCCC);
					graphics.moveTo(sortItemRendererInstance.x - 1, 1);
					graphics.lineTo(sortItemRendererInstance.x - 1, unscaledHeight - 1);
				}
				else
				{
					partsSeparatorSkin.x = sortItemRendererInstance.x
						- horizontalGap - partsSeparatorSkin.width;
					partsSeparatorSkin.y = (unscaledHeight - partsSeparatorSkin.height) / 2;
				}
			}
			
			// Set text color
			var labelColor:Number;
			
			if (data && parent)
			{
				if (!enabled)
					labelColor = getStyle("disabledColor");
				else if (listOwner.isItemHighlighted(listData.uid))
					labelColor = getStyle("textRollOverColor");
				else if (listOwner.isItemSelected(listData.uid))
					labelColor = getStyle("textSelectedColor");
				else
					labelColor = getStyle("color");
				
				label.setColor(labelColor);
			}
			
			// Set background size, position, color
			drawBgColor();
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
				? AdvancedDataGrid.HEADER_TEXT_PART
				: AdvancedDataGrid.HEADER_ICON_PART;
		}
		
		public function getLabel():IUITextField
		{
			return label;
		}
		
		/**************************************************************************
		 * draw background color 
		 * @author Duong Pham
		 **************************************************************************/
		private function drawBgColor():void
		{
			var bgColor:uint;
			var _isDrawGradientBox:Boolean = false;
			var listColors:Array;
			if(data.getStyle("headerBackgroundColor") != undefined)				
				bgColor = data.getStyle("headerBackgroundColor");				
			else if (listOwner.getStyle("headerBackgroundColor") != undefined)
				bgColor = listOwner.getStyle("headerBackgroundColor");
			else
			{
				listColors = listOwner.getStyle("headerColors");
				if(listColors[0] == listColors[1])
					bgColor = listColors[0];
				else
				{
					_isDrawGradientBox = true;
				}															
			}
			var xPos:Number=0;
			var yPos:Number=0;
			if(!_isDrawGradientBox)
			{							
				background.graphics.clear();			
				background.graphics.beginFill(bgColor);						
				background.graphics.drawRect(xPos, yPos - 2, this.width, this.height + 3);	
				background.graphics.endFill();
			}
			else
			{					
				background.graphics.clear();
				var bgMatrix:Matrix=new Matrix();
				bgMatrix.createGradientBox(this.width, this.height + 4, Math.PI / 2, 0, -2);
				background.graphics.beginGradientFill(GradientType.LINEAR, listColors, [1, 1], [0, 60, 255], bgMatrix);
				background.graphics.drawRect(xPos, yPos-2, this.width, this.height+4);	
				background.graphics.endFill();
			}
			setChildIndex( DisplayObject(background), 0 );
		}
		
		/******************************************************************************************
		 * Apply color of cell
		 * @author Duong Pham
		 ******************************************************************************************/
		override public function validateNow():void
		{
			super.validateNow();
			//			applyColor(this.label,this.getStyle('color'));
			if (data && parent)
			{
				var newColor:Number;
				var colIndex:int=listData.columnIndex;
				newColor = getStyle("color");
				if(!listOwner.selectCell)
				{
					if (listOwner.isItemHighlighted(data))
					{
						newColor=listOwner.getStyle("textRollOverColor");
					}
					else if (listOwner.isItemSelected(data))
					{
						newColor=listOwner.getStyle("textSelectedColor");
					}
				}
				else
				{
					if(listOwner.isCellHighlighted(data,colIndex))
					{
						newColor=listOwner.getStyle("textRollOverColor");
					}
					else if (listOwner.isCellSelected(data,colIndex))
					{
						newColor=listOwner.getStyle("textSelectedColor");
					}
				}
				var oldColor:* = label.textColor;
				if (oldColor != newColor)
				{
					label.setColor(newColor);
					invalidateDisplayList();
				}
			}
		}
	}
}