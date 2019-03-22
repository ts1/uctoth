#include "bb_index.h"

#define INDEX_ORDER 10
#define INDEX_SIZE (1<<INDEX_ORDER)

int bb_index_tbl[INDEX_SIZE];

void bb_index_init(void)
{
    int i;

    for (i = 0; i < INDEX_SIZE; i++) {
        int bit, sum, p3;

        sum = 0;
        p3 = 1;
        for (bit = 0; bit < INDEX_ORDER; bit++) {
            if (i & (1<<bit))
                sum += p3;
            p3 *= 3;
        }
        bb_index_tbl[i] = sum;
    }
}
