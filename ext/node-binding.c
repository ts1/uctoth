#include <node_api.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include "napimacros.h"
#include "src/bitboard.h"
#include "src/bb_eval.h"
#include "src/bb_index.h"
#include "src/bb_hash.h"
#include "src/bb_uct.h"
#include "src/bb_minimax.h"
#include "src/oth.h"

FUNCTION(set_verbose)
{
    ARGC(1)
    ARG_BOOL(0, verbose)
    bb_verbosity = verbose ? 2 : 1;
    return 0;
}

FUNCTION(set_weights)
{
    ARGC(2)
    ARG_ARRAY(0, array);
    ARG_BOOL(1, inverted);

    for (int i = 0; i < N_PHASES; i++) {
        napi_value val;
        CHECK(napi_get_element(env, array, i, &val));
        bool is_typed_array;
        CHECK(napi_is_typedarray(env, val, &is_typed_array));
        if (!is_typed_array) {
            napi_throw_error(env, 0, "Argument 0 must be array of Int16Array");
            return 0;
        }
        napi_typedarray_type type;
        void *data;
        size_t offset;
        CHECK(napi_get_typedarray_info(env, val, &type, 0, &data, 0, &offset));
        if (type != napi_int16_array) {
            napi_throw_error(env, 0, "Argument 0 must be array of Int16Array");
            return 0;
        }
        int16_t *weights = (int16_t *) ((char *) data + offset);
        bb_set_weights(i, weights);
    }

    if (inverted)
        bb_nega_weight();
    return 0;
}

FUNCTION(evaluate)
{
    ARGC(2)
    ARG_STRING(0, board, 256);
    ARG_INT32(1, turn);

    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);
    int n_discs = bm_count_bits(bb.black | bb.white);
    int eval = bb_eval(bb, n_discs);

    napi_value retval;
    CHECK(napi_create_int32(env, eval, &retval));
    return retval;
}

FUNCTION(set_uct_options)
{
    ARGC(5)
    ARG_INT32(0, n_search)
    ARG_DOUBLE(1, scope)
    ARG_DOUBLE(2, randomness)
    ARG_BOOL(3, tenacious)
    ARG_BOOL(4, by_value)

    bb_uct_set_options(n_search, scope, randomness, tenacious, by_value);

    return 0;
}

FUNCTION(uct_search)
{
    ARGC(4)
    ARG_STRING(0, board, 256)
    ARG_INT32(1, turn)
    ARG_INT32(2, mask_lower)
    ARG_INT32(3, mask_upper)

    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);

    u64 mask = (((u64) mask_upper) << 32) | mask_lower;

    int move = -1;
    int value = bb_uct_search(bb, &move, mask);

    napi_value retval, val;
    CHECK(napi_create_object(env, &retval));

    CHECK(napi_create_int32(env, move, &val));
    CHECK(napi_set_named_property(env, retval, "move", val));

    CHECK(napi_create_int32(env, value, &val));
    CHECK(napi_set_named_property(env, retval, "value", val));

    return retval;
}

FUNCTION(solve)
{
    ARGC(3)
    ARG_STRING(0, board, 256)
    ARG_INT32(1, turn)
    ARG_BOOL(2, wld)

    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);
    int score;
    int move = bb_endgame(bb, &score, wld, 0);

    napi_value retval, val;
    CHECK(napi_create_object(env, &retval));

    CHECK(napi_create_int32(env, move, &val));
    CHECK(napi_set_named_property(env, retval, "move", val));

    CHECK(napi_create_int32(env, score, &val));
    CHECK(napi_set_named_property(env, retval, "value", val));

    return retval;
}

FUNCTION(reset_hash)
{
    bb_hash_reset();
    return 0;
}

FUNCTION(minimax)
{
    ARGC(6)
    ARG_STRING(0, board, 256);
    ARG_INT32(1, turn);
    ARG_INT32(2, depth);
    ARG_INT32(3, nodes);
    ARG_INT32(4, mask_lower);
    ARG_INT32(5, mask_upper);
    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);

    u64 mask = (((u64) mask_upper) << 32) | mask_lower;

    int move;
    int value = bb_minimax(bb, depth, nodes, &move, mask);

    napi_value retval, val;
    CHECK(napi_create_object(env, &retval));
    CHECK(napi_create_int32(env, move, &val));
    CHECK(napi_set_named_property(env, retval, "move", val));
    CHECK(napi_create_int32(env, value, &val));
    CHECK(napi_set_named_property(env, retval, "value", val));
    return retval;
}

MODULE_INIT(init)
{
    bb_index_init();
    bb_hash_init(22);

    srand(time(NULL) + getpid());

    napi_property_descriptor pd[] = {
        EXPORT(set_verbose),
        EXPORT(set_weights),
        EXPORT(evaluate),
        EXPORT(set_uct_options),
        EXPORT(uct_search),
        EXPORT(reset_hash),
        EXPORT(solve),
        EXPORT(minimax),
    };
    CHECK(napi_define_properties(env, exports, sizeof(pd)/sizeof(pd[0]), pd));
    return exports;
}

NAPI_MODULE(ext, init);
