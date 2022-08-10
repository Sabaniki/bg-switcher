docker run -td --net none --name Blue-A --rm --privileged --hostname Blue-A --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect Blue-A --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/Blue-A > /dev/null
docker run -td --net none --name Blue-B --rm --privileged --hostname Blue-B --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect Blue-B --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/Blue-B > /dev/null
docker run -td --net none --name Blue-C --rm --privileged --hostname Blue-C --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect Blue-C --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/Blue-C > /dev/null
docker run -td --net none --name Green-A --rm --privileged --hostname Green-A --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect Green-A --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/Green-A > /dev/null
docker run -td --net none --name Green-B --rm --privileged --hostname Green-B --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect Green-B --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/Green-B > /dev/null
docker run -td --net none --name Green-C --rm --privileged --hostname Green-C --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect Green-C --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/Green-C > /dev/null
docker run -td --net none --name EX-A --rm --privileged --hostname EX-A --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect EX-A --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/EX-A > /dev/null
docker run -td --net none --name EX-B --rm --privileged --hostname EX-B --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect EX-B --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/EX-B > /dev/null
docker run -td --net none --name EX-C --rm --privileged --hostname EX-C --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect EX-C --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/EX-C > /dev/null
docker run -td --net none --name PE-A --rm --privileged --hostname PE-A --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect PE-A --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/PE-A > /dev/null
docker run -td --net none --name PE-B --rm --privileged --hostname PE-B --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect PE-B --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/PE-B > /dev/null
docker run -td --net none --name PE-C --rm --privileged --hostname PE-C --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect PE-C --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/PE-C > /dev/null
docker run -td --net none --name CM-A --rm --privileged --hostname CM-A --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect CM-A --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/CM-A > /dev/null
docker run -td --net none --name CM-B --rm --privileged --hostname CM-B --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect CM-B --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/CM-B > /dev/null
docker run -td --net none --name CM-C --rm --privileged --hostname CM-C --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect CM-C --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/CM-C > /dev/null
docker run -td --net none --name EA-A --rm --privileged --hostname EA-A --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect EA-A --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/EA-A > /dev/null
docker run -td --net none --name EA-B --rm --privileged --hostname EA-B --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect EA-B --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/EA-B > /dev/null
docker run -td --net none --name EA-C --rm --privileged --hostname EA-C --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 -v /tmp/tinet:/tinet sabaniki/frr:latest > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect EA-C --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/EA-C > /dev/null
ip link add blue-b netns Blue-A type veth peer name blue-a netns Blue-B > /dev/null
ip netns exec Blue-A ip link set blue-b up > /dev/null
ip netns exec Blue-B ip link set blue-a up > /dev/null
ip link add blue-c netns Blue-A type veth peer name blue-a netns Blue-C > /dev/null
ip netns exec Blue-A ip link set blue-c up > /dev/null
ip netns exec Blue-C ip link set blue-a up > /dev/null
ip link add ex-a netns Blue-A type veth peer name blue-a netns EX-A > /dev/null
ip netns exec Blue-A ip link set ex-a up > /dev/null
ip netns exec EX-A ip link set blue-a up > /dev/null
ip link add pe-a netns Blue-A type veth peer name blue-a netns PE-A > /dev/null
ip netns exec Blue-A ip link set pe-a up > /dev/null
ip netns exec PE-A ip link set blue-a up > /dev/null
ip link add blue-c netns Blue-B type veth peer name blue-b netns Blue-C > /dev/null
ip netns exec Blue-B ip link set blue-c up > /dev/null
ip netns exec Blue-C ip link set blue-b up > /dev/null
ip link add ex-b netns Blue-B type veth peer name blue-b netns EX-B > /dev/null
ip netns exec Blue-B ip link set ex-b up > /dev/null
ip netns exec EX-B ip link set blue-b up > /dev/null
ip link add pe-b netns Blue-B type veth peer name blue-b netns PE-B > /dev/null
ip netns exec Blue-B ip link set pe-b up > /dev/null
ip netns exec PE-B ip link set blue-b up > /dev/null
ip link add ex-c netns Blue-C type veth peer name blue-c netns EX-C > /dev/null
ip netns exec Blue-C ip link set ex-c up > /dev/null
ip netns exec EX-C ip link set blue-c up > /dev/null
ip link add pe-c netns Blue-C type veth peer name blue-c netns PE-C > /dev/null
ip netns exec Blue-C ip link set pe-c up > /dev/null
ip netns exec PE-C ip link set blue-c up > /dev/null
ip link add green-b netns Green-A type veth peer name green-a netns Green-B > /dev/null
ip netns exec Green-A ip link set green-b up > /dev/null
ip netns exec Green-B ip link set green-a up > /dev/null
ip link add green-c netns Green-A type veth peer name green-a netns Green-C > /dev/null
ip netns exec Green-A ip link set green-c up > /dev/null
ip netns exec Green-C ip link set green-a up > /dev/null
ip link add ex-a netns Green-A type veth peer name green-a netns EX-A > /dev/null
ip netns exec Green-A ip link set ex-a up > /dev/null
ip netns exec EX-A ip link set green-a up > /dev/null
ip link add pe-a netns Green-A type veth peer name green-a netns PE-A > /dev/null
ip netns exec Green-A ip link set pe-a up > /dev/null
ip netns exec PE-A ip link set green-a up > /dev/null
ip link add green-c netns Green-B type veth peer name green-b netns Green-C > /dev/null
ip netns exec Green-B ip link set green-c up > /dev/null
ip netns exec Green-C ip link set green-b up > /dev/null
ip link add ex-b netns Green-B type veth peer name green-b netns EX-B > /dev/null
ip netns exec Green-B ip link set ex-b up > /dev/null
ip netns exec EX-B ip link set green-b up > /dev/null
ip link add pe-b netns Green-B type veth peer name green-b netns PE-B > /dev/null
ip netns exec Green-B ip link set pe-b up > /dev/null
ip netns exec PE-B ip link set green-b up > /dev/null
ip link add ex-c netns Green-C type veth peer name green-c netns EX-C > /dev/null
ip netns exec Green-C ip link set ex-c up > /dev/null
ip netns exec EX-C ip link set green-c up > /dev/null
ip link add pe-c netns Green-C type veth peer name green-c netns PE-C > /dev/null
ip netns exec Green-C ip link set pe-c up > /dev/null
ip netns exec PE-C ip link set green-c up > /dev/null
ip link add ea-a netns EX-A type veth peer name ex-a netns EA-A > /dev/null
ip netns exec EX-A ip link set ea-a up > /dev/null
ip netns exec EA-A ip link set ex-a up > /dev/null
ip link add ea-b netns EX-B type veth peer name ex-b netns EA-B > /dev/null
ip netns exec EX-B ip link set ea-b up > /dev/null
ip netns exec EA-B ip link set ex-b up > /dev/null
ip link add ea-c netns EX-C type veth peer name ex-c netns EA-C > /dev/null
ip netns exec EX-C ip link set ea-c up > /dev/null
ip netns exec EA-C ip link set ex-c up > /dev/null
ip link add cm-a netns PE-A type veth peer name pe-a netns CM-A > /dev/null
ip netns exec PE-A ip link set cm-a up > /dev/null
ip netns exec CM-A ip link set pe-a up > /dev/null
ip link add cm-b netns PE-B type veth peer name pe-b netns CM-B > /dev/null
ip netns exec PE-B ip link set cm-b up > /dev/null
ip netns exec CM-B ip link set pe-b up > /dev/null
ip link add cm-c netns PE-C type veth peer name pe-c netns CM-C > /dev/null
ip netns exec PE-C ip link set cm-c up > /dev/null
ip netns exec CM-C ip link set pe-c up > /dev/null
./set_hosts.sh Blue-A > /dev/null
./set_hosts.sh Blue-B > /dev/null
./set_hosts.sh Blue-C > /dev/null
./set_hosts.sh Green-A > /dev/null
./set_hosts.sh Green-B > /dev/null
./set_hosts.sh Green-C > /dev/null
./set_hosts.sh EX-A > /dev/null
./set_hosts.sh EX-B > /dev/null
./set_hosts.sh EX-C > /dev/null
./set_hosts.sh PE-A > /dev/null
./set_hosts.sh PE-B > /dev/null
./set_hosts.sh PE-C > /dev/null
./set_hosts.sh CM-A > /dev/null
./set_hosts.sh CM-B > /dev/null
./set_hosts.sh CM-C > /dev/null
./set_hosts.sh EA-A > /dev/null
./set_hosts.sh EA-B > /dev/null
./set_hosts.sh EA-C > /dev/null
ip netns del Blue-A > /dev/null
ip netns del Blue-B > /dev/null
ip netns del Blue-C > /dev/null
ip netns del Green-A > /dev/null
ip netns del Green-B > /dev/null
ip netns del Green-C > /dev/null
ip netns del EX-A > /dev/null
ip netns del EX-B > /dev/null
ip netns del EX-C > /dev/null
ip netns del PE-A > /dev/null
ip netns del PE-B > /dev/null
ip netns del PE-C > /dev/null
ip netns del CM-A > /dev/null
ip netns del CM-B > /dev/null
ip netns del CM-C > /dev/null
ip netns del EA-A > /dev/null
ip netns del EA-B > /dev/null
ip netns del EA-C > /dev/null
docker exec Blue-A vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:100:ace::1/128" > /dev/null
docker exec Blue-A vtysh -c "conf t" -c "router bgp 64600" -c " bgp router-id 10.64.60.1" -c " no bgp ebgp-requires-policy" -c " no bgp default ipv4-unicast" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64501 64502 64503 64601" -c " neighbor BB-BLUE peer-group" -c " neighbor BB-BLUE remote-as 64600" -c " neighbor EX-A peer-group" -c " neighbor EX-A remote-as 64501" -c " neighbor CONSUMERS peer-group" -c " neighbor blue-b interface peer-group BB-BLUE" -c " neighbor blue-c interface peer-group BB-BLUE" -c " neighbor ex-a interface peer-group EX-A" -c " neighbor pe-a interface peer-group CONSUMERS" -c " neighbor pe-a interface remote-as 64701" > /dev/null
docker exec Blue-A vtysh -c "conf t" -c "router bgp 64600" -c " address-family ipv6 unicast" -c "  network 2001:db8:6500::/48" -c "  network 2001:db8:6500:100:ace::1/128" -c "  neighbor BB-BLUE activate" -c "  neighbor BB-BLUE next-hop-self" -c "  neighbor BB-BLUE soft-reconfiguration inbound" -c "  neighbor EX-A activate" -c "  neighbor EX-A next-hop-self" -c "  neighbor EX-A soft-reconfiguration inbound" -c "  neighbor EX-A route-map WEIGHT_LEVEL out" -c "  neighbor CONSUMERS activate" -c "  neighbor CONSUMERS next-hop-self" -c "  neighbor CONSUMERS soft-reconfiguration inbound" -c "  neighbor CONSUMERS route-map WEIGHT_LEVEL out" > /dev/null
docker exec Blue-A vtysh -c "conf t" -c "route-map WEIGHT_LEVEL permit 5" -c " set extcommunity bandwidth 10" > /dev/null
docker exec Blue-B vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:100:cafe::1/128" > /dev/null
docker exec Blue-B vtysh -c "conf t" -c "router bgp 64600" -c " bgp router-id 10.64.60.2" -c " no bgp ebgp-requires-policy" -c " no bgp default ipv4-unicast" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64501 64502 64503 64601" -c " neighbor BB-BLUE peer-group" -c " neighbor BB-BLUE remote-as 64600" -c " neighbor EX-B peer-group" -c " neighbor EX-B remote-as 64502" -c " neighbor CONSUMERS peer-group" -c " neighbor blue-a interface peer-group BB-BLUE" -c " neighbor blue-c interface peer-group BB-BLUE" -c " neighbor ex-b interface peer-group EX-B" -c " neighbor pe-b interface peer-group CONSUMERS" -c " neighbor pe-b interface remote-as 64702" > /dev/null
docker exec Blue-B vtysh -c "conf t" -c "router bgp 64600" -c " address-family ipv6 unicast" -c "  network 2001:db8:6500::/48" -c "  network 2001:db8:6500:100:cafe::1/128" -c "  neighbor BB-BLUE activate" -c "  neighbor BB-BLUE next-hop-self" -c "  neighbor BB-BLUE soft-reconfiguration inbound" -c "  neighbor EX-B activate" -c "  neighbor EX-B next-hop-self" -c "  neighbor EX-B soft-reconfiguration inbound" -c "  neighbor EX-B route-map WEIGHT_LEVEL out" -c "  neighbor CONSUMERS activate" -c "  neighbor CONSUMERS next-hop-self" -c "  neighbor CONSUMERS soft-reconfiguration inbound" -c "  neighbor CONSUMERS route-map WEIGHT_LEVEL out" > /dev/null
docker exec Blue-B vtysh -c "conf t" -c "route-map WEIGHT_LEVEL permit 5" -c " set extcommunity bandwidth 10" > /dev/null
docker exec Blue-C vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:100:beef::1/128" > /dev/null
docker exec Blue-C vtysh -c "conf t" -c "router bgp 64600" -c " bgp router-id 10.64.60.3" -c " no bgp ebgp-requires-policy" -c " no bgp default ipv4-unicast" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64501 64502 64503 64601" -c " neighbor BB-BLUE peer-group" -c " neighbor BB-BLUE remote-as 64600" -c " neighbor EX-C peer-group" -c " neighbor EX-C remote-as 64503" -c " neighbor CONSUMERS peer-group" -c " neighbor blue-b interface peer-group BB-BLUE" -c " neighbor blue-a interface peer-group BB-BLUE" -c " neighbor ex-c interface peer-group EX-C" -c " neighbor pe-c interface peer-group CONSUMERS" -c " neighbor pe-c interface remote-as 64703" > /dev/null
docker exec Blue-C vtysh -c "conf t" -c "router bgp 64600" -c " address-family ipv6 unicast" -c "  network 2001:db8:6500::/48" -c "  network 2001:db8:6500:100:beef::1/128" -c "  neighbor BB-BLUE activate" -c "  neighbor BB-BLUE next-hop-self" -c "  neighbor BB-BLUE soft-reconfiguration inbound" -c "  neighbor EX-C activate" -c "  neighbor EX-C next-hop-self" -c "  neighbor EX-C soft-reconfiguration inbound" -c "  neighbor EX-C route-map WEIGHT_LEVEL out" -c "  neighbor CONSUMERS activate" -c "  neighbor CONSUMERS next-hop-self" -c "  neighbor CONSUMERS soft-reconfiguration inbound" -c "  neighbor CONSUMERS route-map WEIGHT_LEVEL out" > /dev/null
docker exec Blue-C vtysh -c "conf t" -c "route-map WEIGHT_LEVEL permit 5" -c " set extcommunity bandwidth 10" > /dev/null
docker exec Green-A vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:200:ace::1/128" > /dev/null
docker exec Green-A vtysh -c "conf t" -c "router bgp 64601" -c " bgp router-id 10.64.61.1" -c " no bgp ebgp-requires-policy" -c " no bgp default ipv4-unicast" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64501 64502 64503 64600" -c " neighbor BB-GREEN peer-group" -c " neighbor BB-GREEN remote-as 64601" -c " neighbor EX-A peer-group" -c " neighbor EX-A remote-as 64501" -c " neighbor CONSUMERS peer-group" -c " neighbor green-b interface peer-group BB-GREEN" -c " neighbor green-c interface peer-group BB-GREEN" -c " neighbor ex-a interface peer-group EX-A" -c " neighbor pe-a interface peer-group CONSUMERS" -c " neighbor pe-a interface remote-as 64701" > /dev/null
docker exec Green-A vtysh -c "conf t" -c "router bgp 64601" -c " address-family ipv6 unicast" -c "  network 2001:db8:6500::/48" -c "  network 2001:db8:6500:200:ace::1/128" -c "  neighbor BB-GREEN activate" -c "  neighbor BB-GREEN next-hop-self" -c "  neighbor BB-GREEN soft-reconfiguration inbound" -c "  neighbor EX-A activate" -c "  neighbor EX-A next-hop-self" -c "  neighbor EX-A soft-reconfiguration inbound" -c "  neighbor EX-A route-map WEIGHT_LEVEL out" -c "  neighbor CONSUMERS activate" -c "  neighbor CONSUMERS next-hop-self" -c "  neighbor CONSUMERS soft-reconfiguration inbound" -c "  neighbor CONSUMERS route-map WEIGHT_LEVEL out" > /dev/null
docker exec Green-A vtysh -c "conf t" -c "route-map WEIGHT_LEVEL permit 5" -c " set extcommunity bandwidth 90" > /dev/null
docker exec Green-B vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:200:cafe::1/128" > /dev/null
docker exec Green-B vtysh -c "conf t" -c "router bgp 64601" -c " bgp router-id 10.64.61.2" -c " no bgp ebgp-requires-policy" -c " no bgp default ipv4-unicast" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64501 64502 64503 64600" -c " neighbor BB-GREEN peer-group" -c " neighbor BB-GREEN remote-as 64601" -c " neighbor EX-B peer-group" -c " neighbor EX-B remote-as 64502" -c " neighbor CONSUMERS peer-group" -c " neighbor green-a interface peer-group BB-GREEN" -c " neighbor green-c interface peer-group BB-GREEN" -c " neighbor ex-b interface peer-group EX-B" -c " neighbor pe-b interface peer-group CONSUMERS" -c " neighbor pe-b interface remote-as 64702" > /dev/null
docker exec Green-B vtysh -c "conf t" -c "router bgp 64601" -c " address-family ipv6 unicast" -c "  network 2001:db8:6500::/48" -c "  network 2001:db8:6500:200:cafe::1/128" -c "  neighbor BB-GREEN activate" -c "  neighbor BB-GREEN next-hop-self" -c "  neighbor BB-GREEN soft-reconfiguration inbound" -c "  neighbor EX-B activate" -c "  neighbor EX-B next-hop-self" -c "  neighbor EX-B soft-reconfiguration inbound" -c "  neighbor EX-B route-map WEIGHT_LEVEL out" -c "  neighbor CONSUMERS activate" -c "  neighbor CONSUMERS next-hop-self" -c "  neighbor CONSUMERS soft-reconfiguration inbound" -c "  neighbor CONSUMERS route-map WEIGHT_LEVEL out" > /dev/null
docker exec Green-B vtysh -c "conf t" -c "route-map WEIGHT_LEVEL permit 5" -c " set extcommunity bandwidth 90" > /dev/null
docker exec Green-C vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:200:beef::1/128" > /dev/null
docker exec Green-C vtysh -c "conf t" -c "router bgp 64601" -c " bgp router-id 10.64.61.3" -c " no bgp ebgp-requires-policy" -c " no bgp default ipv4-unicast" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64501 64502 64503 64600" -c " neighbor BB-GREEN peer-group" -c " neighbor BB-GREEN remote-as 64601" -c " neighbor EX-C peer-group" -c " neighbor EX-C remote-as 64503" -c " neighbor CONSUMERS peer-group" -c " neighbor green-a interface peer-group BB-GREEN" -c " neighbor green-b interface peer-group BB-GREEN" -c " neighbor ex-c interface peer-group EX-C" -c " neighbor pe-c interface peer-group CONSUMERS" -c " neighbor pe-c interface remote-as 64703" > /dev/null
docker exec Green-C vtysh -c "conf t" -c "router bgp 64601" -c " address-family ipv6 unicast" -c "  network 2001:db8:6500::/48" -c "  network 2001:db8:6500:200:beef:1/128" -c "  neighbor BB-GREEN activate" -c "  neighbor BB-GREEN next-hop-self" -c "  neighbor BB-GREEN soft-reconfiguration inbound" -c "  neighbor EX-C activate" -c "  neighbor EX-C next-hop-self" -c "  neighbor EX-C soft-reconfiguration inbound" -c "  neighbor EX-C route-map WEIGHT_LEVEL out" -c "  neighbor CONSUMERS activate" -c "  neighbor CONSUMERS next-hop-self" -c "  neighbor CONSUMERS soft-reconfiguration inbound" -c "  neighbor CONSUMERS route-map WEIGHT_LEVEL out" > /dev/null
docker exec Green-C vtysh -c "conf t" -c "route-map WEIGHT_LEVEL permit 5" -c " set extcommunity bandwidth 90" > /dev/null
docker exec EX-A vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:6451::1/128" > /dev/null
docker exec EX-A vtysh -c "conf t" -c "router bgp 64501" -c " bgp router-id 10.64.50.1" -c " no bgp ebgp-requires-policy" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " no bgp default ipv4-unicast" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64502 64503 64600 64601" -c " neighbor BB-BLUE peer-group" -c " neighbor BB-BLUE remote-as 64600" -c " neighbor BB-GREEN peer-group" -c " neighbor BB-GREEN remote-as 64601" -c " neighbor EX-AS peer-group" -c " neighbor EX-AS remote-as 65100" -c " neighbor EX-AS local-as 65000 no-prepend" -c " neighbor blue-a interface peer-group BB-BLUE" -c " neighbor green-a interface peer-group BB-GREEN" -c " neighbor ea-a interface peer-group EX-AS" > /dev/null
docker exec EX-A vtysh -c "conf t" -c "router bgp 64501" -c " address-family ipv6 unicast" -c "  redistribute connected" -c "  aggregate-address 2001:db8:6500::/48 summary-only" -c "  neighbor BB-BLUE activate" -c "  neighbor BB-BLUE next-hop-self" -c "  neighbor BB-BLUE soft-reconfiguration inbound" -c "  neighbor BB-GREEN activate" -c "  neighbor BB-GREEN next-hop-self" -c "  neighbor BB-GREEN soft-reconfiguration inbound" -c "  neighbor EX-AS activate" -c "  neighbor EX-AS next-hop-self" -c "  neighbor EX-AS soft-reconfiguration inbound" > /dev/null
docker exec EX-B vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:6452::1/128" > /dev/null
docker exec EX-B vtysh -c "conf t" -c "router bgp 64502" -c " bgp router-id 10.64.50.2" -c " no bgp ebgp-requires-policy" -c " no bgp default ipv4-unicast" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64501 64503 64600 64601" -c " neighbor BB-BLUE peer-group" -c " neighbor BB-BLUE remote-as 64600" -c " neighbor BB-GREEN peer-group" -c " neighbor BB-GREEN remote-as 64601" -c " neighbor EX-AS peer-group" -c " neighbor EX-AS remote-as 65200" -c " neighbor EX-AS local-as 65000 no-prepend" -c " neighbor blue-b interface peer-group BB-BLUE" -c " neighbor green-b interface peer-group BB-GREEN" -c " neighbor ea-b interface peer-group EX-AS" > /dev/null
docker exec EX-B vtysh -c "conf t" -c "router bgp 64502" -c " address-family ipv6 unicast" -c "  redistribute connected" -c "  aggregate-address 2001:db8:6500::/48 summary-only" -c "  neighbor BB-BLUE activate" -c "  neighbor BB-BLUE next-hop-self" -c "  neighbor BB-BLUE soft-reconfiguration inbound" -c "  neighbor BB-GREEN activate" -c "  neighbor BB-GREEN next-hop-self" -c "  neighbor BB-GREEN soft-reconfiguration inbound" -c "  neighbor EX-AS activate" -c "  neighbor EX-AS next-hop-self" -c "  neighbor EX-AS soft-reconfiguration inbound" > /dev/null
docker exec EX-C vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6500:6453::1/128" > /dev/null
docker exec EX-C vtysh -c "conf t" -c "router bgp 64503" -c " bgp router-id 10.64.50.3" -c " no bgp ebgp-requires-policy" -c " no bgp default ipv4-unicast" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " bgp confederation identifier 65000" -c " bgp confederation peers 64501 64502 64600 64601" -c " neighbor BB-BLUE peer-group" -c " neighbor BB-BLUE remote-as 64600" -c " neighbor BB-GREEN peer-group" -c " neighbor BB-GREEN remote-as 64601" -c " neighbor EX-AS peer-group" -c " neighbor EX-AS remote-as 65300" -c " neighbor EX-AS local-as 65000 no-prepend" -c " neighbor blue-c interface peer-group BB-BLUE" -c " neighbor green-c interface peer-group BB-GREEN" -c " neighbor ea-c interface peer-group EX-AS" > /dev/null
docker exec EX-C vtysh -c "conf t" -c "router bgp 64503" -c " address-family ipv6 unicast" -c "  redistribute connected" -c "  aggregate-address 2001:db8:6500::/48 summary-only" -c "  neighbor BB-BLUE activate" -c "  neighbor BB-BLUE next-hop-self" -c "  neighbor BB-BLUE soft-reconfiguration inbound" -c "  neighbor BB-GREEN activate" -c "  neighbor BB-GREEN next-hop-self" -c "  neighbor BB-GREEN soft-reconfiguration inbound" -c "  neighbor EX-AS activate" -c "  neighbor EX-AS next-hop-self" -c "  neighbor EX-AS soft-reconfiguration inbound" > /dev/null
docker exec PE-A vtysh -c "conf t" -c "interface cm-a" -c " ipv6 address 2001:db8:6500:6471::1/64" > /dev/null
docker exec PE-A vtysh -c "conf t" -c "router bgp 64701" -c " bgp router-id 10.64.70.1" -c " no bgp ebgp-requires-policy" -c " no bgp ebgp-requires-policy" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " no bgp default ipv4-unicast" -c " neighbor BB peer-group" -c " neighbor BB remote-as 65000" -c " neighbor blue-a interface peer-group BB" -c " neighbor green-a interface peer-group BB" > /dev/null
docker exec PE-A vtysh -c "conf t" -c "router bgp 64701" -c " address-family ipv6 unicast" -c "  redistribute connected" -c "  neighbor BB activate" -c "  neighbor BB soft-reconfiguration inbound" > /dev/null
docker exec PE-B vtysh -c "conf t" -c "interface cm-b" -c " ipv6 address 2001:db8:6500:6472::1/64" > /dev/null
docker exec PE-B vtysh -c "conf t" -c "router bgp 64702" -c " bgp router-id 10.64.70.2" -c " no bgp ebgp-requires-policy" -c " no bgp ebgp-requires-policy" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " no bgp default ipv4-unicast" -c " neighbor BB peer-group" -c " neighbor BB remote-as 65000" -c " neighbor blue-b interface peer-group BB" -c " neighbor green-b interface peer-group BB" > /dev/null
docker exec PE-B vtysh -c "conf t" -c "router bgp 64702" -c " address-family ipv6 unicast" -c "  redistribute connected" -c "  neighbor BB activate" -c "  neighbor BB soft-reconfiguration inbound" > /dev/null
docker exec PE-C vtysh -c "conf t" -c "interface cm-c" -c " ipv6 address 2001:db8:6500:6473::1/64" > /dev/null
docker exec PE-C vtysh -c "conf t" -c "router bgp 64703" -c " bgp router-id 10.64.70.3" -c " no bgp ebgp-requires-policy" -c " no bgp ebgp-requires-policy" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " no bgp default ipv4-unicast" -c " neighbor BB peer-group" -c " neighbor BB remote-as 65000" -c " neighbor blue-c interface peer-group BB" -c " neighbor green-c interface peer-group BB" > /dev/null
docker exec PE-C vtysh -c "conf t" -c "router bgp 64703" -c " address-family ipv6 unicast" -c "  redistribute connected" -c "  neighbor BB activate" -c "  neighbor BB soft-reconfiguration inbound" > /dev/null
docker exec CM-A vtysh -c "conf t" -c "interface pe-a" -c " ipv6 address 2001:db8:6500:6471::2/64" > /dev/null
docker exec CM-A vtysh -c "conf t" -c "ip route ::/0 2001:db8:6500:6471::1" > /dev/null
docker exec CM-B vtysh -c "conf t" -c "interface pe-b" -c " ipv6 address 2001:db8:6500:6472::2/64" > /dev/null
docker exec CM-B vtysh -c "conf t" -c "ip route ::/0 2001:db8:6500:6472::1" > /dev/null
docker exec CM-C vtysh -c "conf t" -c "interface pe-c" -c " ipv6 address 2001:db8:6500:6473::2/64" > /dev/null
docker exec CM-C vtysh -c "conf t" -c "ip route ::/0 2001:db8:6500:6473::1" > /dev/null
docker exec EA-A vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6510::1/128" > /dev/null
docker exec EA-A vtysh -c "conf t" -c "router bgp 65100" -c " bgp router-id 10.65.10.0" -c " no bgp ebgp-requires-policy" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " no bgp default ipv4-unicast" -c " neighbor TESTBED peer-group" -c " neighbor TESTBED remote-as 65000" -c " neighbor ex-a interface peer-group TESTBED" > /dev/null
docker exec EA-A vtysh -c "conf t" -c "router bgp 65100" -c " address-family ipv6 unicast" -c "  network  2001:db8:6510::/48" -c "  neighbor TESTBED activate" -c "  neighbor TESTBED soft-reconfiguration inbound" > /dev/null
docker exec EA-B vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6520::1/128" > /dev/null
docker exec EA-B vtysh -c "conf t" -c "router bgp 65200" -c " bgp router-id 10.65.20.0" -c " no bgp ebgp-requires-policy" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " no bgp default ipv4-unicast" -c " neighbor TESTBED peer-group" -c " neighbor TESTBED remote-as 65000" -c " neighbor ex-b interface peer-group TESTBED" > /dev/null
docker exec EA-B vtysh -c "conf t" -c "router bgp 65200" -c " address-family ipv6 unicast" -c "  network 2001:db8:6520::/48" -c "  neighbor TESTBED activate" -c "  neighbor TESTBED soft-reconfiguration inbound" > /dev/null
docker exec EA-C vtysh -c "conf t" -c "interface lo" -c " ipv6 address 2001:db8:6530::1/128" > /dev/null
docker exec EA-C vtysh -c "conf t" -c "router bgp 65300" -c " bgp router-id 10.65.30.0" -c " no bgp ebgp-requires-policy" -c " no bgp suppress-duplicates" -c " no bgp network import-check" -c " no bgp default ipv4-unicast" -c " neighbor TESTBED peer-group" -c " neighbor TESTBED remote-as 65000" -c " neighbor ex-c interface peer-group TESTBED" > /dev/null
docker exec EA-C vtysh -c "conf t" -c "router bgp 65300" -c " address-family ipv6 unicast" -c "  network 2001:db8:6530::/48" -c "  neighbor TESTBED activate" -c "  neighbor TESTBED soft-reconfiguration inbound" > /dev/null
