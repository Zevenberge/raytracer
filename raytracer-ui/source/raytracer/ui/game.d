module raytracer.ui.game;

import std.experimental.logger;
import dsfml.graphics.renderwindow;
import raytracer.domain.scene;
import raytracer.domain.sphere;
import raytracer.domain.viewport;
import raytracer.maths.lightsource;
import raytracer.maths.point;
import raytracer.maths.shader;
import raytracer.ui.framework.application;
import raytracer.ui.framework.controller;
import raytracer.ui.raytracer;

class Game : Application
{
    this(RenderWindow window)
    {
        super(window);
    }

    protected override Controller initializeController()
    {
        return new RaytracerController(this, createClassicScene());
    }

    private Scene createClassicScene()
    {
        auto viewpoint = Point(0,0,0);
        auto viewport = new Viewport(Point(-400, 300, 50), Point(400, 300, 50), Point(-400, -300, 50), 400, 300);
        auto shapeA = new Sphere(Point(0, 0, 100), 200, new FlatShader());
        auto shapeB = new Sphere(Point(100, 150, 130), 50, new FlatShader());
        auto lightA = new LightSource(Point(500, 500, 155), 1);
        auto lightB = new LightSource(Point(500, -100, 75), 0.5f);
        return new Scene(viewpoint, viewport, [lightA, lightB], [shapeA, shapeB]);
    }

    protected override void applicationStart()
    {
        info("Application started.");
    }

    protected override void applicationEnd()
    {
        info("Application ended normally.");
    }

    protected override void applicationException(Exception e)
    {
        error("Application exception", e);
    }

    protected override void applicationError()
    {
        fatal("Unknown application error.");
    }

}
