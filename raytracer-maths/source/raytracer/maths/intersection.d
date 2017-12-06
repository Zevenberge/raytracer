module raytracer.maths.intersection;

import raytracer.maths.point;

struct Intersection
{
    Point point() @property pure const nothrow @nogc { return _point; }
    private Point _point;
    float angle() @property pure const nothrow @nogc { return _angle; }
    private float _angle;

    static Intersection none() @property pure nothrow  @nogc
    {
        return Intersection();
    }
}
