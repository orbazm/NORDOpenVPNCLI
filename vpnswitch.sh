#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
VPNDIR='/usr/local/etc/openvpn'
CONFDIR='/usr/local/etc/openvpn/config'
VPNCONF='/usr/local/etc/openvpn/client.conf'

SERVERSTATS="$(curl https://api.nordvpn.com/server/stats)"
SERVERSTATS="$(echo \"$SERVERSTATS\" | tr -d '{}\"')"
IFS=', ' read -r -a files <<< $SERVERSTATS

echo -e "${GREEN}First letters of Server [ENTER]:${NC}"
read partial

IFS=$'\n'; files=($(printf '%s\n' "${files[@]}" |grep $partial))
IFS=$'\n' files=($(sort -r -k3 -t':' -n <<<"${files[*]}"))
unset IFS

echo "${array[0]}"

shopt -s extglob

string="@(${files[0]}"

for((i=1;i<${#files[@]};i++))
do
string+="|${files[$i]}"
done
string+=")"

select file in "${files[@]}" "quit"
do
case $file in

$string)
rm $VPNCONF

echo "$partial"

partial=${file%.nord*}
echo "$partial"

files=( $CONFDIR/$partial*.ovpn )
echo "${files[0]}"

file=${files[0]}
echo "$file"

sed 's/auth-user-pass/auth-user-pass \/usr\/local\/etc\/openvpn\/ovpnauth/g' $file >$VPNDIR/client.conf
osascript -e  "do shell script \"sudo launchctl stop homebrew.mxcl.openvpn >/dev/null;\" with administrator privileges"
break;
;;

"quit")
## Exit
exit;;
*)
file=""
echo -e "${GREEN}Please choose a number from 1 to $((${#files[@]}+1))${NC}";;
esac
done

