package
{
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;

    import plumkit.dragdrop.IPKDragData;

    import plumkit.dragdrop.IPKDropTarget;

    /**
     * @history Created on 9/27/15, 12:08 PM.
     * @author Sergey Smirnov
     */
    public class DropTargetContainer extends Sprite implements IPKDropTarget
    {
        private var _color:uint;
        private var _width:int;
        private var _height:int;

        public function DropTargetContainer(color:uint, w:int, h:int)
        {
            _color = color;
            _width = w;
            _height = h;

            drawRect(_color, _width, _height);
        }

        private function drawRect(color:uint, w:int, h:int, border:Boolean = false):void
        {
            var graphics:Graphics = this.graphics;
            graphics.clear();

            if (border)
            {
                graphics.lineStyle(5, 0xFFFFFF, 1.0, true, LineScaleMode.NONE, CapsStyle.SQUARE);
            }

            graphics.beginFill(color, 1.0);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();
        }

        public function canAccept(dragData:IPKDragData):Boolean
        {
            return true;
        }

        public function accept(dragData:IPKDragData):void
        {
            dragData.dragObject.interactiveObject.x = this.width / 2;
            dragData.dragObject.interactiveObject.y = Math.random() * (this.height - 100) + 50;
            this.addChild(dragData.dragObject.interactiveObject);

            drawRect(_color, _width, _height, false);
        }

        public function onDragEnter(dragData:IPKDragData):void
        {
            drawRect(_color, _width, _height, true);
        }

        public function onDragExit(dragData:IPKDragData):void
        {
            drawRect(_color, _width, _height, false);
        }

        public function get interactiveObject():InteractiveObject
        {
            return this;
        }

        public function get groupsAccepted():Vector.<String>
        {
            return null;
        }
    }
}
