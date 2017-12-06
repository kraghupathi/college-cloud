#############physical chemistry#############
siege -c 100 -r 1 -t 3M http://ccnsb06-iiith.vlabs.ac.in/exp6_10/IR_Powder_exp6.swf >> siege-100-users-pc.txt

#########sleep 10sec########
sleep 10s

siege -c 200 -r 1 -t 3M http://ccnsb06-iiith.vlabs.ac.in/exp6_10/IR_Powder_exp6.swf >> siege-200-users-pc.txt
#########sleep 10sec########
sleep 10s

siege -c 300 -r 1 -t 3M http://ccnsb06-iiith.vlabs.ac.in/exp6_10/IR_Powder_exp6.swf >> siege-300-users-pc.txt
#########sleep 10sec########
sleep 10s


###############computer programming ###########
siege -c 100 -r 1 -t 3M http://cse02-iiith.vlabs.ac.in/exp4/simulation.html >> siege-100-users-cp.txt
#########sleep 10sec########
sleep 10s

siege -c 200 -r 1 -t 3M http://cse02-iiith.vlabs.ac.in/exp4/simulation.html >> siege-200-users-cp.txt
#########sleep 10sec########
sleep 10s

siege -c 300 -r 1 -t 3M http://cse02-iiith.vlabs.ac.in/exp4/simulation.html >> siege-300-users-cp.txt
#########sleep 10sec########
sleep 10s

###############vlsi lab ####################
siege -c 100 -r 1 -t 3M http://cse14-iiith.vlabs.ac.in/final-build/EXP_1sep2010/exp1/exp1.html >> siege-100-users-vlsi.txt
#########sleep 10sec########
sleep 10s

siege -c 200 -r 1 -t 3M http://cse14-iiith.vlabs.ac.in/final-build/EXP_1sep2010/exp1/exp1.html >> siege-200-users-vlsi.txt
#########sleep 10sec########
sleep 10s

siege -c 300 -r 1 -t 3M http://cse14-iiith.vlabs.ac.in/final-build/EXP_1sep2010/exp1/exp1.html >> siege-300-users-vlsi.txt

