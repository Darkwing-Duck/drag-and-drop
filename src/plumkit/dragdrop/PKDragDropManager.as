package plumkit.dragdrop
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
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

        protected var _dropTargetByInteractiveObjectMap:Dictionary;
        protected var _dropTargets:Vector.<IPKDropTarget>;

        protected var _dragLauncher:PKDragLauncher;

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
            _dragLayer.mouseEnabled = false;

            _dropTargets = new <IPKDropTarget>[];
            _dropTargetByInteractiveObjectMap = new Dictionary(true);
            _dragLauncher = new PKDragLauncher(this, _stage);
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

            var dropTarget:IPKDropTarget = _dropTargetByInteractiveObjectMap[InteractiveObject(event.currentTarget)];

            if (dropTarget.groupsAccepted && dropTarget.groupsAccepted.indexOf(_currentDragData.groupId) < 0)
            {
                return;
            }

            _currentDropTarget = dropTarget;
            _currentDropTarget.onDragEnter(_currentDragData);
        }

        protected function onDropTargetMouseOut(event:MouseEvent):void
        {
            if (!isDraggingNow)
            {
                return;
            }

            if (!_currentDropTarget)
            {
                return;
            }

            var dropTarget:IPKDropTarget = _dropTargetByInteractiveObjectMap[InteractiveObject(event.currentTarget)];

            if (dropTarget.groupsAccepted && dropTarget.groupsAccepted.indexOf(_currentDragData.groupId) < 0)
            {
                return;
            }

            _currentDropTarget.onDragExit(_currentDragData);
            _currentDropTarget = null;
        }

        protected function onStageMouseUp(event:MouseEvent):void
        {
            if (!isDraggingNow)
            {
                return;
            }

            _isDraggingNow = false;
            removeStageListeners();

            if (!_currentDropTarget || !_currentDropTarget.canAccept(_currentDragData))
            {
                failDrop();
            }
            else
            {
                acceptDrop();
            }

            reset();
        }

        protected function onStageMouseMove(event:MouseEvent):void
        {
            updateDragObjectPosition();
        }

        protected function updateDragObjectPosition():void
        {
            if (!_currentDragData.dragView)
            {
                return;
            }

            _currentDragData.dragView.x = _stage.mouseX + _currentDragData.viewOffsetX;
            _currentDragData.dragView.y = _stage.mouseY + _currentDragData.viewOffsetY;
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
            dropTarget.interactiveObject.addEventListener(MouseEvent.MOUSE_OVER, onDropTargetMouseOver);
            dropTarget.interactiveObject.addEventListener(MouseEvent.MOUSE_OUT, onDropTargetMouseOut);
        }

        protected function removeDropTargetListeners(dropTarget:IPKDropTarget):void
        {
            dropTarget.interactiveObject.removeEventListener(MouseEvent.MOUSE_OVER, onDropTargetMouseOver);
            dropTarget.interactiveObject.removeEventListener(MouseEvent.MOUSE_OUT, onDropTargetMouseOut);
        }

        protected function addStageListeners():void
        {
            _stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            _stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onStageMouseUp);
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        }

        protected function removeStageListeners():void
        {
            _stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            _stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onStageMouseUp);
            _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        }

        protected function acceptDrop():void
        {
            _currentDropTarget.accept(_currentDragData);

            finishDrag();
            _currentDragData.dragObject.onDropSuccess();
        }

        protected function failDrop():void
        {
            finishDrag();
            _currentDragData.dragObject.onDropFail();
        }

        protected function finishDrag():void
        {
            if (!_currentDragData.dragView)
            {
                return;
            }

            if (_currentDragData.dragView is InteractiveObject)
            {
                InteractiveObject(_currentDragData.dragView).mouseEnabled = true;
            }

            if (_currentDragData.dragObject != _currentDragData.dragView)
            {
                _dragLayer.removeChild(_currentDragData.dragView);
            }
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        internal function startDrag(dragData:IPKDragData):void
        {
            _currentDragData = dragData;
            _isDraggingNow = true;
            _currentDragData.dragObject.onDragStart();

            if (dragData.dragView)
            {
                if (dragData.dragView is InteractiveObject)
                {
                    InteractiveObject(dragData.dragView).mouseEnabled = false;
                }

                updateDragObjectPosition();
                _dragLayer.addChild(dragData.dragView);
            }

            addStageListeners();
        }

        public function registerDropTarget(dropTarget:IPKDropTarget):void
        {
            //cache drop target by its display object
            _dropTargetByInteractiveObjectMap[dropTarget.interactiveObject] = dropTarget;
            _dropTargets.push(dropTarget);

            // add listeners to drop target
            addDropTargetListeners(dropTarget);
        }

        public function unregisterDropTarget(dropTarget:IPKDropTarget):void
        {
            // remove drop target listeners
            removeDropTargetListeners(dropTarget);

            delete _dropTargetByInteractiveObjectMap[dropTarget.interactiveObject];

            var index:int = _dropTargets.indexOf(dropTarget);

            if (index < 0)
            {
                return;
            }

            _dropTargets.splice(index, 1);
        }

        public function unregisterAllDropTargets():void
        {
            var dropTarget:IPKDropTarget;

            while (_dropTargets.length > 0)
            {
                dropTarget = _dropTargets.shift();
                unregisterDropTarget(dropTarget);
            }
        }

        public function registerDragObject(dragObject:IPKDragObject):void
        {
            _dragLauncher.registerDragObject(dragObject);
        }

        public function unregisterDragObject(dragObject:IPKDragObject):void
        {
            _dragLauncher.unregisterDragObject(dragObject);
        }

        public function unregisterAllDragObjects():void
        {
            _dragLauncher.unregisterAll();
        }

        public function dispose():void
        {
            unregisterAllDragObjects();
            unregisterAllDropTargets();

            _dragLauncher.dispose();

            _dropTargetByInteractiveObjectMap = null;
            _dragLauncher = null;
            _dropTargets = null;
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

        public function get startDragOffset():Number
        {
            return _dragLauncher.startDragOffset;
        }

        public function set startDragOffset(value:Number):void
        {
            _dragLauncher.startDragOffset = value;
        }
    }
}
