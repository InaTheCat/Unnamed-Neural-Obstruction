package game.score;

class ScoreManager
{
	public var score:Int = 0;
	public var misses:Int = 0;

	public var totalHits:Int = 0;
	public var totalNotes:Int = 0;

	public function new() {}

	public function addTapScore(rating:String):Void
	{
		totalNotes++;

		switch (rating)
		{
			case "sick":
				score += 500;
				totalHits += 100;

			case "good":
				score += 350;
				totalHits += 75;

			/*case "oks":
				score += 250;
				totalHi
			*/

			case "bad":
				score += 150;
				totalHits += 40;

			case "shit":
				score += 50;
				totalHits += 10;
		}
	}

	public function addHoldScore(points:Int):Void
	{
		score += points;
	}

	public function addMiss():Void
	{
		misses++;
		totalNotes++;
	}

	public function getAccuracy():Float
	{
		if (totalNotes <= 0) return 0;
		return totalHits / totalNotes;
	}
}