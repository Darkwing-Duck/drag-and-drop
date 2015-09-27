package
{
    import flash.display.Sprite;
    import flash.events.Event;

    import plumkit.dragdrop.PKDragDropManager;

    [SWF(backgroundColor="0x222222")]
    public class Main extends Sprite
    {
        private var _dragDropManager:PKDragDropManager;

        public function Main()
        {
            if (stage)
            {
                init();
            }
            else
            {
                this.addEventListener(Event.ADDED_TO_STAGE, onAddedToState);
            }
        }

        private function onAddedToState(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToState);
            init();
        }

        private function init():void
        {
            initDragDrop();
            initField();
        }

        private function initDragDrop():void
        {
            _dragDropManager = new PKDragDropManager(stage, this);
        }

        private function initField()
        {
            createDropContainers();
            createDraggableObjects();
        }

        private function createDropContainers():void
        {
            var dropContainer1:DropTargetContainer = new DropTargetContainer(0xA8ABFF, 150, stage.stageHeight - 20);
            dropContainer1.x = 10;
            dropContainer1.y = 10;
            this.addChild(dropContainer1);

            var dropContainer2:DropTargetContainer = new DropTargetContainer(0xFFC6A8, 150, stage.stageHeight - 20);
            dropContainer2.x = stage.stageWidth - dropContainer2.width - 10;
            dropContainer2.y = 10;
            this.addChild(dropContainer2);

            _dragDropManager.registerDropTarget(dropContainer1);
            _dragDropManager.registerDropTarget(dropContainer2);
        }

        private function createDraggableObjects():void
        {
            var blueObject:DraggableObject = new DraggableObject(0x00A6FF, true);
            blueObject.x = stage.stageWidth / 2;
            blueObject.y = 100;
            this.addChild(blueObject);

            var greenObject:DraggableObject = new DraggableObject(0x91FF00, false);
            greenObject.x = stage.stageWidth / 2;
            greenObject.y = 200;
            this.addChild(greenObject);

            _dragDropManager.registerDragObject(blueObject);
            _dragDropManager.registerDragObject(greenObject);
        }
    }
}
