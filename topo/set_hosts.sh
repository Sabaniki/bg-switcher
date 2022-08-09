#!/bin/zsh
docker exec $1 bash -c "
cat <<EOF > /etc/hosts
2001:db8:6500:100:ace::1 lo.Blue-A
2001:db8:6500:100:cafe::1 lo.Blue-B
2001:db8:6500:100:beef::1 lo.Blue-C

2001:db8:6500:200:ace::1 lo.Blue-A
2001:db8:6500:200:cafe::1 lo.Blue-B
2001:db8:6500:200:beef::1 lo.Blue-C

2001:db8:6500:6451::1 lo.EX-A
2001:db8:6500:6452::1 lo.EX-B
2001:db8:6500:6453::1 lo.EX-C

2001:db8:6500:6471::1 down.PE-A
2001:db8:6500:6472::1 down.PE-B
2001:db8:6500:6473::1 down.PE-C

2001:db8:6500:6471::2 up.CM-A
2001:db8:6500:6472::2 up.CM-B
2001:db8:6500:6473::2 up.CM-C

2001:db8:6510::1 lo.EA-A
2001:db8:6520::1 lo.EA-B
2001:db8:6530::1 lo.EA-B
EOF"