obj-m = xt_FULLCONENAT.o
CFLAGS_xt_FULLCONENAT.o := ${CFLAGS}
KVERSION = $(shell uname -r)

PKG_CONFIG ?= pkg-config
INSTALL ?= install

XTABLES_SO_DIR = $(shell $(PKG_CONFIG) xtables --variable xtlibdir)

ipt_objs = libipt_FULLCONENAT.so

all: $(ipt_objs)
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) clean

.PHONY: install clean

install:
	for i in $(ipt_objs); do $(INSTALL) -m 755 $$i $(DESTDIR)${XTABLES_SO_DIR}; done

lib%.so: lib%.o
	gcc -shared -fPIC -o $@ $^;

lib%.o: lib%.c
	gcc ${CFLAGS} -D_INIT=lib$*_init -fPIC -c -o $@ $<;

clean:
	rm -rf *.o *.so *.ko
