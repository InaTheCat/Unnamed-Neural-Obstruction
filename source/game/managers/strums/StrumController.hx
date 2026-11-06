package game.managers.strums;

import flixel.input.keyboard.FlxKey;
import game.chart.UNOChart;
import game.managers.strums.HitWindow;
import game.notes.Note;
import game.notes.StrumLine;
import openfl.events.KeyboardEvent;
import states.PlayState;

class StrumController {
	public var state:PlayState;
    public var parent:StrumLine;

    public var curKeybinds:Array<FlxKey> = [];

    var notes:Array<StrumNotes>;
    var spawnedNotes:Array<Note> = [];

    public var lastPressed:Bool = false;
	public var lastRating:String = '';

    /**
     * if for SOME FUCKING REASON u wanna set this things off, well, u can,
     * but nothing else than `inputUpdating` is... uhm, useful??? ig man, ion fucking know
    **/
    public var positionUpdating:Bool = true;
    public var inputUpdating:Bool = true;
    public var controllerUpdating:Bool = true;

    public var ratingWindow:RatingWindow = new RatingWindow();

    public function new(strum:StrumLine, ?chartNotes:Array<StrumNotes>) {
        parent = strum;
		state = strum.stateParent;

        notes = chartNotes;

        if (parent.isPlayer){
            curKeybinds = Options.keybinds.get(parent.keyCount) ?? [Q, W, O, P];

            FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPress);
            FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onRelease);
        }

        if (notes != null && notes.length > 0) {
            generateNotes();
            updatePos();
        }
    }

    public function update() {
        if (!controllerUpdating)
            return;
    
        if (positionUpdating)
            updatePos();

        var i = spawnedNotes.length - 1;
    
        while (i >= 0) {
            var note = spawnedNotes[i];
    
            if (note == null) {
                i--;
                continue;
            }
    
            if (note.y <= -200) {
				parent.character.miss(note.dir);

				if (state != null)
					state.combo = 0;

                removeNoteAt(i);
                i--;
                continue;
            }
    
            note.exists = note.y <= FlxG.height;
    
            i--;
        }

        if (!parent.isPlayer)
            updateCpuInput();
    }

    public function removeNoteAt(i:Int) {
        var note = spawnedNotes[i];
    
        if (note == null)
            return;
    
        spawnedNotes[i] = null;
    
        parent.unspawnNotes.remove(note);
        note.destroy();
    }

    public function updateCpuInput() {
        if (!inputUpdating)
            return;

        for (i in 0...spawnedNotes.length) {
            var note = spawnedNotes[i];
    
            if (note == null)
                continue;
    
            if (note.y <= parent.hitbox.y) {
                removeNoteAt(i);
                parent.playAnim(note.dir, 'confirm', true);
				if (parent.character != null)
					parent.character.sing(note.dir);

				if (parent.willMimic)
				{
					if (state != null)
					{
						state.combo++;
						state.comboGrp.showCombo('sick', state.combo);
					}
					parent.splashes[note.dir].hit();
				}
			}
		}
	}

	public function updateInput(dir:Int = 0)
	{
		if (!inputUpdating)
			return;

		var note = getClosestNote(dir);

		if (note == null)
			return;

		setLastRating(note);

		if (state != null)
			state.combo++;

		note.gotHit = true;
		lastPressed = true;

		var i = spawnedNotes.indexOf(note);
		if (i >= 0)
			removeNoteAt(i);
	}

	public function updatePos()
	{
        for (note in spawnedNotes) {
            if (note == null)
                continue;

			note.y = parent.getReceptor(note.dir).y + (note.strumTime - Conductor.songPosition) * 0.45 * parent.scrollSpeed;
        }
    }

    public function generateNotes()
        for (e in notes) {
            var receptor = parent.getReceptor(e.dir);
            var note = new Note(receptor.x - parent.unspawnNotes.x, e.time, parent._receptor(e.dir));
            spawnedNotes.push(note);
            parent.unspawnNotes.add(note);
        }

    public function onPress(k:KeyboardEvent) {
        for (i => e in curKeybinds)
            if (k.keyCode == e && !parent.notes[i].isDown){
				updateInput(i);

				parent.playAnim(i, lastPressed ? (lastRating == 'stupid' ? 'press' : 'confirm') : 'press');
				if (lastPressed && parent.character != null)
					if (lastRating == 'stupid')
					{
						if (state != null)
							state.combo = 0;
						parent.character.miss(i);
					}
					else
						parent.character.sing(i);

				if (lastPressed)
				{
					if (state != null)
						state.comboGrp.showCombo(lastRating, lastRating == 'stupid' ? null : state.combo);

					if (lastRating == 'sick')
						parent.splashes[i].hit();
				}

                lastPressed = false;
            }
    }

    public function onRelease(k:KeyboardEvent) {
        for (i => e in curKeybinds)
            if (k.keyCode == e)
                parent.playAnim(i, 'static');
    }

	public function getClosestNote(dir:Int):Note
	{
		var closest:Note = null;
		var closestDiff:Float = ratingWindow.miss;

		for (note in spawnedNotes)
		{
			if (note == null || !note.exists || !note.alive)
				continue;

			if (note.dir != dir)
				continue;

			var diff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			if (diff <= closestDiff)
			{
				closest = note;
				closestDiff = diff;
			}
		}

		return closest;
	}

	public function setLastRating(note:Note)
	{
		var diff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		var rating:String = 'shit';

		if (diff <= ratingWindow.sick)
			rating = 'sick';
		else if (diff <= ratingWindow.good)
			rating = 'good';
		else if (diff <= ratingWindow.bad)
			rating = 'bad';
		else if (diff <= ratingWindow.shit)
			rating = 'shit';
		else if (diff <= ratingWindow.miss)
			rating = 'stupid';

		lastRating = rating;
	}

    public function destroy() {
        if (parent.isPlayer) {
            FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPress);
            FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onRelease);
        }
    }
}