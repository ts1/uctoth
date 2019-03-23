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

    if (!info[0]->IsBoolean()) {
        Nan::ThrowTypeError("Argument 1 must be a Number");
        return;
    }
    bool verbose = Nan::To<bool>(info[0]).FromMaybe(false);
    bb_verbosity = verbose ? 2 : 1;
}

NAN_METHOD(set_weights)
{
    Nan::HandleScope scope;

    if (!info[0]->IsArray()) {
        Nan::ThrowTypeError("Argument must be an Array");
        return;
    }

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
}

NAN_METHOD(uct_search)
{
    if (!info[0]->IsString()) {
        Nan::ThrowTypeError("Argument 1 must be a String");
        return;
    }
    const char *board = *Nan::Utf8String(info[0]);
    bboard bb = bb_from_ascii(board, 0);

    if (!info[1]->IsNumber()) {
        Nan::ThrowTypeError("Argument 2 must be a Number");
        return;
    }
    int turn = Nan::To<int>(info[1]).FromMaybe(0);

    if (!info[2]->IsNumber()) {
        Nan::ThrowTypeError("Argument 3 must be a Number");
        return;
    }
    int n_search = Nan::To<int>(info[2]).FromMaybe(0);

    if (!info[3]->IsNumber()) {
        Nan::ThrowTypeError("Argument 4 must be a Number");
        return;
    }
    int scope = Nan::To<int>(info[3]).FromMaybe(0);

    if (!info[4]->IsNumber()) {
        Nan::ThrowTypeError("Argument 5 must be a Number");
        return;
    }
    double randomness = Nan::To<double>(info[4]).FromMaybe(0);

    if (!info[5]->IsBoolean()) {
        Nan::ThrowTypeError("Argument 6 must be a Boolean");
        return;
    }
    int tenacious = Nan::To<int>(info[5]).FromMaybe(0);

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
    if (!info[0]->IsString()) {
        Nan::ThrowTypeError("Argument 1 must be a String");
        return;
    }
    const char *board = *Nan::Utf8String(info[0]);
    bboard bb = bb_from_ascii(board, 0);

    if (!info[1]->IsNumber()) {
        Nan::ThrowTypeError("Argument 2 must be a Number");
        return;
    }
    int turn = Nan::To<int>(info[1]).FromMaybe(0);

    if (!info[2]->IsBoolean()) {
        Nan::ThrowTypeError("Argument 3 must be a Boolean");
        return;
    }
    int wld = Nan::To<int>(info[2]).FromMaybe(0);

    bb_hash_init(24);

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

NAN_MODULE_INIT(init)
{
    bb_index_init();
    NAN_EXPORT(target, set_verbose);
    NAN_EXPORT(target, set_weights);
    NAN_EXPORT(target, uct_search);
    NAN_EXPORT(target, solve);
}

NODE_MODULE(ext, init);
