// ignore ts, i was trying to test sumting

package states;

import flixel.text.FlxText;
import game.managers.music.BeatState;

class Selector extends BeatState {
	public var sngs:FlxSpriteGroup = new FlxSpriteGroup();

	public var songs:Array<Dynamic> = [
		['red-3', 'hard'],
		['test', 'hard'],
		['run', 'hard'],
		['Ectospasm', 'hard'],
		['Premeditated', 'hard', [' smiley', ' boyfriend']]
	];

    override public function create() {
        super.create();

		add(sngs);

		for (i in 0...songs.length)
		{
			var sng:FlxText = new FlxText(0, i * 50, 0, songs[i][0], 24);
			sngs.add(sng);
		}

		sngs.setPosition(50, 50);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		for (i in 0...songs.length)
			if (FlxG.mouse.overlaps(sngs.members[i]) && FlxG.mouse.justPressed)
				FlxG.switchState(() -> new PlayState(songs[i][0], songs[i][1], songs[i][2] ?? null));
    }
}