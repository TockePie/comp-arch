obj-m += hello1.o
obj-m += hello2.o

ccflags-y := -I$(PWD)/inc

all:
	make -C /workspace/repos/linux-stable M=$(PWD) modules

clean:
	make -C /workspace/repos/linux-stable M=$(PWD) clean
