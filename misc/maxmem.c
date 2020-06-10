#include <sys/types.h>
#include <sys/mman.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdint.h>
#include <unistd.h>

static unsigned long long maxmem (void)
{
    void *pp = NULL;
    int i = 31;
    unsigned long long total = 0;

    while (i > 11) {
        void *p;

        errno = 0;
        p = mmap (0, 1 << i,
                  PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
        if (0) printf ("alloc %u ret=%p: %s\n", 1 << i, p, strerror (errno));
        if (p == MAP_FAILED) {
            if (errno == ENOMEM) {
                i -= 1;
            }
            else {
                if (0)
                    fprintf (stderr, "%s after allocating %lld\n",
                             strerror (errno), total);
                exit (EXIT_FAILURE);
            }
        }
        else {
            *(void **) p = pp;
            *(size_t *) ((uintptr_t) p + sizeof (p)) = 1 << i;
            pp = p;
            total += 1 << i;
            /* i += 1; */
        }
    }
    /* printf ("total=%lld\n", total); */

    while (pp) {
        void *p = *(void **) pp;
        size_t l = *(size_t *) ((uintptr_t) pp + sizeof (p));
        /* printf ("pp=%p\n", pp); */
        munmap (pp, l);
        pp = p;
    }
    return total;
}

static void *thrfn (void *unused)
{
    int ret;

    (void) unused;
    ret = pause ();
    if (ret)
        perror ("pause");
    return NULL;
}

int main (void)
{
    int ret;
    pthread_t thread;
    unsigned long long memthr, memnothr;

    memnothr = maxmem ();
    ret = pthread_create (&thread, NULL, thrfn, NULL);
    if (ret) {
        fprintf (stderr, "pthread_create: %s\n", strerror (ret));
        exit (EXIT_FAILURE);
    }
    memthr = maxmem ();
    maxmem ();
    printf ("mem no thread %llu %fGb\n", memnothr, memnothr*1e-9);
    if ((memnothr - memthr) >> 20 > 8) {
        printf ("mem thread %llu %lluMb\n", memthr, memthr>>20);
        printf ("diff %llu %lluMb\n", memnothr - memthr,
                (memnothr - memthr) >> 20);
    }
    return 0;
}
/*
  Local Variables:
  compile-command: "gcc -o maxmem maxmem.c -lpthread"
  End:
*/
