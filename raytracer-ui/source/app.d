import std.experimental.logger;
import dsfml.graphics;
import x11.Xlib;
import raytracer.ui.game;

void main(string[] args) {
    auto status = XInitThreads();
    assert(status, "XInitThreads failed with a zero status code.");
    auto window = new RenderWindow(VideoMode(600, 500), "Raytracer");
    auto app = new Game(window);
    app.run();
}

