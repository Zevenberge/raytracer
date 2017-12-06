module raytracer.domain.lightsource;

import raytracer.maths.point;

class LightSource
{
    this(Point point, ubyte brightness)
    {
        _point = point;
        _brightness = brightness;
    }
    
    private Point _point;
    private ubyte _brightness;
}
