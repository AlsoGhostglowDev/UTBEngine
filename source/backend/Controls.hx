package backend;

@:access(backend.Preferences)
class Controls {
	public var GAME_LEFT(get, never):Bool;
	public var GAME_DOWN(get, never):Bool;
	public var GAME_UP(get, never):Bool;
	public var GAME_RIGHT(get, never):Bool;
    public var GAME_SLOW(get, never):Bool;

	public var GAME_LEFT_P(get, never):Bool;
	public var GAME_DOWN_P(get, never):Bool;
	public var GAME_UP_P(get, never):Bool;
	public var GAME_RIGHT_P(get, never):Bool;
	public var GAME_SLOW_P(get, never):Bool;

	public var GAME_LEFT_R(get, never):Bool;
	public var GAME_DOWN_R(get, never):Bool;
	public var GAME_UP_R(get, never):Bool;
	public var GAME_RIGHT_R(get, never):Bool;
	public var GAME_SLOW_R(get, never):Bool;

    public var UI_LEFT(get, never):Bool;
	public var UI_DOWN(get, never):Bool;
	public var UI_UP(get, never):Bool;
	public var UI_RIGHT(get, never):Bool;

	public var UI_LEFT_P(get, never):Bool;
	public var UI_DOWN_P(get, never):Bool;
	public var UI_UP_P(get, never):Bool;
	public var UI_RIGHT_P(get, never):Bool;

	public var UI_LEFT_R(get, never):Bool;
	public var UI_DOWN_R(get, never):Bool;
	public var UI_UP_R(get, never):Bool;
	public var UI_RIGHT_R(get, never):Bool;

    function get_GAME_LEFT() return FlxG.keys.anyPressed(Preferences.__fields.GAME_LEFT);
    function get_GAME_DOWN() return FlxG.keys.anyPressed(Preferences.__fields.GAME_DOWN);
    function get_GAME_UP() return FlxG.keys.anyPressed(Preferences.__fields.GAME_UP);
    function get_GAME_RIGHT() return FlxG.keys.anyPressed(Preferences.__fields.GAME_RIGHT);
    function get_GAME_SLOW() return FlxG.keys.anyPressed(Preferences.__fields.GAME_SLOW);

    function get_GAME_LEFT_P() return FlxG.keys.anyJustPressed(Preferences.__fields.GAME_LEFT);
    function get_GAME_DOWN_P() return FlxG.keys.anyJustPressed(Preferences.__fields.GAME_DOWN);
    function get_GAME_UP_P() return FlxG.keys.anyJustPressed(Preferences.__fields.GAME_UP);
    function get_GAME_RIGHT_P() return FlxG.keys.anyJustPressed(Preferences.__fields.GAME_RIGHT);
    function get_GAME_SLOW_P() return FlxG.keys.anyJustPressed(Preferences.__fields.GAME_SLOW);

    function get_GAME_LEFT_R() return FlxG.keys.anyJustReleased(Preferences.__fields.GAME_LEFT);
    function get_GAME_DOWN_R() return FlxG.keys.anyJustReleased(Preferences.__fields.GAME_DOWN);
    function get_GAME_UP_R() return FlxG.keys.anyJustReleased(Preferences.__fields.GAME_UP);
    function get_GAME_RIGHT_R() return FlxG.keys.anyJustReleased(Preferences.__fields.GAME_RIGHT);
    function get_GAME_SLOW_R() return FlxG.keys.anyJustReleased(Preferences.__fields.GAME_SLOW);

    function get_UI_LEFT() return FlxG.keys.anyPressed(Preferences.__fields.UI_LEFT);
    function get_UI_DOWN() return FlxG.keys.anyPressed(Preferences.__fields.UI_DOWN);
    function get_UI_UP() return FlxG.keys.anyPressed(Preferences.__fields.UI_UP);
    function get_UI_RIGHT() return FlxG.keys.anyPressed(Preferences.__fields.UI_RIGHT);

    function get_UI_LEFT_P() return FlxG.keys.anyJustPressed(Preferences.__fields.UI_LEFT);
    function get_UI_DOWN_P() return FlxG.keys.anyJustPressed(Preferences.__fields.UI_DOWN);
    function get_UI_UP_P() return FlxG.keys.anyJustPressed(Preferences.__fields.UI_UP);
    function get_UI_RIGHT_P() return FlxG.keys.anyJustPressed(Preferences.__fields.UI_RIGHT);

    function get_UI_LEFT_R() return FlxG.keys.anyJustReleased(Preferences.__fields.UI_LEFT);
    function get_UI_DOWN_R() return FlxG.keys.anyJustReleased(Preferences.__fields.UI_DOWN);
    function get_UI_UP_R() return FlxG.keys.anyJustReleased(Preferences.__fields.UI_UP);
    function get_UI_RIGHT_R() return FlxG.keys.anyJustReleased(Preferences.__fields.UI_RIGHT);

    @:isVar public static var instance(get, null):Controls;
    static function get_instance() {
        if (instance == null) instance = new Controls();
        return instance;
    }

    public function new() {
        instance = this;
    }
}