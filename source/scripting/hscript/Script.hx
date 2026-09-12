package scripting.hscript;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;

class Script
{
    public var iris:Iris;

    public function new(path:String, insertedCode:Bool = false)
    {
        final rules:RawIrisConfig = {
            name: insertedCode ? 'Nameless Script' : path,
            autoRun: false,
            autoPreset: true
        };

        var text:String = '';

        if (insertedCode)
            text = path;
        else
            text = Paths.getContent(path);

        iris = new Iris(text, rules);

        iris.execute();
    }

    public function call(func:String, ?args:Array<Dynamic>):Dynamic
    {
        return iris.call(func, args ?? []);
    }
}