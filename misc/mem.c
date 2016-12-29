#include <string.h>

int main (void)
{
#if 0
    volatile long long a = (long long) &main;
    for (;;) ++a;
#else
    static char data[512<<20];
    static char mata[sizeof data];
    for (;;) {
        long long moo1;
        asm volatile ("rdtsc" : "=A" (moo1) : :);
#if 1
        memcpy (mata, data, sizeof data);
#else
        memset (data, moo1, sizeof (data));
#endif
    }
#endif
    return 0;
}
