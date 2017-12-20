module raytracer.maths.shape;

import std.algorithm;
import raytracer.maths.lightsource;
import raytracer.maths.line;
import raytracer.maths.point;
import raytracer.maths.shader;

interface Shape
{
    Point[] intersections(const Line line) pure const nothrow;
    const(Shader) shader() @property pure const nothrow @nogc;
}

bool intersectsBetween(const Shape shape, const Point pointA, const Point pointB) pure nothrow
{
    return shape.intersections(Line(pointA, pointB)).areBetween(pointA, pointB);
}

auto nearestIntersection(const Shape shape, const Line line) pure nothrow
{
    return shape.intersections(line).getNearestPoint(line);
}

float calculateBrightness(const Shape shape, const Point intersection, 
    const LightSource[] lightSources, const Shape[] otherShapes) 
    pure nothrow
{
    return lightSources
        .map!((lightSource) pure nothrow {return otherShapes.blockLight(intersection, shape, lightSource) ? 0.0f :
                shape.shader.calculateBrightness(shape, intersection, lightSource);})
        .sum;
}

private bool blockLight(const Shape[] shapes, const Point intersection, const Shape shape, const LightSource lightSource)
    pure nothrow
{
    return shapes.any!((s) nothrow {
            if(s is shape) return false;
            return shape.intersectsBetween(intersection, lightSource.point);
        });
}

