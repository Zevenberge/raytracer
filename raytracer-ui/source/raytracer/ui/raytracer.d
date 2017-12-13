module raytracer.ui.raytracer;

import dsfml.window.event;
import dsfml.graphics.rendertarget;
import raytracer.domain.scene;
import raytracer.ui.framework.application;
import raytracer.ui.framework.controller;

class Raytracer
{
    this(Scene scene)
    {
        _scene = scene;
    }

    private Scene _scene;

    void draw(RenderTarget target)
    {

    }
}

class RaytracerController : Controller
{
    this(Application application, Raytracer raytracer)
    {
        _application = application;
        _raytracer = raytracer;
    }

    private Application _application;
    private Raytracer _raytracer;

    void draw(RenderTarget target)
    {
        _raytracer.draw(target);
    }

    void handle(Event event)
    {

    }
}
