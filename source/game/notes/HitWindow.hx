package game.notes;

abstract RatingWindows(Array<Float>)
{
	public inline function new(
		sick:Float = 45,
		good:Float = 90,
		bad:Float = 135,
		shit:Float = 166,
		miss:Float = 180
	)
	{
		this = [
			sick,
			good,
			bad,
			shit,
			miss
		];
	}

	public var sick(get, set):Float;

	inline function get_sick():Float
		return this[0];

	inline function set_sick(value:Float):Float
		return this[0] = value;


	public var good(get, set):Float;

	inline function get_good():Float
		return this[1];

	inline function set_good(value:Float):Float
		return this[1] = value;


	public var bad(get, set):Float;

	inline function get_bad():Float
		return this[2];

	inline function set_bad(value:Float):Float
		return this[2] = value;


	public var shit(get, set):Float;

	inline function get_shit():Float
		return this[3];

	inline function set_shit(value:Float):Float
		return this[3] = value;


	public var miss(get, set):Float;

	inline function get_miss():Float
		return this[4];

	inline function set_miss(value:Float):Float
		return this[4] = value;
}