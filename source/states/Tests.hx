package states;

import backend.TroubleShooter;
import backend.chart.CNEParser;
import backend.chart.PsychParser;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import states.UNOState;
import utils.Paths;

class Tests extends UNOState {
	var parseText:FlxText;

    override public function create() {
        super.create();
		
		// FlxG.camera.bgColor = 0xFFFFFFFF;

		// parseText = new FlxText(0, 0, 2000, PsychParser.parseChart('Premeditated', 'hard').toString()).setFormat(null, 12, 0xFFFFFFFF, 'center');
		// add(parseText);


		new FlxTimer().start(1, (_) -> {
			var lps:String = 'Info';

			if (_.loopsLeft >= 9 && _.loopsLeft <= 12) lps = 'Warning';
			if (_.loopsLeft >= 5 && _.loopsLeft <= 8) lps = 'Error';
			if (_.loopsLeft >= 0 && _.loopsLeft <= 4) lps = 'None';

			shoot('test message ${_.loopsLeft}', lps);
		}, 15);
    }

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.pressed.A) FlxG.camera.scroll.x -= 10;
		if (FlxG.keys.pressed.S) FlxG.camera.scroll.y += 10;
		if (FlxG.keys.pressed.W) FlxG.camera.scroll.y -= 10;
		if (FlxG.keys.pressed.D) FlxG.camera.scroll.x += 10;

		if (FlxG.mouse.wheel != 0)
			FlxG.camera.zoom += FlxG.mouse.wheel * 0.1;

		FlxG.camera.zoom = FlxMath.bound(FlxG.camera.zoom, 0.1, 5);
	}
}