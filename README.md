VRF-VYATTA
==========

vrf-vyatta is vyatta CLI extension for enabling VRF using Linux network
namespace. It enables that you can configure _vrf_ in top level of 
configure mode. It uses Linux namespace. Protocol static, ospf, and 
ospfv3 processes can be run on a vrf instance. 
And only vlan interface can be attached into VRF.


vrf-vyatta requires alternative quagga and iproute2. 

Install quagga
--------------

vrf-vyatta requires quagga software that is applied multi vtysh patch.
The patch url is 
<http://lists.quagga.net/pipermail/quagga-dev/2012-July/009627.html>.
This patch can be applied to only quagga release 0.99.21.

	 % apt-get install -y libreadline-dev 
	 % wget http://download.savannah.gnu.org/releases/quagga/quagga-0.99.21.tar.gz
	 % tar zxvf quagga-0.99.21.tar.gz
	 % cd quagga-0.99.21
	 % patch -p1 < quagga-multi-vty.patch
	 % ./configure --enable-vtysh --disable-ripd --disable-ripngd --disable-babeld --disable-watchquagga --disable-doc
	 % make
	 % make install
	 % /usr/sbin/zebra --version
	 lt-zebra version 0.99.21
	 Copyright 1996-2005 Kunihiro Ishiguro, et al.

This quagga routing softwares (ospfd, ospf6d, zebra) are installed to 
/usr/sbin, and vtysh is installed to /usr/local/bin directory. 
Don't change these prefixes because they are hardcoded into vyatta cli 
extensions for VRF. Preinstalled quagga softwares are installed to 
/usr/*bin directories.


Install iproute2
----------------

Preinstalled iproute2 (iproute2-ss120801) on VC6.5 can not exec commands
on network namespace. So please install new iproute2
(I have tested with iproute2-ss121211).

	 % apt-get install -y pkg-config bison flex libdb-dev xtables-addons-source
	 % wget https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.7.0.tar.gz
	 % tar zxvf iproute2-3.7.0.tar.gz
	 % cd iproute2-3.7.0
	 % ./configure
	 % make
	 % make install
	 % /sbin/ip -V
	 ip utility, iproute2-ss121211

This ip command is installed to /sbin directory (original ip command is in 
/bin). This prefix is also used on cli extensions.


Install CLI Extension
---------------------

	 % sh install.sh 

install.sh installs vyatta cli extensions and some scripts.
The prefix of extension scripts is _xyatta_.


Configuratin example
---------------------

Content of VRF is linux network namespace. When new namespace is 
created, a quagga instance is executed on the namespace.

Configuration exapmle.

	 vyatta@vrf1# show vrf 
	  vrf hoge {
	      interfaces {
	          ethernet eth1 {
	              vif 10 {
	                  address 10.10.10.1/24
	                  address 2001:db8::1/64
	              }
	          }
	      }
	      protocols {
	          ospf {
	              area 0.0.0.0 {
	                  network 10.10.10.0/24
	              }
	          }
	          ospfv3 {
	              area 0.0.0.0 {
	                  interface eth1.10
	              }
	          }
	          static {
	              route 192.168.0.0/24 {
	                  next-hop 10.10.10.2 {
	                  }
	              }
	          }
	      }
	  }
	 [edit]
	 vyatta@vrf1# 
	 vyatta@vrf1# run show vrf hoge ip ospf neighbor 
	 
	     Neighbor ID Pri State           Dead Time Address         Interface            RXmtL RqstL DBsmL
	 10.10.10.2        1 Full/DR           38.094s 10.10.10.2      eth1.10:10.10.10.1       0     0     0
	 [edit]


And, veth type interface pairs between two VRFs (including default VRF) is supported. 
You can create veth pair under configure mode _interfaces veth-pair vethX_.
a veth interface can be attached under VRF. 

Configuration exapmle.

	 vyatta@vrf1# show 
	  interfaces {
	      veth-pair veth0 {
	          veth veth0a {
	              vrf hoge
	          }
	      }
	      vethernet veth0b {
	          address 172.16.0.1/24
	      }
	  }
	  protocols {
	      ospf {
	          area 0.0.0.0 {
	              network 172.16.0.0/24
	          }
	      }
	  }
	  vrf hoge {
	      interfaces {
	          vethernet veth0a {
	              address 172.16.0.2/24
	          }
	      }
	      protocols {
	          ospf {
	              area 0.0.0.0 {
	                  network 172.16.0.0/24
	              }
	          }
	      }
	  }
	 [edit]
	 upa@neito# run show ip ospf neighbor 
	 
	     Neighbor ID Pri State           Dead Time Address         Interface            RXmtL RqstL DBsmL
	 172.16.31.1       1 Full/DR           38.961s 172.16.0.2      veth0b:172.16.0.1        0     0     0
	 [edit]
	 upa@neito# run show vrf hoge ip ospf neighbor 
	 
	     Neighbor ID Pri State           Dead Time Address         Interface            RXmtL RqstL DBsmL
	 203.178.135.19    1 Full/Backup       30.933s 172.16.0.1      veth0a:172.16.0.2        0     0     0
	 [edit]

vethXa and vethXb are auto generated when _veth-pair vethX_ is defiend.



Todo
----
+ bgpd on VRF
+ some operational commands


Contact
-------
<upa@haeena.net>

if you found bugs, please let me know.

