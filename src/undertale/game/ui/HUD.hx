package undertale.game.ui;

import flixel.group.FlxSpriteGroup;

class HUD extends FlxSpriteGroup {
    public var username:FlxText;
    public var level:FlxText;
    public var hp:FlxText;
    public var kr:FlxText;
    public var healthText:FlxText;
    public var healthBar:HealthBar;
    public var shieldBar:ShieldBar;
    public var buttons:Array<Button>;

    public function new() {
        super();

        username = new FlxText(30, 402, 0, Player.name);
        username.setFormat(Paths.font('mars.ttf'), 25, 0xFFFFFFFF);
        add(username);

        level = new FlxText(132, 402, 0, 'LV ' + Player.levelOfViolence);
        level.setFormat(Paths.font('mars.ttf'), 25, 0xFFFFFFFF);
        add(level);

        healthBar = new HealthBar(275, 400, Player.maxHealth);
        add(healthBar);

		hp = new FlxText(244, 402, 0, 'HP');
		hp.setFormat(Paths.font('wonder.ttf'), 10, 0xFFFFFFFF);
		add(hp);

		kr = new FlxText(healthBar.x + (Player.health * 2) + 10, 402, 0, 'KR');
		kr.setFormat(Paths.font('wonder.ttf'), 10, 0xFFFFFFFF);
		add(kr);

		healthText = new FlxText(kr.x + kr.width + 15, 0, 0, Player.health + ' / ' + Player.maxHealth);
		healthText.setFormat(Paths.font('mars.ttf'), 25, 0xFFFFFFFF);
		add(healthText);

        hp.y = healthBar.y + (healthBar.height - hp.height) / 2;
		kr.y = healthBar.y + (healthBar.height - kr.height) / 2;
		healthText.y = healthBar.y + (healthBar.height - healthText.height) / 2 + 5;

        //shieldBar = new ShieldBar(10, 30, Player, "karma", Player.maxHealth);
        //add(shieldBar);
        //buttons = [];
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        healthText.text = (Player.health + Player.karma) + ' / ' + Player.maxHealth;
        healthText.color = Player.karma > 0 ? 0xFFFF00FF : 0xFFFFFFFF;
    } 
}