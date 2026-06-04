package;

import backend.TroubleShooter;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import game.Character;
import game.Controls;
import game.HealthBar;
import game.notes.StrumLine;
import states.UNOState;
import utils.Paths;

class PlayState extends UNOState
{
	var strums:FlxTypedGroup<FlxBasic> = new FlxTypedGroup<FlxBasic>();

	var opponent:StrumLine;
	var player:StrumLine;

	var bfTimer:FlxTimer = new FlxTimer();
	var directions:Map<Int, String> = [0 => 'singLEFT', 1 => 'singDOWN', 2 => 'singUP', 3 => 'singRIGHT'];

	var bf:Character;
	var dad:Character;

	var healthBarBG:FlxSprite;
	var healthBar:HealthBar;
	var maxHealth:Float = 2;
	var health:Float = 1;

	override public function create() {
		super.create();

		// --- Test stage n char ---
		bf = new Character(850, 400, 'bf', true);
		dad = new Character(150, 50, 'dad');

		var floor:FlxSprite = new FlxSprite(-600, 600).loadGraphic(Paths.image('stages/default/floor'));
		var back:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/default/back'));
		var curtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stages/default/curtains'));

		back.scrollFactor.set(0.9, 0.9);
		curtains.scrollFactor.set(1.3, 1.3);

		for (e in [back, floor, dad, bf, curtains])
		{
			add(e);
			e.camera = camGame;
		}
		// --- HUD ---
		add(strums);

		player = new StrumLine(true);
		strums.add(player);
		player.camera = camHUD;

		opponent = new StrumLine();
		strums.add(opponent);
		opponent.camera = camHUD;

		add(healthBarBG = new FlxSprite(0, FlxG.height - 70).loadGraphic(Paths.image('game/hud/healthBar')));
		healthBarBG.screenCenter(X);
		healthBarBG.camera = camHUD;

		add(healthBar = new HealthBar(healthBarBG.x + 4, healthBarBG.y + 4, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), 0, maxHealth,
			this, 'health', LEFT_TO_RIGHT, true));
		healthBar.setColors(dad.getColor(), bf.getColor());
		healthBar.camera = camHUD;
		healthBar.screenCenter(X);

		FlxTween.num(2, 0, 3, {ease: FlxEase.quartInOut, type: PINGPONG}, (v:Float) -> health = v);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		for (direction in 0...4) {
			if (Controls.getKeyPressed(direction))
			{
				player.noteAnim(direction, 'pressed');
				opponent.noteAnim(direction, 'pressed');

				bf.playAnim(directions[direction], true);
				dad.playAnim(directions[direction], true);

				if (bfTimer != null) bfTimer.cancel();
				bfTimer.start(0.5, (_:FlxTimer) ->
				{
					if (!Controls.common_p)
					{
						bf.playAnim('idle');
						dad.playAnim('idle');
					}
				});

			} else if (Controls.getKeyReleased(direction)) {
				player.noteAnim(direction, 'static');
				opponent.noteAnim(direction, 'static');
			}
		}

		if (FlxG.keys.pressed.Z) camGame.zoom -= 2 * elapsed;
		if (FlxG.keys.pressed.X) camGame.zoom += 2 * elapsed;

		if (FlxG.keys.pressed.J) camGame.scroll.x -= 25;
		if (FlxG.keys.pressed.L)
			camGame.scroll.x += 25;
		if (FlxG.keys.pressed.I)
			camGame.scroll.y -= 25;
		if (FlxG.keys.pressed.K)
			camGame.scroll.y += 25;
	}
}
