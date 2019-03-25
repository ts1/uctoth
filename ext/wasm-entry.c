#include <emscripten/emscripten.h>
#include "src/bitboard.h"
#include "src/bitmap.h"
#include "src/bb_index.h"
#include "src/bb_hash.h"
#include "src/bb_eval.h"
#include "src/bb_uct.h"
#include "src/oth.h"

EMSCRIPTEN_KEEPALIVE
void set_verbose(int verbose)
{
    bb_verbosity = verbose ? 2 : 1;
}

EMSCRIPTEN_KEEPALIVE
void set_weights_single(int i, const s16 *weights)
{
    bb_set_weights(i, weights);
}

EMSCRIPTEN_KEEPALIVE
void *get_weights_ptr(int phase)
{
    return bb_get_weights_ptr(phase);
}

EMSCRIPTEN_KEEPALIVE
void nega_weight(int phase)
{
    bb_nega_weight();
}

EMSCRIPTEN_KEEPALIVE
s32 eval(const char *board, int turn, int n_search, int scope)
{
    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);
    int n_discs = bm_count_bits(bb.black | bb.white);
    return bb_eval(bb, n_discs);
}

EMSCRIPTEN_KEEPALIVE
s32 uct_search(const char *board, int turn, int n_search, int scope)
{
    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);

    int move;
    int value = bb_uct_search(bb, n_search, &move, scope, 0., 1);
    return value << 8 | move;
}

EMSCRIPTEN_KEEPALIVE
s32 solve(const char *board, int turn, int wld)
{
    bboard bb = bb_from_ascii(board, 0);

    if (turn == -1)
        bb = bb_swap(bb);
    int score;
    int move = bb_endgame(bb, &score, wld, 0);
    return score << 16 | move;
}

int main(void)
{
    bb_hash_init(18);
    bb_index_init();
    return 0;
}
