package states;

import backend.chart.NewTestChartparser.ParsedChart; // // //
import backend.chart.NewTestChartparser.ParsedNote; //
import backend.chart.NewTestChartparser; //
import flixel.math.FlxPoint;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.typeLimit.OneOfTwo;
import game.CamPointer;
import game.Character;
import game.Combo;
import game.HealthBar;
import game.Icon;
import game.Stage;
import game.notes.Note;
import game.notes.NoteHitResult;
import game.notes.NoteManager;
import game.notes.StrumLine;
import game.score.ScoreManager;

typedef HitSettings =
{
	?note:Note,
	?sustain:Bool
}

class PlayState extends UNOState
{
	public static var instance:PlayState = null;

	public var camPointer:CamPointer = new CamPointer();
	public var camUpdating:Bool = true;

	var strums:FlxSpriteGroup = new FlxSpriteGroup();

	public var opponent:StrumLine;
	public var player:StrumLine;

	public var bf:Character;
	public var dad:Character;

	public static var inst:FlxSound;
	public static var voices:Array<FlxSound> = [];
	private var nullVoices:Bool = false;

	public static var mustHitSection:Bool = false;
	public static var chart:ParsedChart;

	public var songPosition:Float = 0;
	public var curSong:String = null;

	public var unspawnNotes:Array<ParsedNote> = [];
	public var playerNotes:Array<ParsedNote> = [];
	public var opponentNotes:Array<ParsedNote> = [];

	var scoreManager:ScoreManager;
	var opponentManager:NoteManager;
	var playerManager:NoteManager;

	public var combo:Int = 0;
	public var comboRating:Combo;

	var directions:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var stage:Stage = new Stage();

	public var healthBar:HealthBar;
	public var maxHealth:Float = 2;
	public var health:Float = 1;

	public var iconP1:Icon;
	public var iconP2:Icon;
	public var updateIcons:Bool = true;

	public var accuracyTxt:FlxText;
	public var missesTxt:FlxText;
	public var scoreTxt:FlxText;

	public var scoresBack:FlxSprite;

	public var scoreTexts:FlxSpriteGroup = new FlxSpriteGroup();
	public var healthBarGrp:FlxSpriteGroup = new FlxSpriteGroup();

	public var hudUpdating:Bool = true;
	public var switchScorePos:Bool = false;

	public var alphaCenter:Float = 360;
	public var alphaRange:Float = 100;

	public final BF_BASE:FlxPoint = FlxPoint.get(850, 400);
	public final DAD_BASE:FlxPoint = FlxPoint.get(150, 50);

	public var camZoom:Float = 0.9;
	public var camZooming:Bool = true;

	override public function create() {
		instance = this;

		super.create();

		camGame.zoom = camZoom;

		// --- Test stage n char ---
		var floor:FlxSprite = new FlxSprite(-600, 600).loadGraphic(Paths.image('stages/stage/floor'));
		var back:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/stage/back'));
		var curtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stages/stage/curtains'));

		back.scrollFactor.set(0.9, 0.9);
		curtains.scrollFactor.set(1.3, 1.3);

		add(back);
		add(floor);

		add(dad = new Character(DAD_BASE.x, DAD_BASE.y, 'dad'));
		add(bf = new Character(BF_BASE.x, BF_BASE.y, 'bf', true));

		add(curtains);
		for (e in [back, floor, dad, bf, curtains])
			e.camera = camGame;

		add(comboRating = new Combo(600, 200));
		comboRating.camera = camGame;

		// stage.startStage('stage');

		// --- HUD ---
		add(scoreTexts);
		add(healthBarGrp);
		add(strums);

		strums.camera = camHUD;
		strums.add(player = new StrumLine(true));
		strums.add(opponent = new StrumLine());
		strums.y = Options.downscroll ? FlxG.height * 0.8 : 50;

		healthBarGrp.add(healthBar = new HealthBar(0, 0, 0, maxHealth, this, 'health', LEFT_TO_RIGHT, true));
		healthBar.setColors(dad.getColor(), bf.getColor());
		for (e in [healthBarGrp, healthBar, healthBar.bar, healthBar.bg])
			e.updateHitbox();
		healthBarGrp.screenCenter(X);

		scoreTexts.add(scoresBack = new FlxSprite());
		scoresBack.camera = camHUD;

		scoreTexts.add(scoreTxt = new FlxText(0, 0, 0, 'Score: 0', 32).setFormat(Paths.font('vcr.ttf'), 32, 0xFFFFFFFF, 'right', OUTLINE, 0xFF000000));
		scoreTexts.add(accuracyTxt = new FlxText(0, 0, 0, 'Accuracy: -%', 32).setFormat(Paths.font('vcr.ttf'), 32, 0xFFFFFFFF, 'left', OUTLINE, 0xFF000000));
		scoreTexts.add(missesTxt = new FlxText(0, 0, 0, 'Misses: 0', 32).setFormat(Paths.font('vcr.ttf'), 32, 0xFFFFFFFF, 'center', OUTLINE, 0xFF000000));

		for (i => e in [scoreTxt, missesTxt, accuracyTxt])
		{
			e.x = i * 200;
			e.scale.set(0.65, 0.65);
			e.updateHitbox();
		}

		scoreTexts.camera = camHUD;
		scoreTexts.screenCenter(X);

		scoresBack.makeGraphic(Std.int(accuracyTxt.textField.textWidth) * 2 + 147, Std.int(accuracyTxt.textField.textHeight) + 5, 0x55000000);

		healthBarGrp.add(iconP1 = new Icon(bf, true, 1.8));
		healthBarGrp.add(iconP2 = new Icon(dad, false, 0.2));
		healthBarGrp.y = FlxG.height * 0.9;
		healthBarGrp.camera = camHUD;

		// --- Song ---
		loadSong('Ectospasm', 'Voices', false);
		startSong();

		opponentManager = new NoteManager(opponent, opponentNotes);
		opponentManager.cpu = true;
		opponentManager.onNoteHit = (note:Note) -> onOpponentHit({note: note});
		opponentManager.onSustainNote = (note:Note) -> onOpponentHit({note: note, sustain: true});
		strums.add(opponentManager);

		playerManager = new NoteManager(player, playerNotes);
		// playerManager.cpu = true;
		playerManager.onSustainScore = (points:Int) -> scoreManager.addHoldScore(points);
		playerManager.onNoteHit = (note:Note) -> onPlayerHit({note: note});
		playerManager.onSustainNote = (note:Note) -> onPlayerHit({note: note, sustain: true});
		strums.add(playerManager);
		scoreManager = new ScoreManager();

		playerManager.onMiss = () -> scoreManager.addMiss();

		add(camPointer);
		// camPointer.setPosition = (bf.getMidpoint().x + dad.getMidpoint().x) / 2;
		camPointer.updatePos(bf);

		camGame.follow(camPointer, LOCKON, 0.045);

		// FlxTween.num(2, 0, 3, {ease: FlxEase.smootherStepInOut, type: PINGPONG}, (v:Float) -> health = v);
		// FlxTween.num(50, FlxG.height * 0.8, 4, {ease: FlxEase.quartInOut, type: PINGPONG}, (v:Float) -> strums.y = v);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (camZooming)
		{
			camGame.zoom = CoolUtil.lerp(camGame.zoom, camZoom, 0.05);
			camHUD.zoom = CoolUtil.lerp(camHUD.zoom, 1, 0.05);
		}

		updateHud();
		updateIconPos();
		for (e in [iconP1, iconP2])
			e.updateIcon(health);

		if (!playerManager.cpu)
		{
			for (direction in 0...4)
			{
				if (Controls.getKeyPressed(direction))
				{
					switch (playerManager.press(direction))
					{
						case HIT(note, diff, rating):
							scoreManager.addTapScore(rating);
							combo++;
							comboRating.showCombo(rating, combo);
							player.noteAnim(direction, 'confirm');
							if (rating == 'sick')
								player.splashes[note.dir].press();

							addHealth(0.015);

						case MISS:
							combo = 0;
							player.noteAnim(direction, 'pressed');
							addHealth(-0.05);
					}
				}
				else if (Controls.getKeyReleased(direction))
				{
					playerManager.release(direction);

					player.noteAnim(direction, 'static');
				}
			}
		}
		for (direction in 0...4)
			playerManager.setHeld(direction, Controls.getKeyHeld(direction));

		health = FlxMath.bound(health, 0, maxHealth);

		Conductor.update(elapsed);

		playerManager.updateNotes();
		opponentManager.updateNotes();
		for (e in [iconP1, iconP2])
			e.updateScale();

		for (e in voices)
			if (!nullVoices)
			{
				var diff:Float = Math.abs(e.time - FlxG.sound.music.time);

				if (diff > 20)
					e.time = FlxG.sound.music.time;
			}

		scoreTxt.text = "Score: " + scoreManager.score;
		missesTxt.text = "Misses: " + scoreManager.misses;
		accuracyTxt.text = "Accuracy: " + Std.int(scoreManager.getAccuracy()) + "%";
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new states.LoadState());
	}

	override public function destroy():Void
	{
		super.destroy();

		inst?.stop();
		FlxG.sound?.music?.stop();

		if (voices != null || voices.length > 0 || !nullVoices)
			for (e in voices)
				e.stop();

		Conductor.reset();

		for (e in members)
			if (e is FlxSprite)
				e.destroy();
	}

	public function onPlayerHit(?n:HitSettings = null)
	{
		var note:Null<Note> = n.note ?? null;
		var sustain:Null<Bool> = n.sustain ?? false;

		if (note != null)
		{
			if (bf != null)
			{
				bf.playAnim(directions[note.dir], true);

				if (playerManager.cpu)
				{
					player.noteAnim(note.dir, 'confirm', true);

					if (!sustain)
					{
						scoreManager.addTapScore('sick');
						combo++;
						comboRating.showCombo('sick', combo);
						addHealth(0.015);
					}
				}
			}
		}
	}

	public function onOpponentHit(?n:HitSettings = null)
	{
		var note:Null<Note> = n.note ?? null;
		var sustain:Null<Bool> = n.sustain ?? false;

		if (note != null)
		{
			if (dad != null)
			{
				dad.playAnim(directions[note.dir], true);
				if (opponentManager.cpu)
					opponent.noteAnim(note.dir, 'confirm', true);
			}
		}
	}

	override public function beatHit(b:Int)
	{
		super.beatHit(b);

		if (b % 2 == 0)
			for (e in [iconP1, iconP2])
				e.iconScale = 1.2;
	}

	override public function sectionHit(s:Int)
	{
		super.sectionHit(s);

		mustHitSection = chart.sections[s].mustHitSection ?? false;
		if (camUpdating)
			camPointer.updatePos(mustHitSection ? bf : dad);

		if (camZooming)
		{
			camGame.zoom = camZoom + 0.02;
			camHUD.zoom = 1.015;
		}

		for (e in [dad, bf])
			e.dance();
	}

	private function updateHud():Void
	{
		if (!hudUpdating)
			return;

		for (e in scoreTexts.members)
			e.updateHitbox();
		
		for (e in [healthBarGrp, scoreTexts])
		{
			var dist:Float = Math.abs(e.y - alphaCenter);

			var t:Float = Math.min(dist / alphaRange, 1);

			e.alpha = t;
		}

		healthBarGrp.y = (-strums.y + FlxG.height) - 50 - (Options.downscroll ? 40 : 0);

		if (switchScorePos)
			scoreTexts.y = healthBarGrp.y * 1.025 + ((healthBarGrp.y * 0.15) - 72.5);
		else
			scoreTexts.y = healthBarGrp.y + 50;
		scoresBack.setPosition(scoreTexts.x - 22.5, scoreTexts.y - 5);
	}

	private function updateIconPos():Void
	{
		if (!updateIcons)
			return;

		var healthBarPercent:Float = healthBar.bar.percent;

		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBarPercent, 0, 100, 0, 1);

		iconP1.setPosition(center - 20, healthBar.y + healthBar.height - (iconP1.height / 2));
		iconP2.setPosition(center - (iconP2.width - 20), healthBar.y + healthBar.height - (iconP2.height / 2));
	}
	public function addHealth(am:Float = 0)
		health -= am ?? 0;

	/**
	 * @param song da name of da song gng hehheehhehheeehhhehehhhhhhhhehehehhehheehhehheeehhhehehhhhhhhhehehehhehheehhehheeehhhehehhhhhhhhehehehhehheehhehheeehhhehehhhhhhhhehehehhehheehhehheeehhhehehhhhhhhhehehehhehheehhehheeehhhehehhhhhhhhehehehhehheehhehheeehhhehehhhhhhhheheheh
	 * @param prefix can be an Array with all the voices (placeholder) or a string... but the string needs to be `''`, yea, its still a placeholder cuz i suck at this
	 * @param bar is if the voices has the `-Prefix`, ye, exactly the "-"
	 *
	 * `Please, don't try to "play" with this rn, its still on WIP and its horribly bad coded`
	**/
	@:deprecated("WIP Func, be aware with ts pls")
	public function loadSong(song:String, ?prefix:Any, bar:Bool = true)
	{
		chart = NewTestChartparser.parseChart(song, "hard");
		curSong = song;

		FlxG.sound.load(Paths.songInst(song), 1, false);

		if (prefix == null)
		{
			nullVoices = true;
			return;
		}

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
			Logs.send('prefix was null or not even a thing,\n voices will be replaced with "beep"', {type: Error});
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
			if (note.mustHit)
				playerNotes.push(note);
			else
				opponentNotes.push(note);
		}

		if (chart.notes.length > 0)
		{
			// Logs.send(chart.notes[0].time, 'Info');
			// Logs.send(chart.notes[0].dir, 'Info');
		}

		FlxG.sound.playMusic(Paths.songInst(curSong), 1, false);

		inst = FlxG.sound.music;

		/**
		 * FOR TESTING!!!
		 */
		FlxG.sound.music.time = 10 * 1000;
		// my dih

		if (voices != null || voices.length > 0 || !nullVoices)
			for (e in voices)
				e.play();
	}
}
