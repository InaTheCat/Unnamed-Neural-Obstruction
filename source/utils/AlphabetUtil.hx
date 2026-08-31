package utils;

class AlphabetUtil {
	private static final replacement:Map<String, String> = [
		// Numbers
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
		// Brackets
		'{' => 'curlybracket-left',
		'}' => 'curlybracket-right',
		'(' => 'roundbracket-left',
		')' => 'roundbracket-right',
		'[' => 'squarebracket-left',
		']' => 'squarebracket-right',
		'<' => 'anglebracket-left',
		'>' => 'anglebracket-right',
		// random bs???
		"'" => 'singlequote',
		'"' => 'doulequote',
		"$" => 'dollar',
		"%" => 'percent',
		"!" => 'exclamationmark',
		"#" => 'pound',
		'&' => 'ampersand',
		'/' => 'slash',
		'=' => 'equal',
		'?' => 'questionmark',
		'.' => 'period',
		'-' => 'hypen',
		'~' => 'tilde',
		'|' => 'verticalbar',
		'←' => 'arrow-left',
		'↑' => 'arrow-down',
		'↓' => 'arrow-up',
		'→' => 'arrow-right',
		'^' => 'caret',
		'\\' => 'backslash',
		'×' => 'multiply',
		'@' => 'at',
		'æ' => 'ash',
		'œ' => 'ethel'
	];

	public static function check(input:String, extra:{full:String, textNum:Int}):String
	{
        var found:Bool = replacement.exists(input);

		if (found)
			Logs.send('[${extra.full} | Index: ${extra.textNum}] Letter given has replacement [$input -> ${replacement.get(input)}]',
				{type: SourceInfo, showShooter: false});

        return found ? replacement.get(input) : input;
    }
}