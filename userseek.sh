#!/bin/bash
# Coded by: thelinuxchoice
# Github: https://github.com/thelinuxchoice/userseek
# Instagram: @thelinuxchoice

trap 'store;exit 1' 2

dependencies() {


command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Run ./install.sh. Aborting."; exit 1; }


}

menu() {

printf "\e[1;77m[\e[0m\e[1;92m01\e[0m\e[1;77m] Instagram\e[0m\n"
printf "\e[1;77m[\e[0m\e[1;92m02\e[0m\e[1;77m] Twitter\e[0m\n"
printf "\e[1;77m[\e[0m\e[1;92m03\e[0m\e[1;77m] Facebook\e[0m\n"
#printf "\e[1;77m[\e[0m\e[1;92m01\e[0m\e[1;77m] Github\e[0m\n"
#printf "\e[1;77m[\e[0m\e[1;92m01\e[0m\e[1;77m] Youtube\e[0m\n"
printf "\n"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Seek available users on: \e[0m' choice

if [[ $choice -eq 1 ]]; then
media="instagram"
start
instagram

elif [[ $choice -eq 2 ]]; then
media="twitter"
start
twitter

elif [[ $choice -eq 3 ]]; then
media="facebook"
start
facebook

else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
menu
fi

}

banner() {


printf "\n"
printf "\e[1;77m888     888                           .d8888b.                    888       \n"
printf "888     888                          d88P  Y88b                   888       \n"
printf "888     888                          Y88b.                        888       \n"
printf "888     888 .d8888b   .d88b.  888d888 \"Y888b.    .d88b.   .d88b.  888  888  \n"
printf "888     888 88K      d8P  Y8b 888P\"      \"Y88b. d8P  Y8b d8P  Y8b 888 .88P  \n"
printf "888     888 \"Y8888b. 88888888 888          \"888 88888888 88888888 888888K   \n"
printf "Y88b. .d88P      X88 Y8b.     888    Y88b  d88P Y8b.     Y8b.     888 \"88b  \n"
printf " \"Y88888P\"   88888P'  \"Y8888  888     \"Y8888P\"   \"Y8888   \"Y8888  888  888  \e[0m\n"
printf "\n"
printf "\e[1;77m v1.0\e[0m\e[1;92m Author: @thelinuxchoice\e[0m\n"
printf "\n"
}

function start() {
if [[ -e available.txt ]]; then
rm -rf available.txt
fi
default_wl_user="users.txt"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Username List: \e[0m' wl_user
wl_user="${wl_user:-${default_wl_user}}"
default_threads="10"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Threads (Default 10): \e[0m' threads
threads="${threads:-${default_threads}}"
#fi
}

checktor() {

check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org > /dev/null; echo $?)

if [[ "$check" -gt 0 ]]; then
printf "\e[1;91mPlease, check your TOR Connection! Just type tor or service tor start\n\e[0m"
exit 1
fi

}

function store() {

if [[ -n "$threads" ]]; then
printf "\e[1;91m [*] Waiting threads shutting down...\n\e[0m"
if [[ "$threads" -gt 10 ]]; then
sleep 6
else
sleep 3
fi

if [[ -e available.txt ]]; then
result=$(wc -l available.txt | cut -d " " -f1 )
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] available: %s\n" $result
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Saved: available.txt\n"
fi

default_session="Y"
printf "\n\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Save session for media\e[0m\e[1;92m %s \e[0m" $media
read -p $'?\e[1;92m [Y/n]: \e[0m' session
session="${session:-${default_session}}"
if [[ "$session" == "Y" || "$session" == "y" || "$session" == "yes" || "$session" == "Yes" ]]; then
if [[ ! -d sessions ]]; then
mkdir sessions
fi
IFS=$'\n'
countuser=$(grep -n -x "$user" "$wl_user" | cut -d ":" -f1)
printf "user=\"%s\"\nwl_user=\"%s\"\ntoken=\"%s\"\nmedia=\"%s\"\n" $user $wl_user $countuser $media > sessions/store.session.$media.$(date +"%FT%H%M")
printf "\e[1;77mSession saved.\e[0m\n"
printf "\e[1;92mUse ./userseek --resume\n"
else
exit 1
fi
else
exit 1
fi
}


function changeip() {

killall -HUP tor


}

function instagram() {


count_user=$(wc -l $wl_user | cut -d " " -f1)
printf "\e[1;92mWordlist:\e[0m\e[1;77m %s (%s)\e[0m\n" $wl_user $count_user
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"
token=0
startline=1
endline="$threads"
while [ $token -lt $count_user ]; do
IFS=$'\n'
for user in $(sed -n ''$startline','$endline'p' $wl_user); do

IFS=$'\n'
countuser=$(grep -n -x "$user" "$wl_user" | cut -d ":" -f1)
let token++
printf "\e[1;77mChecking user (%s/%s):\e[0m\e[1;92m %s\e[0m\n" $countuser $count_user $user  
{(trap '' SIGINT && var=$(curl -L -s https://www.instagram.com/$user/ | grep -c "the page may have been removed"); if [[ $var == "1" ]]; then printf "%s\n" $user >> available.txt ; fi ;) } & done; wait $!;
let startline+=$threads
let endline+=$threads

done
if [[ -e available.txt ]]; then
result=$(wc -l available.txt | cut -d " " -f1 )
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] available: %s\n" $result
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Saved: available.txt\n"
fi
exit 1
}

function twitter() {


count_user=$(wc -l $wl_user | cut -d " " -f1)
printf "\e[1;92mWordlist:\e[0m\e[1;77m %s (%s)\e[0m\n" $wl_user $count_user
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"
token=0
startline=1
endline="$threads"
while [ $token -lt $count_user ]; do
IFS=$'\n'
for user in $(sed -n ''$startline','$endline'p' $wl_user); do

IFS=$'\n'
countuser=$(grep -n -x "$user" "$wl_user" | cut -d ":" -f1)
let token++
printf "\e[1;77mChecking user (%s/%s):\e[0m\e[1;92m %s\e[0m\n" $countuser $count_user $user  
{(trap '' SIGINT && var=$(curl -s "https://www.twitter.com/$user" -L -H "Accept-Language: en" | grep -c 'page doesn’t exist';); if [[ $var == "1" ]]; then printf "%s\n" $user >> available.txt ; fi ;) } & done; wait $!;
let startline+=$threads
let endline+=$threads

done
if [[ -e available.txt ]]; then
result=$(wc -l available.txt | cut -d " " -f1 )
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] available: %s\n" $result
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Saved: available.txt\n"
fi
exit 1
}

function facebook() {


count_user=$(wc -l $wl_user | cut -d " " -f1)
printf "\e[1;92mWordlist:\e[0m\e[1;77m %s (%s)\e[0m\n" $wl_user $count_user
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"
token=0
startline=1
endline="$threads"
while [ $token -lt $count_user ]; do
IFS=$'\n'
for user in $(sed -n ''$startline','$endline'p' $wl_user); do

IFS=$'\n'
countuser=$(grep -n -x "$user" "$wl_user" | cut -d ":" -f1)
let token++
printf "\e[1;77mChecking user (%s/%s):\e[0m\e[1;92m %s\e[0m\n" $countuser $count_user $user  
{(trap '' SIGINT && var=$(curl -s "https://www.facebook.com/$username" -L -H "Accept-Language: en" | grep -c 'not found'); if [[ $var == "1" ]]; then printf "%s\n" $user >> available.txt ; fi ;) } & done; wait $!;
let startline+=$threads
let endline+=$threads

done
if [[ -e available.txt ]]; then
result=$(wc -l available.txt | cut -d " " -f1 )
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] available: %s\n" $result
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Saved: available.txt\n"
fi
exit 1
}

resume_insta() {

count_user=$(wc -l $wl_user | cut -d " " -f1)

while [ $token -lt $count_user ]; do


for user in $(sed -n ''$token','$(($token+threads))'p' $wl_user); do

countuser=$(grep -n -x "$user" "$wl_user" | cut -d ":" -f1)

printf "\e[1;77mChecking user (%s/%s):\e[0m\e[1;92m %s\e[0m\n" $countuser $count_user $user  
let token++
{(trap '' SIGINT && var=$(curl -L -s https://www.instagram.com/$user/ | grep -c "the page may have been removed"); if [[ $var == "1" ]]; then printf "%s\n" $user >> available.txt ; fi ;) } & done; wait $!;
let token--
done
if [[ -e available.txt ]]; then
result=$(wc -l available.txt | cut -d " " -f1 )
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] available: %s\n" $result
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Saved: available.txt\n"
fi
exit 1

}

resume_face() {

count_user=$(wc -l $wl_user | cut -d " " -f1)

while [ $token -lt $count_user ]; do


for user in $(sed -n ''$token','$(($token+threads))'p' $wl_user); do

countuser=$(grep -n -x "$user" "$wl_user" | cut -d ":" -f1)

printf "\e[1;77mChecking user (%s/%s):\e[0m\e[1;92m %s\e[0m\n" $countuser $count_user $user  
let token++
{(trap '' SIGINT && var=$(curl -s "https://www.facebook.com/$username" -L -H "Accept-Language: en" | grep -c 'not found'); if [[ $var == "1" ]]; then printf "%s\n" $user >> available.txt ; fi ;) } & done; wait $!;
let token--
done
if [[ -e available.txt ]]; then
result=$(wc -l available.txt | cut -d " " -f1 )
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] available: %s\n" $result
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Saved: available.txt\n"
fi
exit 1

}
resume_twitter() {

count_user=$(wc -l $wl_user | cut -d " " -f1)

while [ $token -lt $count_user ]; do


for user in $(sed -n ''$token','$(($token+threads))'p' $wl_user); do

countuser=$(grep -n -x "$user" "$wl_user" | cut -d ":" -f1)

printf "\e[1;77mChecking user (%s/%s):\e[0m\e[1;92m %s\e[0m\n" $countuser $count_user $user  
let token++
{(trap '' SIGINT && var=$(curl -s "https://www.twitter.com/$user" -L -H "Accept-Language: en" | grep -c 'page doesn’t exist';); if [[ $var == "1" ]]; then printf "%s\n" $user >> available.txt ; fi ;) } & done; wait $!;
let token--
done
if [[ -e available.txt ]]; then
result=$(wc -l available.txt | cut -d " " -f1 )
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] available: %s\n" $result
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Saved: available.txt\n"
fi
exit 1

}

function resume() {


counter=1
if [[ ! -d sessions ]]; then
printf "\e[1;91m[*] No sessions\n\e[0m"
exit 1
fi
printf "\e[1;92mFiles sessions:\n\e[0m"
for list in $(ls sessions/store.session*); do
IFS=$'\n'
source $list
printf "\e[1;92m%s \e[0m\e[1;77m: %s (\e[0m\e[1;92mwl:\e[0m\e[1;77m %s\e[0m\e[1;92m,\e[0m\e[1;92m last: \e[0m\e[1;77m %s, \e[1;92m media:\e[0m\e[1;77m %s )\n\e[0m" "$counter" "$list" "$wl_user" "$token" "$media"
let counter++
done
read -p $'\e[1;92mChoose a session number: \e[0m' fileresume
source $(ls sessions/store.session* | sed ''$fileresume'q;d')
default_threads=10
read -p $'\e[1;92mThreads (Default 10): \e[0m' threads
threads="${threads:-${default_threads}}"

printf "\e[1;92m[*] Resuming session for user:\e[0m \e[1;77m%s\e[0m\n" $user
printf "\e[1;92m[*] Wordlist: \e[0m \e[1;77m%s\e[0m\n" $wl_user
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"

if [[ $media == "instagram" ]]; then
resume_insta
elif [[ $media == "facebook" ]]; then
resume_face
elif [[ $media == "twitter" ]]; then
resume_twitter
fi
}

case "$1" in --resume) resume ;; *)
banner
menu
esac

