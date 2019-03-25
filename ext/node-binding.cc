#include <nan.h>
#include <stdlib.h>
#include "src/bitboard.h"
#include "src/bb_eval.h"
#include "src/bb_index.h"
#include "src/bb_hash.h"
#include "src/bb_uct.h"
#include "src/oth.h"

using namespace v8;

NAN_METHOD(set_verbose)
{
    Nan::HandleScope scope;

    bool verbose = Nan::To<bool>(info[0]).FromMaybe(false);
    bb_verbosity = verbose ? 2 : 1;
}

NAN_METHOD(set_weights)
{
    Nan::HandleScope scope;

    Local<Array> array = info[0].As<Array>();
    for (int i = 0; i < N_PHASES; i++) {
        Local<Value> val = array->Get(i);
        if (!val->IsInt16Array()) {
            Nan::ThrowTypeError("Argument must be an Array of Int16Array");
            return;
        }
        Nan::TypedArrayContents<s16> weights(val.As<Int16Array>());
        bb_set_weights(i, *weights);
    }

    bool inverted = Nan::To<bool>(info[1]).FromMaybe(false);
    if (inverted)
        bb_nega_weight();
}

NAN_METHOD(evaluate)
{
    const char *board = *Nan::Utf8String(info[0]);
    int turn = Nan::To<int>(info[1]).FromMaybe(0);
    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);
    int n_discs = bm_count_bits(bb.black | bb.white);

    int eval = bb_eval(bb, n_discs);

    info.GetReturnValue().Set(eval);
}

NAN_METHOD(uct_search)
{
    const char *board = *Nan::Utf8String(info[0]);
    int turn = Nan::To<int>(info[1]).FromMaybe(0);
    int n_search = Nan::To<int>(info[2]).FromMaybe(0);
    int scope = Nan::To<int>(info[3]).FromMaybe(0);
    double randomness = Nan::To<double>(info[4]).FromMaybe(0);
    int tenacious = Nan::To<int>(info[5]).FromMaybe(0);

    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);

    int move = -1;
    int value = bb_uct_search(bb, n_search, &move, scope, randomness, tenacious);

    Local<Object> retval = Nan::New<Object>();
    retval->Set(
        Nan::New<String>("move").ToLocalChecked(),
        Nan::New<Int32>(move)
    );
    retval->Set(
        Nan::New<String>("value").ToLocalChecked(),
        Nan::New<Int32>(value)
    );
    info.GetReturnValue().Set(retval);
}

NAN_METHOD(solve)
{
    const char *board = *Nan::Utf8String(info[0]);
    int turn = Nan::To<int>(info[1]).FromMaybe(0);
    int wld = Nan::To<int>(info[2]).FromMaybe(0);

    bboard bb = bb_from_ascii(board, 0);
    if (turn == -1)
        bb = bb_swap(bb);
    int score;
    int move = bb_endgame(bb, &score, wld, 0);

    Local<Object> retval = Nan::New<Object>();
    retval->Set(
        Nan::New<String>("move").ToLocalChecked(),
        Nan::New<Int32>(move)
    );
    retval->Set(
        Nan::New<String>("value").ToLocalChecked(),
        Nan::New<Int32>(score)
    );
    info.GetReturnValue().Set(retval);
}

NAN_METHOD(reset_hash)
{
    bb_hash_reset();
}

NAN_MODULE_INIT(init)
{
    bb_index_init();
    bb_hash_init(22);
    NAN_EXPORT(target, set_verbose);
    NAN_EXPORT(target, set_weights);
    NAN_EXPORT(target, evaluate);
    NAN_EXPORT(target, uct_search);
    NAN_EXPORT(target, reset_hash);
    NAN_EXPORT(target, solve);
}

NODE_MODULE(ext, init);
