#!/usr/bin/env expect

spawn "bash"

#send "echo \$PATH\r"
send "export PATH=/tmp:\$PATH\r"
#send "echo \$PATH\r"

interact

#echo "Bye!!!"