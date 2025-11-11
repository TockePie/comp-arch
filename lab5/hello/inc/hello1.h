#ifndef HELLO1_H
#define HELLO1_H

#include <linux/ktime.h>

void print_hello(void);

struct hello_data {
    struct list_head list;
    ktime_t start_time;
    ktime_t end_time;
};

#endif
