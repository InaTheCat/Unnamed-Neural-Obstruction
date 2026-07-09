package backend.chart;

typedef ParsedNote =
{
	var time:Float;
	var dir:Int;
	var sustain:Float; //dur
	var mustHit:Bool; // player - opp
	var mustHitSection:Bool;
}

typedef ParsedChart =
{
	var notes:Array<ParsedNote>;
	var sections:Array<ParsedChartSection>;
	var bpm:Float;
	var speed:Float;
}

typedef ParsedChartSectionNoteData = Array<Dynamic>;

typedef ParsedChartSection =
{
	var sectionNotes:Array<ParsedChartSectionNoteData>;
	var mustHitSection:Bool;
}

typedef ParsedChartSongData =
{
	var notes:Array<ParsedChartSection>;
	var bpm:Null<Float>;
	var speed:Null<Float>;
}

typedef ParsedChartFile =
{
	var song:ParsedChartSongData;
}

class NewTestChartparser
{
	public static function parseChart(songName:String, difficulty:String):ParsedChart
	{
		var chart:Null<ParsedChartFile> = CoolUtil.parseJson('songs/$songName/chart/$difficulty');

		var result:Array<ParsedNote> = [];
		var sections:Array<ParsedChartSection> = [];

		if (chart == null || chart.song == null) //vr g
		{
			return {
				notes: result,
				sections: sections,
				bpm: 100,
				speed: 1
			};
		}

		var songData:ParsedChartSongData = chart.song;

		if (songData.notes != null)
		{
			sections = songData.notes;

			for (section in sections)
			{
				if (section == null || section.sectionNotes == null)
					continue;

				var mustHitSection:Bool = section.mustHitSection;
				var sectionNotes:Array<ParsedChartSectionNoteData> = section.sectionNotes;

				for (noteData in sectionNotes)
				{
					var rawDir:Int = Std.int(noteData[1]);
					var mustHit:Bool;

					if (mustHitSection)
						mustHit = rawDir < 4;
					else
						mustHit = rawDir >= 4;
				
					result.push({
						time: Std.parseFloat(Std.string(noteData[0])),
						dir: rawDir % 4,
						sustain: Std.parseFloat(Std.string(noteData[2])),
						mustHit: mustHit,
						mustHitSection: mustHitSection
					});
				}
			}
		}

		result.sort((a, b) -> Reflect.compare(a.time, b.time));

		return {
			notes: result,
			sections: sections,
			bpm: songData.bpm ?? 100,
			speed: songData.speed ?? 1
		};
	}
}