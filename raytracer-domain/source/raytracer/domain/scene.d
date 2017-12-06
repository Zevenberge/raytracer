module raytracer.domain.scene;

import raytracer.domain.lightsource;
import raytracer.domain.shape;
import raytracer.domain.viewport;

class Scene
{
    this(Viewport viewport, LightSource[] lightSources, Shape[] shapes)
    in
    {
        assert(viewport, "I need a viewport");
        assert(lightSources.length != 0, "It's too dark. Have a light source.");
    }
    do
    {
        _viewport = viewport;
        _lightSources = lightSources;
        _shapes = shapes;
    }

    private Viewport _viewport;
    private LightSource[] _lightSources;
    private Shape[] _shapes;
}
