module raytracer.maths.lightsource;

import raytracer.maths.point;

class LightSource
{
    this(Point point, float brightness)
    {
        _point = point;
        _brightness = brightness;
    }

    Point point() @property pure const nothrow @nogc
    {
        return _point;
    }
    private Point _point;
    float brightness() @property pure const nothrow @nogc
    {
        return _brightness;
    }
    private float _brightness;
}
