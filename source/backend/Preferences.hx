package backend;

import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;

@:structInit class SavedFields {
    // game controls
    public var GAME_LEFT:Array<FlxKey>  = [ A, LEFT  ];
    public var GAME_DOWN:Array<FlxKey>  = [ S, DOWN  ];
    public var GAME_UP:Array<FlxKey>    = [ W, UP    ];
    public var GAME_RIGHT:Array<FlxKey> = [ D, RIGHT ];
    public var GAME_SLOW:Array<FlxKey>  = [ X, SHIFT ];
    
    // ui controls
    public var UI_LEFT:Array<FlxKey>     = [ A, LEFT  ];
    public var UI_DOWN:Array<FlxKey>     = [ S, DOWN  ];
    public var UI_UP:Array<FlxKey>       = [ W, UP    ];
    public var UI_RIGHT:Array<FlxKey>    = [ D, RIGHT ];
    public var UI_INTERACT:Array<FlxKey> = [ Z, ENTER ];

    public function new() {}
}

class Preferences {
    static var __save:FlxSave;
    static var __fields = new SavedFields();
    static var __default = new SavedFields();

    public static function init() {
        __save = new FlxSave();
        
        load();
        __save.bind('preferences' ,'com.ghostglowdev.utbengine');
        __save.flush();

        // in case
        FlxG.stage.window.onClose.add(save);
    }

    public static function load() {
        for (field in Reflect.fields(__default)) {
            var data:Dynamic;
            if ((data = Reflect.field(__save, field)) != null) {
                Reflect.setProperty(__fields, field, data);
            } else 
                Reflect.setProperty(__fields, field, Reflect.field(__default, field));
        }
    }

    public static function save() {
        __save.flush();
    }
}