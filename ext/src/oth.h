#ifndef oth_h
#define oth_h

#include <stdint.h>

typedef uint64_t u64;
typedef int64_t s64;
typedef uint32_t u32;
typedef int32_t s32;
typedef uint16_t u16;
typedef int16_t s16;
typedef uint8_t u8;
typedef int8_t s8;

#ifdef __GNUC__
# define inline __inline__ __attribute__((__always_inline__))
# define asm __asm__
#else /* !__GNUC__ */
# define inline /* no op */
# define asm /* no op */
#endif

#define SCORE_MULT 4000 /* from pattern.coffee */
#define LOG_MULT 5000 /* from logutil.coffee */

#ifdef __cplusplus
extern "C" {
#endif

void bb_error(const char *fmt, ...);
void bb_info(const char *fmt, ...);
void bb_debug(const char *fmt, ...);

extern int bb_verbosity;

double bb_get_time(void);

//void solve_linear_equation(int dim, double **matrix, double *vector);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* oth_h */
