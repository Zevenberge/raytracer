module raytracer.domain.sphere;

import raytracer.maths.line;
import raytracer.maths.parametrisation;
import raytracer.maths.point;
import raytracer.domain.shape;

class Sphere : Shape
{
    this(const Point center, const float radius)
    {
        _center = center;
        _radius = radius;
    }

    private const Point _center;
    private const float _radius;
    
    Point[] intersections(const Line line) pure const nothrow
    {
        import std.math;
        auto parametrisation = line.parametrise();
        auto discriminator = calculateDiscriminator(parametrisation);
        if(discriminator < 0) return null;
        auto primaryFactor = -(parametrisation.delta*(parametrisation.root - _center))/parametrisation.delta.norm;
        if(discriminator == 0) return composeIntersections(parametrisation, primaryFactor);
        return composeIntersections(parametrisation, primaryFactor+sqrt(discriminator), primaryFactor-sqrt(discriminator));
    }

    private float calculateDiscriminator(const Parametrisation parametrisation) pure const nothrow @nogc
    {
        auto sizeFactor = _radius*_radius;
        auto deltaFactor = parametrisation.delta*(parametrisation.root - _center)/parametrisation.delta.norm;
        auto distanceFactor = (parametrisation.root - _center).norm;
        return sizeFactor + deltaFactor*deltaFactor - distanceFactor;
    }

    private Point[] composeIntersections(const Parametrisation parametrisation, float[] offsets...) pure const nothrow
    {
        auto points = new Point[offsets.length];
        foreach(i, offset; offsets)
        {
            points[i] = parametrisation.calculatePointWithOffset(offset);
        }
        return points;
    }
}
