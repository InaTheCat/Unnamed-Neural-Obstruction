package game.notes;

import backend.chart.NewTestChartparser.ParsedNote;
import backend.game.Conductor;

class NoteManager extends FlxSpriteGroup
{
	public var unspawnNotes:Array<ParsedNote> = []; //idiotas que no aparecen
	public var activeNotes:Array<Note> = [];

	public var playerStrum:StrumLine;

	public var spawnAhead:Float = 2000;
	public var spawnDistance:Float = 500;
	//public var hitWindow:Float = 45; ni su ptmr

	public var sustainAlpha:Float = 0.9; //0.9

	public var activeSustains:Array<SustainNote> = [];


	public var sickWindow:Float = 45;
	public var goodWindow:Float = 90;
	public var badWindow:Float = 135;
	public var shitWindow:Float = 166;
	public var missWindow:Float = 180;

	public var onSustainScore:Int->Void;
	public var onSustainNote:Note->Void;
	public var onMiss:Void->Void;
	public var onNoteHit:Note->Void;

	public var holdClipOffsetY:Float = 35;

	public var cpu:Bool = false;

	public var downscroll:Bool = Options.downscroll;

	private var scrollDir:Int = 1;

	public function new(playerStrum:StrumLine, notes:Array<ParsedNote>)
	{
		super();

		this.playerStrum = playerStrum;
		this.unspawnNotes = notes.copy();
	}

	public var heldDirs:Array<Bool> = [false, false, false, false];

	public function setHeld(dir:Int, held:Bool):Void
	{
		if (dir >= 0 && dir < heldDirs.length)
			heldDirs[dir] = held;
	}

	public var baseScrollSpeed:Float = 450;

	public function updateNotes():Void
	{
		scrollDir = downscroll ? -1 : 1;

		for (noteData in unspawnNotes.copy())
		{
			if (noteData.time <= Conductor.songPosition + spawnAhead)
			{
				spawnNote(noteData);
				unspawnNotes.remove(noteData);
			}
		}

//xd

		for (note in activeNotes.copy())
		{
			if (note == null || !note.exists || !note.alive)
				continue;

			if (note.whenhit && note.isHold)
			{
				var holdEndTime:Float = note.strumTime + note.sustain;

				if (Conductor.songPosition <= holdEndTime)
				{
					if (cpu || heldDirs[note.dir])
					{
						note.rewardSustainNote += FlxG.elapsed * 1000;
						if (!Options.vSliceSustains)
							note.sustainTimer += FlxG.elapsed * 1000;

						while (note.rewardSustainNote >= 100)
						{
							note.rewardSustainNote -= 100;

							if (onSustainScore != null)
								onSustainScore(100);
						}

						if (!Options.vSliceSustains)
							while (note.sustainTimer >= Conductor.stepCrochet)
							{
								note.sustainTimer -= Conductor.stepCrochet;

								if (onSustainNote != null)
									onSustainNote(note);
							}
					}
				}
				else
				{
					clearHoldNote(note);
				}
			}
		}

		for (note in activeNotes.copy())
		{
			if (note == null || !note.exists || !note.alive)
				continue;

			var receptor = playerStrum.getReceptor(note.dir % 4);
			var pixelsPerMs:Float = (baseScrollSpeed * Conductor.speed) / 1000;

			note.y = receptor.y + (note.strumTime - Conductor.songPosition) * pixelsPerMs * scrollDir;
			// note.y = receptor.y + (note.strumTime - Conductor.songPosition) * pixelsPerMs;
		}

		for (hold in activeSustains.copy())
		{
			if (hold == null || !hold.exists || !hold.alive)
				continue;

			if (hold.noteOrigin != null)
			{
				var receptor = playerStrum.getReceptor(hold.dir % 4);
				var pixelsPerMs:Float = (baseScrollSpeed * Conductor.speed) / 1000;

				if (!hold.tail)
				{
					var startY:Float = downscroll ? hold.noteOrigin.y + -hold.noteOrigin.height * 1.85 : hold.noteOrigin.y + hold.noteOrigin.height * 0.45;
					var endY:Float = startY + hold.fullHeight * scrollDir;
					// var endY:Float = hold.noteOrigin.y + hold.noteOrigin.height * 0.45 + hold.fullHeight;

					if (hold.noteOrigin.whenhit)
					{
						var clipY:Float = downscroll ? receptor.y - holdClipOffsetY : receptor.y + holdClipOffsetY;
						var clippedStartY:Float = downscroll ? Math.min(startY, clipY) : Math.max(startY, clipY);
						var visibleHeight:Float = downscroll ? clippedStartY - endY : endY - clippedStartY;

						if (visibleHeight <= 0)
						{
							hold.visible = false;
						}
						else
						{
							hold.visible = true;
							hold.y = clippedStartY;

							var oldBottom:Float = hold.y + hold.height;

							hold.scale.y = hold.normalScaleY * (visibleHeight / (downscroll ? -hold.baseHeight : hold.baseHeight));
							hold.updateHitbox();
							if (downscroll)
								hold.y = oldBottom - hold.height;
						}
					}
					else
					{
						hold.visible = true;
						hold.y = startY;
					}

					hold.x = hold.noteOrigin.x + (hold.noteOrigin.width - hold.width) / 2;
				}
				else
				{
					if (hold.pair != null)
						hold.y = downscroll ? hold.pair.y - hold.height + 4 : hold.pair.y + hold.pair.height - 4;

					hold.x = hold.noteOrigin.x + (hold.noteOrigin.width - hold.width) / 2;
				}
			}
		}
		if (cpu)
			updatenoNotes(); //kade engine
	}

	function isDirectionHeld(dir:Int):Bool
	{
		return switch (dir)
		{
			case 0: Controls.getKeyPressed(0) || Controls.getKeyHeld(0);
			case 1: Controls.getKeyPressed(1) || Controls.getKeyHeld(1);
			case 2: Controls.getKeyPressed(2) || Controls.getKeyHeld(2);
			case 3: Controls.getKeyPressed(3) || Controls.getKeyHeld(3);
			default: false;
		}
	}

	function updatenoNotes():Void
	{
		for (note in activeNotes.copy())
		{
			if (note == null || !note.exists || !note.alive || note.whenhit)
				continue;

			if (Conductor.songPosition >= note.strumTime)
			{
				if (onNoteHit != null)
					onNoteHit(note);

				if (note.isHold)
				{
					note.whenhit = true;
					note.holding = true;
					note.visible = false;
				}
				else
					clearHoldNote(note);
			}
		}
	}

	function clearHoldNote(note:Note):Void
	{
		for (hold in activeSustains.copy())
		{
			if (hold != null && hold.noteOrigin == note)
			{
				activeSustains.remove(hold);
				remove(hold, true);
				hold.destroy();
			}
		}

		activeNotes.remove(note);
		remove(note, true);
		note.destroy();
	}

	public function release(dir:Int):Void // chad slice
	{
		for (note in activeNotes.copy())
		{
			if (note == null || !note.exists || !note.alive)
				continue;

			if (note.dir != dir)
				continue;

			if (note.isHold && note.whenhit)
			{
				clearHoldNote(note);
				return;
			}
		}
	}

	function spawnNote(noteData:ParsedNote):Void
	{

		var dir:Int = noteData.dir % 4;
		var receptor = playerStrum.getReceptor(dir);

		var pixelsPerMs:Float = (baseScrollSpeed * Conductor.speed) / 1000;
		var startY:Float = receptor.y + (noteData.time - Conductor.songPosition) * pixelsPerMs * scrollDir;
		// var startY:Float = receptor.y + (noteData.time - Conductor.songPosition) * pixelsPerMs;

		var note:Note = new Note(0, startY, dir, noteData.time, noteData.sustain);
		note.scrollSpeed = baseScrollSpeed * Conductor.speed;
		note.x = receptor.x + (receptor.width - note.width) / 2;

		if (noteData.sustain > 0)
		{
			var pixelsPerMs:Float = note.scrollSpeed / 1000;
			var holdLength:Float = noteData.sustain * pixelsPerMs;

			var holdPiece:SustainNote = new SustainNote(0, 0, dir, false, holdLength, sustainAlpha);
			holdPiece.noteOrigin = note;
			holdPiece.strumTime = noteData.time;
			holdPiece.sustainLength = noteData.sustain;
			holdPiece.x = note.x + (note.width - holdPiece.width) / 2;
			add(holdPiece);
			activeSustains.push(holdPiece);

			var holdEnd:SustainNote = new SustainNote(0, 0, dir, true, holdLength, sustainAlpha);
			holdEnd.noteOrigin = note;
			holdEnd.strumTime = noteData.time + noteData.sustain;
			holdEnd.sustainLength = noteData.sustain;
			holdEnd.x = note.x + (note.width - holdEnd.width) / 2;
			add(holdEnd);
			activeSustains.push(holdEnd);

			holdPiece.pair = holdEnd;
			holdEnd.pair = holdPiece;
		}

		add(note);
		activeNotes.push(note);
	}

	public function press(dir:Int):NoteHitResult
	{
		var note:Note = getClosestNote(dir);

		if (note == null)
		{
			if (onMiss != null)
				onMiss();
			return MISS;
		}

		var diff:Float = note.strumTime - Conductor.songPosition;
		var thediff:Float = Math.abs(diff);

		var rating:String = "shit";

		if (thediff <= sickWindow)
			rating = "sick";
		else if (thediff <= goodWindow)
			rating = "good";
		else if (thediff <= badWindow)
			rating = "bad";
		else if (thediff <= shitWindow)
			rating = "shit";
		else
		{
			if (onMiss != null)
				onMiss();
			return MISS;
		}

		note.whenhit = true;

		if (onNoteHit != null)
			onNoteHit(note);

		if (note.isHold)
		{
			note.holding = true;
			note.visible = false;
		}
		else
			clearHoldNote(note);

		return HIT(note, diff, rating);
	}

	function getClosestNote(dir:Int):Note
	{
		var closest:Note = null;
		var closestDiff:Float = missWindow;

		for (note in activeNotes)
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
}
