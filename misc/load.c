/*
  Building: gcc -o load load.c

  Power consumption:
    5.3.10.1-1        baseline (~4 watts)
      ./load        # baseline
      ./load _      # baseline

    5.3.11 and up            baseline (~4 watts)
      ./load               # baseline
      ./load _             # 6-7 watts
      ./load _ 2>/dev/null # baseline

  Above baseline consumption appears to be tied to the place load was
  started from (and what fd 2 is connected to), i.e. baseline when
  started from the TTY and above baseline when ran from the X terminal
  (rxvt-unicode here). This seem to suggest that the issue is graphics
  related.
*/
#include <unistd.h>

int main (int argc, char ** __attribute ((unused)) argv)
{
    for (;;) {
        sleep (3);
        if (argc > 1) write (2, " ", 1);
    }
}
