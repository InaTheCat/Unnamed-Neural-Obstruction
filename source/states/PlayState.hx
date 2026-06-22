package states;

import backend.chart.NewTestChartparser.ParsedChart; // // //
import backend.chart.NewTestChartparser.ParsedNote; //
import backend.chart.NewTestChartparser; //
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.typeLimit.OneOfTwo;
import game.Character;
import game.Controls;
import game.HealthBar;
import game.Icon;
import game.notes.NoteHitResult;
import game.notes.NoteManager;
import game.notes.StrumLine;
import game.score.ScoreManager;

class PlayState extends UNOState
{
	var strums:FlxSpriteGroup = new FlxSpriteGroup();

	var opponent:StrumLine;
	var player:StrumLine;

	public var inst:FlxSound;
	public var voices:Array<FlxSound> = [];

	private var singleVoice:Bool = false;

	public static var chart:ParsedChart;

	public var songPosition:Float = 0;
	public var curSong:String = '';

	var unspawnNotes:Array<ParsedNote> = [];
	var playerNotes:Array<ParsedNote> = [];
	var opponentNotes:Array<ParsedNote> = [];

	var scoreManager:ScoreManager;
	var opponentManager:NoteManager;
	var playerManager:NoteManager;

	var bfTimer:FlxTimer = new FlxTimer();
	var directions:Map<Int, String> = [0 => 'singLEFT', 1 => 'singDOWN', 2 => 'singUP', 3 => 'singRIGHT'];

	var bf:Character;
	var dad:Character;

	var healthBar:HealthBar;
	var maxHealth:Float = 2;
	public var health:Float = 1;

	public var iconP1:Icon;
	public var iconP2:Icon;

	var accuracyTxt:FlxText;
	var missesTxt:FlxText;
	var scoreTxt:FlxText;

	var scoreTexts:FlxSpriteGroup = new FlxSpriteGroup();
	var healthBarGrp:FlxSpriteGroup = new FlxSpriteGroup();

	public var hudUpdating:Bool = true;
	public var switchScorePos:Bool = false;

	var alphaCenter:Float = 360;
	var alphaRange:Float = 100;

	override public function create() {
		super.create();

		// --- Test stage n char ---
		bf = new Character(850, 400, 'bf', true);
		dad = new Character(150, 50, 'dad');

		var floor:FlxSprite = new FlxSprite(-600, 600).loadGraphic(Paths.image('stages/default/floor'));
		var back:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/default/back'));
		var curtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stages/default/curtains'));

		// --- HUD ---
		add(scoreTexts);
		add(healthBarGrp);
		add(strums);

		strums.camera = camHUD;
		strums.add(player = new StrumLine(true));
		strums.add(opponent = new StrumLine());
		strums.y = 50;

		// --- Song ---
		back.scrollFactor.set(0.9, 0.9);
		curtains.scrollFactor.set(1.3, 1.3);

		loadSong('Premeditated', ['boyfriend', 'smiley'], false);
		startSong();

		for (e in [back, floor, dad, bf, curtains])
		{
			add(e);
			e.camera = camGame;
		}

		opponentManager = new NoteManager(opponent, opponentNotes);
		opponentManager.ayuwoki = true;
		strums.add(opponentManager);

		playerManager = new NoteManager(player, playerNotes);
		strums.add(playerManager);
		scoreManager = new ScoreManager();

		playerManager.onHoldScore = function(points:Int)
		{
			scoreManager.addHoldScore(points);
		};

		playerManager.onMiss = function()
		{
			scoreManager.addMiss();
		};

		healthBarGrp.add(healthBar = new HealthBar(0, 0, 0,
			maxHealth, this, 'health', LEFT_TO_RIGHT, true));
		healthBar.setColors(dad.getColor(), bf.getColor());
		// -- //
		scoreTexts.add(accuracyTxt = new FlxText(0, 0, 0, 'Accuracy: -%', 32).setFormat(null, 32, 0xFFFFFFFF, 'left', OUTLINE, 0xFF000000));
		scoreTexts.add(missesTxt = new FlxText(0, 0, 0, 'Misses: 0', 32).setFormat(null, 32, 0xFFFFFFFF, 'center', OUTLINE, 0xFF000000));
		scoreTexts.add(scoreTxt = new FlxText(0, 0, 0, 'Score: 0', 32).setFormat(null, 32, 0xFFFFFFFF, 'right', OUTLINE, 0xFF000000));

		for (i => e in [accuracyTxt, missesTxt, scoreTxt])
		{
			e.x = i * 250;
			e.scale.set(0.5, 0.5);
			e.updateHitbox();
		}

		healthBarGrp.add(iconP1 = new Icon('bf', true, 1.8, bf));
		healthBarGrp.add(iconP2 = new Icon('dad', false, 0.2, dad));

		for (e in [scoreTexts, healthBarGrp])
		{
			e.camera = camHUD;
			e.screenCenter(X);
		}

		healthBarGrp.y = FlxG.height * 0.9;

		FlxTween.num(2, 0, 3, {ease: FlxEase.smootherStepInOut, type: PINGPONG}, (v:Float) -> health = v);
		// FlxTween.num(50, FlxG.height * 0.8, 4, {ease: FlxEase.quartInOut, type: PINGPONG}, (v:Float) -> strums.y = v);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		updateHud();
		updateIconPos();
		for (e in [iconP1, iconP2])
			e.updateIcon(health);

		for (direction in 0...4) {
			if (Controls.getKeyPressed(direction))
			{
				switch (playerManager.press(direction))
				{
					case HIT(note, diff, rating):
						scoreManager.addTapScore(rating);
						player.noteAnim(direction, 'confirm');

					case MISS:
						player.noteAnim(direction, 'pressed');
				}

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

			}
			else if (Controls.getKeyReleased(direction))
			{
				playerManager.release(direction);

				player.noteAnim(direction, 'static');
				opponent.noteAnim(direction, 'static');
			}
		}
		for (direction in 0...4)
		{
			playerManager.setHeld(direction, Controls.getKeyHeld(direction));
		}

		Conductor.update(FlxG.sound.music.time);
		playerManager.updateNotes();
		opponentManager.updateNotes();

		scoreTxt.text = "Score: " + scoreManager.score;
		missesTxt.text = "Misses: " + scoreManager.misses;
		accuracyTxt.text = "Accuracy: " + Std.int(scoreManager.getAccuracy()) + "%";

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
	private function updateHud():Void
	{
		if (!hudUpdating)
			return;

		// var distY:Float = ;

		for (e in [healthBarGrp, scoreTexts])
		{
			var dist:Float = Math.abs(e.y - alphaCenter);

			var t:Float = Math.min(dist / alphaRange, 1);

			e.alpha = t;
		}

		healthBarGrp.y = (-strums.y + FlxG.height) - 50;

		if (switchScorePos)
			scoreTexts.y = healthBarGrp.y * 1.025 + ((healthBarGrp.y * 0.15) - 72.5);
		else
			scoreTexts.y = healthBarGrp.y + 50;
	}

	private function updateIconPos():Void
	{
		var healthBarPercent:Float = healthBar.bar.percent;

		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBarPercent, 0, 100, 0, 1);

		iconP1.x = center - 20;
		iconP2.x = center - (iconP2.width - 20);

		iconP1.y = healthBar.y + healthBar.height - (iconP1.height / 2);
		iconP2.y = healthBar.y + healthBar.height - (iconP2.height / 2);
	}
	/**
	 * @param 
	 *
	**/
	public function loadSong(song:String, ?prefix:Any, bar:Bool = true)
	{
		chart = NewTestChartparser.parseChart("Premeditated", "hard");
		curSong = song;

		FlxG.sound.load(Paths.songInst(song), 1, false);

		if (prefix is Array)
		{
			var arr:Array<String> = cast prefix;

			for (e in arr)
			{
				var voice:FlxSound = FlxG.sound.load(Paths.songVoices(song, e, bar));
				voices.push(voice);
			}
		}
		else if (prefix is String)
		{
			var voice:FlxSound = FlxG.sound.load(Paths.songVoices(song, null, bar));
			voices.push(voice);
		}
		else
		{
			shoot('prefix was null or not even a thing,\n voices will be replaced with "beep"', 'Error');
			var beep:FlxSound = backend.system.SFXBank._beep;
			voices.push(beep);
		}
	}

	private function startSong()
	{
		Conductor.reset();
		Conductor.mapSong(chart.bpm, chart.speed);

		unspawnNotes = chart.notes;

		for (note in chart.notes)
		{
			if (note.dir >= 4 && note.dir <= 7)
				playerNotes.push(note);
			else
				opponentNotes.push(note);
		}

		if (chart.notes.length > 0)
		{
			trace(chart.notes[0].time);
			trace(chart.notes[0].dir);
		}

		FlxG.sound.playMusic(Paths.songInst(curSong), 1, false);
		inst = FlxG.sound.music;

		if (voices != null || voices.length > 0)
			for (e in voices)
				e.play();
	}
}
