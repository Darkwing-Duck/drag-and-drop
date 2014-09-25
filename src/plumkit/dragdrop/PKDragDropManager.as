package plumkit.dragdrop
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    /**
     * @history Created on 25.09.2014, 14:31.
     * @author Sergey Smirnov
     */
    public class PKDragDropManager
    {
        //----------------------------------------------------------------------------------------------
        //
        //  Class constants
        //
        //----------------------------------------------------------------------------------------------

        public static const DEFAULT_GROUP_ID:String = "default";

        //----------------------------------------------------------------------------------------------
        //
        //  Class variables
        //
        //----------------------------------------------------------------------------------------------

        protected var _stage:Stage;
        protected var _dragLayer:DisplayObjectContainer;
        protected var _currentDropTarget:IPKDropTarget;
        protected var _currentDragData:IPKDragData;

        protected var _dropTargetByDisplayObjectMap:Dictionary;
        protected var _groupByDropTargetMap:Dictionary;

        //----------------------------------------------------------------------------------------------
        //
        //  Class flags
        //
        //----------------------------------------------------------------------------------------------

        protected var _isDraggingNow:Boolean;

        //----------------------------------------------------------------------------------------------
        //
        //  Constructor
        //
        //----------------------------------------------------------------------------------------------

        public function PKDragDropManager(stage:Stage, dragLayer:DisplayObjectContainer)
        {
            _stage = stage;
            _dragLayer = dragLayer;
            _dropTargetByDisplayObjectMap = new Dictionary(true);
            _groupByDropTargetMap = new Dictionary(true);

            _isDraggingNow = false;
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Event handlers
        //
        //----------------------------------------------------------------------------------------------

        protected function onDropTargetMouseOver(event:MouseEvent):void
        {
            if (!isDraggingNow)
            {
                return;
            }

            var dropTarget:IPKDropTarget = _dropTargetByDisplayObjectMap[DisplayObject(event.currentTarget)];
            var groupId:String = _groupByDropTargetMap[dropTarget];

            if (_currentDragData.groupId != groupId)
            {
                return;
            }

            _currentDropTarget = dropTarget;
            _currentDropTarget.onDragEnter(_currentDragData.dragObject);
        }

        protected function onDropTargetMouseOut(event:MouseEvent):void
        {
            if (!isDraggingNow)
            {
                return;
            }

            var dropTarget:IPKDropTarget = _dropTargetByDisplayObjectMap[DisplayObject(event.currentTarget)];
            var groupId:String = _groupByDropTargetMap[dropTarget];

            if (_currentDragData.groupId != groupId)
            {
                return;
            }

            _currentDropTarget.onDragExit(_currentDragData.dragObject);
            _currentDropTarget = null;
        }

        protected function onStageMouseUp(event:MouseEvent):void
        {
            if (!isDraggingNow)
            {
                return;
            }

            if (!_currentDropTarget)
            {
                return;
            }

            _isDraggingNow = false;
            removeStageListeners();

            if (_currentDropTarget.canAccept(_currentDragData.dragObject))
            {
                acceptDrop();
            }
            else
            {
                failDrop();
            }

            reset();
        }

        protected function reset():void
        {
            _currentDragData.dispose();

            _currentDragData = null;
            _currentDropTarget = null;
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Private Methods
        //
        //----------------------------------------------------------------------------------------------

        //----------------------------------------------------------------------------------------------
        //
        //  Protected Methods
        //
        //----------------------------------------------------------------------------------------------

        protected function addDropTargetListeners(dropTarget:IPKDropTarget):void
        {
            dropTarget.displayObject.addEventListener(MouseEvent.MOUSE_OVER, onDropTargetMouseOver);
            dropTarget.displayObject.addEventListener(MouseEvent.MOUSE_OUT, onDropTargetMouseOut);
        }

        protected function removeDropTargetListeners(dropTarget:IPKDropTarget):void
        {
            dropTarget.displayObject.removeEventListener(MouseEvent.MOUSE_OVER, onDropTargetMouseOver);
            dropTarget.displayObject.removeEventListener(MouseEvent.MOUSE_OUT, onDropTargetMouseOut);
        }

        protected function addStageListeners():void
        {
            _stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        }

        protected function removeStageListeners():void
        {
            _stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        }

        protected function acceptDrop():void
        {
            _currentDropTarget.accept(_currentDragData.dragObject);
            _currentDragData.dragObject.onDropSuccess();
        }

        protected function failDrop():void
        {
            _currentDragData.dragObject.onDropFail();
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        public function registerDropTarget(dropTarget:IPKDropTarget, groupId:String = "default"):void
        {
            //cache drop target by its display object
            _dropTargetByDisplayObjectMap[dropTarget.displayObject] = dropTarget;
            _groupByDropTargetMap[dropTarget] = groupId;

            // add listeners to drop target
            addDropTargetListeners(dropTarget);
        }

        public function unregisterDropTarget(dropTarget:IPKDropTarget):void
        {
            // remove drop target listeners
            removeDropTargetListeners(dropTarget);

            delete _dropTargetByDisplayObjectMap[dropTarget.displayObject];
            delete _groupByDropTargetMap[dropTarget];
        }

        public function startDrag(dragData:IPKDragData):void
        {
            _currentDragData = dragData;
            _isDraggingNow = true;
            _currentDragData.dragObject.onDragStart();

            addStageListeners();
        }

        public function dispose():void
        {
            _dropTargetByDisplayObjectMap = null;
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Accessors
        //
        //----------------------------------------------------------------------------------------------

        public function get isDraggingNow():Boolean
        {
            return _isDraggingNow;
        }
    }
}
