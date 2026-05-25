package undertale.backend;

@:publicFields class Paths
{
	static inline function image(key:String)
	{
		return 'assets/images/$key.png';
	}

	static inline function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	static inline function sound(key:String)
	{
		return 'assets/sounds/$key.ogg';
	}

	static inline function music(key:String)
	{
		return 'assets/music/$key.ogg';
	}

	static inline function json(key:String)
	{
		return 'assets/data/$key.json';
	}
}
