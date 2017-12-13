module raytracer.maths.lightsource;

import raytracer.maths.point;

class LightSource
{
    this(Point point, float brightness)
    {
        _point = point;
        _brightness = brightness;
    }
    
    private Point _point;
    private float _brightness;
}
