module raytracer.ui.framework.controller;

import dsfml.graphics.rendertarget;
import dsfml.window.event;

interface Controller
{
    void draw(RenderTarget target);
    void handle(Event event);
}
