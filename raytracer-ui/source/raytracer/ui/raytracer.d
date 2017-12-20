module raytracer.ui.raytracer;

//import std.parallelism;
import dsfml.graphics.color;
import dsfml.graphics.image;
import dsfml.graphics.rendertarget;
import dsfml.graphics.sprite;
import dsfml.graphics.texture;
import dsfml.graphics.transformable;
import dsfml.system.vector2;
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
        _texture = new Texture();
        _texture.loadFromImage(_image);
        _sprite = new Sprite(_texture);
    }

    private Scene _scene;
    private Image _image;
    private Texture _texture;
    private Sprite _sprite;

    Transformable transformable() {return _sprite;}
    alias transformable this;

    void draw(RenderTarget target)
    {
        auto pixels = _scene.calculateColoredPixels();
        foreach(pixel; pixels)//.parallel // Tell X11 that everything will be ok...
        {
            _image.setPixel(pixel.coordinate.x, pixel.coordinate.y, pixel.color);
        }
        _texture.loadFromImage(_image);
        target.draw(_sprite);
    }
}

class RaytracerController : Controller
{
    this(Application application, Scene scene)
    {
        _application = application;
        _raytracer = new Raytracer(scene);
        _raytracer.position = Vector2f(50,50);
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
