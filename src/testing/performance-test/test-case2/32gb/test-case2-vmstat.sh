##########physcal chemistry lab#########
vmstat 1 180 -n -w -S M >> vmstat-100-users-pc.txt

#########sleep 10sec########
sleep 10s

vmstat 1 180 -n -w -S M >> vmstat-200-users-pc.txt
#########sleep 10sec########
sleep 10s

vmstat 1 180 -n -w -S M >> vmstat-300-users-pc.txt
#########sleep 10sec########
sleep 10s

#############computer programming lab#######cp##
vmstat 1 180 -n -w -S M >> vmstat-100-users-cp.txt
#########sleep 10sec########
sleep 10s

vmstat 1 180 -n -w -S M >> vmstat-200-users-cp.txt
#########sleep 10sec########
sleep 10s

vmstat 1 180 -n -w -S M >> vmstat-300-users-cp.txt
#########sleep 10sec########
sleep 10s

#############vlsi lab#######cp##
vmstat 1 180 -n -w -S M >> vmstat-100-users-vlsi.txt
#########sleep 10sec########
sleep 10s

vmstat 1 180 -n -w -S M >> vmstat-200-users-vlsi.txt
#########sleep 10sec########
sleep 10s

vmstat 1 180 -n -w -S M >> vmstat-300-users-vlsi.txt

