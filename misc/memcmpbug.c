#include <string.h>

static const float z[1] = {0};
static const float z1;
int f(float x)
{
    return memcmp(&x, z, sizeof(x));
}
int g(float x)
{
    return memcmp(&x, &z1, sizeof(x));
}
/*
  Local Variables:
  compile-command: "gcc -Wall -O2 -S memcmpbug.c -o -"
  End:
*/
