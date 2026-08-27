package backend.chart;

typedef ParsedNote =
{
	time:Float,
	dir:Int,
	sustain:Float, // dur
	mustHit:Bool, // player - opp
	mustHitSection:Bool
}

typedef ParsedChart =
{
	notes:Array<ParsedNote>,
	sections:Array<ParsedChartSection>,
	bpm:Float,
	speed:Float
}

typedef ParsedChartSectionNoteData = Array<Dynamic>;

typedef ParsedChartSection =
{
	sectionNotes:Array<ParsedChartSectionNoteData>,
	mustHitSection:Bool
}

typedef ParsedChartSongData =
{
	notes:Array<ParsedChartSection>,
	?bpm:Float,
	?speed:Float
}

typedef ParsedChartFile =
{
	song:ParsedChartSongData
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