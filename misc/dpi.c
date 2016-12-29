#include <stdio.h>
#include <X11/Xlib.h>

int main (void)
{
    Display *dpy = XOpenDisplay (NULL);
    int screen = DefaultScreen (dpy);
    int w = DisplayWidth (dpy, screen);
    int h = DisplayHeight (dpy, screen);
    int wmm = DisplayWidthMM (dpy, screen);
    int hmm = DisplayHeightMM (dpy, screen);
    double wdpi, hdpi, win, hin;

    win = wmm / 25.4;
    hin = hmm / 25.4;
    wdpi = w / win;
    hdpi = h / hin;
    printf ("%dx%d %dx%d %f %f\n", w, h, wmm, hmm, wdpi, hdpi);
    return 0;
}
