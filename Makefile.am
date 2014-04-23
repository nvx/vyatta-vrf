cfgdir = $(datadir)/vyatta-cfg
opdir = $(datadir)/vyatta-op
sbindir = $(datadir)/sbin
curverdir = $(sysconfdir)/config-migrate/current
bin_sudo_usersdir = $(bindir)/sudo-users

vprefix = /opt/vyatta
vsbindir = $(vprefix)/sbin

sbin_SCRIPTS =

bin_sudo_users_SCRIPTS =

curver_DATA = 

cpiop = find  . ! -regex '\(.*~\|.*\.bak\|.*\.swp\|.*\#.*\#\)' -print0 | \
  cpio -0pd

install-exec-hook:
	mkdir -p $(DESTDIR)$(cfgdir)
	cd vyatta-cfg; $(cpiop) $(DESTDIR)$(cfgdir)
	mkdir -p $(DESTDIR)$(opdir)
	cd vyatta-op; $(cpiop) $(DESTDIR)$(opdir)
	mkdir -p $(DESTDIR)$(sbindir)
	cd sbin; $(cpiop) $(DESTDIR)$(sbindir)
