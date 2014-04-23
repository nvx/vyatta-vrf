cfgdir = $(datadir)/vyatta-cfg
opdir = $(datadir)/vyatta-op
curverdir = $(sysconfdir)/config-migrate/current
bin_sudo_usersdir = $(bindir)/sudo-users

bin_SCRIPTS = bin/xvtyshow.pl

sbin_SCRIPTS = sbin/xvyatta-link-detect sbin/xvyatta-multi-vtysh.pl sbin/xvyatta-quagga-config-gen.pl sbin/xvyatta-veth.pl

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
