#define _GNU_SOURCE
#include <err.h>

#include <time.h>
#include <stdio.h>
#include <errno.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>

#define WIDTH  1280
#define HEIGHT 1024

static struct {
    char *title;
    struct timespec ts;
    int w, h;
    int pos;
} state;

static void repaint (long inc)
{
    static int f;
    GLclampf c;

    if (inc) {
        if (state.ts.tv_sec == 0) {
            if (clock_gettime (CLOCK_MONOTONIC, &state.ts))
                err (1, "clock_gettime");
        }
        else {
            if (clock_nanosleep (CLOCK_MONOTONIC, TIMER_ABSTIME,
                                 &state.ts, NULL))
                err (1, "clock_nanosleep");
            state.ts.tv_nsec += inc;
            while (state.ts.tv_nsec > 1000000000) {
                state.ts.tv_nsec -= 1000000000;
                state.ts.tv_sec += 1;
            }
        }
    }

    c = (++f%4) ? 0.4 : 0.7-(1e-5*(f&1));
    glClearColor (c, c, c, 0);
    glClear (GL_COLOR_BUFFER_BIT);

    $SwapBuffers
}

static void setup_opengl (int w, int h)
{
    state.w = w;
    state.h = h;
#if 0
    printf ("setup %dx%d\n", state.w, state.h);
#endif
    glColor3i (0, 0, 0);
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity ();
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity ();
    glViewport (0, 0, w, h);
}

static void setup_wsi (void)
{
    $CreateWinodwsEtc
    setup_opengl (WIDTH, HEIGHT);
}

static void main_loop (long div)
{
    static int f;


$resize:
                        setup_opengl (event.window.data1, event.window.data2);
                        break;
                }
                break;

$keydown:
'q': exit (EXIT_SUCCESS);
'p': $toggle-fullscrieen
up: div += 2;
down:
                    div--;
                    if (div <= 0) div = 1;
                    free (state.title);
                    state.title = NULL;
                    asprintf (&state.title, "div=%ld %f", div, 1e9 / div);
                    SDL_SetWindowTitle (state.win, state.title);
default:
                    break;

        repaint (1000000000 / div);
    }
}

int main (int argc, char* argv[])
{
    long div = 1;

    if (argc > 1) {
        /* following is a slightly modified example code from man strtol */
        char *endptr;
        errno = 0;     /* To distinguish success/failure after call */
        div = strtol (argv[1], &endptr, 10);

        /* Check for various possible errors */
        if ((errno == ERANGE && (div == LONG_MAX || div == LONG_MIN))
            || (errno != 0 && div == 1)) {
            perror ("strtol");
            exit (EXIT_FAILURE);
        }

        if (endptr == argv[1]) {
            fprintf (stderr, "No digits were found\n");
            exit (EXIT_FAILURE);
        }
    }

    asprintf (&state.title, "div=%ld %f", div, 1e9 / div);
    setup_wsi ();
    main_loop (div);
    return 0;
}
/*
  Local Variables:
  compile-command: "gcc -o teartest teartest.c -l$WSI -lGL -g -Wall -Werror"
  End:
*/
