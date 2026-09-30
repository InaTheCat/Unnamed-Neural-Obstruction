package states.editors.charter.sustain;

class High extends FlxSpriteContainer {
    public var piece:FlxSprite;
    public var end:FlxSprite;
    public var size:Float = 0;

    public function new(x:Float = 0, y:Float = 0, size:Float = 0, dir:Int = 0) {
        super(x, y);

        piece = new FlxSprite();
        end = new FlxSprite();

        piece.frames = Paths.getSparrowAtlas('editors/charter/notesHD');
        end.frames = Paths.getSparrowAtlas('editors/charter/notesHD');

        switch (dir){
            case 0:
                piece.animation.addByPrefix('i', 'left piece', 0, false);
                end.animation.addByPrefix('i', 'left end', 0, false);
            case 1:
                piece.animation.addByPrefix('i', 'down piece', 0, false);
                end.animation.addByPrefix('i', 'down end', 0, false);
            case 2:
                piece.animation.addByPrefix('i', 'up piece', 0, false);
                end.animation.addByPrefix('i', 'up end', 0, false);
            case 3:
                piece.animation.addByPrefix('i', 'right piece', 0, false);
                end.animation.addByPrefix('i', 'right end', 0, false);
        }

        piece.animation.play('i');
        end.animation.play('i');

        add(piece);
        add(end);

        this.size = FlxMath.bound(size, 0);

        piece.setGraphicSize(30, FlxMath.bound(size, 0));
        piece.updateHitbox();

        end.setGraphicSize(30, 44);
        end.updateHitbox();

        end.y = piece.y + piece.height;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (end.y != piece.y + piece.height - 2.5)
            end.y = piece.y + piece.height - 2.5;

        piece.visible = end.visible = Std.int(size) != 0;
    }

    public function setLength(size:Float) {
        this.size = size;

        piece.setGraphicSize(30, FlxMath.bound(size, 0));
        piece.updateHitbox();
    }
}