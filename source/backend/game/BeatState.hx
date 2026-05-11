package backend.game;

import flixel.FlxState;

// import vupx.states.VpState;

class RhythmState extends FlxState {
	public var curStep:Int = 0;
	public var curBeat:Int = 0;
	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;

	override public function update(elapsed:Float) {
		super.update(elapsed);

		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep) {
			if (curStep > 0)
				stepHit();
		}
	}

	private function updateBeat():Void {
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep / 4;
	}

	private function updateCurStep():Void {
		var stepCrochet = (60.0 / Conductor.bpm) * 1000.0 / 4.0;
		curDecStep = Conductor.songPosition / stepCrochet;
		curStep = Math.floor(curDecStep);
	}

	// Functions

	public function stepHit():Void {
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void {}
}