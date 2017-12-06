module raytracer.domain.shape;

import raytracer.maths.line;
import raytracer.maths.point;

interface Shape
{
    Point[] intersections(const Line line) pure const nothrow;
}
