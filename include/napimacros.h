#ifndef NAPIMACROS_H
#define NAPIMACROS_H

#include <stdio.h>
#include <string.h>
#include <node_api.h>

#define FUNCTION(name) \
static napi_value name##_binding(napi_env env, napi_callback_info info)

#define CHECK(e) ( \
    (e) == napi_ok ? \
        (void) 0 : \
        (fprintf(stderr, "N-API call failed at %s:%d\n", __FILE__, __LINE__), \
             abort()))

#define ARGC(n) \
    size_t _argc = n; \
    napi_value _argv[n]; \
    memset(_argv, 0, sizeof _argv); \
    CHECK(napi_get_cb_info(env, info, &_argc, _argv, 0, 0));

#define ARG_STRING(i, name, len) \
    char name[len]; \
    { \
        napi_value tmp; \
        CHECK(napi_coerce_to_string(env, _argv[i], &tmp)); \
        CHECK(napi_get_value_string_utf8(env, tmp, name, len, 0)); \
    }

#define ARG_INT32(i, name) \
    int32_t name; \
    { \
        napi_value tmp; \
        CHECK(napi_coerce_to_number(env, _argv[i], &tmp)); \
        CHECK(napi_get_value_int32(env, tmp, &name)); \
    }

#define ARG_DOUBLE(i, name) \
    double name; \
    { \
        napi_value tmp; \
        CHECK(napi_coerce_to_number(env, _argv[i], &tmp)); \
        CHECK(napi_get_value_double(env, tmp, &name)); \
    }

#define ARG_BOOL(i, name) \
    bool name; \
    { \
        napi_value tmp; \
        CHECK(napi_coerce_to_bool(env, _argv[i], &tmp)); \
        CHECK(napi_get_value_bool(env, tmp, &name)); \
    }

#define ARG_FUNC(i, name) \
    napi_value name; \
    { \
        napi_valuetype type = 0; \
        napi_typeof(env, _argv[i], &type); \
        if (type != napi_function) { \
            napi_throw_error(env, 0, "Argument " #i " must be a function"); \
            return 0; \
        } \
        name = _argv[i]; \
    }

#define ARG_ARRAY(i, name) \
    napi_value name; \
    { \
        bool is_array = 0; \
        napi_is_array(env, _argv[i], &is_array); \
        if (!is_array) { \
            napi_throw_error(env, 0, "Argument " #i " must be an array"); \
            return 0; \
        } \
        name = _argv[i]; \
    }

#define MODULE_INIT(name) \
static napi_value name(napi_env env, napi_value exports)

#define EXPORT(name) { #name, 0, name##_binding, 0, 0, 0, napi_default, 0 }

#endif
