#include <emscripten.h>
#include "src/bitboard.h"
#include "src/bb_eval.h"
#include "src/bb_index.h"
#include "src/bb_hash.h"
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
u32 solve(const char *board, int turn, int wld)
{
    bboard bb = bb_from_ascii(board, 0);

    bb_hash_init(18);

    if (turn == -1)
        bb = bb_swap(bb);
    int score;
    int move = bb_endgame(bb, &score, wld, 0);
    return score << 16 | move;
}
