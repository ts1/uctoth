#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/time.h>
#include <time.h>
#include "oth.h"

int bb_verbosity = 1;

static void message(int level, const char *fmt, va_list ap)
{
    if (bb_verbosity >= level)
        vfprintf(stderr, fmt, ap);
}

void bb_debug(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    message(2, fmt, ap);
    va_end(ap);
}

void bb_info(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    message(1, fmt, ap);
    va_end(ap);
}

void bb_error(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    message(0, fmt, ap);
    va_end(ap);
    exit(1);
}

double bb_get_time(void)
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + tv.tv_usec*1e-6;
}
