module raytracer.maths.line;

import raytracer.maths.intersection;
import raytracer.maths.matrix;
import raytracer.maths.parametrisation;
import raytracer.maths.point;

struct Line
{
    private const Point _a;
    private const Point _b;

    Line normal(const Point point) pure const nothrow @nogc
    {
        return parametrise().calculateNormal(point);
    }

    Intersection intersection(const Line line) pure const nothrow @nogc
    {
        auto matrix = Matrix(this, line);
        return matrix.solve;
    }

    Parametrisation parametrise() @property pure const nothrow @nogc
    {
        return Parametrisation(_a, _b);
    }
}

Point calculatePointWithStandardParametrisation(const Line line, float offset) pure nothrow @nogc
{
    return line.parametrise().calculatePointWithOffset(offset);
}

float calculateAngleOfIntersection(const Line one, const Line two) pure nothrow @nogc
{
    return one.parametrise().calculateAngleOfIntersection(two.parametrise());
}
