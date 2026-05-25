package undertale.backend;

import openfl.media.Sound;

@:publicFields class Util {
    static function getSound(name:String):Sound {
        return Sound.fromFile(Paths.sound(name));
    }
}