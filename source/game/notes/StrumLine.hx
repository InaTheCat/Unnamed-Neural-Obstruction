package game.notes;

import game.chart.UNOChart;
import game.managers.strums.StrumController;
import states.PlayState;

class StrumLine extends FlxSpriteGroup
{
	public var stateParent:PlayState;

	public var controller:StrumController;

    public var keyCount:Int = 4;
    public var spacing:Int = 110;

	public var isPlayer:Bool = false;
	public var character:Character = null;
	public var willMimic:Bool = false;

	public var notes:Array<StrumNote>;
	public var boxes:Array<FlxSprite>;
	public var splashes:Array<Splash>;
	public var hitbox:FlxSprite;
	public var scrollSpeed:Float;

	public var unspawnNotes:FlxSpriteGroup = new FlxSpriteGroup();

	/**
	 * ik it might be fucking stupid but, uhm, its sorta useful, ig???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
	**/
	public var keyCountMap:Map<Int, Array<Int>> = [
		1 => [2],
		2 => [0, 3],
		3 => [0, 1, 3],
		4 => [0, 1, 2, 3],
		5 => [0, 1, 2, 2, 3],
		6 => [0, 1, 3, 0, 2, 3],
		7 => [0, 1, 3, 1, 0, 2, 3],
		8 => [0, 1, 2, 3, 0, 1, 2, 3],
		9 => [0, 1, 2, 3, 2, 0, 1, 2, 3]
	];

	public function new(x:Float = 0, y:Float = 0, keyCount:Int = 4, isPlayer:Bool = false, charParent:Character, ?stateParent:PlayState,
			mimicPlayer:Bool = false)
	{
		super();

		stateParent.strumLines++;

		this.stateParent = stateParent;
        this.keyCount = keyCount;
		this.scrollSpeed = stateParent.chart.speed ?? 1;
		this.isPlayer = isPlayer;
		this.character = charParent;
		this.willMimic = mimicPlayer;

		notes = [];
		splashes = [];
		boxes = [];

		var dirs:Array<Int> = keyCountMap.get(this.keyCount);
		for (i in 0...this.keyCount)
		{
			var dir:Int = dirs != null && i < dirs.length ? dirs[i] : i % 4;
			var note:StrumNote = new StrumNote(i * spacing, 0, dir);
			add(note);
			notes.push(note);

			var box:FlxSprite = new FlxSprite(note.x, note.y).makeGraphic(Std.int(note.width), Std.int(note.height), 0x00000000);
			add(box);
			boxes.push(box);

			if (!isPlayer)
				note.animation.onFinish.add((n:String) -> if (n != 'static') note.playAnim('static', true));
		}
		add(unspawnNotes);

		add(hitbox = new FlxSprite(notes[0].x ?? 0,
			notes[0].y ?? 0).makeGraphic(Std.int(notes[notes.length - 1].x + notes[notes.length - 1].width), Std.int(notes[0].height), 0x00FFFFFF));

		for (i in 0...this.keyCount)
		{
			var dir:Int = dirs != null && i < dirs.length ? dirs[i] : i % 4;
			var splash:Splash = new Splash(notes[i].x + 35, 0, dir);
			add(splash);
			splashes.push(splash);
		}
		setPosition(x, y);
		var chart:Array<StrumNotes> = stateParent.chart.strums[stateParent.strumLines].notes ?? null;

		controller = new StrumController(this, chart);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controller != null)
			controller.update();
	}

	public function clean()
	{
		controller.destroy();
		controller = null;

		for (e in unspawnNotes.members)
		{
			if (e != null)
			{
				remove(e);
				e.destroy();
			}
		}
	}

	public inline function playAnim(dir:Int = 0, anim:String, force:Bool = false)
		notes[dir %= keyCount].playAnim(anim, force);

	public inline function _receptor(dir:Int):Int
		return notes[dir].dir ?? notes[0].dir;

	public inline function getReceptor(dir:Int):FlxSprite
		return boxes[dir] ?? boxes[0];
}