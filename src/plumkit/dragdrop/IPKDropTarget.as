package plumkit.dragdrop
{
    import flash.display.InteractiveObject;

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

        function canAccept(dragData:IPKDragData):Boolean;
        function accept(dragData:IPKDragData):void;

        function onDragEnter(dragData:IPKDragData):void;
        function onDragExit(dragData:IPKDragData):void;

        //----------------------------------------------------------------------------------------------
        //
        //  Accessors
        //
        //----------------------------------------------------------------------------------------------

        function get interactiveObject():InteractiveObject;
        function get groupsAccepted():Vector.<String>;
    }
}
