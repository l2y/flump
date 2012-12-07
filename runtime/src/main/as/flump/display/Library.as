//
// Flump - Copyright 2012 Three Rings Design

package flump.display {

import starling.display.DisplayObject;

/**
 * Container for Movie and texture symbols created by the flump exporter.
 */
public interface Library
{
    /** @return the names of all Movie symbols in the Library */
    function get movieSymbols () :Vector.<String>;

    /** @return the names of all iamge symbols in the Library */
    function get imageSymbols () :Vector.<String>;

    /**
     * Creates a movie for the given symbol.
     *
     * @param symbol the symbol name of the movie to be created
     *
     * @return a Movie instance for the symbol
     *
     * @throws Error if there is no such symbol in these resources, or if the symbol isn't a Movie.
     */
    function createMovie (symbolName :String) :Movie;

    /**
     * Creates an image for the given symbol.
     *
     * @param symbol the symbol name of the image to be created
     *
     * @return a DisplayObject instance for the symbol
     *
     * @throws Error if there is no such symbol in these resources, or if the symbol isn't a texture.
     */
    function createImage (symbol :String) :DisplayObject;

    /** Creates an instance of the given Movie or Image symbol */
    function instantiateSymbol (name :String) :DisplayObject;
}

}
