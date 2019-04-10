#include <node_api.h>
#include <assert.h>
#include <stdlib.h>
#include <time.h>
#include "napimacros.h"
#include "learn.h"

FUNCTION(init)
{
    ARGC(4)
    ARG_INT32(0, vector_size)
    ARG_BOOL(1, logistic)
    ARG_INT32(2, base)
    ARG_BOOL(3, verbose)

    lx_vector_size = vector_size + 1;
    lx_logistic = logistic;
    lx_verbose = verbose;
    lx_offset = lx_vector_size - 1;
    lx_min = -32768. / base;
    lx_max = 32767. / base;
    srand(time(NULL));
    return 0;
}

FUNCTION(add_sample)
{
    ARGC(1)
    ARG_ARRAY(0, array)

    const uint32_t MAX_LEN = 100;
    int buf[MAX_LEN];
    uint32_t len;
    CHECK(napi_get_array_length(env, array, &len));
    assert(len < MAX_LEN);
    for (uint32_t i = 0; i < len; i++) {
        napi_value val;
        CHECK(napi_get_element(env, array, i, &val));
        CHECK(napi_get_value_int32(env, val, &buf[i]));
    }
    lx_add_sample(buf, len);
    return 0;
}

FUNCTION(reset)
{
    lx_reset();
    return 0;
}

FUNCTION(learn)
{
    ARGC(3)
    ARG_INT32(0, n_epochs)
    ARG_DOUBLE(1, l2)
    ARG_INT32(2, batch_size)

    uint32_t byte_length = lx_vector_size * sizeof(float);

    napi_value arraybuffer;
    float *weights;
    CHECK(napi_create_arraybuffer(env, byte_length, (void **) &weights,
                &arraybuffer));

    float loss = lx_learn(n_epochs, batch_size, l2, weights);

    napi_value retval, val;
    CHECK(napi_create_object(env, &retval));

    CHECK(napi_create_typedarray(env, napi_float32_array, lx_vector_size,
                arraybuffer, 0, &val));
    CHECK(napi_set_named_property(env, retval, "weights", val));

    CHECK(napi_create_double(env, loss, &val));
    CHECK(napi_set_named_property(env, retval, "loss", val));

    CHECK(napi_create_double(env, lx_average(), &val));
    CHECK(napi_set_named_property(env, retval, "avg", val));

    CHECK(napi_create_double(env, lx_deviation(), &val));
    CHECK(napi_set_named_property(env, retval, "dev", val));

    CHECK(napi_create_double(env, weights[lx_offset], &val));
    CHECK(napi_set_named_property(env, retval, "offset", val));

    return retval;
}

FUNCTION(cross_validation)
{
    ARGC(4)
    ARG_INT32(0, n_epochs)
    ARG_DOUBLE(1, l2)
    ARG_INT32(2, batch_size)
    ARG_INT32(3, k)

    double loss = lx_cross_validation(n_epochs, batch_size, l2, k);

    napi_value retval;
    CHECK(napi_create_double(env, loss, &retval));
    return retval;
}

MODULE_INIT(module_init)
{
    napi_property_descriptor pd[] = {
        EXPORT(init),
        EXPORT(reset),
        EXPORT(add_sample),
        EXPORT(learn),
        EXPORT(cross_validation),
    };
    CHECK(napi_define_properties(env, exports, sizeof(pd)/sizeof(pd[0]), pd));
    return exports;
}

NAPI_MODULE(learn_ext, module_init);
