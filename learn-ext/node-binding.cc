#include <nan.h>
#include <assert.h>
#include <stdlib.h>
#include <time.h>
#include "learn.h"

using namespace v8;

namespace learn_ext {
    NAN_METHOD(init)
    {
        lx_vector_size = Nan::To<int>(info[0]).FromMaybe(0) + 1;
        lx_logistic = (int) Nan::To<bool>(info[1]).FromMaybe(false);
        int base = Nan::To<int>(info[2]).FromMaybe(0);
        lx_verbose = (int) Nan::To<bool>(info[3]).FromMaybe(true);

        lx_offset = lx_vector_size - 1;
        lx_min = -32768. / base;
        lx_max = 32767. / base;
        srand(time(NULL));
    }

    NAN_METHOD(add_sample)
    {
        const int MAX_LEN = 100;
        Nan::HandleScope scope;
        int buf[MAX_LEN];

        Local<Array> array = info[0].As<Array>();
        int len = array->Length();
        assert(len < MAX_LEN);
        for (int i = 0; i < len; i++) {
            Local<Value> val = array->Get(i);
            buf[i] = Nan::To<int>(val).FromMaybe(0);
        }
        lx_add_sample(buf, len);
    }

    NAN_METHOD(reset)
    {
        lx_reset();
    }

    NAN_METHOD(learn)
    {
        int n_epochs = Nan::To<int>(info[0]).FromMaybe(0);
        double l2 = Nan::To<double>(info[1]).FromMaybe(0.);
        int batch_size = Nan::To<int>(info[2]).FromMaybe(0);

        uint32_t byte_length = lx_vector_size * sizeof(float);
        Local<ArrayBuffer> buffer = ArrayBuffer::New(Isolate::GetCurrent(), byte_length);
        Local<Float32Array> f32array = Float32Array::New(buffer, 0, lx_vector_size);
        Nan::TypedArrayContents<float> weights(f32array);

        float loss = lx_learn(n_epochs, batch_size, l2, *weights);

        Local<Object> retval = Nan::New<Object>();
        retval->Set(Nan::New<String>("weights").ToLocalChecked(), f32array);
        retval->Set(
            Nan::New<String>("loss").ToLocalChecked(),
            Nan::New<Number>(loss)
        );
        retval->Set(
            Nan::New<String>("avg").ToLocalChecked(),
            Nan::New<Number>(lx_average())
        );
        retval->Set(
            Nan::New<String>("dev").ToLocalChecked(),
            Nan::New<Number>(lx_deviation())
        );
        retval->Set(
            Nan::New<String>("offset").ToLocalChecked(),
            Nan::New<Number>((*weights)[lx_offset])
        );
        info.GetReturnValue().Set(retval);
    }

    NAN_MODULE_INIT(module_init)
    {
        NAN_EXPORT(target, init);
        NAN_EXPORT(target, reset);
        NAN_EXPORT(target, add_sample);
        NAN_EXPORT(target, learn);
    }

    NODE_MODULE(learn_ext, module_init);
}
