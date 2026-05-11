package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import game.Character;
import game.Controls;
import game.notes.StrumLine;
import states.UNOState;
import utils.Paths;

class PlayState extends UNOState {
	// public static var troubleShooter:TroubleShooter; // Ya no necesario, está en UNOState

	// Well... it's pretty self descriptive, isnt it? if not, js the strums group
	var strums:FlxTypedGroup<FlxBasic> = new FlxTypedGroup<FlxBasic>();

	// Opponent Strums, short of "strums.members[0]"
	var opponent:StrumLine;

	// Player Strums, short of "strums.members[1]"
	var player:StrumLine;

	var bfTimer:FlxTimer = new FlxTimer();
	var directions:Map<Int, String>=[
		0 => 'idle',
		1 => 'singLEFT',
		2 => 'singDOWN',
		3 => 'singUP',
		4 => 'singRIGHT'
	];

	var bf:Character;
	var dad:Character;

	var camGame:FlxCamera = new FlxCamera();
	var camHUD:FlxCamera = new FlxCamera();

	override public function create() {
		super.create();

		// troubleShooter = new TroubleShooter(); // Ya no necesario
		// add(troubleShooter);

		FlxG.cameras.add(camGame);
		FlxG.cameras.add(camHUD, false);
		camHUD.bgColor = 0x00000000;
		cameras = [camGame];
		camGame.zoom = 0.9;

		add(strums);

		player = new StrumLine(true);
		strums.add(player);
		player.camera = camHUD;

		opponent = new StrumLine();
		strums.add(opponent);
		opponent.camera = camHUD;

		bf = new Character(850, 400, 'characters/bf', true);
		dad = new Character(150, 50, 'characters/dad');

		var floor:FlxSprite = new FlxSprite(-600, 600).loadGraphic(Paths.image('stages/default/floor'));
		var back:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/default/back'));
		var curtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stages/default/curtains'));

		back.scrollFactor.set(0.9, 0.9);
		curtains.scrollFactor.set(1.3, 1.3);

		for (e in [back, floor, dad, bf, curtains]){
			add(e);
			e.camera = camGame;
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		for (direction in 0...4) {
		    if (Controls.getKeyPressed(direction)) {
		        player.noteAnim(direction, 'pressed');

		        bf.playAnim(directions[direction+1]);

				if (bfTimer != null) bfTimer.cancel();
				bfTimer.start(0.5, (_:FlxTimer) -> bf.playAnim(directions[0]));
			} else if (Controls.getKeyReleased(direction)) {
		        player.noteAnim(direction, 'static');
		    }
		}

		if (FlxG.keys.pressed.Z) camGame.zoom -= 2 * elapsed;
		if (FlxG.keys.pressed.X) camGame.zoom += 2 * elapsed;

		if (FlxG.keys.pressed.J) camGame.scroll.x -= 25;
		if (FlxG.keys.pressed.K) camGame.scroll.y += 25;
		if (FlxG.keys.pressed.I) camGame.scroll.y -= 25;
		if (FlxG.keys.pressed.L) camGame.scroll.x += 25;
	}
}
