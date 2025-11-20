ifneq ($(KERNELRELEASE),)
# kbuild part of makefile
obj-m := hello.o
ccflags-y += -g
else
KDIR ?= /lib/modules/`uname -r`/build
PWD := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
	cp hello.ko hello.ko.unstripped
	strip -g hello.ko

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
endif
