#!/bin/bash
clear
figlet "ehre-ja" | lolcat --force
echo -e "🧠 User:      $(whoami)" | lolcat --force
echo -e "💻 Host:      $(hostname)" | lolcat --force
echo -e "🐧 OS:        $(uname -o) $(lsb_release -ds 2>/dev/null || echo $(uname -s))" | lolcat --force
echo -e "🖥  Terminal:  $TERM" | lolcat --force
echo -e "🌐 Local IP:  $(hostname -I | awk '{print $1}')" | lolcat --force
echo -e "🌍 Public IP: $(curl -s ifconfig.me)" | lolcat --force
echo ""
fortune riddles | lolcat --force
