read -s password

sudo ./install.sh
expect <<EOD
spawn ./after.sh
expect "password"
send "$password\n"
send "exit\n"
EOD
