package plumkit.dragdrop
{
    /**
     * @history Created on 25.09.2014, 14:32.
     * @author Sergey Smirnov
     */
    public interface IDropTarget
    {
        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        function canAccept(dragObject:IDragObject):Boolean;
        function accept(dragObject:IDragObject):void;

        function onDragEnter(dragObject:IDragObject):void;
        function onDragExit(dragObject:IDragObject):void;

        //----------------------------------------------------------------------------------------------
        //
        //  Accessors
        //
        //----------------------------------------------------------------------------------------------
    }
}
