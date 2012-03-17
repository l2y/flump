//
// Flump - Copyright 2012 Three Rings Design

package flump.xfl {

import flash.utils.Dictionary;

import flump.executor.load.LoadedSwf;
import flump.mold.KeyframeMold;
import flump.mold.LayerMold;
import flump.mold.Mold;
import flump.mold.MovieMold;

public class XflLibrary extends Mold
{
    // When an exported movie contains an unexported movie, it gets assigned a generated symbol name
    // with this prefix.
    public static const IMPLICIT_PREFIX :String = "~";

    public var swf :LoadedSwf;

    // The MD5 of the published library SWF
    public var md5 :String;

    public const movies :Vector.<MovieMold> = new Vector.<MovieMold>();
    public const textures :Vector.<XflTexture> = new Vector.<XflTexture>();

    public function XflLibrary(location :String) {
        this.location = location;
    }

    public function hasSymbol (symbol :String) :Boolean {
        return _symbols[symbol] !== undefined;
    }

    public function getSymbol (symbol :String, requiredType :Class=null) :* {
        const result :* = _symbols[symbol];
        if (result === undefined) throw new Error("Unknown symbol '" + symbol + "'");
        else if (requiredType != null) return requiredType(result);
        else return result;
    }

    public function getLibrary (name :String, requiredType :Class=null) :* {
        const result :* = _libraryItems[name];
        if (result === undefined) throw new Error("Unknown library item '" + name + "'");
        else if (requiredType != null) return requiredType(result);
        else return result;
    }

    public function finishLoading () :void {
        for each (var tex :XflTexture in textures) {
            _libraryItems[tex.libraryItem] = tex;
            _symbols[tex.symbol] = tex;
        }
        for each (var movie :MovieMold in movies) {
            if (movie.symbol != null) _symbols[movie.symbol] = movie;
            _libraryItems[movie.libraryItem] = movie;
        }

        for each (movie in movies) {
            for each (var layer :LayerMold in movie.layers) {
                for each (var kf :KeyframeMold in layer.keyframes) {
                    if (kf.libraryItem != null) {
                        var item :Object = _libraryItems[kf.libraryItem];
                        if (item.symbol == null) {
                            // This unexported movie was referenced, generate a symbol name for it
                            item.symbol = IMPLICIT_PREFIX + item.libraryItem;
                            _symbols[item.symbol] = item;
                        }
                        kf.symbol = item.symbol;
                    }
                }
            }
        }
    }

    public function getErrors (sev :String=null) :Vector.<ParseError> {
        if (sev == null) return _errors;
        const sevOrdinal :int = ParseError.severityToOrdinal(sev);
        return _errors.filter(function (err :ParseError, ..._) :Boolean {
            return err.sevOrdinal >= sevOrdinal;
        });
    }

    public function get valid () :Boolean {
        return getErrors(ParseError.CRIT).length == 0;
    }

    public function addError(mold :Mold, severity :String, message :String, e :Object=null) :void {
        _errors.push(new ParseError(mold.location, severity, message, e));
    }

    protected var _errors :Vector.<ParseError> = new Vector.<ParseError>;

    protected const _libraryItems :Dictionary = new Dictionary();
    protected const _symbols :Dictionary = new Dictionary();
}
}