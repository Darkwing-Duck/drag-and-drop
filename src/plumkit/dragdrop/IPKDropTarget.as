package plumkit.dragdrop
{
    import flash.display.DisplayObject;

    /**
     * @history Created on 25.09.2014, 14:32.
     * @author Sergey Smirnov
     */
    public interface IPKDropTarget
    {
        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        function canAccept(dragObject:IPKDragObject):Boolean;
        function accept(dragObject:IPKDragObject):void;

        function onDragEnter(dragObject:IPKDragObject):void;
        function onDragExit(dragObject:IPKDragObject):void;

        //----------------------------------------------------------------------------------------------
        //
        //  Accessors
        //
        //----------------------------------------------------------------------------------------------

        function get displayObject():DisplayObject;
    }
}
