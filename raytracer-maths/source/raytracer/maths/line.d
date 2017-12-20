module raytracer.maths.line;

import std.algorithm;
import raytracer.maths.lightsource;
import raytracer.maths.intersection;
import raytracer.maths.matrix;
import raytracer.maths.parametrisation;
import raytracer.maths.point;
import raytracer.maths.shape;

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

    float calculateIntensity(const LightSource[] lightSources, const Shape[] shapes) @property pure const nothrow
    {
        return shapes.map!((shape) {
                auto intersection = shape.nearestIntersection(this);
                if(intersection is null) return 0.0f;
                return shape.calculateBrightness(*intersection, lightSources, shapes);
            }).sum;
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
