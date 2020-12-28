#include <time.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main (void)
{
    int res;
    struct timespec ts, tr;

#if 0
    res = clock_nanosleep (CLOCK_REALTIME_ALARM, 0,
                           &(struct timespec){.tv_sec=120}, 0);
    if (res) {
        fprintf (stderr, "res=%d %s\n", res, strerror (res));
        exit (1);
    }
#endif

    if (clock_gettime (CLOCK_REALTIME_ALARM, &ts)) {
        perror ("clock_gettime");
    }
    ts.tv_sec += 1;
    res = clock_nanosleep (CLOCK_REALTIME_ALARM, TIMER_ABSTIME, &ts, &tr);
    if (res) {
        fprintf (stderr, "res=%d %s\n", res, strerror (res));
        exit (1);
    }
    return 0;
}
/*
  Local Variables:
  compile-command: "clang -Weverything -O2 -o cnscba cnscba.c"
  End:
*/
