/**
 * Well... uhm, this is for those guys who dont really like typing `UNOSprite`
 * but `FunkinSprite`, this is literally UNOSprite with other name, and thats it...
**/

package game.objects;

import game.objects.UNOSprite;

class FunkinSprite extends UNOSprite {
    public function new(x:Int, y:Int, image:String, settings:SpriteSettings):Void
        super(x, y, image, settings);
}