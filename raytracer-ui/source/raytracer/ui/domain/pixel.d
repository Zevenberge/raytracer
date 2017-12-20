module raytracer.ui.domain.pixel;

import std.algorithm.comparison : min;
import dsfml.graphics.color;
import raytracer.domain.coordinate;

struct Pixel
{
    this(const Coordinate coordinate, const float intensity)
    {
        this.coordinate = coordinate;
        auto greyValue = cast(ubyte)(min(255, 255*intensity));
        this.color = Color(greyValue, greyValue, greyValue, 255);
    }

    const Coordinate coordinate;
    const Color color;
}
