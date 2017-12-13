module raytracer.ui.domain.scene;

import std.algorithm.iteration : map;
import dsfml.graphics.color;
import raytracer.domain.scene;
import raytracer.ui.domain.pixel;

auto calculateColoredPixels(Scene scene)
{
    return scene.calculatePixels().map!(px => Pixel(px.coordinate, px.intensity));
}
