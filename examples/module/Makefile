obj-$(CONFIG_MYDEBUG_MODULE) += mydebug_module.o

CFLAGS_mydebug_module.o := -ggdb3 -DDEBUG

ifeq ($(KERNELRELEASE),)

ifeq ($(KDIR),)
KDIR := $(shell echo /lib/modules/`uname -r`/build)
else
$(info Custom linux from $(KDIR))
CFLAGS_mydebug_module.o += -O0
endif

OUT="$(KDIR)/out"

include .config
export
export CONFIG_MYDEBUG_MODULE=m
CFLAGS_mydebug_module.o += -include $(PWD)/include/generated/autoconf.h

all: .config
	make -C $(KDIR) M=$(PWD) V=1 EXTRA_CFLAGS="$(CFLAGS_mydebug_module.o)" modules

.config: Kconfig
	$(KDIR)/scripts/kconfig/conf --alldefconfig Kconfig

.PHONY: config
config:
	$(KDIR)/scripts/kconfig/mconf Kconfig
	$(KDIR)/scripts/kconfig/conf --syncconfig Kconfig

clean:
	rm .config*
	rm -rf include/
	make -C $(KDIR) M=$(PWD) clean

install:
	make -C $(KDIR) M=$(PWD) INSTALL_MOD_PATH=$(OUT) modules_install
endif
