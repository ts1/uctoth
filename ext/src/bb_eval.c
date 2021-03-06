#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <string.h>
#include "bb_index.h"
#include "bb_eval.h"
#include "bb_hash.h"

#define POW3_4 (3*3*3*3)
#define POW3_5 (POW3_4*3)
#define POW3_6 (POW3_5*3)
#define POW3_7 (POW3_6*3)
#define POW3_8 (POW3_7*3)
#define POW3_9 (POW3_8*3)
#define POW3_10 (POW3_9*3)

struct weight {
    s16 offset;
    s16 corner9[POW3_9];
    s16 corner10[POW3_10];
    s16 edge2x[POW3_10];
    s16 row1[POW3_8];
    s16 row2[POW3_8];
    s16 row3[POW3_8];
    s16 diag4[POW3_4];
    s16 diag5[POW3_5];
    s16 diag6[POW3_6];
    s16 diag7[POW3_7];
    s16 diag8[POW3_8];
};

struct weight weights[N_PHASES];

void *bb_get_weights_ptr(int phase)
{
    return &weights[phase];
}

void bb_set_weights(int phase, const s16 *weight)
{
    assert(phase >= 0 && phase < N_PHASES);
    memcpy(&weights[phase], weight, sizeof(struct weight));
}

int bb_eval(bboard b, int n_discs)
{
    bboard f, m, mf, t, tf, tm, tmf;
    bboard bd, fd, md, mfd;
    int eval;
    const struct weight *w;

    assert(n_discs >= 5 && n_discs <= 64);
    w = &weights[(n_discs - 5) / 6];

    BB_ALL_SYMMETRIC(b, f, m, mf, t, tf, tm, tmf);
    bd = bb_diag(b);
    fd = bb_diag(f);
    md = bb_diag(m);
    mfd = bb_diag(mf);

    eval = w->offset;

    eval += w->diag4[bb_index_diag4_d(bd)];
    eval += w->diag4[bb_index_diag4_d(fd)];
    eval += w->diag4[bb_index_diag4_d(md)];
    eval += w->diag4[bb_index_diag4_d(mfd)];

    eval += w->diag5[bb_index_diag5_d(bd)];
    eval += w->diag5[bb_index_diag5_d(fd)];
    eval += w->diag5[bb_index_diag5_d(md)];
    eval += w->diag5[bb_index_diag5_d(mfd)];

    eval += w->diag6[bb_index_diag6_d(bd)];
    eval += w->diag6[bb_index_diag6_d(fd)];
    eval += w->diag6[bb_index_diag6_d(md)];
    eval += w->diag6[bb_index_diag6_d(mfd)];

    eval += w->diag7[bb_index_diag7_d(bd)];
    eval += w->diag7[bb_index_diag7_d(fd)];
    eval += w->diag7[bb_index_diag7_d(md)];
    eval += w->diag7[bb_index_diag7_d(mfd)];

    eval += w->diag8[bb_index_diag8_d(md)];
    eval += w->diag8[bb_index_diag8_d(mfd)];

    eval += w->row1[bb_index_row1(b)];
    eval += w->row1[bb_index_row1(f)];
    eval += w->row1[bb_index_row1(t)];
    eval += w->row1[bb_index_row1(tm)];

    eval += w->row2[bb_index_row2(b)];
    eval += w->row2[bb_index_row2(f)];
    eval += w->row2[bb_index_row2(t)];
    eval += w->row2[bb_index_row2(tm)];

    eval += w->row3[bb_index_row3(b)];
    eval += w->row3[bb_index_row3(f)];
    eval += w->row3[bb_index_row3(t)];
    eval += w->row3[bb_index_row3(tm)];

    eval += w->corner9[bb_index_corner9(b)];
    eval += w->corner9[bb_index_corner9(f)];
    eval += w->corner9[bb_index_corner9(m)];
    eval += w->corner9[bb_index_corner9(mf)];

    eval += w->edge2x[bb_index_edge2x(b)];
    eval += w->edge2x[bb_index_edge2x(f)];
    eval += w->edge2x[bb_index_edge2x(t)];
    eval += w->edge2x[bb_index_edge2x(tm)];

    eval += w->corner10[bb_index_corner10(b)];
    eval += w->corner10[bb_index_corner10(f)];
    eval += w->corner10[bb_index_corner10(m)];
    eval += w->corner10[bb_index_corner10(mf)];
    eval += w->corner10[bb_index_corner10(t)];
    eval += w->corner10[bb_index_corner10(tf)];
    eval += w->corner10[bb_index_corner10(tm)];
    eval += w->corner10[bb_index_corner10(tmf)];

    return eval;
}

#if 0
int bb_eval_dump(bboard b, int n_discs)
{
    bboard f, m, mf, t, tf, tm, tmf;
    bboard bd, fd, md, mfd;
    int eval;
    const struct weight *w;

    assert(n_discs >= 5 && n_discs <= 64);
    w = &weights[(n_discs - 5) / 6];

    BB_ALL_SYMMETRIC(b, f, m, mf, t, tf, tm, tmf);
    bd = bb_diag(b);
    fd = bb_diag(f);
    md = bb_diag(m);
    mfd = bb_diag(mf);

    eval = 0;

    printf("%d\n", w->corner9[bb_index_corner9(b)]);
    printf("%d\n", w->corner9[bb_index_corner9(f)]);
    printf("%d\n", w->corner9[bb_index_corner9(m)]);
    printf("%d\n", w->corner9[bb_index_corner9(mf)]);
    printf("\n");

    printf("%d\n", w->corner10[bb_index_corner10(b)]);
    printf("%d\n", w->corner10[bb_index_corner10(f)]);
    printf("%d\n", w->corner10[bb_index_corner10(m)]);
    printf("%d\n", w->corner10[bb_index_corner10(mf)]);
    printf("%d\n", w->corner10[bb_index_corner10(t)]);
    printf("%d\n", w->corner10[bb_index_corner10(tf)]);
    printf("%d\n", w->corner10[bb_index_corner10(tm)]);
    printf("%d\n", w->corner10[bb_index_corner10(tmf)]);
    printf("\n");

    printf("%d\n", w->edge2x[bb_index_edge2x(b)]);
    printf("%d\n", w->edge2x[bb_index_edge2x(f)]);
    printf("%d\n", w->edge2x[bb_index_edge2x(t)]);
    printf("%d\n", w->edge2x[bb_index_edge2x(tm)]);
    printf("\n");

    printf("%d\n", w->row1[bb_index_row1(b)]);
    printf("%d\n", w->row1[bb_index_row1(f)]);
    printf("%d\n", w->row1[bb_index_row1(t)]);
    printf("%d\n", w->row1[bb_index_row1(tm)]);
    printf("\n");

    printf("%d\n", w->row2[bb_index_row2(b)]);
    printf("%d\n", w->row2[bb_index_row2(f)]);
    printf("%d\n", w->row2[bb_index_row2(t)]);
    printf("%d\n", w->row2[bb_index_row2(tm)]);
    printf("\n");

    printf("%d\n", w->row3[bb_index_row3(b)]);
    printf("%d\n", w->row3[bb_index_row3(f)]);
    printf("%d\n", w->row3[bb_index_row3(t)]);
    printf("%d\n", w->row3[bb_index_row3(tm)]);
    printf("\n");

    printf("%d\n", w->diag4[bb_index_diag4_d(bd)]);
    printf("%d\n", w->diag4[bb_index_diag4_d(fd)]);
    printf("%d\n", w->diag4[bb_index_diag4_d(md)]);
    printf("%d\n", w->diag4[bb_index_diag4_d(mfd)]);
    printf("\n");

    printf("%d\n", w->diag5[bb_index_diag5_d(bd)]);
    printf("%d\n", w->diag5[bb_index_diag5_d(fd)]);
    printf("%d\n", w->diag5[bb_index_diag5_d(md)]);
    printf("%d\n", w->diag5[bb_index_diag5_d(mfd)]);
    printf("\n");

    printf("%d\n", w->diag6[bb_index_diag6_d(bd)]);
    printf("%d\n", w->diag6[bb_index_diag6_d(fd)]);
    printf("%d\n", w->diag6[bb_index_diag6_d(md)]);
    printf("%d\n", w->diag6[bb_index_diag6_d(mfd)]);
    printf("\n");

    printf("%d\n", w->diag7[bb_index_diag7_d(bd)]);
    printf("%d\n", w->diag7[bb_index_diag7_d(fd)]);
    printf("%d\n", w->diag7[bb_index_diag7_d(md)]);
    printf("%d\n", w->diag7[bb_index_diag7_d(mfd)]);
    printf("\n");

    printf("%d\n", w->diag8[bb_index_diag8_d(md)]);
    printf("%d\n", w->diag8[bb_index_diag8_d(mfd)]);

    return eval;
}
#endif

void bb_nega_weight(void)
{
    s16 *p, *end;

    p = (s16 *) weights;
    end = p + (sizeof(weights) / sizeof(s16));
    while (p < end) {
        *p = -*p;
        p++;
    }
}
