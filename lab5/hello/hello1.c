#include <linux/init.h>
#include <linux/module.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/ktime.h>
#include "hello1.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Maxim Kradozhon");
MODULE_DESCRIPTION("Hello1 module with time measurement");

static LIST_HEAD(hello_list);

void print_hello(void)
{
    struct hello_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
    if (!data)
        return;

    data->start_time = ktime_get();
    pr_info("Hello, world!\n");
    data->end_time = ktime_get();

    list_add_tail(&data->list, &hello_list);
}
EXPORT_SYMBOL(print_hello);

static void __exit hello1_exit(void)
{
    struct hello_data *data, *tmp;

    list_for_each_entry_safe(data, tmp, &hello_list, list) {
        s64 delta = ktime_to_ns(ktime_sub(data->end_time, data->start_time));
        pr_info("Time for print_hello(): %lld ns\n", delta);
        list_del(&data->list);
        kfree(data);
    }

    pr_info("hello1 unloaded\n");
}

module_exit(hello1_exit);
