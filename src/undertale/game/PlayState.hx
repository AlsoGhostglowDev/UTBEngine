package undertale.game;

import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import undertale.objects.*;
import undertale.objects.Heart.HeartType;

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

	var ghostCooldown:Float = 0.025;
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// 16 = heart size, 5 = box border thickness
		if ( ((heart.y < box.y + 5) || (heart.y > box.y + box.boxHeight - 16 - 5)) && !heart.canJump) {
			heart.canJump = true;
			@:privateAccess heart.jumpElapsed = 0;
		}

		heart.x = FlxMath.bound(heart.x, box.x + 5, box.x + box.boxWidth - 16 - 5);
		heart.y = FlxMath.bound(heart.y, box.y + 5, box.y + box.boxHeight - 16 - 5);

		if (FlxG.keys.justPressed.ONE) changeHeart(DETERMINATION);
		if (FlxG.keys.justPressed.TWO) changeHeart(INTEGRITY);
		if (FlxG.keys.justPressed.THREE) changeHeart(JUSTICE);
		if (FlxG.keys.justPressed.FOUR) changeHeart(PERSEVERANCE);
		if (FlxG.keys.justPressed.FIVE) changeHeart(KINDNESS);
		if (FlxG.keys.justPressed.SIX) changeHeart(BRAVERY);
		if (FlxG.keys.justPressed.SEVEN) changeHeart(PATIENCE);

		ghostCooldown -= elapsed;
		if (heart.heartType == BRAVERY && ghostCooldown < 0) {
			ghostCooldown = 0.025;
			final sprite = heart.sprite;
			final ghost = sprite.clone();
			ghost.setPosition(sprite.x, sprite.y);
			ghost.color = sprite.color;
			ghost.scale.set(sprite.scale.x, sprite.scale.y);
			ghost.updateHitbox();
			add(ghost);
			FlxTween.tween(ghost, {alpha: 0}, .5, {ease: FlxEase.expoOut, onComplete: twn -> {
				remove(ghost);
				ghost.destroy();
			}});
		}
	}

	public function changeHeart(type:HeartType) {
		heart.changeType(type);

		final sprite = heart.sprite;
		final trans = sprite.clone();
		trans.setPosition(sprite.x, sprite.y);
		trans.color = sprite.color;
		trans.scale.set(sprite.scale.x, sprite.scale.y);
		trans.updateHitbox();
		add(trans);
		FlxTween.tween(trans.scale, {x: trans.scale.x + .05, y: trans.scale.y + .05}, .8, {ease: FlxEase.expoOut});
		FlxTween.tween(trans, {alpha: 0}, .8, {ease: FlxEase.expoOut, onComplete: twn -> {
			remove(trans);
			trans.destroy();
		}});
	}
}
