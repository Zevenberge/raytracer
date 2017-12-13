module raytracer.ui.game;

import std.experimental.logger;
import dsfml.graphics.renderwindow;
import raytracer.domain.scene;
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
        Scene scene;
        return new RaytracerController(this, new Raytracer(scene));
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
