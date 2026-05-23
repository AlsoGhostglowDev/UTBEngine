package undertale.game;

import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import undertale.objects.*;

class PlayState extends BaseState
{
	public var box:Box;
	public var heart:Heart;
	public var actor:Actor;

	override public function create()
	{
		super.create();

		actor = Actor.load('sans');
		actor.scale.set(2, 2);
		actor.updateHitbox();
		actor.screenCenter();
		actor.y -= 150;
		add(actor);

		box = new Box(0, 0, 250, 250);
		box.screenCenter();
		add(box);

		heart = new Heart(0, 0);
		heart.screenCenter();
		add(heart);

		new FlxTimer().start(2, tmr -> box.tweenSize(500, 150, .15, {onUpdate: twn -> box.screenCenter()}));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// 16 = heart size, 5 = box border thickness
		heart.x = FlxMath.bound(heart.x, box.x + 5, box.x + box.boxWidth - 16 - 5);
		heart.y = FlxMath.bound(heart.y, box.y + 5, box.y + box.boxHeight - 16 - 5);
	}
}
