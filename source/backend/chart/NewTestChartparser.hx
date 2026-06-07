package backend.chart;

import utils.CoolUtil;

typedef ParsedNote =
{
	var time:Float;
	var dir:Int;
	var sustain:Float; //dur
	var mustHit:Bool; // player - opp
}

typedef ParsedChart =
{
	var notes:Array<ParsedNote>;
	var bpm:Float;
	var speed:Float;
}

class NewTestChartparser
{
	public static function parseChart(songName:String, difficulty:String):ParsedChart
	{
		var chart:Dynamic = CoolUtil.parseJson('songs/$songName/chart/$difficulty');

		var result:Array<ParsedNote> = [];

		if (chart == null || chart.song == null) //vr g
		{
			return {
				notes: result,
				bpm: 100,
				speed: 1
			};
		}

		var songData:Dynamic = chart.song;

		if (songData.notes != null)
		{
			var sections:Array<Dynamic> = cast songData.notes;

			for (section in sections)
			{
				if (section == null || section.sectionNotes == null)
					continue;

				var sectionNotes:Array<Dynamic> = cast section.sectionNotes;

				for (noteData in sectionNotes)
				{
					var rawDir:Int = noteData[1];
					var sectionMustHit:Bool = section.mustHitSection == true;

					var isPlayerNotelol:Bool = sectionMustHit;

					result.push({
						time: noteData[0],
						dir: rawDir % 4,
						sustain: noteData[2],
						mustHit: isPlayerNotelol
					});
				}
			}
		}

		result.sort((a, b) -> Reflect.compare(a.time, b.time));

		return {
			notes: result,
			bpm: songData.bpm != null ? songData.bpm : 100,
			speed: songData.speed != null ? songData.speed : 1
		};
	}
}