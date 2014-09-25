package plumkit.dragdrop
{
    import flash.display.DisplayObject;

    /**
     * @history Created on 25.09.2014, 14:35.
     * @author Sergey Smirnov
     */
    public interface IPKDragObject
    {
        //----------------------------------------------------------------------------------------------
        //
        //  Public Methods
        //
        //----------------------------------------------------------------------------------------------

        function onDragStart():void;
        function onDropSuccess():void;
        function onDropFail():void;

        //----------------------------------------------------------------------------------------------
        //
        //  Accessors
        //
        //----------------------------------------------------------------------------------------------
    }
}
