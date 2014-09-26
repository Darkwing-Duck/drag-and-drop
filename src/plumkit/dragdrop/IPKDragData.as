package plumkit.dragdrop
{
    import flash.display.DisplayObject;

    /**
     * @history Created on 25.09.2014, 19:11.
     * @author Sergey Smirnov
     */
    public interface IPKDragData
    {
        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        function dispose():void;

        //----------------------------------------------------------------------------------------------
        //
        //  Accessors
        //
        //----------------------------------------------------------------------------------------------

        function get dragObject():IPKDragObject;
        function get dragView():DisplayObject;
        function get groupId():String;

        function get viewOffsetX():Number;
        function set viewOffsetX(value:Number):void;

        function get viewOffsetY():Number;
        function set viewOffsetY(value:Number):void;
    }
}
