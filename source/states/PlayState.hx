package states;

import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import game.chart.UNOChart;
import game.managers.music.BeatState;
import game.managers.music.Conductor;
import game.managers.music.Voices.VoicesPack;
import game.notes.StrumLine;

class PlayState extends BeatState
{
	var songStarted:Bool = false;
	var stateLoss:Bool = false;
	var sOnFocus:Bool = false;
	var vOnLoss:Array<Bool> = [];
	var curSong:String = 'Tutorial';
	var curDiff:String = 'hard';

	var inst:FlxSound;
	var voices:VoicesPack = new VoicesPack();

	var chart:UnnamedChart;

	var strum:StrumLine;
	var strum2:StrumLine;
	var floor:FlxSprite;
	var bg:FlxSprite;

	public function new(song:String, diff:String)
	{
		super();

		curSong = song;
		curDiff = diff;
	}

	override public function create()
	{
		super.create();
		add(bg = new FlxSprite().loadGraphic(Paths.image('stages/stage/back')));
		add(floor = new FlxSprite().loadGraphic(Paths.image('stages/stage/floor')));
		// chart = PsychParser.parse('test', 'hard');

		chart = UNOChart.toTypedef(curSong, curDiff);
		curSong = chart.song;

		add(strum = new StrumLine(50, 50, 4, false, chart.strums[0].notes, chart.speed));
		add(strum2 = new StrumLine(FlxG.width * 0.55, 50, 4, false, chart.strums[1].notes, chart.speed));

		loadSong();

		new FlxTimer().start(0.5, (_:FlxTimer) -> startSong());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (songStarted)
		{
			Conductor.update(elapsed, inst);
			voices.update(inst);
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			Conductor.reset();
			for (e in [strum, strum2])
				e.clean();
			FlxG.switchState(() -> new states.Selector());
		}
	}

	override public function destroy()
	{
		super.destroy();

		voices.destroy();

		if (inst != null)
		{
			inst.stop();
			inst = null;
		}
	}

	override public function onFocusLost():Void
	{
		super.onFocusLost();

		if (stateLoss)
			return;

		stateLoss = true;
		sOnFocus = songStarted && inst != null && inst.playing;
		vOnLoss = [for (voice in voices.vocals) voice != null && voice.playing];
	}
	override public function onFocus():Void
	{
		super.onFocus();

		if (!stateLoss)
			return;

		stateLoss = false;

		if (!sOnFocus)
			return;

		sOnFocus = false;

		if (inst != null)
		{
			inst.play();
			Conductor.songPosition = inst.time;
		}
		for (i in 0...voices.vocals.length)
			if (i < vOnLoss.length && vOnLoss[i])
				voices.vocals[i].play();

		vOnLoss = [];
	}

	public function loadSong()
	{
		var _vcs:Array<String> = [];

		for (i in 0...2)
			_vcs.push(chart?.strums[i]?.voice);

		if (Paths.exists('songs/$curSong/song/Voices${_vcs[0]}.ogg')
			&& Paths.exists('songs/$curSong/song/Voices${_vcs[1]}.ogg')
			|| Paths.exists('songs/$curSong/song/Voices.ogg'))
			if (_vcs != null)
				if (_vcs == ['', ''])
					voices.save(FlxG.sound.load(Paths.songVoices(chart.song), 0.7, false));
				else
					for (i in 0...2)
						voices.save(FlxG.sound.load(Paths.songVoices(chart.song, chart?.strums[i]?.voice), 0.7, false));
			else
				voices.save(FlxG.sound.load(Paths.songVoices(chart.song), 0.7, false));

		FlxG.sound.music = inst = FlxG.sound.load(Paths.songInst(chart.song), 1, false);

		Conductor.bpm = chart?.bpm;
	}

	function startSong()
	{
		Conductor.songPosition = inst.time;

		voices.play();
		inst.play();

		// FlxG.sound.music.time = 5000;

		songStarted = true;
	}
}