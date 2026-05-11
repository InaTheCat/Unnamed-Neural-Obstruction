package game.notes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import utils.Paths;

class StrumLine extends FlxTypedGroup<FlxSprite> {
    var notes:Array<FlxSprite>=[];
    var receptors:Array<FlxSprite>=[];

    public var isPlayer:Bool = false;

	/**
	 * Creates a `StrumLine` already prepraded (isnt it like that how it should be?).
	 * If is empty, it'll make an opponent strum.
	 *
	 * @param   x               Position that u can already tell what it does.
	 * @param   y               Same as `x` gng.
	 * @param   player          if `true`, will be a Player Strum, else, it'll be opponent.
	 */
	public function new(?player:Bool = false, ?x:Float = 70, ?y:Float = 50) {
		super();

		isPlayer = player ?? false;
		
		prepareStrums(player ?? false, x ?? 70, y ?? 50);
    }

	private function prepareStrums(?playable:Bool = false, ?x:Float, ?y:Float):Void {
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
			note.setPosition((x + playerOffset) + (i * 110), y);

			add(note);
            notes.push(note);

            var receptor:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0x00FFFFFF);
            
            receptor.setGraphicSize(note.width, note.height);
            receptor.updateHitbox();
            receptor.setPosition(note.x, note.y);

            add(receptor);
            receptors.push(receptor);
		}
	}

	/**
	 * Plays an animation for a note in the Strum.
	 * @param direction The direction of the note that will have the animation
     *                  (its an `Int` from `0` to `3` normally).
	 * @param anim The animation that will play the note, if empty, it wont do nothing.
	 */
	public function noteAnim(direction:Int = 0, ?anim:String = 'static'){
		if (direction >= 0 && direction < members.length) {
			notes[direction].animation.play(anim ?? 'static', true);
			notes[direction].centerOffsets();
		}
	}
}