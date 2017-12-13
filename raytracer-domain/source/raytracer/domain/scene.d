module raytracer.domain.scene;

import std.algorithm.iteration;
import raytracer.domain.pixel;
import raytracer.domain.viewport;
import raytracer.maths.lightsource;
import raytracer.maths.point;
import raytracer.maths.shape;

class Scene
{
    this(Point viewpoint, Viewport viewport, LightSource[] lightSources, Shape[] shapes)
    in
    {
        assert(viewport, "I need a viewport");
        assert(lightSources.length != 0, "It's too dark. Have a light source.");
    }
    do
    {
        _viewpoint = viewpoint;
        _viewport = viewport;
        _lightSources = lightSources;
        _shapes = shapes;
    }

    private Point _viewpoint;
    private Viewport _viewport;
    private LightSource[] _lightSources;
    private Shape[] _shapes;

    auto calculatePixels()
    {
        return _viewport.getViewLines(_viewpoint)
            .map!(vl => Pixel(vl.coordinate, vl.line.calculateIntensity(_lightSources, _shapes)));
    }
}
