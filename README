vyatta-vrf
==========

This is a fork of https://github.com/upa/vrf-vyatta for use with EdgeOS.

This requires EdgeOS 1.4.0 or newer due to kernel and iproute2 package dependancies.

This also requires installation of a multi vtysh patched quagga.


Quagga setup
------------

sudo dpkg -i vyatta-quagga_0.99.20.1-ubnt7_mips-vtysh.deb


Configuration example
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


TODO
----

+ Add veth to Interface.pm
