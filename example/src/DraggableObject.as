package
{
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;

    import plumkit.dragdrop.IPKDragData;

    import plumkit.dragdrop.IPKDragObject;
    import plumkit.dragdrop.PKDragData;

    /**
     * @history Created on 9/26/15, 11:12 PM.
     * @author Sergey Smirnov
     */
    public class DraggableObject extends Sprite implements IPKDragObject
    {
        private var _dragSelf:Boolean;
        private var _color:uint;
        private var _size:int;

        public function DraggableObject(color:uint, dragSelf:Boolean)
        {
            _color = color;
            _dragSelf = dragSelf;
            _size = 40;

            drawRect(this, _color, _size);
        }

        private function drawRect(target:Sprite, color:uint, size:int, border:Boolean = false):void
        {
            var graphics:Graphics = target.graphics;
            graphics.clear();

            if (border)
            {
                graphics.lineStyle(5, 0xFF5900, 1.0, true, LineScaleMode.NONE, CapsStyle.SQUARE);
            }

            graphics.beginFill(color, 1.0);
            graphics.drawRect(-size / 2, -size / 2, size, size);
            graphics.endFill();
        }

        public function onDragStart():void
        {
            if (!_dragSelf)
            {
                drawRect(this, _color, _size, true);
            }
            else
            {
                drawRect(this, 0xFF5900, 50);
            }
        }

        public function onDropSuccess():void
        {
            resetState();
        }

        public function onDropFail():void
        {
            resetState();
        }

        private function resetState()
        {
            drawRect(this, _color, _size);
        }

        public function createDragData():IPKDragData
        {
            var dragView:Sprite;

            if (_dragSelf)
            {
                dragView = this;
            }
            else
            {
                dragView = new Sprite();
                drawRect(dragView, _color, _size);
                dragView.alpha = 0.5;
            }

            return new PKDragData(this, dragView);
        }

        public function get interactiveObject():InteractiveObject
        {
            return this;
        }
    }
}
