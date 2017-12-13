module raytracer.ui.raytracer;

import std.parallelism;
import dsfml.graphics.color;
import dsfml.graphics.image;
import dsfml.graphics.rendertarget;
import dsfml.window.event;
import raytracer.domain.scene;
import raytracer.ui.domain.scene;
import raytracer.ui.framework.application;
import raytracer.ui.framework.controller;

class Raytracer
{
    this(Scene scene)
    {
        _scene = scene;
        _image = new Image();
        _image.create(_scene.viewport.amountOfHorizontalPoints,
            _scene.viewport.amountOfVerticalPoints,
            Color.Red);
    }

    private Scene _scene;
    private Image _image;

    void draw(RenderTarget target)
    {
        auto pixels = _scene.calculateColoredPixels();
        foreach(pixel; pixels.parallel)
        {
            _image.setPixel(pixel.coordinate.x, pixel.coordinate.y, pixel.color);
        }
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
