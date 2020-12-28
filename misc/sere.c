/*
  https://github.com/ocaml/ocaml/issues/8985
$ gcc -o sere sere.c
$ ./sere C
ret = 0
$ ./sere sv_SE.UTF-8
ret = 1
*/
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <regex.h>

int main (int argc, char **argv)
{
    int ret;
    regex_t re;

    if (!setlocale (LC_COLLATE, argc > 1 ? argv[1] : "")) {
        fprintf (stderr, "setlocale failed %d\n", errno);
        exit (EXIT_FAILURE);
    }

    ret = regcomp (&re, "[a-z]", 0);
    if (ret) {
        char errbuf[80];
        size_t size;

        size = regerror (ret, &re, errbuf, sizeof (errbuf));
        fprintf (stderr, "regcomp failed `%.*s'\n", (int) size, errbuf);
        exit (EXIT_FAILURE);
    }
    else {
        regmatch_t rm;
        ret = regexec (&re, "w", 1, &rm, 0);
        printf ("ret = %d\n", ret);
    }

    return 0;
}
