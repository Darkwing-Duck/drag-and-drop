package plumkit.dragdrop
{
    import flash.display.DisplayObject;

    /**
     * @history Created on 25.09.2014, 19:15.
     * @author Sergey Smirnov
     */
    public class PKDragData implements IPKDragData
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

        protected var _dragObject:IPKDragObject;
        protected var _dragView:DisplayObject;
        protected var _groupId:String;

        protected var _viewOffsetX:Number;
        protected var _viewOffsetY:Number;

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

        public function PKDragData(dragObject:IPKDragObject, dragView:DisplayObject = null, groupId:String = "default")
        {
            _dragObject = dragObject;
            _dragView = dragView;
            _groupId = groupId;

            _viewOffsetX = 0.0;
            _viewOffsetY = 0.0;
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Event handlers
        //
        //----------------------------------------------------------------------------------------------

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

        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        public function dispose():void
        {
            _dragObject = null;
            _dragView = null;
            _groupId = null;
        }

        //----------------------------------------------------------------------------------------------
        //
        //  Accessors
        //
        //----------------------------------------------------------------------------------------------  

        public function get dragObject():IPKDragObject
        {
            return _dragObject;
        }

        public function get dragView():DisplayObject
        {
            return _dragView;
        }

        public function get groupId():String
        {
            return _groupId;
        }

        public function get viewOffsetX():Number
        {
            return _viewOffsetX;
        }

        public function set viewOffsetX(value:Number):void
        {
            _viewOffsetX = value;
        }

        public function get viewOffsetY():Number
        {
            return _viewOffsetY;
        }

        public function set viewOffsetY(value:Number):void
        {
            _viewOffsetY = value;
        }
    }
}
