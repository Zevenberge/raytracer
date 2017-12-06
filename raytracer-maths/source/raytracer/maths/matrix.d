module raytracer.maths.matrix;

import raytracer.maths.intersection;
import raytracer.maths.line;
import raytracer.maths.point;

struct Matrix
{
    @disable this();

    this(const Line first, const Line second) pure nothrow @nogc
    {
        _first = first;
        _second = second;
    }
    
    private const Line _first;
    private const Line _second;

    Intersection solve() pure const nothrow @nogc
    {
        auto matrix = setUpMatrix();
        matrix = matrix.wipeFirstRow();
        if(matrix.wasDeclaredUnsolvable()) return Intersection.none;
        auto solution = Solution(matrix);
        if(!solution.wasDeclaredUnsolvable()) return Intersection.none;
        auto pointOfIntersectionAsPerFirstLine = _first.calculatePointWithStandardParametrisation(solution.parametrisationFirstLine);
        auto pointOfIntersectionAsPerSecondLine = _second.calculatePointWithStandardParametrisation(solution.parametrisationSecondLine);
        assert(pointOfIntersectionAsPerFirstLine == pointOfIntersectionAsPerSecondLine, "The points of intersection should overlap");
        return Intersection(pointOfIntersectionAsPerFirstLine, calculateAngleOfIntersection());
    }

    private Point[3] setUpMatrix() pure const nothrow @nogc
    {
        auto line1 = _first.parametrise;
        auto line2 = _second.parametrise;
        return [
            Point(line1.delta.x, -line2.delta.x, line1.root.x - line2.root.x),
            Point(line1.delta.y, -line2.delta.y, line1.root.y - line2.root.y),
            Point(line1.delta.z, -line2.delta.z, line1.root.z - line2.root.z)
            ];
    }

    private float calculateAngleOfIntersection() pure const nothrow @nogc
    {
        return _first.calculateAngleOfIntersection(_second);
    }
}

private Point[3] wipeFirstRow(Point[3] matrix) pure nothrow @nogc
{
    matrix = matrix.correctForZeroesInFirstRow();
    if(matrix[0].x != 0)
    {
        matrix[0] = matrix[0].eliminate!"x"(matrix[1]);
    }
    else
    {
        matrix[0] = matrix[0].eliminate!"y"(matrix[1]);
    }
    return matrix;
}

private Point[3] correctForZeroesInFirstRow(Point[3] matrix) pure nothrow @nogc
{
    if(!matrix[0].hasGradient())
    {
        if(!matrix[1].hasGradient() || !matrix[2].hasGradient()) return UNSOLVABLE;
        auto temp = matrix[0];
        matrix[0] = matrix[2];
        matrix[2] = temp;
    }
    return matrix;
}

private bool hasGradient(Point vector) pure nothrow @nogc
{
    return vector.x != 0 || vector.y != 0;
}

private Point eliminate(string direction)(Point row, Point eliminatorRow) pure nothrow @nogc
{
    import std.format;
    mixin("return row - eliminatorRow*(row.%s/eliminatorRow.%s);".format(direction, direction));
}

private bool wasDeclaredUnsolvable(Point[3] matrix) pure nothrow @nogc
{
    import std.math;
    return matrix[0].x.isNaN;
}

private struct Solution
{
    @disable this();

    this(Point[3] matrix) pure nothrow @nogc
    {
        if(matrix[0].x != 0)
        {
            startSolvingX(matrix);
        }
        else
        {
            startSolvingY(matrix);
        }
        sanityCheck(matrix);
    }

    private void startSolvingX(Point[3] matrix) pure nothrow @nogc
    {
        parametrisationFirstLine = -matrix[0].z/matrix[0].x;
        if(matrix[1].y != 0)
        {
            parametrisationSecondLine = -(parametrisationFirstLine * matrix[1].x + matrix[1].z)/matrix[1].y;
        }
        else if(matrix[2].y != 0)
        {
            parametrisationSecondLine = -(parametrisationFirstLine * matrix[2].x + matrix[2].z)/matrix[2].y;
        }
        else
        {
            declareUnsolvable();
        }
    }

    private void startSolvingY(Point[3] matrix) pure nothrow @nogc
    {
        parametrisationSecondLine = -matrix[0].z/matrix[0].y;
        if(matrix[1].x != 0)
        {
            parametrisationFirstLine = -(parametrisationSecondLine * matrix[1].y + matrix[1].z)/matrix[1].x;
        }
        else if(matrix[2].x != 0)
        {
            parametrisationFirstLine = -(parametrisationSecondLine * matrix[2].y + matrix[2].z)/matrix[2].x;
        }
        else
        {
            declareUnsolvable();
        }
    }

    private void declareUnsolvable() pure nothrow @nogc
    {
        parametrisationFirstLine = float.nan;
        parametrisationSecondLine = float.nan;
    }
    
    float parametrisationFirstLine;
    float parametrisationSecondLine;
    
    bool wasDeclaredUnsolvable() @property pure const nothrow @nogc
    {
        import std.math;
        return parametrisationFirstLine.isNaN || parametrisationSecondLine.isNaN;
    }

    private void sanityCheck(Point[3] matrix) pure nothrow @nogc
    {
        if(wasDeclaredUnsolvable) return;
        foreach(row; matrix)
        {
            auto outcome = parametrisationFirstLine * row.x + parametrisationSecondLine * row.y + row.z;
            assert(outcome == 0, "All equations should result in a total of 0.");
        }
    }
}

enum UNSOLVABLE = [Point(), Point(), Point()];
