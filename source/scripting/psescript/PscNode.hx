package scripting.psescript;

/**
 * PscNode
 * Represents a parsed sentence of the .psc.
 * The interpreter reciebs an `Array<PscNode>` and it exec one-by-one.
*/
enum PscNode {
    /** Definir/definir/define/var <name> como <tipo> */
    DeclareVar(name:String, type:String);

    /** <varName>.sprite = "path/image" */
    SetSprite(varName:String, imagePath:String);

    /** <varName>.pos(x, y) */
    SetPos(varName:String, x:Float, y:Float);

    /** <varName>.scale(x, y) */
    SetScale(varName:String, x:Float, y:Float);

    /** <varName>.alpha(value) */
    SetAlpha(varName:String, value:Float);

    /** <varName>.visible(true|false) */
    SetVisible(varName:String, value:Bool);

    /** <varName>.<property> = <value>  (generic property as String-Type) */
    SetProperty(varName:String, prop:String, value:String);

    /** add(<varName>) */
    AddToScene(varName:String);

    /** Line that the interpreted didnt... interpreted... (for debuging shii)*/
    Unknown(raw:String);
}
