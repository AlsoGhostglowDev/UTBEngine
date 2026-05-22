package game;

import flixel.util.FlxTimer;
import objects.*;

class PlayState extends FlxState
{
	public var box:Box;
	public var heart:Heart;
	override public function create() {
		super.create();

		box = new Box(0, 0, 250, 250);
		box.screenCenter();
		add(box);

		heart = new Heart(0, 0);
		heart.screenCenter();
		add(heart); 

		new FlxTimer().start(1, tmr -> box.tweenSize(500, 150, .15, {onUpdate: twn -> box.screenCenter()}));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
