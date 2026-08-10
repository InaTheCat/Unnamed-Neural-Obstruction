package states.editors.charter;

class Note extends FlxSprite {
    public var dir:Int = 0;

    public var sustainLength:Float = 0;

    public var hasSustain:Bool = false;
    public var isPlayer:Bool = false;

    public function new(x:Float = 0, y:Float = 0, dir:Int = 0, hasSustain:Bool = false, sustainLength:Float = 0, isPlayer:Bool = false) {
        super(x, y);

        if (dir < 0 || dir >= 4)
            dir = dir % 4;

        if (hasSustain){
            this.sustainLength = sustainLength;
            this.hasSustain = hasSustain;
        }

        this.dir = dir;
        this.isPlayer = isPlayer;

        loadGraphic(Paths.image('editors/charter/note'));

        scale.set(0.7, 0.7);
        updateHitbox();

        setPosition(x ?? 0, y ?? 0);

        if (isPlayer)
            this.x += 500;

        switch(dir){
            case 0:
                color = 0xFFC24B99;
                angle = -90;
    
            case 1:
                color = 0xFF00FFFF;
                angle = -180;
    
            case 2:
                color = 0xFF12FA05;
        
            case 3:
                color = 0xFFF9393F;
                angle = 90;

            default:
                Logs.send('ion know how tf u did to skip the dir check, but well,\nnow u have a white note pointing up, ig', {type: 'Error'});
        }
    }
}