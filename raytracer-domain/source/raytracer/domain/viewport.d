module raytracer.domain.viewport;

import raytracer.domain.coordinate;
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

    Point getPoint(Coordinate coordinate)
    {
        if(coordinate.x > _amountOfHorizontalPoints-1 || coordinate.y > _amountOfVerticalPoints-1) return Point();
        return _topLeft + 
            (_bottomLeft - _topLeft)*(coordinate.y/(_amountOfVerticalPoints -1)) +
            (_topRight - _topLeft)*(coordinate.x/(_amountOfHorizontalPoints -1));
    }
}
