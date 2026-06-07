package undertale.backend;

#if HSCRIPT_ALLOWED
import flixel.util.FlxStringUtil;

import undertale.backend.scripting.Scripts;
import undertale.backend.scripting.HScript;
#end

class BaseState extends FlxState {
    public var variables:Map<String, Dynamic> = [];
    #if HSCRIPT_ALLOWED
    public var stateScripts:Scripts;
    public var scriptsAllowed:Bool = true;
    #end

    public var controls:Controls;
    public function new() {
        super();
        controls = Controls.instance;

		#if HSCRIPT_ALLOWED
		if (scriptsAllowed) {
			var stateName:String = FlxStringUtil.getClassName(this, true);
			stateScripts = new Scripts();
			stateScripts.parent = this;

			for (script in Paths.checkScriptsInDirectory('data/states/$stateName/', false)) {
				stateScripts.importScript(script);
            }
			call("create");
        }
        #end

        call("createPost");
    }

    public override function update(elapsed:Float) {
		call("update", [elapsed]);

        super.update(elapsed);

		call("updatePost", [elapsed]);
    }

    public override function destroy() {
        call("destroy");
        #if HSCRIPT_ALLOWED
		if (stateScripts != null) {
			stateScripts.destroy();
			stateScripts = null;
        }
        #end

        super.destroy();
    }

    public inline function call(func:String, ?args:Array<Dynamic>) {
        #if HSCRIPT_ALLOWED
		if (stateScripts != null) stateScripts.call(func, args);
        #end
    }

    public inline function importScript(path:String):Null<HScript> {
		#if HSCRIPT_ALLOWED
        return (stateScripts != null ? stateScripts.importScript(path) : null);
        #end
    }
}