/* based on the SDL tutorial code from the web, sadly I don't remember
   where from exactly */
#define _GNU_SOURCE
#include <err.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_opengl.h>

#include <time.h>
#include <stdio.h>
#include <errno.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>

#if 1
#define WIDTH  640
#define HEIGHT 480
#else
#define WIDTH  2560
#define HEIGHT 1440
#endif

static struct {
    SDL_Window *win;
    SDL_GLContext ctx;
    char *title;
    struct timespec ts;
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
    f ^= 1;
    c = f ? 0.8 : 0.6;
    glClearColor (c, c, c, 0);
    glClear (GL_COLOR_BUFFER_BIT);
    SDL_GL_SwapWindow (state.win);
}

static void setup_sdl (void)
{
    if (SDL_Init (SDL_INIT_VIDEO) < 0) {
        fprintf (stderr, "Couldn't initialize SDL: %s\n", SDL_GetError());
        exit (1);
    }

    state.win = SDL_CreateWindow (state.title,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  WIDTH, HEIGHT,
                                  SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN);
    /* Quit SDL properly on exit */
    atexit (SDL_Quit);
    state.ctx = SDL_GL_CreateContext (state.win);
}

static void setup_opengl (void)
{
    glViewport (0, 0, WIDTH, HEIGHT);
}

static void main_loop (long nswaps)
{
    SDL_Event event;
    static int f;

    while (1) {
        /* process pending events */
        while (SDL_PollEvent (&event)) {
            switch (event.type) {
            case SDL_KEYUP:
                switch (event.key.keysym.sym) {
                case SDLK_q:
                    exit (EXIT_SUCCESS);
                    break;

                case SDLK_p:
                    SDL_SetWindowFullscreen (
                        state.win, (f=!f) * SDL_WINDOW_FULLSCREEN_DESKTOP);
                    break;

                case SDLK_0:
                    nswaps = 10;
                    goto lbl;
                case SDLK_1...SDLK_9:
                    nswaps = event.key.keysym.sym - SDLK_1 + 1;
                lbl:
                    free (state.title);
                    state.title = NULL;
                    asprintf (&state.title, "swaps=%lu", nswaps);
                    SDL_SetWindowTitle (state.win, state.title);
                    break;

                default:
                    break;
                }
                break;

            case SDL_WINDOWEVENT_RESIZED:
                glViewport (0, 0,
                            event.window.data1,
                            event.window.data2);
                break;

            case SDL_QUIT:
                exit (0);
                break;
            }
        }

        repaint (nswaps);
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
    setup_sdl ();
    setup_opengl ();
    main_loop (1000000000 / div);
    return 0;
}
/*
  Local Variables:
  compile-command: "gcc -o teartest teartest.c -lSDL2 -lGL -g -Wall -Werror"
  End:
*/
