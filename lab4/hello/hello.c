#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/slab.h>        // kmalloc, kfree
#include <linux/list.h>        // списки
#include <linux/ktime.h>       // час ядра

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Maxim Kradozhon");
MODULE_DESCRIPTION("Hello world module with list and time tracking");
MODULE_VERSION("1.2");

static uint times = 1;
module_param(times, uint, 0444);
MODULE_PARM_DESC(times, "Кількість виведених повідомлень 'Hello, world!' (uint)");

// структура для зберігання часу виклику
struct hello_item {
    struct list_head list;
    ktime_t timestamp;
};

static LIST_HEAD(hello_list); // статична голова списку

static int __init hello_init(void)
{
    int i;
    struct hello_item *item;

    if (times == 0 || (times >= 5 && times <= 10)) {
        pr_warn("hello: Warning! times=%u — граничне значення, але продовжую\n", times);
    }

    if (times > 10) {
        pr_err("hello: Error! times=%u > 10 — модуль не буде завантажено\n", times);
        return -EINVAL;
    }

    for (i = 0; i < times; i++) {
        item = kmalloc(sizeof(*item), GFP_KERNEL);
        if (!item) {
            pr_err("hello: Помилка виділення пам’яті\n");
            return -ENOMEM;
        }

        item->timestamp = ktime_get();
        list_add_tail(&item->list, &hello_list);
        pr_info("Hello, world! (%d)\n", i + 1);
    }

    return 0;
}

static void __exit hello_exit(void)
{
    struct hello_item *item, *tmp;

    pr_info("Goodbye, world! Вивід часу подій:\n");

    list_for_each_entry_safe(item, tmp, &hello_list, list) {
        pr_info("  time(ns): %lld\n", ktime_to_ns(item->timestamp));
        list_del(&item->list);
        kfree(item);
    }
}

module_init(hello_init);
module_exit(hello_exit);
