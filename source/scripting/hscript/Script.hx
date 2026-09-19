package scripting.hscript;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;

class Script
{
    public var iris:Iris;

	public function new(path:String, insertedCode:Bool = false, firstCall:String = 'create')
    {
        final rules:RawIrisConfig = {
            name: insertedCode ? 'Nameless Script' : path,
            autoRun: false,
            autoPreset: true
        };

		var text:String = insertedCode ? path : Paths.getContent(path);

        iris = new Iris(text, rules);

        iris.execute();
		if (insertedCode)
			iris.call(firstCall);
    }

    public function call(func:String, ?args:Array<Dynamic>):Dynamic
    {
        return iris.call(func, args ?? []);
    }
}