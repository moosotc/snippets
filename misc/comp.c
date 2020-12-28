#include <stdio.h>

int main (void)
{
    printf ("(int) -3 < (unsigned long) 7 = %d\n",
            (int) -3 < (unsigned long) 7);
    printf ("(long) -3 < (unsigned long) 7 = %d\n",
            (long) -3 < (unsigned long) 7);
    printf ("(long long) -3 < (unsigned long) 7 = %d\n",
            (long long) -3 < (unsigned long) 7);
    printf ("-3 < 7 = %d\n",
            -3 < 7);
    return 0;
}
/*
  compile-command: "clang -Wall -O2 -o compc comp.c"
  compile-command: "clang -Weverything -O2 -o compc comp.c"
  Local Variables:
  compile-command: "clang -Wall -m32 -O2 -o compc comp.c"
  End:
*/
