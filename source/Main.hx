package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		Preferences.init();
		addChild(new FlxGame(0, 0, game.PlayState, 60, 60, true));
	}
}
