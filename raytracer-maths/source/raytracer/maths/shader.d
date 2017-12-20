module raytracer.maths.shader;

import raytracer.maths.lightsource;
import raytracer.maths.point;
import raytracer.maths.shape;

interface Shader
{
    float calculateBrightness(const Shape shape, const Point intersection, const LightSource lightSource) pure const nothrow;
}

class FlatShader : Shader
{
    float calculateBrightness(const Shape shape, const Point intersection, const LightSource lightSource) pure const nothrow
    {
        return lightSource.brightness;
    }
}
