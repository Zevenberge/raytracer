module raytracer.maths.parametrisation;

import raytracer.maths.line;
import raytracer.maths.point;

struct Parametrisation
{
    @disable this() nothrow;
    
    this(Point a, Point b) pure nothrow @nogc
    {
        root = a;
        delta = b - a;
    }

    const Point root;
    const Point delta;

    float calculateAngleOfIntersection(const Parametrisation two) pure nothrow @nogc
    {
        return delta.calculateAngleOfIntersection(two.delta);
    }
}

Point calculatePointWithOffset(const Parametrisation parametrisation, float offset) pure nothrow @nogc
{
    return parametrisation.root + parametrisation.delta*offset;
}

Line calculateNormal(const Parametrisation parametrisation, const Point point) pure nothrow @nogc
{
    auto nearestOffset = (point - parametrisation.root).sum/parametrisation.delta.sum;
    auto nearestPoint = parametrisation.calculatePointWithOffset(nearestOffset);
    return Line(parametrisation.root, nearestPoint);
}
