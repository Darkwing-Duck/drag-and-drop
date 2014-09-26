package plumkit.dragdrop
{
    import flash.display.InteractiveObject;
    import flash.display.InteractiveObject;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    /**
     * @history Created on 26.09.2014, 11:24.
     * @author Sergey Smirnov
     */
    public class PKDragLauncher
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
        protected var _dragDropManager:PKDragDropManager;
        protected var _dragObjects:Vector.<IPKDragObject>;
        protected var _dragObjectByInteractiveObjectMap:Dictionary;
        protected var _mouseDownPosition:Point;
        protected var _startDragOffset:Number;
        protected var _currentInteractionObject:InteractiveObject;

        //----------------------------------------------------------------------------------------------
        //
        //  Class flags
        //
        //----------------------------------------------------------------------------------------------

        //----------------------------------------------------------------------------------------------
        //
        //  Constructor
        //
        //----------------------------------------------------------------------------------------------

        public function PKDragLauncher(dragDropManager:PKDragDropManager, stage:Stage)
        {
            _stage = stage;
            _dragDropManager = dragDropManager;
            _dragObjectByInteractiveObjectMap = new Dictionary(true);
            _dragObjects = new <IPKDragObject>[];
            _mouseDownPosition = new Point();
            _startDragOffset = 5.0;
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Event handlers
        //
        //----------------------------------------------------------------------------------------------

        protected function onDragObjectMouseDown(event:MouseEvent):void
        {
            _currentInteractionObject = InteractiveObject(event.currentTarget);

            _mouseDownPosition.x = event.stageX;
            _mouseDownPosition.y = event.stageY;

            addStageListeners();
        }

        protected function onStageMouseMove(event:MouseEvent):void
        {
            var currentOffsetX:Number = Math.abs(_mouseDownPosition.x - event.stageX);
            var currentOffsetY:Number = Math.abs(_mouseDownPosition.y - event.stageY);

            if (currentOffsetX < _startDragOffset && currentOffsetY < _startDragOffset)
            {
                return;
            }

            removeStageListeners();

            var dragObject:IPKDragObject = _dragObjectByInteractiveObjectMap[_currentInteractionObject];
            _dragDropManager.startDrag(dragObject.createDragData());
            _currentInteractionObject = null;
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

        protected function addDragObjectListeners(dragObject:IPKDragObject):void
        {
            dragObject.interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, onDragObjectMouseDown);
        }

        protected function removeDragObjectListeners(dragObject:IPKDragObject):void
        {
            dragObject.interactiveObject.removeEventListener(MouseEvent.MOUSE_DOWN, onDragObjectMouseDown);
        }

        protected function addStageListeners():void
        {
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        }

        protected function removeStageListeners():void
        {
            _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        public function registerDragObject(dragObject:IPKDragObject):void
        {
            _dragObjectByInteractiveObjectMap[dragObject.interactiveObject] = dragObject;
            _dragObjects.push(dragObject);

            addDragObjectListeners(dragObject);
        }

        public function unregisterDragObject(dragObject:IPKDragObject):void
        {
            removeDragObjectListeners(dragObject);

            delete _dragObjectByInteractiveObjectMap[dragObject.interactiveObject];

            var index:int = _dragObjects.indexOf(dragObject);

            if (index < 0)
            {
                return;
            }

            _dragObjects.splice(index, 1);
        }

        public function unregisterAll():void
        {
            var dragObject:IPKDragObject;

            while (_dragObjects.length > 0)
            {
                dragObject = _dragObjects.shift();
                unregisterDragObject(dragObject);
            }
        }

        public function dispose():void
        {
            _stage = null;
            _dragDropManager = null;
            _dragObjectByInteractiveObjectMap = null;
            _mouseDownPosition = null;
            _dragObjects = null;
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Accessors
        //
        //----------------------------------------------------------------------------------------------

        public function get startDragOffset():Number
        {
            return _startDragOffset;
        }

        public function set startDragOffset(value:Number):void
        {
            _startDragOffset = value;
        }
    }
}
