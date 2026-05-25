package undertale.game;

import flixel.util.FlxSave;

class Flags {
    static var __save:FlxSave;
    public static var fun:Int = 0;
    public static var damage:Int = 1; // opponent's attack damage
    public static var defense:Int = 0; // player's defense stat

    public static function init() {
        __save = new FlxSave();
        __save.bind('flags', 'com.ghostglowdev.utbengine');

        if (__save.data.fun == null)
            resetFun();
        else
            fun = __save.data.fun;
    }

    public static function resetFun()
        fun = FlxG.random.int(1, 100);

    public static function saveFlags() {
        __save.data.fun = fun;
        __save.flush();
    }
}