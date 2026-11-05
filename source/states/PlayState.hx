package states;

import flixel.FlxObject;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import game.Character;
import game.Combo;
import game.chart.UNOChart;
import game.managers.music.BeatState;
import game.managers.music.VoicesPack;
import game.notes.StrumLine;

class PlayState extends BeatState
{
	public var songStarted:Bool = false;
	public var stateLoss:Bool = false;
	public var sOnFocus:Bool = false;
	public var vOnLoss:Array<Bool> = [];

	public var curSong:String = 'Tutorial';
	public var curDiff:String = 'hard';
	public var forcedVoices:Array<String>;

	public var inst:FlxSound;
	public var voices:VoicesPack = new VoicesPack();
	public var startingPos:Bool = false;

	public var chart:UnnamedChart;

	public var camZoom:Float = 0.9;
	public var defaultCamZoom(get, set):Float;

	function set_defaultCamZoom(v:Float):Float
	{
		camZoom = v;

		return camZoom;
	}

	function get_defaultCamZoom():Float
	{
		return camZoom;
	}

	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;
	public var camPointer:FlxObject = new FlxObject(0, 0, 1, 1);

	public var opponent:StrumLine;
	public var player:StrumLine;
	public var strumLines:Int = -1;

	public var bf:Character;
	public var dad:Character;

	public final BF_BASE:FlxPoint = FlxPoint.get(850, 400);
	public final DAD_BASE:FlxPoint = FlxPoint.get(150, 50);

	public var comboGrp:Combo;

	public var combo:Int = 0;
	public var misses:Int = 0;

	public var floor:FlxSprite;
	public var bg:FlxSprite;

	var impossible:Bool = false;

	public function new(song:String, diff:String, ?forcedVoices:Array<String>)
	{
		super();

		if (forcedVoices != null)
			this.forcedVoices = forcedVoices;

		curSong = song;
		curDiff = diff;
	}

	override public function create()
	{
		super.create();
		impossible = curSong == 'run' || curSong == 'red-3';

		FlxG.cameras.add(camGame = new FlxCamera());
		FlxG.cameras.add(camHUD = new FlxCamera(), false).bgColor = 0x00000000;

		camGame.zoom = camZoom;

		add(bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/stage/back')));
		add(floor = new FlxSprite(-600, 600).loadGraphic(Paths.image('stages/stage/floor')));

		add(dad = new Character(DAD_BASE.x, DAD_BASE.y, 'dad', true));
		add(bf = new Character(BF_BASE.x, BF_BASE.y, 'bf', true));

		chart = UNOChart.toTypedef(curSong, curDiff);

		insert(members.indexOf(dad) - 1, comboGrp = new Combo((dad.x + bf.x) / 2 + 10, (dad.y + bf.y) / 2));

		add(opponent = new StrumLine(50, 50, 4, false, dad, this));

		add(player = new StrumLine(FlxG.width * 0.55, 50, 4, !impossible, bf, this, impossible));

		add(camPointer);
		camPointer.setPosition(dad.getMidpoint().x + dad.camOffset.x, dad.getMidpoint().y + dad.camOffset.y);

		camGame.follow(camPointer, LOCKON, 0.045);

		opponent.camera = camHUD;
		player.camera = camHUD;

		loadSong();

		new FlxTimer().start(0.25, (_:FlxTimer) -> startSong());
	}

	override public function update(elapsed:Float)
	{
		if (songStarted)
		{
			Conductor.update(elapsed, inst);
			voices.update(inst);
		}
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			exitSong();

		camGame.zoom = CoolUtil.lerp(camGame.zoom, camZoom, 0.05);
		camHUD.zoom = CoolUtil.lerp(camHUD.zoom, 1, 0.05);
	}

	public function loadSong()
	{
		if (forcedVoices != null)
			for (i in 0...2)
				chart.strums[i].voice = forcedVoices[i];

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

		inst.onComplete = () -> exitSong();

		Conductor.bpm = chart.bpm;
	}

	function startSong()
	{
		Conductor.songPosition = inst.time;

		voices.play();
		inst.play();

		if (curSong == 'red-3')
			FlxG.sound.music.time = 19000;

		songStarted = true;
	}

	public function exitSong()
	{
		Conductor.reset();
		for (e in [opponent, player])
			e.clean();
		FlxG.switchState(() -> new states.Selector());
	}
	public function updateCamera(i:Int)
	{
		if (chart.meta[i].mustHitSection == null)
			return;

		var character:Character = chart.meta[i].mustHitSection ? bf : dad;
		var mid:FlxPoint = character.getMidpoint();

		var offsets:FlxPoint = FlxPoint.get(character.camOffset.x ?? 0, character.camOffset.y ?? 0);

		camPointer.setPosition(mid.x + offsets.x, mid.y + offsets.y);
	}

	public function updateBpm(i:Int)
		if (chart.meta[i].bpm != Conductor.bpm)
			Conductor.bpm = chart.meta[i].bpm;

	override public function sectionHit(sec:Int)
	{
		super.sectionHit(sec);

		if (chart.meta.length != 0)
			for (i in 0...chart.meta.length)
			{
				if (chart.meta[i].sec == sec)
				{
					updateCamera(i);

					if (chart.meta[i].changeBPM == true)
						updateBpm(i);
				}
			}

		camGame.zoom = camZoom + 0.02;
		camHUD.zoom = 1.015;

		for (e in [dad, bf])
			e.dance();
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
}