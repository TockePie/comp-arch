#include <linux/moduleparam.h>
#include "hello1.h"

static uint times = 1;          // значення за замовчуванням
module_param(times, uint, 0444);
MODULE_PARM_DESC(times, "Number of times to call print_hello()");

static int __init hello2_init(void)
{
    if (times == 0 || (times >= 5 && times <= 10))
        pr_warn("hello2: WARNING – times parameter in [5..10] or 0\n");
    if (times > 10) {
        pr_err("hello2: ERROR – invalid times value > 10\n");
        return -EINVAL;
    }
    print_hello(times);
    pr_info("hello2 loaded with count=%u\n", times);
    return 0;
}

static void __exit hello2_exit(void)
{
    pr_info("hello2 unloaded\n");
}

module_init(hello2_init);
module_exit(hello2_exit);

MODULE_LICENSE("GPL");
