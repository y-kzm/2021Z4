## (1) FRR Setup
個人的に分からないことを調べた内容、およびコマンド実行結果を記述する  

### 用語
- FRR  
  - Free Range Routing  
  - ルーティングプロトコルスイート  
  - https://frrouting.org  
- vty   
  - virtual teletype  
  - ルータなどの通信機器にネットワークを通じて別のコンピュータから接続し、操作や管理を行うための仮想的な接続口(仮想ポート)  
  - sshやtelnetで接続  
  - vtysh: https://docs.frrouting.org/en/latest/vtysh.html 
  ~~~
  ubuntu@student04:~/seccamp-Z4/0x02/frr-setup$ docker exec -it R1 vtysh

  Hello, this is FRRouting (version 6.0).
  Copyright 1996-2005 Kunihiro Ishiguro, et al.
  
  R1#
  ~~~

### コマンドの種類
- 実行可能なコマンドを?コマンドで確かめる   
  
~~~
R1# 
 add Add registration
 clear Reset functions
 configure Configuration from vty interface
 copy Copy from one file to another
 debug Debugging functions
 disable Turn off privileged mode command
 enable Turn on privileged mode command
 end End current mode and change to enable mode
 exit Exit current mode and down to previous mode
 find Find CLI command containing text
 list Print command list
 mtrace Multicast trace route to multicast source
 no Negate a command or set its defaults
 output Direct vtysh output to file
 ping Send echo messages
 quit Exit current mode and down to previous mode
 show Show running system information
 terminal Set terminal line parameters
 traceroute Trace route to destination
 write Write running configuration to memory, network, or terminal
~~~

### コマンド実行結果  

~~~
R1# show interface
Interface lo is up, line protocol is up
 Link ups: 0 last: (never)
 Link downs: 0 last: (never)
 vrf: Default-IP-Routing-Table
 index 1 metric 0 mtu 65536 speed 0 
 flags: <UP,LOOPBACK,RUNNING>
 Type: Loopback
 Interface Type Other
Interface net0 is up, line protocol is up
 Link ups: 0 last: (never)
 Link downs: 0 last: (never)
 vrf: Default-IP-Routing-Table
 index 2 metric 0 mtu 1500 speed 10000 
 flags: <UP,BROADCAST,RUNNING,MULTICAST>
 Type: Ethernet
 HWaddr: 1a:3a:9d:fe:20:fb
 inet 10.255.1.1/24
 Interface Type Other
 Link ifindex 2(Unknown)
Interface net1 is up, line protocol is up
 Link ups: 0 last: (never)
 Link downs: 0 last: (never)
 vrf: Default-IP-Routing-Table
 index 3 metric 0 mtu 1500 speed 10000 
 flags: <UP,BROADCAST,RUNNING,MULTICAST>
 Type: Ethernet
 HWaddr: 46:7f:95:21:c0:7b
 inet 10.1.0.1/24
 Interface Type Other
 Link ifindex 2(net0)
Interface net2 is up, line protocol is up
 Link ups: 0 last: (never)
 Link downs: 0 last: (never)
 vrf: Default-IP-Routing-Table
 index 4 metric 0 mtu 1500 speed 10000 
 flags: <UP,BROADCAST,RUNNING,MULTICAST>
 Type: Ethernet
 HWaddr: aa:63:fc:25:39:33
 inet 10.2.0.1/24
 Interface Type Other
 Link ifindex 2(net0)

R1# show running-config 
Building configuration...

Current configuration:
!
frr version 6.0
frr defaults traditional
hostname R1
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
username cumulus nopassword
!
line vty
!
bfd
!
end
~~~

---
