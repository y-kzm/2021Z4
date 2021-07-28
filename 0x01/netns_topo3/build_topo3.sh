#!/bin/bash
echo ">> Build Playground 2. <<"

# netnsの生成
ip netns add C1 
ip netns add C2 
ip netns add C3 
ip netns add C4

ip netns add R1
ip netns add R2
ip netns add R3


# peerの生成
ip link add C1-net0 type veth peer name R1-net1
ip link set C1-net0 netns C1
ip link set R1-net1 netns R1

ip link add C2-net0 type veth peer name R1-net2
ip link set C2-net0 netns C2
ip link set R1-net2 netns R1
 
ip link add C3-net0 type veth peer name R2-net1
ip link set C3-net0 netns C3
ip link set R2-net1 netns R2

ip link add C4-net0 type veth peer name R2-net2
ip link set C4-net0 netns C4
ip link set R2-net2 netns R2

ip link add R1-net0 type veth peer name R2-net0
ip link set R1-net0 netns R1
ip link set R2-net0 netns R2

ip link add R1-net3 type veth peer name R3-net0
ip link set R1-net3 netns R1
ip link set R3-net0 netns R3

ip link add R2-net3 type veth peer name R3-net1
ip link set R2-net3 netns R2
ip link set R3-net1 netns R3


# アドレス付与
ip netns exec C1 ip address add 10.1.0.2/24 dev C1-net0
ip netns exec C2 ip address add 10.2.0.2/24 dev C2-net0
ip netns exec C3 ip address add 10.3.0.2/24 dev C3-net0
ip netns exec C4 ip address add 10.4.0.2/24 dev C4-net0

ip netns exec R1 ip address add 10.255.1.1/24 dev R1-net0
ip netns exec R1 ip address add 10.1.0.1/24 dev R1-net1
ip netns exec R1 ip address add 10.2.0.1/24 dev R1-net2
ip netns exec R1 ip address add 10.255.2.1/24 dev R1-net3

ip netns exec R2 ip address add 10.255.1.2/24 dev R2-net0
ip netns exec R2 ip address add 10.3.0.1/24 dev R2-net1
ip netns exec R2 ip address add 10.4.0.1/24 dev R2-net2
ip netns exec R2 ip address add 10.255.3.1/24 dev R2-net3

ip netns exec R3 ip address add 10.255.2.2/24 dev R3-net0
ip netns exec R3 ip address add 10.255.3.2/24 dev R3-net1


# インターフェース準備
ip netns exec C1 ip link set C1-net0 up
ip netns exec C2 ip link set C2-net0 up
ip netns exec C3 ip link set C3-net0 up
ip netns exec C4 ip link set C4-net0 up

ip netns exec R1 ip link set R1-net0 up
ip netns exec R1 ip link set R1-net1 up
ip netns exec R1 ip link set R1-net2 up
ip netns exec R1 ip link set R1-net3 up

ip netns exec R2 ip link set R2-net0 up
ip netns exec R2 ip link set R2-net1 up
ip netns exec R2 ip link set R2-net2 up
ip netns exec R2 ip link set R2-net3 up

ip netns exec R3 ip link set R3-net0 up
ip netns exec R3 ip link set R3-net1 up


# デフォルトルート
ip netns exec C1 ip route add default via 10.1.0.1
ip netns exec C2 ip route add default via 10.2.0.1
ip netns exec C3 ip route add default via 10.3.0.1
ip netns exec C4 ip route add default via 10.4.0.1


# ルータ機能の付与
ip netns exec R1 sysctl net.ipv4.ip_forward=1
ip netns exec R2 sysctl net.ipv4.ip_forward=1
ip netns exec R3 sysctl net.ipv4.ip_forward=1


# 経路情報の記述
ip netns exec R1 ip route add 10.3.0.0/24 via 10.255.1.2
ip netns exec R1 ip route add 10.4.0.0/24 via 10.255.1.2
ip netns exec R1 ip route add 10.255.3.0/24 via 10.255.2.1

ip netns exec R2 ip route add 10.1.0.0/24 via 10.255.1.1
ip netns exec R2 ip route add 10.2.0.0/24 via 10.255.1.1
ip netns exec R2 ip route add 10.255.2.0/24 via 10.255.3.1

ip netns exec R3 ip route add 10.1.0.0/24 via 10.255.2.1
ip netns exec R3 ip route add 10.2.0.0/24 via 10.255.2.1
ip netns exec R3 ip route add 10.3.0.0/24 via 10.255.3.1
ip netns exec R3 ip route add 10.4.0.0/24 via 10.255.3.1


echo ">> Finished. <<"
































