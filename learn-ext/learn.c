#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include <string.h>
#include "learn.h"

#define MAX_FEATURES 46

int lx_vector_size, lx_offset, lx_logistic, lx_verbose;
double lx_min, lx_max;;

typedef struct {
    float outcome;
    uint16_t n_features; 
    uint16_t indexes[MAX_FEATURES];
    int8_t values[MAX_FEATURES];
} sample_t;

typedef struct {
    uint32_t length;
    sample_t *array[];
} ptr_array_t;

static int n_samples, max_samples;
static sample_t *samples;
static float *gradient, *g2, *weights;

#define LOG(args) (lx_verbose ? printf args : 0)

static inline double clip(double val)
{
    if (val > lx_max) return lx_max;
    if (val < lx_min) return lx_min;
    return val;

}

void clear_vector(float *vector)
{
    memset(vector, 0, lx_vector_size * sizeof(float));
}

void lx_add_sample(const int *row, int length)
{
    if (n_samples >= max_samples) {
        if (max_samples == 0)
            max_samples = 1000;
        else
            max_samples *= 2;
        samples = realloc(samples, max_samples * sizeof(sample_t));
    }

    sample_t *s = &samples[n_samples++];

    if (lx_logistic)
        s->outcome = row[0] > 0 ? 0.99 : row[0] < 0 ? 0.01 : 0.5;
    else
        s->outcome = (float) row[0];

    int j = 0;
    for (int i = 1; i < length; i += 2) {
        assert(row[i] >= 0 && row[i] < 65536);
        assert(row[i+1] >= -128 && row[i+1] < 128);
        s->indexes[j] = (uint16_t) row[i];
        s->values[j] = (int8_t) row[i+1];
        j++;
    }
    assert(j <= MAX_FEATURES);
    s->n_features = j;
}

void lx_reset(void)
{
    if (samples) {
        free(samples);
        samples = NULL;
    }
    n_samples = 0;
    max_samples = 0;
}

double lx_average(void)
{
    double sum = 0;
    for (sample_t *s = samples; s < &samples[n_samples]; s++)
        sum += s->outcome;
    return sum / n_samples;
}

static double deviation(ptr_array_t *a)
{
    double sum = 0;
    for (sample_t **p = a->array; p < a->array + a->length; p++) {
        sample_t *s = *p;
        double y = lx_logistic ? s->outcome - 0.5 : s->outcome;
        sum += y * y;
    }
    return sqrt(sum / a->length);
}

static ptr_array_t *alloc_ptr_array(len)
{
    ptr_array_t *array = calloc(1, sizeof(ptr_array_t) + len * sizeof(void *));
    array->length = len;
    return array;
}

static ptr_array_t *make_sample_array(void)
{
    ptr_array_t *a = alloc_ptr_array(n_samples);
    sample_t **p = a->array;
    for (sample_t *s = samples; s < &samples[n_samples]; s++)
        *p++ = s;
    return a;
}

double lx_deviation(void)
{
    ptr_array_t *array = make_sample_array();
    double retval = deviation(array);
    free(array);
    return retval;
}

static void shuffle(ptr_array_t *a)
{
    for (int i = a->length - 1; i >= 0; i--) {
        int r = rand() % (i + 1);
        void *tmp = a->array[i];
        a->array[i] = a->array[r];
        a->array[r] = tmp;
    }
}

static double predict(const sample_t *s)
{
    double sum = 0;
    for (int i = 0; i < s->n_features; i++)
        sum += weights[s->indexes[i]] * s->values[i];
    sum += weights[lx_offset];
    if (lx_logistic)
        return 1. / (1. + exp(-sum));
    else
        return sum;
}

static double verify(ptr_array_t *a)
{
    double sum = 0;
    sample_t **end = a->array + a->length;
    for (sample_t **p = a->array; p < end; p++) {
        sample_t *s = *p;
        double e = s->outcome - predict(s);
        sum += e * e;
    }
    return sqrt(sum / a->length);
}

static void
batch(sample_t **start, sample_t **end, int stride, double l2)
{
    clear_vector(gradient);
    for (sample_t **p = start; p < end; p += stride) {
        sample_t *s = *p;
        double e = predict(s) - s->outcome;
        for (int i = 0; i < s->n_features; i++)
            gradient[s->indexes[i]] -= e * s->values[i];
        gradient[lx_offset] -= e;
    }
}

static void
epoch(ptr_array_t *a, int batch_size, double rate, double l2)
{
    int n_batches = a->length / batch_size;
    for (int offset = 0; offset < n_batches; offset++) {
        batch(a->array + offset, a->array + a->length, n_batches, l2);
        for (int i = 0; i < lx_vector_size; i++) {
            double g = gradient[i];
            if (g) {
                g2[i] += g * g;
                double w = weights[i];
                g -= l2 * w;
                w += rate * g / sqrt(g2[i]);
                weights[i] = clip(w);
            }
        }
    }
}

static double
find_learning_rate(ptr_array_t *a, int batch_size, double l2)
{
    double rate = 10;
    double step = 10;
    double min_loss = deviation(a);
    double best_rate = 0;
    LOG(("Finding optimal learning rate: "));
    for (;;) {
        clear_vector(weights);
        clear_vector(g2);
        epoch(a, batch_size, rate, l2);
        double loss = verify(a);
        if (loss < min_loss) {
            min_loss = loss;
            best_rate = rate;
        } else {
            if (best_rate)
                break;
        }
        rate /= step;
        if (rate < 1e-100) {
            LOG(("something's wrong\n"));
            abort();
        }
    }

    while (step >= 1.1) {
        step = sqrt(step);
        double rate, loss;

        rate = best_rate * step;
        clear_vector(weights);
        clear_vector(g2);
        epoch(a, batch_size, rate, l2);
        loss = verify(a);
        if (loss < min_loss) {
            min_loss = loss;
            best_rate = rate;
            continue;
        }

        rate = best_rate / step;
        clear_vector(weights);
        clear_vector(g2);
        epoch(a, batch_size, rate, l2);
        loss = verify(a);
        if (loss < min_loss) {
            min_loss = loss;
            best_rate = rate;
        }
    }
    LOG(("%g\n", best_rate));
    return best_rate;
}

static void learn(ptr_array_t *a, int n_epochs, int batch_size, double l2)
{
    shuffle(a);
    if (!batch_size)
        batch_size = a->length / 10;
    double rate = find_learning_rate(a, batch_size, l2);
    clear_vector(weights);
    clear_vector(g2);
    for (int i = 0 ; i < n_epochs; i++) {
        LOG(("epoch %d\r", i));
        shuffle(a);
        epoch(a, batch_size, rate, l2);
    }
}

double lx_learn(int n_epochs, int batch_size, double l2, float *weights_)
{
    weights = weights_;
    gradient = malloc(lx_vector_size * sizeof(float));
    g2 = malloc(lx_vector_size * sizeof(float));

    ptr_array_t *array = make_sample_array();

    learn(array, n_epochs, batch_size, l2);
    double loss = verify(array);
    LOG(("loss %g\r", loss));

    free(array);
    free(gradient);
    free(g2);
    return loss;
}

static ptr_array_t **split_groups(ptr_array_t *a, int k)
{
    ptr_array_t **groups = malloc(k * sizeof(ptr_array_t *));
    int n_per_group = (n_samples + k - 1) / k;
    for (int i = 0; i < k; i++) {
        int n = n_per_group;
        if (n * i + n > n_samples)
            n = n_samples - n * i;
        groups[i] = alloc_ptr_array(n);
        memcpy(groups[i]->array, &a->array[i * n_per_group], n*sizeof(void *));
    }
    return groups;
}

static ptr_array_t *join_groups(ptr_array_t *groups[], int exclude, int k)
{
    int len = 0;
    for (int i = 0; i < k; i++)
        if (i != exclude)
            len += groups[i]->length;

    ptr_array_t *a = alloc_ptr_array(len);
    int offset = 0;
    for (int i = 0 ; i < k; i++) {
        if (i != exclude) {
            memcpy(a->array + offset, groups[i]->array,
                    groups[i]->length * sizeof(void *));
            offset += groups[i]->length;
        }
    }
    return a;
}

double lx_cross_validation(int n_epochs, int batch_size, double l2, int k)
{
    weights = malloc(lx_vector_size * sizeof(float));
    gradient = malloc(lx_vector_size * sizeof(float));
    g2 = malloc(lx_vector_size * sizeof(float));

    ptr_array_t *array = make_sample_array();
    shuffle(array);

    ptr_array_t **groups = split_groups(array, k);

    double avg = 0;
    for (int i = 0; i < k; i++) {
        ptr_array_t *test_set = groups[i];
        ptr_array_t *train_set = join_groups(groups, i, k);
        learn(train_set, n_epochs, batch_size, l2);
        double loss = verify(test_set);
        avg += loss / k;
        free(train_set);
    }

    for (int i = 0; i < k; i++)
        free(groups[i]);
    free(groups);
    free(array);
    free(weights);
    free(gradient);
    free(g2);

    return avg;
}
