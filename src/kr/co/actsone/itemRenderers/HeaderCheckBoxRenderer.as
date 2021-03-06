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
	import flash.utils.setTimeout;
	
	import kr.co.actsone.common.Global;
	import kr.co.actsone.controls.ExAdvancedDataGrid;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridColumn;
	import kr.co.actsone.controls.advancedDataGridClasses.ExAdvancedDataGridListData;
	import kr.co.actsone.events.SAEvent;
	
	import mx.controls.CheckBox;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	import mx.styles.CSSStyleDeclaration;
	
	use namespace mx_internal;
	
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	public class HeaderCheckBoxRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
	{
		public var listOwner:ExAdvancedDataGrid;
		private var _listData:ExAdvancedDataGridListData;
		private var _data:Object;
		public var toolTipSet:Boolean = false;
		
		public var strike:UIComponent = new UIComponent();
		public var _isStrikeThrough:Boolean;
		
		protected var cb:CheckBox;
		protected var label:UITextField;
		protected var background:Sprite;
		
		public function HeaderCheckBoxRenderer()
		{
			super();
			mouseEnabled = true;
			this.setStyle('headerTextAlign','center');
			this.setStyle('verticalAlign','middle');
			this.setStyle('horizontalGap',0);
			this.setStyle('paddingLeft',5);
			addEventListener(ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler);
			addEventListener(FlexEvent.CREATION_COMPLETE,createCompleteHandler)
		}
		
		/**************************************************************************
		 * create complete handler
		 **************************************************************************/
		private function createCompleteHandler(event:FlexEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.systemManager.addEventListener(SAEvent.UPDATE_STATE_HEADER_CHECK_BOX,updateStateHeaderCheckboxHandler);
		}
		
		/**************************************************************************
		 * update state header check box handler
		 **************************************************************************/
		protected function updateStateHeaderCheckboxHandler(saEvent:SAEvent):void
		{
			if(saEvent.data && saEvent.data["isCheckedAll"] != cb.selected && saEvent.columnKey == dataField)
			{
				cb.selected = saEvent.data["isCheckedAll"];
			}
		}
		
		/**************************************************************************
		 * mouse over handler
		 **************************************************************************/
		protected function mouseOverHandler(event:MouseEvent):void
		{
			this.cb.setFocus();
		}
		
		/**************************************************************************
		 * mouse down handler
		 **************************************************************************/
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if(event.target is UITextField)
			{
				this.cb.selected=!this.cb.selected;
				selectThis(event);
			}
		}
		
		/**************************************************************************
		 * create children
		 **************************************************************************/
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!cb)
			{
				cb = new CheckBox();
				cb.addEventListener(Event.CHANGE,selectedChangeHandler);
				this.cb.styleName = this;
				addChild(DisplayObject(cb));
			}
			if (!label)
			{
				label = UITextField(createInFontContext(UITextField));
				label.styleName = this;
				addChild(DisplayObject(label));				
			}
			if (!background)
			{
				background = new UIComponent();
				addChild(background);
			}
		}
		
		/**************************************************************************
		 * selected change handler
		 **************************************************************************/
		protected function selectedChangeHandler(event:Event):void
		{
			if (_listData != null && data != null)
			{
				var i:int;
				var item:Object;
				var dgEditable:Boolean=listOwner.editable == "" ? false : true;
				if (listOwner.dataProvider == null)
					return;
				
				if (listOwner.strCellClickAction == Global.ROWSELECT || data.cellActivation!= Global.EDIT)
				{
					cb.selected=!cb.selected;
				}
				else
				{ 									
					data.isSelectedCheckboxAll=cb.selected;		
					var headerEvent:SAEvent = new SAEvent(SAEvent.ON_HEADER_CLICK,true);
					headerEvent.columnKey = this.dataField;
					this.listOwner.dispatchEvent(headerEvent);
					
					var strNewValue:String = "";
					if (!(listOwner.columns[this.listOwner.dataFieldIndex[this.dataField]] as ExAdvancedDataGridColumn).isSelectSingleCheckbox)
					{
						var changeEvent:SAEvent;
						if(listOwner.crudMode)
						{
							for (i=0; i < listOwner.getLength(); i++)
							{								
								item=listOwner.getItemAt(i);	
								if(data.bChangeCellEvent)
								{
									strNewValue = cb.selected ? "1" : "0";							
									if(item[(data as ExAdvancedDataGridColumn).dataField].toString() != strNewValue)
									{
										changeEvent = new SAEvent(SAEvent.ON_CELL_CHANGE,true);
										changeEvent.columnKey = this.dataField;
										changeEvent.nRow = i;
										changeEvent.strOldValue = item[(data as ExAdvancedDataGridColumn).dataField];										
										changeEvent.strNewValue = strNewValue;	
										this.listOwner.dispatchEvent(changeEvent);
									}
								}
								item[(data as ExAdvancedDataGridColumn).dataField]=cb.selected ? "1" : "0";									
								if(item[listOwner.crudColumnKey]!=listOwner.strInsertRowText)
								{
									item[listOwner.crudColumnKey]=listOwner.strUpdateRowText;
									item[listOwner.crudColumnKey + Global.CRUD_KEY]=Global.CRUD_UPDATE;
								}
							}
						}
						else
						{ 
							for (i=0; i < listOwner.getLength(); i++)
							{								
								item=listOwner.getItemAt(i);
								if(data.bChangeCellEvent)
								{
									strNewValue = cb.selected ? "1" : "0";							
									if(item[(data as ExAdvancedDataGridColumn).dataField].toString() != strNewValue)
									{
										changeEvent= new SAEvent(SAEvent.ON_CELL_CHANGE,true);
										changeEvent.columnKey = this.dataField;
										changeEvent.nRow = i;
										changeEvent.strOldValue = item[(data as ExAdvancedDataGridColumn).dataField];										
										changeEvent.strNewValue = strNewValue;	
										this.listOwner.dispatchEvent(changeEvent);
									}
								}
								item[(data as ExAdvancedDataGridColumn).dataField]=cb.selected ? "1" : "0";
							}
						}
						
						if (cb.selected)
						{
							listOwner.columns[this.listOwner.dataFieldIndex[this.dataField]].arrSelectedCheckbox.removeAll();
							for (var m:int=0; m < listOwner.getLength(); m++)
							{
								var temp:Object=listOwner.getItemAt(m);
								listOwner.columns[this.listOwner.dataFieldIndex[this.dataField]].arrSelectedCheckbox.addItem(temp);
							}
						}
						else
							listOwner.columns[this.listOwner.dataFieldIndex[this.dataField]].arrSelectedCheckbox.removeAll();
						listOwner.dataProvider.refresh();
					}
					var saEvent:SAEvent=new SAEvent(SAEvent.ON_HD_CHECKBOX_CLICK);
					saEvent.columnKey = this.dataField;	
					saEvent.strNewValue=cb.selected;
					setTimeout(dispatchOnHDCheckBoxClickEvent,500,saEvent);
					this.cb.setFocus();
				}
			}
		}
		
		[Bindable("dataChange")]
		public function get data():Object
		{
			return _data;
		}
		
		/**************************************************************************
		 * set data
		 **************************************************************************/
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
				//				column=listOwner.columns[this.listData.columnIndex];	
			}
			invalidateProperties();
		}
		
		/**************************************************************************
		 * Get data field of column
		 * @author Duong Pham 
		 **************************************************************************/
		public function get dataField():String
		{
			return data.dataField;
		}
		
		/**************************************************************************
		 * The event handler to position the tooltip.
		 * @param event The event object.
		 * @author Duong Pham 
		 **************************************************************************/
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
		
		/**************************************************************************
		 * Get information of column such as: Header text and column type
		 * @param object need to be drawn strike through text
		 * @author Duong Pham 
		 **************************************************************************/
		private function drawStrikeThrough():void
		{
			if (listOwner.bHDFontCLine && data.bHDFontCLine && this.label.text != "" && this.label)
			{
				if(!strike.parent)
					this.addChild(strike);
				this.strike.graphics.clear();
				this.strike.graphics.moveTo(0, 0);
				this.strike.graphics.lineStyle(1, this.getStyle("color"), 1);
				var align:String="center";
				if(data.getStyle('headerTextAlign') != undefined)
					align = data.getStyle('headerTextAlign');
				else if(listOwner.getStyle('headerTextAlign') != undefined)
					align = listOwner.getStyle('headerTextAlign');
				
				var paddingLeft:int   = getStyle("paddingLeft");
				var paddingRight:int  = getStyle("paddingRight");
				var paddingTop:int    = getStyle("paddingTop");
				var paddingBottom:int = getStyle("paddingBottom");
				var horizontalGap:Number = getStyle("horizontalGap");
				
				var y:int=0;
				var x:int = 0;
				if (align == "left")
				{
					x = paddingLeft + cb.width + horizontalGap;
				}
				else if (align == "right")
				{
					x = this.width - paddingRight - this.label.textWidth -1;
				}
				else // if (align == "center")
				{
					x = (this.width - this.label.textWidth - paddingLeft - paddingRight - horizontalGap - cb.width)/2 + paddingLeft + cb.width;
				}
				
				for (var i:int=0; i < this.label.numLines; i++)
				{
					var metrics:TextLineMetrics=this.label.getLineMetrics(i);
					if (i == 0)
					{
						y+=label.y + (metrics.ascent * 0.66) + 2;
					}
					else
					{
						y+=metrics.height;
					}
					
					this.strike.graphics.moveTo(x, y);
					this.strike.graphics.lineTo(x+metrics.width+1, y);
				}
			}
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
		 * update data
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(label)
			{
				if (data is ExAdvancedDataGridColumn)
				{
					this.label.text=data.headerText;
					if(this.label.text == "" || this.label.text == null)
					{
						this.label.includeInLayout = false;
						this.label.visible = false;
					}
					else
					{
						this.label.includeInLayout = true;
						this.label.visible = true;
						this.label.width=data.width-this.cb.width;
					}
					if(this.listOwner.getLength() == 0)
					{
						this.cb.selected = false;
						ExAdvancedDataGridColumn(data).isSelectedCheckboxAll = false;
					}
					else
						this.cb.selected = ExAdvancedDataGridColumn(data).isSelectedCheckboxAll;
					
					label.multiline = listOwner.variableRowHeight;
					if( data is ExAdvancedDataGridColumn)
						label.wordWrap = listOwner.columnHeaderWordWrap(data as ExAdvancedDataGridColumn);
					else
						label.wordWrap = listOwner.wordWrap;
					
					var dataTips:Boolean = listOwner.showDataTips;
					if (data.showDataTips == true)
						dataTips = true;
					if (data.showDataTips == false)
						dataTips = false;
					if (dataTips)
					{
						if (label.textWidth > label.width 
							|| data.dataTipFunction || data.dataTipField 
							|| listOwner.dataTipFunction || listOwner.dataTipField)
						{
							toolTip = data.itemToDataTip(_data);
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
				else
				{
					label.text = " ";
					toolTip = null;
				}
			}
			invalidateDisplayList();
		}
		
		/**************************************************************************
		 * measure
		 **************************************************************************/
		override protected function measure():void
		{
			super.measure();
			// Measure text
			//			var labelWidth:Number  = 0;
			//			var labelHeight:Number = 0;
			//			var h:Number = 0;
			//			var w:Number = 0;
			//			
			//			// Cache padding values
			//			var paddingLeft:int   = getStyle("paddingLeft");
			//			var paddingRight:int  = getStyle("paddingRight");
			//			var paddingTop:int    = getStyle("paddingTop");
			//			var paddingBottom:int = getStyle("paddingBottom");
			//			
			//			var horizontalGap:Number = getStyle("horizontalGap");
			//			
			//			// By default, we already get the column's width
			//			if (!isNaN(explicitWidth))
			//			{
			//				w = explicitWidth;
			//				labelWidth = w - horizontalGap - paddingLeft - paddingRight - cb.width;
			//				label.width = labelWidth;
			//				// Inspired by mx.controls.Label#measureTextFieldBounds():
			//				// In order to display the text completely,
			//				// a TextField must be 4-5 pixels larger.
			//				labelHeight = label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
			//			}
			//			else
			//			{
			//				var lineMetrics:TextLineMetrics = measureText(label.text);
			//				labelWidth  = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
			//				labelHeight = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
			//				w = labelWidth + horizontalGap + cb.width;
			//			}
			//			h = labelHeight;
			//			
			//			// Add padding
			//			w += paddingLeft + paddingRight;
			//			h += paddingTop  + paddingBottom;
			//			
			//			// Set required width and height
			//			measuredMinWidth  = measuredWidth  = w;
			//			measuredMinHeight = measuredHeight = h;
		}
		
		/******************************************************************************************
		 * Processes the properties set on the component
		 * @author Duong Pham
		 ******************************************************************************************/
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			var paddingLeft:int   = getStyle("paddingLeft");
			var paddingRight:int  = getStyle("paddingRight");
			var paddingTop:int    = getStyle("paddingTop");
			var paddingBottom:int = getStyle("paddingBottom");
			var horizontalGap:Number = getStyle("horizontalGap");
			var startx:Number = paddingLeft;
			
			var headerTextAlign:String="center";
			var cbY:Number;
			var verticalAlign:String = getStyle("verticalAlign");
			
			if(data.getStyle('headerTextAlign') != undefined)
				headerTextAlign = data.getStyle('headerTextAlign');
			else if(listOwner.getStyle('headerTextAlign') != undefined)
				headerTextAlign = listOwner.getStyle('headerTextAlign');
			
			if(this.label.visible && this.label.includeInLayout)
			{
				if (cb)
				{
					cb.x = startx;
					startx = cb.x + cb.measuredMinWidth + 2;
					cb.setActualSize(cb.measuredMinWidth, cb.measuredMinHeight);            
				}
				
				if(label)
				{
					// Size of label
					const MINIMUM_SIZE:TextLineMetrics = measureText("w");
					
					// Adjust to given width
					var lineMetrics:TextLineMetrics = measureText(label.text);
					var labelWidth:Number  = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
					var maxLabelWidth:int = unscaledWidth - horizontalGap - paddingLeft - paddingRight - cb.width;
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
				}
				
				var labelX:Number;
				if (headerTextAlign == "left")
				{
					labelX = startx + horizontalGap;
				}
				else if (headerTextAlign == "right")
				{
					labelX = unscaledWidth - paddingRight - labelWidth;
				}
				else // if (headerTextAlign == "center")
				{
					labelX = (unscaledWidth - labelWidth - paddingLeft - paddingRight - horizontalGap - cb.width)/2 + paddingLeft + cb.width;
				}
				labelX = Math.max(labelX, 0);
				
				var labelY:Number;
				if (verticalAlign == "top")
				{
					cbY = labelY = paddingTop;
				}
				else if (verticalAlign == "bottom")
				{				
					cbY = unscaledHeight - cb.height - paddingBottom + 2;
					labelY = unscaledHeight - labelHeight - paddingBottom + 2; // 2 for gutter
				}
				else // if (verticalAlign == "middle")
				{
					cbY =  (unscaledHeight - cb.height - paddingBottom - paddingTop)/2 + paddingTop;
					labelY = (unscaledHeight - labelHeight - paddingBottom - paddingTop)/2 + paddingTop;
				}
				labelY = Math.max(labelY, 0);
				
				// Set positions
				cb.y = Math.round(cbY);
				
				label.x = Math.round(labelX);
				label.y = Math.round(labelY);
			}
			else
			{
				cb.setActualSize(cb.measuredMinWidth, cb.measuredMinHeight);
				//x position
				if (headerTextAlign == "left")
				{
					cb.x = startx + horizontalGap;
				}
				else if (headerTextAlign == "right")
				{
					cb.x = unscaledWidth - paddingRight - cb.width;
				}
				else // if (headerTextAlign == "center")
				{
					cb.x = (unscaledWidth - paddingLeft - paddingRight - horizontalGap)/2 - cb.width/2;
				}
				//y position
				if (verticalAlign == "top")
				{
					cb.y = paddingTop;
				}
				else if (verticalAlign == "bottom")
				{				
					cb.y = unscaledHeight - cb.height - paddingBottom + 2;
				}
				else // if (verticalAlign == "middle")
				{
					cb.y =  (unscaledHeight - cb.height - paddingBottom - paddingTop)/2 + paddingTop;
				}
			}
			var truncated:Boolean;
			truncated = label.truncateToFit();				
			
			if (!toolTipSet)
				super.toolTip = truncated ? this.label.text : null;
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			drawBgColor();
			
			drawStrikeThrough();
			
			applyStyle();
		}
		
		/**************************************************************************
		 * apply color when roll over in item renderer
		 * @author Duong Pham
		 **************************************************************************/
		private function applyStyle():void
		{
			if (this.data && this.listData)
			{
				var headerColor:uint=0;
				if(data.getStyle('headerColor') != undefined)
					headerColor = data.getStyle('headerColor');				
				else if(listOwner.getStyle('headerColor') != undefined)
					headerColor = listOwner.getStyle('headerColor');					
				if(headerColor)
				{
					this.setStyle('color',headerColor);
				}
				else
				{
					this.setStyle('color', "0x0B333C");		//default color			
				}				
				
				var sName:String = "." + listOwner.getStyle("headerStyleName");					
				var myHeaderStyles:CSSStyleDeclaration = listOwner.styleManager.getStyleDeclaration(sName);
				if (myHeaderStyles)
				{
					if(headerColor==0 && myHeaderStyles.getStyle("color") != undefined)							
						this.setStyle("color", myHeaderStyles.getStyle("color"));
					
					if (myHeaderStyles.getStyle("borderStyle") != undefined)
						this.setStyle("borderStyle", myHeaderStyles.getStyle("borderStyle"));
					
					if (myHeaderStyles.getStyle("fontFamily") != undefined)
						this.setStyle("fontFamily", myHeaderStyles.getStyle("fontFamily"));
					
					if (myHeaderStyles.getStyle("fontWeight") != undefined)
						this.setStyle("fontWeight", myHeaderStyles.getStyle("fontWeight"));
					
					if (myHeaderStyles.getStyle("fontStyle") != undefined)
						this.setStyle("fontStyle", myHeaderStyles.getStyle("fontStyle"));
					else
						this.setStyle("fontStyle", "normal");
					
					if (myHeaderStyles.getStyle("fontSize") != undefined)
						this.setStyle("fontSize", myHeaderStyles.getStyle("fontSize"));
					
					if (myHeaderStyles.getStyle("textDecoration") != undefined)
						this.setStyle("textDecoration", myHeaderStyles.getStyle("textDecoration"));
					else
						this.setStyle("textDecoration", "none");					
				} 					
			}
		}
		
		//Accessibility:  =========================================================================================
		/**************************************************************************
		 * Get name and value of control in cell
		 * @author Thuan 
		 **************************************************************************/
		public function getAccessibilityName(defaultHeaderReader: String):String
		{
			var strReader:String = data.strAccessReaderHeaderOrigin;
			
			if (strReader && strReader.length > 0) // Parse value in strAccessReader 
			{
				if (strReader.indexOf(Global.ACCESS_READER_CONTROLTYPE) > -1)
				{
					strReader = strReader.replace(Global.ACCESS_READER_CONTROLTYPE, Global.ACCESS_READER_CHECKBOX);
					if (strReader.indexOf(Global.ACCESS_READER_HEADERTEXT) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_HEADERTEXT, this.cb.selected);
				}
				else // don't have control type in strAccessReader
				{
					if (strReader.indexOf(Global.ACCESS_READER_HEADERTEXT) > -1)
						strReader = strReader.replace(Global.ACCESS_READER_HEADERTEXT, this.cb.selected);
				}
				//trace("Label Renderer strReader != null: " + strReader);
			}
			else // make column default information
			{
				strReader = defaultHeaderReader;
				//trace("Label Renderer strReader == null: " + strReader);
			}
			return strReader;   
		}
		
		/**************************************************************************
		 * select checbox in header
		 * @author Duong Pham 
		 **************************************************************************/
		public function selectThis(event:MouseEvent):void
		{
			if (_listData != null && data != null)
			{
				var i:int;var item:Object;
				var changeEvent:SAEvent;
				var dgEditable:Boolean=listOwner.editable == "" ? false : true;
				
				if (listOwner.strCellClickAction == Global.ROWSELECT || data.cellActivation!= Global.EDIT)
				{
					cb.selected=!cb.selected;
				}
				else
				{ 									
					data.isSelectedCheckboxAll=cb.selected;		
					var headerEvent:SAEvent = new SAEvent(SAEvent.ON_HEADER_CLICK,true);
					headerEvent.columnKey = this.dataField;
					this.listOwner.dispatchEvent(headerEvent);
					
					var strNewValue:String = "";
					if (!(listOwner.columns[this.listOwner.dataFieldIndex[this.dataField]] as ExAdvancedDataGridColumn).isSelectSingleCheckbox)
					{
						if(listOwner.crudMode)
						{
							for (i=0; i < listOwner.getLength(); i++)
							{								
								item=listOwner.getItemAt(i);	
								if(data.bChangeCellEvent)
								{
									strNewValue = cb.selected ? "1" : "0";							
									if(item[(data as ExAdvancedDataGridColumn).dataField].toString() != strNewValue)
									{
										changeEvent = new SAEvent(SAEvent.ON_CELL_CHANGE,true);
										changeEvent.columnKey = this.dataField;
										changeEvent.nRow = i;
										changeEvent.strOldValue = item[(data as ExAdvancedDataGridColumn).dataField];										
										changeEvent.strNewValue = strNewValue;	
										this.listOwner.dispatchEvent(changeEvent);
									}
								}
								item[(data as ExAdvancedDataGridColumn).dataField]=cb.selected ? "1" : "0";									
								if(item[listOwner.crudColumnKey]!=listOwner.strInsertRowText)
								{
									item[listOwner.crudColumnKey]=listOwner.strUpdateRowText;
									item[listOwner.crudColumnKey + Global.CRUD_KEY]=Global.CRUD_UPDATE;
								}
							}
						}
						else
						{ 
							for (i=0; i < listOwner.getLength(); i++)
							{								
								item=listOwner.getItemAt(i);
								if(data.bChangeCellEvent)
								{
									strNewValue = cb.selected ? "1" : "0";							
									if(item[(data as ExAdvancedDataGridColumn).dataField].toString() != strNewValue)
									{
										changeEvent= new SAEvent(SAEvent.ON_CELL_CHANGE,true);
										changeEvent.columnKey = this.dataField;
										changeEvent.nRow = i;
										changeEvent.strOldValue = item[(data as ExAdvancedDataGridColumn).dataField];										
										changeEvent.strNewValue = strNewValue;	
										this.listOwner.dispatchEvent(changeEvent);
									}
								}
								item[(data as ExAdvancedDataGridColumn).dataField]=cb.selected ? "1" : "0";
							}
						}
						
						
						if (cb.selected)
						{
							listOwner.columns[this.listOwner.dataFieldIndex[this.dataField]].arrSelectedCheckbox.removeAll();
							for (var m:int=0; m < listOwner.getLength(); m++)
							{
								var temp:Object=listOwner.getItemAt(m);
								listOwner.columns[this.listOwner.dataFieldIndex[this.dataField]].arrSelectedCheckbox.addItem(temp);
							}
						}
						else
							listOwner.columns[this.listOwner.dataFieldIndex[this.dataField]].arrSelectedCheckbox.removeAll();
						listOwner.invalidateList();	
						if(listOwner.dataProvider != null)
							listOwner.dataProvider.refresh();
					}
					var saEvent:SAEvent=new SAEvent(SAEvent.ON_HD_CHECKBOX_CLICK);
					saEvent.strNewValue=cb.selected;
					saEvent.columnKey = this.dataField;						
					setTimeout(dispatchOnHDCheckBoxClickEvent,500,saEvent);
				}
			}
		}
		
		/**************************************************************************
		 * dispatch event on header checkbox click
		 * @author Duong Pham 
		 **************************************************************************/
		private function dispatchOnHDCheckBoxClickEvent(saEvent:SAEvent):void
		{				
			this.listOwner.dispatchEvent(saEvent);
		}
	}
}