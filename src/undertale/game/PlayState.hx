package undertale.game;

import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import undertale.objects.*;
import undertale.objects.Heart.HeartType;
import undertale.game.ui.*;

class PlayState extends BaseState
{
	public var box:Box;
	public var heart:Heart;
	public var actor:Actor;
	public var hud:HUD;

	public var isHit:Bool = false;

	override public function create()
	{
		super.create();

		actor = Actor.load('sans');
		actor.scale.set(2, 2);
		actor.updateHitbox();
		actor.screenCenter();
		actor.y -= 150;
		add(actor);

		hud = new HUD();
		add(hud);

		box = new Box(0, 0, 250, 250);
		box.screenCenter();
		add(box);

		heart = new Heart(0, 0);
		heart.screenCenter();
		add(heart);

		new FlxTimer().start(2, tmr -> box.tweenSize(500, 150, .15, {onUpdate: twn -> box.screenCenter()}));
	}

	var ghostCooldown:Float = 0.025;
	var shootCooldown:Float = 0;
	var karmaCooldown:Float = 0;
	var krIFrame:Float = 0;
	var iFrames:Float = 0;
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

		if (FlxG.keys.pressed.Q) hurt(1, true);
		if (FlxG.keys.pressed.W) heal(1);
		if (FlxG.keys.pressed.E) heal(Player.maxHealth);
		Player.health = Std.int(FlxMath.bound(Player.health, 0, Player.maxHealth - Player.karma));
		Player.karma = Std.int(FlxMath.bound(Player.karma, 0, Player.maxHealth - Player.health));

		karmaCooldown -= elapsed;
		if (karmaCooldown <= 0) {
			karmaCooldown = 1;
			Player.karma -= 1;
		}

		iFrames -= elapsed;
		krIFrame -= elapsed;
		if (isHit && iFrames <= 0) {
			hurt(Flags.damage);
		}

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

		if (heart.heartType == JUSTICE) {
			if (shootCooldown > 0) shootCooldown -= elapsed;
			if (controls.GAME_SHOOT_P && shootCooldown <= 0) {
				var bullet = new Bullet(heart.x, heart.y, 0xFFFFFF00);
				FlxG.sound.play(Util.getSound('shoot'), 1);
				bullet.x = heart.x + ((heart.sprite.width - bullet.width) / 2);
				add(bullet);
				bullet.velocity.y = -300;
				shootCooldown = 0.1;
			}
		}
	}

	public inline function heal(amount:Int)
		Player.health += amount;

	public inline function hurt(amount:Int, inflictKarma:Bool = false) {
		if (inflictKarma) {
			if (krIFrame <= 0) { 
				krIFrame = 0.02;
				if (Player.health == 1) {
					if (Player.karma <= 0)
						Player.health -= amount;
					else
						Player.karma -= amount;
				} else { 
					Player.karma += amount; 
					Player.health -= 1; 
				}
			}
		} else {
			if (iFrames <= 0) {
				iFrames = 1/3;
				Player.health -= amount;
			}
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
