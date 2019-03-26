#ifndef LEARN_H
#define LEARN_H

#ifdef __cplusplus
extern "C" {
#endif

extern int lx_vector_size, lx_offset, lx_logistic, lx_verbose;
extern double lx_min, lx_max;

void lx_add_sample(const int *row, int length);
void lx_reset(void);
double lx_average(void);
double lx_deviation(void);
double lx_learn(int n_epochs, int batch_size, double l2, float *coeffs);
double lx_cross_validation(int n_epochs, int batch_size, double l2, int k);

#ifdef __cplusplus
}
#endif

#endif
