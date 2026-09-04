package game.notes;

import flixel.math.FlxPoint;
import game.notes.Splash;

class StrumLine extends FlxSpriteGroup
{
	public var notes:Array<FlxSprite>;
	public var splashes:Array<Splash>;
	public var receptors:Array<FlxSprite>;

    public var isPlayer:Bool = false;

	/**
	 * ts is js for the creation of the strum, if its true or null that is for
	 * setting and `animation.onFinish.add()` for the notes whether is cpu or not
	 * but... it cant be changed later, heh
	 * 
	 * `(Not Final Var)`
	**/
	public var _strumParentAsCpu:Bool = false;

	/**
	 * Creates a `StrumLine` already prepraded (isnt it like that how it should be?).
	 * If is empty, it'll make an opponent strum.
	 *
	 * @param x Position that u can already tell what it does.
	 * @param y Same as `x` gng.
	 * @param player if `true`, will be a Player Strum, else, it'll be opponent.
	 */
	public function new(player:Bool = false, x:Float = 70, y:Float = 50, _cpu:Bool = null):Void
	{
		super();

		isPlayer = player ?? false;
		
		_strumParentAsCpu = _cpu;

		notes = [];
		splashes = [];
		receptors = [];

		prepareStrums(player ?? false, x ?? 70, y ?? 50);
    }

	private function prepareStrums(playable:Bool = false, x:Float, y:Float):Void
	{
        var playerOffset:Float = playable ? FlxG.width * 0.55 : 0;

		for (i in 0...4){
			var note:FlxSprite = new FlxSprite();
			note.frames = Paths.getSparrowAtlas('game/notes/default');

			switch(Math.abs(i) % 4){
				case 0:
					note.animation.addByPrefix('static', 'arrowLEFT');
					note.animation.addByPrefix('pressed', 'left press', 24, false);
					note.animation.addByPrefix('confirm', 'left confirm', 24, false);
		
					note.animation.addByPrefix('scroll', 'purple0');
					note.animation.addByPrefix('hold', 'purple hold piece');
					note.animation.addByPrefix("holdend", "pruple end hold");
				case 1:
					note.animation.addByPrefix('static', 'arrowDOWN');
					note.animation.addByPrefix('pressed', 'down press', 24, false);
					note.animation.addByPrefix('confirm', 'down confirm', 24, false);
		
					note.animation.addByPrefix('scroll', 'blue0');
					note.animation.addByPrefix('hold', 'blue hold piece');
					note.animation.addByPrefix('holdend', 'blue hold end');
				case 2:
					note.animation.addByPrefix('static', 'arrowUP');
					note.animation.addByPrefix('pressed', 'up press', 24, false);
					note.animation.addByPrefix('confirm', 'up confirm', 24, false);
			
					note.animation.addByPrefix('scroll', 'green0');
					note.animation.addByPrefix('hold', 'green hold piece');
					note.animation.addByPrefix('holdend', 'green hold end');
				case 3:
					note.animation.addByPrefix('static', 'arrowRIGHT');
					note.animation.addByPrefix('pressed', 'right press', 24, false);
					note.animation.addByPrefix('confirm', 'right confirm', 24, false);
				
					note.animation.addByPrefix('scroll', 'red0');
					note.animation.addByPrefix('hold', 'red hold piece');
					note.animation.addByPrefix('holdend', 'red hold end');
			}

			note.animation.play('static');

			note.scale.set(0.7, 0.7);
			note.updateHitbox();
			note.setPosition((x + playerOffset) + (i * 110));

			note.antialiasing = Options.antialiasing ?? true;

			add(note);
			notes.push(note);

			if (!_strumParentAsCpu)
				note.animation.onFinish.add((n:String) -> if (n != 'static') noteAnim(i, 'static'));

            var receptor:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0x00FFFFFF);
            
            receptor.setGraphicSize(note.width, note.height);
            receptor.updateHitbox();
			receptor.setPosition(note.x, note.y);
			add(receptor);
			receptors.push(receptor);
			var splash:Splash = new Splash(0, 0, i, 0.5);
			splash.setPosition(note.x - (splash.width / 6), note.y - (splash.height / 6));
			insert(members.indexOf(note) + 1, splash);
			splashes.push(splash);
		}
	}

	/**
	 * Plays an animation for a note in the Strum.
	 * @param direction The direction of the note that will have the animation
     *                  (its an `Int` from `0` to `3` normally).
	 * @param anim The animation that will play the note, if empty, it wont do nothing.
	 */
	public function noteAnim(direction:Int = 0, ?anim:String = 'static', ?isCpu:Bool = false):Void
	{
		if (direction >= 0 && direction < notes.length)
		{
			var note = notes[direction];

			var center:FlxPoint = FlxPoint.get(note.x + note.width / 2, note.y + note.height / 2);

			note.animation.play(anim ?? 'static', true);
			note.updateHitbox();

			note.setPosition(center.x - note.width / 2, center.y - note.height / 2);

			note.centerOffsets();
		}
	}

	/**
	 * returns a receptor gng
	**/
	public function getReceptor(dir:Int):FlxSprite
		return dir >= 0 && dir <= 3 ? receptors[dir] : receptors[0];

	/**
	 * same as the other one but with the note ig
	**/
	public function getNote(dir:Int):FlxSprite
		return dir >= 0 && dir <= 3 ? notes[dir] : notes[0];
}