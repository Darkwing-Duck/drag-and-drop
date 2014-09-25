package plumkit.dragdrop
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    /**
     * @history Created on 25.09.2014, 14:31.
     * @author Sergey Smirnov
     */
    public class DragDropManager
    {
        //----------------------------------------------------------------------------------------------
        //
        //  Class constants
        //
        //----------------------------------------------------------------------------------------------

        //----------------------------------------------------------------------------------------------
        //
        //  Class variables
        //
        //----------------------------------------------------------------------------------------------

        protected var _stage:Stage;
        protected var _dragLayer:DisplayObjectContainer;
        protected var _dropTargetByDisplayObjectMap:Dictionary;
        protected var _currentDragObject:IDragObject;
        protected var _currentDropTarget:IDropTarget;

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

        public function DragDropManager(stage:Stage, dragLayer:DisplayObjectContainer)
        {
            _stage = stage;
            _dragLayer = dragLayer;
            _dropTargetByDisplayObjectMap = new Dictionary(true);

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

            var dropTarget:IDropTarget = _dropTargetByDisplayObjectMap[DisplayObject(event.currentTarget)];
            _currentDropTarget = dropTarget;
            _currentDropTarget.onDragEnter(_currentDragObject);
        }

        protected function onDropTargetMouseOut(event:MouseEvent):void
        {
            if (!isDraggingNow)
            {
                return;
            }

            var dropTarget:IDropTarget = _dropTargetByDisplayObjectMap[DisplayObject(event.currentTarget)];
            _currentDropTarget.onDragExit(_currentDragObject);
            _currentDropTarget = null;
        }

        protected function onStageMouseUp(event:MouseEvent):void
        {
            removeStageListeners();

            if (_currentDropTarget.canAccept(_currentDragObject))
            {
                acceptDrop();
            }
            else
            {
                failDrop();
            }
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

        protected function addDropTargetListeners(dropTarget:IDropTarget):void
        {
            dropTarget.displayObject.addEventListener(MouseEvent.MOUSE_OVER, onDropTargetMouseOver);
            dropTarget.displayObject.addEventListener(MouseEvent.MOUSE_OUT, onDropTargetMouseOut);
        }

        protected function removeDropTargetListeners(dropTarget:IDropTarget):void
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
            _currentDropTarget.accept(_currentDragObject);
            _currentDragObject.onDropSuccess();
        }

        protected function failDrop():void
        {
            _currentDragObject.onDropFail();
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        public function registerDropTarget(dropTarget:IDropTarget, groupId:String = "default"):void
        {
            //cache drop target by its display object
            _dropTargetByDisplayObjectMap[dropTarget.displayObject] = dropTarget;

            // add listeners to drop target
            addDropTargetListeners(dropTarget);
        }

        public function unregisterDropTarget(dropTarget:IDropTarget):void
        {
            // remove drop target listeners
            removeDropTargetListeners(dropTarget);
        }

        public function startDrag(dragObject:IDragObject, groupId:String = "default"):void
        {
            _currentDragObject = dragObject;
            _currentDragObject.onDragStart();
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
