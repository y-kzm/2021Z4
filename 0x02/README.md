# 事前学習 0x02
https://github.com/seccamp-z/2021Z4/tree/main/0x02

---
## (1) FRR Setup
- TiNETを用いてtopo2のR1、R2でFRRoutingを動かす
  - yamlファイルは上記repoのREADMEに記載のものを使用
  - FRRのvtyに入って何かしらのコマンドを実行する

### [用語]
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

### [コマンドの種類]
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

### [コマンド実行結果]  
- show interface  
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
  ~~~

- show running-config  (現在の設定を確認)
  ~~~
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
## (2) BGP Peer Setup
### [Peer 確立]
  ~~~
  ### R1 ###
  R1# conf t
  R1(config)# router bgp 1
  R1(config-router)# bgp router-id 10.255.1.1
  R1(config-router)# neighbor 10.255.1.2 remote-as 2
  ~~~

  ~~~
  ### R2 ###
  R2(config)# router bgp 2
  R2(config-router)# bgp router-id 10.255.1.2
  R2(config-router)# neighbor 10.255.1.1 remote-as 1
  ~~~

### [Peer 確認]
  ~~~
  ### R1 ###
  R1# show ip bgp summary       

  IPv4 Unicast Summary:
  BGP router identifier 10.255.1.1, local AS number 1 vrf-id 0
  BGP table version 0
  RIB entries 0, using 0 bytes of memory
  Peers 1, using 21 KiB of memory

  Neighbor        V         AS MsgRcvd MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd
  10.255.1.2      4          2      10      10        0    0    0 00:07:10            0

  Total number of neighbors 1
  ~~~

  ~~~
  ### R2 ###
  R2# show ip bgp summary 

  IPv4 Unicast Summary:
  BGP router identifier 10.255.1.2, local AS number 2 vrf-id 0
  BGP table version 0
  RIB entries 0, using 0 bytes of memory
  Peers 1, using 21 KiB of memory

  Neighbor        V         AS MsgRcvd MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd
  10.255.1.1      4          1      11      11        0    0    0 00:08:52            0

  Total number of neighbors 1
  ~~~

---
## (3) BGP Route Advertise
### [設定内容]
  ~~~
  ### R1 ###
  R1(config-router)# address-family ipv4 unicast 
  R1(config-router-af)# network 10.1.0.0/24
  R1(config-router-af)# exit-address-family 

  R1# show bgp ipv4 unicast 
  BGP table version is 2, local router ID is 10.255.1.1, vrf id 0
  Status codes: s suppressed, d damped, h history, * valid, > best, = multipath,
   i internal, r RIB-failure, S Stale, R Removed
  Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
  Origin codes: i - IGP, e - EGP, ? - incomplete

   Network Next Hop Metric LocPrf Weight Path
  *> 10.1.0.0/24 0.0.0.0 0 32768 i
  *> 10.3.0.0/24 10.255.1.2 0 0 2 i

  Displayed 2 routes and 2 total paths
  ~~~


  ~~~
  ### R2 ###
  R2(config)# route bgp 2
  R2(config-router)# address-family ipv4 unicast 
  R2(config-router-af)# network 10.3.0.0/24
  R2(config-router-af)# exit-address-family 

  R2# sh bgp ipv4 unicast 
  BGP table version is 2, local router ID is 10.255.1.2, vrf id 0
  Status codes: s suppressed, d damped, h history, * valid, > best, = multipath,
   i internal, r RIB-failure, S Stale, R Removed
  Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
  Origin codes: i - IGP, e - EGP, ? - incomplete

   Network Next Hop Metric LocPrf Weight Path
  *> 10.1.0.0/24 10.255.1.1 0 0 1 i
  *> 10.3.0.0/24 0.0.0.0 0 32768 i

  Displayed 2 routes and 2 total paths
  ~~~

### [ping 確認]
- C1 -> C3
  ~~~
  ubuntu@student04:~/seccamp-Z4/0x02$ docker exec -it C1 ping -c 3 10.3.0.2
  PING 10.3.0.2 (10.3.0.2) 56(84) bytes of data.
  64 bytes from 10.3.0.2: icmp_seq=1 ttl=62 time=0.081 ms
  64 bytes from 10.3.0.2: icmp_seq=2 ttl=62 time=0.059 ms
  64 bytes from 10.3.0.2: icmp_seq=3 ttl=62 time=0.059 ms

  --- 10.3.0.2 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 2030ms
  rtt min/avg/max/mdev = 0.059/0.066/0.081/0.012 ms
  ~~~

- C3 -> C1
  ~~~
  ubuntu@student04:~/seccamp-Z4/0x02$ docker exec -it C3 ping -c 3 10.1.0.2
  PING 10.1.0.2 (10.1.0.2) 56(84) bytes of data.
  64 bytes from 10.1.0.2: icmp_seq=1 ttl=62 time=0.045 ms
  64 bytes from 10.1.0.2: icmp_seq=2 ttl=62 time=0.054 ms
  64 bytes from 10.1.0.2: icmp_seq=3 ttl=62 time=0.056 ms

  --- 10.1.0.2 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 2031ms
  rtt min/avg/max/mdev = 0.045/0.051/0.056/0.009 ms
  ~~~

- C4 -> C1 や C2 -> C3 などはpingが届かない!
  ~~~
  ubuntu@student04:~/seccamp-Z4/0x02$ docker exec -it C4 ping -c 3 10.1.0.2
  PING 10.1.0.2 (10.1.0.2) 56(84) bytes of data.
  ^C
  --- 10.1.0.2 ping statistics ---
  3 packets transmitted, 0 received, 100% packet loss, time 2037ms

  ubuntu@student04:~/seccamp-Z4/0x02$ docker exec -it C2 ping -c 3 10.3.0.2
  PING 10.3.0.2 (10.3.0.2) 56(84) bytes of data.
  ^C
  --- 10.3.0.2 ping statistics ---
  3 packets transmitted, 0 received, 100% packet loss, time 2036ms
  ~~~

---
## (4) Capture BGP Packets
### [手順]
  1. R1でtcpdumpを実行
      ~~~
      docker exec -it R1 tcpdump -nni net0 -w /tmp/in.pcap  
      ~~~
  2. 別windowで各vtyに接続してbgpの設定を行う
      ~~~
      ### R1 ###
      R1# sh running-config 
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
      router bgp 1
       bgp router-id 10.255.1.1
       neighbor 10.255.1.2 remote-as 2
       !
       address-family ipv4 unicast
       network 10.1.0.0/24
       exit-address-family
      !
      line vty
      !
      bfd
      !
      end

      ### R2 ###
      R2# sh running-config 
      Building configuration...

      Current configuration:
      !
      frr version 6.0
      frr defaults traditional
      hostname R2
      log syslog informational
      no ipv6 forwarding
      service integrated-vtysh-config
      username cumulus nopassword
      !
      router bgp 2
       bgp router-id 10.255.1.2
       neighbor 10.255.1.1 remote-as 1
       !
       address-family ipv4 unicast
       network 10.3.0.0/24
       exit-address-family
      !
      line vty
      !
      bfd
      !
      end
      ~~~
  3. pingを行う(C1->C3, C3->C1)
  4. コンテナR1にあるpcapファイルをホストへ
      ~~~
      $ docker cp <コンテナid>:/tmp/in.pcap in.pcap
      ~~~

---
## (5)  Analyze BGP Packets

### [BGPメッセージヘッダ]
  - Marker
    - 16オクテット
    - BGPピア間の同期を取る
    - メッセージタイプがOPENで、ピア間で特別な認証を行っていない場合は全て「1」
  - Length
    - ヘッダを含むBGPメッセージの長さ(オクテット)
    - 19~4096
  - Type
    - OPEN: 1
    - UPDATE: 2
    - ...

### [OPENメッセージ] 
> R2(10.255.1.2) -> R1(10.255.1.1)
  - Version
  - My 



















