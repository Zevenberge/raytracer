module raytracer.maths.point;

import std.algorithm;
import std.array;
import std.typecons;
import raytracer.maths.lightsource;
import raytracer.maths.line;
import raytracer.maths.shape;

struct Point
{
    float x() pure nothrow const @property @nogc {return _x;}
    private float _x;
    float y() pure nothrow const @property @nogc {return _y;}
    private float _y;
    float z() pure nothrow const @property @nogc {return _z;}
    private float _z;

    auto opBinary(string op)(const Point other) pure const @nogc nothrow
        if((op == "+") || (op == "-") || (op == "*"))
    {
        static if (op == "+")
        {
            return Point(_x+other._x, _y+other._y, _z+other._z);
        }
        static if(op == "-")
        {
            return Point(_x-other._x, _y-other._y, _z-other._z);
        }
        static if(op == "*")
        {
            return _x * other._x + _y * other._y + _z * other._z;
        }
    }

    Point opBinary (string op)(float num) pure const @nogc
        if((op == "*") || (op == "/"))
    {
        static if (op == "*")
        {
            return Point(_x*num,_y*num,_z*num);
        }
        static if(op == "/")
        {
            return Point(_x/num,_y/num,_z/num);
        }
    }

    float norm() pure nothrow const @property @nogc
    {
        import std.math;
        return sqrt(this*this);
    }

    float sum() pure nothrow const @property @nogc
    {
        return _x + _y + _z;
    }
}

@("Can I construct a struct with private fields?")
unittest
{
    import fluent.asserts;
    auto point = Point(1f, 2f, 3f);
    point.x.should.equal(1f);
    point.y.should.equal(2f);
    point.z.should.equal(3f);
}

float calculateAngleOfIntersection(const Point one, const Point two) pure nothrow @nogc
{
    import std.math;
    return acos((one * two)/(one.norm() * two.norm()));
}

const(Point)* getNearestPoint(const Point[] points, const Line line) pure nothrow
{
    alias Alpha = Tuple!(float, "alpha", const(Point)*, "point");
    if(points.empty) return null;
    auto parametrisation = line.parametrise();
    auto nearestPoint = points
                .map!(p => Alpha((p - parametrisation.root)*parametrisation.delta, &p))
                .filter!(p => p.alpha > 0) // Only take the points in positive line of sight
                .minElement!(p => p.alpha)(Alpha(0f, null)).point;
    return nearestPoint;
}
