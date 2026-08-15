package utils;

class AlphabetUtil {
	private static final replacement:Map<String, String> = [
		'0' => 'zero',
		'1' => 'one',
		'2' => 'two',
		'3' => 'three',
		'4' => 'four',
		'5' => 'five',
		'6' => 'six',
		'7' => 'seven',
		'8' => 'eight',
		'9' => 'nine',
	];

    public static function check(input:String):String {
        var found:Bool = replacement.exists(input);

        if (found)
            Logs.send('Letter given has replacement [$input -> ${replacement.get(input)}]', {type: 'Source Info'});

        return found ? replacement.get(input) : input;
    }
}