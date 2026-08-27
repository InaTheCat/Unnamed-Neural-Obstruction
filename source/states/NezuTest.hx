package states;

import backend.chart.NewTestChartparser.ParsedChart; // // //
import backend.chart.NewTestChartparser.ParsedNote; //
import backend.chart.NewTestChartparser; //
import game.notes.Note;
import game.notes.NoteManager;
import game.notes.StrumLine;

typedef HitSettings =
{
	?note:Note,
	?sustain:Bool
}

class NezuTest extends UNOState {    
	var strums:FlxSpriteGroup = new FlxSpriteGroup();

    public static var chart:ParsedChart;

    var opponentManager:NoteManager;
	var playerManager:NoteManager;

	public var curSong:String = null;
	public static var inst:FlxSound;
	public static var voices:Array<FlxSound> = [];
	private var nullVoices:Bool = false;

	public var unspawnNotes:Array<ParsedNote> = [];
	public var playerNotes:Array<ParsedNote> = [];
	public var opponentNotes:Array<ParsedNote> = [];

	public var opponent:StrumLine;
	public var player:StrumLine;

    public var red:FlxSprite;
    public var green:FlxSprite;

    var osaka:FlxSprite;

	override public function create():Void
	{
        super.create();

        camHUD.visible = false;

        add(strums);
        strums.camera = camHUD;
		strums.add(player = new StrumLine(true));
		strums.add(opponent = new StrumLine());
        strums.y = 50;

        loadSong('Premeditated', ['smiley', 'boyfriend'], false);
        startSong();

        opponentManager = new NoteManager(opponent, opponentNotes);
        opponentManager.cpu = true;
		opponentManager.onNoteHit = (note:Note) -> onOpponentHit({note: note});
		opponentManager.onSustainNote = (note:Note) -> onOpponentHit({note: note, sustain: true});
		strums.add(opponentManager);

		playerManager = new NoteManager(player, playerNotes);
		playerManager.cpu = true;
		playerManager.onNoteHit = (note:Note) -> onPlayerHit({note: note});
		playerManager.onSustainNote = (note:Note) -> onPlayerHit({note: note, sustain: true});
		strums.add(playerManager);

        add(red = new FlxSprite().makeGraphic(50, 50, 0xFFFF0000));
        add(green = new FlxSprite().makeGraphic(50, 50, 0xFF00FF00));

        add(osaka = new FlxSprite(1100, 50).loadGraphic(Paths.image('osaka')));
        osaka.scale.set(0.35, 0.35);
        osaka.updateHitbox();

        red.screenCenter().x -= 250;
        green.screenCenter().x += 250;
    }

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);

		Conductor.update(elapsed);

		playerManager.updateNotes();
		opponentManager.updateNotes();

		for (e in voices)
			if (!nullVoices)
			{
				var diff:Float = Math.abs(e.time - FlxG.sound.music.time);

				if (diff > 20)
					e.time = FlxG.sound.music.time;
			}

        red.setPosition(CoolUtil.lerp(red.x, 365, 0.15), CoolUtil.lerp(red.y, 335, 0.15));
        green.setPosition(CoolUtil.lerp(green.x, 865, 0.15), CoolUtil.lerp(green.y, 335, 0.15));

        red.angle = CoolUtil.lerp(red.angle, 0, 0.15);
        green.angle = CoolUtil.lerp(green.angle, 0, 0.15);

        var sC:Float = CoolUtil.lerp(osaka.scale.x, 0.35, 0.15);
        osaka.scale.set(sC, sC);
    }

	override public function stepHit(s:Int):Void
	{
        super.stepHit(s);

        if (s % 2 == 0){
            osaka.flipX = !osaka.flipX;
            osaka.scale.set(0.4, 0.4);

            FlxTween.cancelTweensOf(osaka);
            FlxTween.tween(osaka, {angle: osaka.angle + 25}, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.smootherStepOut});
        }
    }

	public function onPlayerHit(?n:HitSettings = null)
	{
		var note:Null<Note> = n.note ?? null;
		var sustain:Null<Bool> = n.sustain ?? false;

		if (note != null){
            player.noteAnim(note.dir, 'confirm', true);
        
            switch(note.dir){
                case 0:
                    green.x = 835;
                    green.angle = -10;
                case 1:
                    green.y = 365;
                    green.angle = 20;
                case 2:
                    green.y = 305;
                    green.angle = -20;
                case 3:
                    green.x = 895;
                    green.angle = 10;
            }
        }
	}

	public function onOpponentHit(?n:HitSettings = null)
	{
		var note:Null<Note> = n.note ?? null;
		var sustain:Null<Bool> = n.sustain ?? false;

		if (note != null){
            opponent.noteAnim(note.dir, 'confirm', true);
        
            switch(note.dir){
                case 0:
                    red.x = 335;
                    red.angle = -10;
                case 1:
                    red.y = 365;
                    red.angle = 20;
                case 2:
                    red.y = 305;
                    red.angle = -20;
                case 3:
                    red.x = 395;
                    red.angle = 10;
            }
        }
	}

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
	}

	private function startSong()
	{
		Conductor.reset();
		Conductor.mapSong(chart.bpm, chart.speed);

		unspawnNotes = chart.notes;

		for (note in chart.notes)
			if (note.mustHit)
				playerNotes.push(note);
			else
				opponentNotes.push(note);

		FlxG.sound.playMusic(Paths.songInst(curSong), 1, false);

		inst = FlxG.sound.music;

		FlxG.sound.music.time = 117 * 1000;

		if (voices != null || voices.length > 0 || !nullVoices)
			for (e in voices)
				e.play();
	}
}