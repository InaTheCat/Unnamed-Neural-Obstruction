package states;

class MainMenuState extends UNOState
{
	var bg:FlxSprite;

    override public function create():Void {
        super.create();

		add(bg = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBG')));
    	bg.scrollFactor.set(0, 0.18);
    	bg.scale.set(1.15, 1.15);
    	bg.updateHitbox();
    	bg.screenCenter();
		bg.antialiasing = true;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new TitleState());
    }
}