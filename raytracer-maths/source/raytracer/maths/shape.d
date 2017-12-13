module raytracer.maths.shape;

import raytracer.maths.line;
import raytracer.maths.point;

interface Shape
{
    Point[] intersections(const Line line) pure const nothrow;
}

bool intersectsBetween(const Shape shape, const Point pointA, const Point pointB) pure nothrow
{
    return shape.intersections(Line(pointA, pointB)).areBetween(pointA, pointB);
}
