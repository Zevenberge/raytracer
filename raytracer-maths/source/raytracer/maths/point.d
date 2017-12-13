module raytracer.maths.point;

import std.algorithm;
import std.array;
import std.math;
import std.typecons;
version(unittest) import fluent.asserts;
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
    auto point = Point(1f, 2f, 3f);
    point.x.should.equal(1f);
    point.y.should.equal(2f);
    point.z.should.equal(3f);
}

@("Inner product")
unittest
{
    (Point(5, 0, 0) * Point(0, 1, 1)).should.equal(0);
    (Point(5, 0, 0) * Point(1, 0, 0)).should.equal(5);
}

float calculateAngleOfIntersection(const Point one, const Point two) pure nothrow @nogc
{
    return acos((one * two)/(one.norm() * two.norm()));
}

@("Hoek van aanraking gegeven twee diffs van de origin")
unittest
{
    Point(5, 0, 0).calculateAngleOfIntersection(Point(0, 5, 0)).should.be.approximately(PI_2, 1e-5);
    Point(5, 0, 0).calculateAngleOfIntersection(Point(5, 0, 0)).should.be.approximately(0, 1e-5);
}

const(Point)* getNearestPoint(const Point[] points, const Line line) pure nothrow
{
    if(points.empty) return null;
    return getNearestAlpha(points, line).point;
}

bool areBetween(const Point[] points, const Point root, const Point target) pure nothrow
{
    if(points.empty) return false;
    auto alpha = getNearestAlpha(points, Line(root, target)).alpha;
    return alpha > 0.0f && alpha < 1.0f;
}

@("Als ik geen snijpunten heb, dan liggen deze niet op de lijn")
unittest
{
    (new Point[0]).areBetween(Point(0,0,0), Point(1,0,0)).should.equal(false);
}

@("Als ik één snijpunt heb op de lijn en tussen de punten wordt dat zo erkend")
unittest
{
    [Point(0.5f, 0, 0)].areBetween(Point(0,0,0), Point(1,0,0)).should.equal(true);
}

private alias Alpha = Tuple!(float, "alpha", const(Point)*, "point");

private Alpha getNearestAlpha(const Point[] points, const Line line) pure nothrow
{
    auto parametrisation = line.parametrise();
    return points
                .map!(p => Alpha((p - parametrisation.root)*parametrisation.delta, &p))
                .filter!(p => p.alpha > 0) // Only take the points in positive line of sight
                .minElement!(p => p.alpha)(Alpha(float.infinity, null));
}

