package states.editors.charter;

class Sustain extends FlxSprite {
    public function new(x:Float = 0, y:Float = 0, size:Float = 0, dir:Int = 0) {
        super(x, y);

        if (dir < 0 || dir >= 4)
            dir = dir % 4;

        makeGraphic(20, 1, 0xFFFFFFFF);

        scale.y = size ?? 1;
        updateHitbox();

        setPosition(x ?? 0, y ?? 0);

		antialiasing = Options.antialiasing ?? true;

        switch (dir % 4){
            case 0: color = 0xFFC24B99;
            case 1: color = 0xFF00FFFF;
            case 2: color = 0xFF12FA05;
            case 3: color = 0xFFF9393F;
        }
    }
}