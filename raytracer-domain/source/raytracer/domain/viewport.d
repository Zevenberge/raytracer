module raytracer.domain.viewport;

import std.algorithm;
import std.array;
import std.range;
import raytracer.domain.coordinate;
import raytracer.domain.viewline;
import raytracer.maths.line;
import raytracer.maths.point;

class Viewport
{
    this(Point topLeft, Point topRight, Point bottomLeft, 
        size_t amountOfHorizontalPoints, size_t amountOfVerticalPoints)
    in
    {
        assert(amountOfHorizontalPoints > 1, "There should be horizontal points");
        assert(amountOfVerticalPoints > 1, "There should be vertical points");
    }
    do
    {
        _topLeft = topLeft;
        _topRight = topRight;
        _bottomLeft = bottomLeft;
        _amountOfHorizontalPoints = amountOfHorizontalPoints;
        _amountOfVerticalPoints = amountOfVerticalPoints;
    }

    private const Point _topLeft;
    private const Point _topRight;
    private const Point _bottomLeft;
    private const size_t _amountOfHorizontalPoints;
    private const size_t _amountOfVerticalPoints;

    Point getPoint(const Coordinate coordinate)
    {
        if(coordinate.x > _amountOfHorizontalPoints-1 || coordinate.y > _amountOfVerticalPoints-1) 
            return Point();
        return _topLeft + 
            (_bottomLeft - _topLeft)*(coordinate.y/(_amountOfVerticalPoints -1)) +
            (_topRight - _topLeft)*(coordinate.x/(_amountOfHorizontalPoints -1));
    }

    Viewline[] _viewlines;
    private bool _requiresUpdate = true;
    Viewline[] getViewLines(const Point viewpoint)
    {
        if(_requiresUpdate)
        {
            _viewlines = getCoordinates()
                            .map!(c => Viewline(c, Line(viewpoint, getPoint(c))))
                            .array;
            _requiresUpdate = false;
        }
        return _viewlines;
    }

    private auto getCoordinates()
    {
        return iota(0, _amountOfHorizontalPoints).map!((x) {
            return iota(0, _amountOfVerticalPoints)
                    .map!(y => Coordinate(x,y));
                }).joiner;
    }
}
