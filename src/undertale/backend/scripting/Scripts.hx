package undertale.backend.scripting;

import undertale.backend.scripting.HScript;
import flixel.FlxBasic;

/*
 * A class that contains many hscript instances, similar
 * to FlxTypedGroup.
 */
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

    /* Script functions */

	/*
	 * Creates a new hscript instance and adds it to the group immediately.
	 */
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
    public inline function set(name:String, value:Dynamic) {
        for(script in this.group) {
            script.set(name, value);
        }
    }

    /*
     * Gets a variable from all scripts. The latest checked script with the variable
     * will have that variable returned.
     */
	public inline function get(name:String):Dynamic {
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

	/* Typed group functions */

	// Identical to `FlxTypedGroup.any`
	public inline function any(func:HScript->Bool):Bool {
		for(script in this.group) {
			if(func(script) == true) return true;
		}
		return false;
	}

	// Identical to `FlxTypedGroup.every`
	public inline function every(func:HScript->Bool):Bool {
		for(script in this.group) {
			if(func(script) == false) return false;
		}
		return true;
	}

	//Identical to `FlxTypedGroup.forEach` without the second parameter
	public inline function forEach(func:HScript->Bool):Bool {
		for(script in this.group) {
			if(func(script) == false) return false;
		}
		return true;
	}

	// Identical to `FlxTypedGroup.forEachAlive` without the second parameter
	public inline function forEachAlive(func:HScript->Void) {
		for(script in this.group) {
			if(script.active) func(script);
		}
	}

    /* Group functions */

	/*
	 * Returns true if the group contains `x` hscript instance.
	 */
    public inline function contains(x:HScript):Bool {
        return (this.group.contains(x));
    }

	/*
	 * Adds an hscript instance to the group.
	 * Warning: This means that callbacks called before being added won't have access
	 * to the group or it's parent. Use `importScript` for that.
	 */
	public function add(x:HScript):HScript {
		if (maxSize != -1 && group.length >= maxSize) return x;

        group.push(x);
		__initScript(x);
        return x;
    }

	/*
	 * Inserts an hscript instance into index `index` of group.
	 * Warning: This means that callbacks called before being added won't have access
	 * to the group or it's parent. Use `importScript` for that.
	 */
	public function insert(x:HScript, index:Int):HScript
	{
		if (maxSize != -1 && group.length >= maxSize) return x;

		group.insert(index ?? group.length, x);
		__initScript(x);
		return x;
	}

	/*
	 * Removes an hscript instance from the group. This does NOT
	 * destroy the instance, it simply removes it.
	 */
	public function remove(x:HScript):HScript
	{
		group.remove(x);
		return x;
	}

	/*
	 * Removes the latest added hscript instance from the group
	 * and returns it.
	 */
	public inline function pop():HScript
	{
		return group.pop();
	}

	/*
	 * Destroys the group and all scripts still inside of it.
	 */
    public override function destroy() {
        for(script in this.group) {
            script.destroy();
			this.group.remove(script);
            script = null;
        }

        super.destroy();
    }

	/*
	 * Used internally by `add`, `insert`, and `importScript` for new scripts being
	 * added. This gives the script access to the group's parent and public variables.
	 */
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