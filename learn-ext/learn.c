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

typedef struct sample {
    float outcome;
    uint16_t n_features; 
    uint16_t indexes[MAX_FEATURES];
    int8_t values[MAX_FEATURES];
} sample_t;

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

static double deviation(sample_t *array[], int len)
{
    double sum = 0;
    for (sample_t **p = array; p < &array[len]; p++) {
        sample_t *s = *p;
        double y = lx_logistic ? s->outcome - 0.5 : s->outcome;
        sum += y * y;
    }
    return sqrt(sum / len);
}

double lx_deviation(void)
{
    double sum = 0;
    for (sample_t *s = samples; s < &samples[n_samples]; s++) {
        double x = lx_logistic ? s->outcome - 0.5 : s->outcome;
        sum += x * x;
    }
    return sqrt(sum / n_samples);
}

static void shuffle(sample_t *array[], int len)
{
    for (int i = len - 1; i >= 0; i--) {
        int r = rand() % (i + 1);
        void *tmp = array[i];
        array[i] = array[r];
        array[r] = tmp;
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

static double verify(sample_t *p[], int len)
{
    double sum = 0;
    sample_t **end = p + len;
    for (; p < end; p++) {
        sample_t *s = *p;
        double e = s->outcome - predict(s);
        sum += e * e;
    }
    return sqrt(sum / len);
}

static void
minibatch(sample_t **start, int stride, sample_t **end, double l2)
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
epoch(sample_t *dataset[], int len, int batch_size, double rate, double l2)
{
    int n_batches = len / batch_size;
    for (int offset = 0; offset < n_batches; offset++) {
        minibatch(dataset + offset, n_batches, dataset + len, l2);
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
find_learning_rate(sample_t *dataset[], int len, int batch_size, double l2)
{
    double rate = 10;
    double step = 10;
    double min_loss = deviation(dataset, len);
    double best_rate = 0;
    LOG(("Finding optimal learning rate: "));
    for (;;) {
        clear_vector(weights);
        clear_vector(g2);
        epoch(dataset, len, batch_size, rate, l2);
        double loss = verify(dataset, len);
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
        epoch(dataset, len, batch_size, rate, l2);
        loss = verify(dataset, len);
        if (loss < min_loss) {
            min_loss = loss;
            best_rate = rate;
            continue;
        }

        rate = best_rate / step;
        clear_vector(weights);
        clear_vector(g2);
        epoch(dataset, len, batch_size, rate, l2);
        loss = verify(dataset, len);
        if (loss < min_loss) {
            min_loss = loss;
            best_rate = rate;
        }
    }
    LOG(("%g\n", best_rate));
    return best_rate;
}

static void learn(sample_t *dataset[], int len, int n_epochs,
        int batch_size, double l2)
{
    shuffle(dataset, len);
    if (!batch_size)
        batch_size = len / 10;
    double rate = find_learning_rate(dataset, len, batch_size, l2);
    clear_vector(weights);
    clear_vector(g2);
    for (int i = 0 ; i < n_epochs; i++) {
        LOG(("epoch %d\r", i));
        shuffle(dataset, len);
        epoch(dataset, len, batch_size, rate, l2);
    }
}

double lx_learn(int n_epochs, int batch_size, double l2, float *weights_)
{
    weights = weights_;
    gradient = malloc(lx_vector_size * sizeof(float));
    g2 = malloc(lx_vector_size * sizeof(float));

    sample_t **dataset = malloc(n_samples * sizeof(sample_t));
    sample_t **p = dataset;
    for (sample_t *s = samples; s < &samples[n_samples]; s++)
        *p++ = s;

    learn(dataset, n_samples, n_epochs, batch_size, l2);
    double loss = verify(dataset, n_samples);
    LOG(("loss %g\r", loss));

    free(dataset);
    free(gradient);
    free(g2);
    return loss;
}
