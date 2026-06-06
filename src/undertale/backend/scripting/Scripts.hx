package undertale.backend.scripting;

import undertale.backend.scripting.HScript;
import flixel.FlxBasic;

class Scripts extends FlxBasic {
	public var group:Array<HScript>;

    public var publicVariables:Map<String, Dynamic> = [];
    public var parent(default, set):Dynamic;

    public var maxSize:Int = -1;
    public function new(?maxSize:Int = -1) {
        super();

		this.maxSize = maxSize;
		this.group = new Array<HScript>();
    }

    //Script functions

    public function importScript(path:String):Null<HScript> {
		var script:HScript = new HScript(path, {parent: this.parent});
        try {
			this.add(script);
			script.runFile(path);
        } catch(e:Dynamic) {
            trace('Error importing "${path}": ${Std.string(e)}');
            if(script != null) this.remove(script);
        }

		return script;
    }

	/*
	 * Sets a variable for all scripts.
	 */
    public function set(name:String, value:Dynamic) {
        for(script in this.group) {
            script.set(name, value);
        }
    }

    /*
     * Gets a variable from all scripts. The latest checked script with the variable
     * will have that variable returned.
     */
	public function get(name:String):Dynamic {
        var retVal = null;
		for (script in this.group) {
			var ret = script.get(name);
			if (ret != null) retVal = ret;
		}

        return retVal;
	}

	/*
	 * Calls a function from all scripts. The latest called script with something other than
	 * null will have it's return value returned.
	 */
	public function call(func:String, ?args:Array<Dynamic>):Dynamic {
		var retVal = null;
		for (script in this.group) {
			var ret = script.call(func, args ?? []);
			if (ret != null) retVal = ret;
		}

		return retVal;
	}

    // Group functions

    public inline function contains(x:HScript):Bool {
        return (this.group.contains(x));
    }

	public function add(x:HScript):HScript {
		if (maxSize != -1 && group.length >= maxSize) return x;

        group.push(x);
		__initScript(x);
        return x;
    }

	public function insert(x:HScript, index:Int):HScript
	{
		if (maxSize != -1 && group.length >= maxSize) return x;

		group.insert(index ?? group.length, x);
		__initScript(x);
		return x;
	}

	public function remove(x:HScript):HScript
	{
		group.remove(x);
		return x;
	}

	public inline function pop():HScript
	{
		return group.pop();
	}

    public override function destroy() {
        for(script in this.group) {
            script.destroy();
			this.group.remove(script);
            script = null;
        }

        super.destroy();
    }

	public function __initScript(script:HScript) {
        script.parent = this.parent;
        script.interp.publicVariables = this.publicVariables;
        script.call("newPost");
    }

	public function set_parent(val:Dynamic):Dynamic {
        this.parent = val;
        for(script in this.group) {
			script.parent = this.parent;
        }

        return this.parent;
    }
}