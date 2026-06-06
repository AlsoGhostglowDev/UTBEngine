package;

import undertale.game.PlayState;
import undertale.states.debug.ActorEditorState;
import flixel.FlxGame;
import openfl.display.Sprite;
#if DEBUG_INFORMATION
import undertale.backend.debug.Framerate;
#end

class Main extends Sprite
{
	#if DEBUG_INFORMATION
	public static var debugText:Framerate;
	#end

	public function new()
	{
		super();

		Preferences.init();
		addChild(new FlxGame(0, 0, PlayState, 60, 60, true));

		#if DEBUG_INFORMATION
		debugText = new Framerate();
		addChild(debugText);
		#end
	}
}
