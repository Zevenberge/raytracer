module raytracer.ui.framework.application;

import dsfml.graphics.color;
import dsfml.graphics.renderwindow;
import dsfml.window.event;
import raytracer.ui.framework.controller;

class Application
{
    this(RenderWindow window)
    {
        _window = window;
    }

    private RenderWindow _window;
    private Controller _controller;

    final void run()
    {
        scope(failure) applicationError();
        applicationStart();
        _controller = initializeController();
        enterMessageLoop();
        applicationEnd();
    }

    protected abstract Controller initializeController();

    protected void applicationStart()
    {
    }

    protected void applicationException(Exception e)
    {
    }

    protected void applicationError()
    {
    }

    protected void applicationEnd()
    {
    }

    private void enterMessageLoop()
    {
        while(_window.isOpen)
        {
            _window.clear(Color.Magenta);
            Event evt;
            while(_window.pollEvent(evt))
            {
                switch(evt.type) with(Event.EventType)
                {
                    case Closed:
                        _window.close();
                        return;
                    default:
                        delegateToController(evt);
                        break;
                }
            }
            _controller.draw(_window);
            _window.display;
        }
    }

    private void delegateToController(Event event)
    {
        try
        {
            _controller.handle(event);
        }
        catch(Exception e)
        {
            applicationException(e);
        }
    }
}
