package backend;

@:publicFields class Paths {
    static inline function image(key:String) {
        return 'assets/images/$key.png';
    } 
}