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

#if 0
    printf("%d\n", w->corner9[bb_index_corner9(b)]);
    printf("%d\n", w->corner9[bb_index_corner9(f)]);
    printf("%d\n", w->corner9[bb_index_corner9(m)]);
    printf("%d\n", w->corner9[bb_index_corner9(mf)]);

    printf("%d\n", w->corner10[bb_index_corner10(b)]);
    printf("%d\n", w->corner10[bb_index_corner10(f)]);
    printf("%d\n", w->corner10[bb_index_corner10(m)]);
    printf("%d\n", w->corner10[bb_index_corner10(mf)]);
    printf("%d\n", w->corner10[bb_index_corner10(t)]);
    printf("%d\n", w->corner10[bb_index_corner10(tf)]);
    printf("%d\n", w->corner10[bb_index_corner10(tm)]);
    printf("%d\n", w->corner10[bb_index_corner10(tmf)]);

    printf("%d\n", w->edge2x[bb_index_edge2x(b)]);
    printf("%d\n", w->edge2x[bb_index_edge2x(f)]);
    printf("%d\n", w->edge2x[bb_index_edge2x(t)]);
    printf("%d\n", w->edge2x[bb_index_edge2x(tm)]);

    printf("%d\n", w->row1[bb_index_row1(b)]);
    printf("%d\n", w->row1[bb_index_row1(f)]);
    printf("%d\n", w->row1[bb_index_row1(t)]);
    printf("%d\n", w->row1[bb_index_row1(tm)]);

    printf("%d\n", w->row2[bb_index_row2(b)]);
    printf("%d\n", w->row2[bb_index_row2(f)]);
    printf("%d\n", w->row2[bb_index_row2(t)]);
    printf("%d\n", w->row2[bb_index_row2(tm)]);

    printf("%d\n", w->row3[bb_index_row3(b)]);
    printf("%d\n", w->row3[bb_index_row3(f)]);
    printf("%d\n", w->row3[bb_index_row3(t)]);
    printf("%d\n", w->row3[bb_index_row3(tm)]);

    printf("%d\n", w->diag4[bb_index_diag4_d(bd)]);
    printf("%d\n", w->diag4[bb_index_diag4_d(fd)]);
    printf("%d\n", w->diag4[bb_index_diag4_d(md)]);
    printf("%d\n", w->diag4[bb_index_diag4_d(mfd)]);

    printf("%d\n", w->diag5[bb_index_diag5_d(bd)]);
    printf("%d\n", w->diag5[bb_index_diag5_d(fd)]);
    printf("%d\n", w->diag5[bb_index_diag5_d(md)]);
    printf("%d\n", w->diag5[bb_index_diag5_d(mfd)]);

    printf("%d\n", w->diag6[bb_index_diag6_d(bd)]);
    printf("%d\n", w->diag6[bb_index_diag6_d(fd)]);
    printf("%d\n", w->diag6[bb_index_diag6_d(md)]);
    printf("%d\n", w->diag6[bb_index_diag6_d(mfd)]);

    printf("%d\n", w->diag7[bb_index_diag7_d(bd)]);
    printf("%d\n", w->diag7[bb_index_diag7_d(fd)]);
    printf("%d\n", w->diag7[bb_index_diag7_d(md)]);
    printf("%d\n", w->diag7[bb_index_diag7_d(mfd)]);

    printf("%d\n", w->diag8[bb_index_diag8_d(md)]);
    printf("%d\n", w->diag8[bb_index_diag8_d(mfd)]);
#endif

    eval = 0;

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

int bb_search(bboard b, int depth, int *move, int alpha, int beta, u64 mask, u32 flags)
{
    int n_discs = bm_count_bits(b.black | b.white);
    u64 pmoves = bb_potential_moves(b);
    pmoves &= ~mask;
    int max = -BB_INF;
    int best_move = -1;
    for (int square = 0; pmoves; square++) {
        if ((pmoves & (1ull << square)) == 0)
            continue;
        pmoves &= ~(1ull << square);
        u64 flips = bb_flip_discs(b, square);
        if (!flips)
            continue;
        bboard newb = bb_swap(bb_apply_flips(b, flips, square));
        int eval = -bb_eval(newb, n_discs+1);
        if (eval > max) {
            max = eval;
            best_move = square;
        }
    }
    if (best_move < 0)
        return -bb_search(bb_swap(b), depth, move, beta, alpha, mask, flags);

    if (move)
        *move = best_move;
    return max;
}
