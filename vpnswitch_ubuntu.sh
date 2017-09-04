GREEN='\033[0;32m'
NC='\033[0m'
VPNDIR='/etc/openvpn'
CONFDIR='/etc/openvpn/config'
VPNCONF='/etc/openvpn/client.conf'

SERVERSTATS="$(curl https://api.nordvpn.com/server/stats)"
SERVERSTATS="$(echo \"$SERVERSTATS\" | tr -d '{}\"')"
IFS=', ' read -r -a files <<< $SERVERSTATS

echo -e "${GREEN}First letters of Server [ENTER]:${NC}"
read partial

IFS=$'\n'; files=($(printf '%s\n' "${files[@]}" |grep $partial))
IFS=$'\n' files=($(sort -r -k3 -t':' -n <<<"${files[*]}"))
unset IFS

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
sudo rm $VPNCONF

partial=${file%.nord*}

files=( $CONFDIR/$partial*.ovpn )

file=${files[0]}
sed 's/auth-user-pass/auth-user-pass \/etc\/openvpn\/ovpnauth/g' $file >/tmp/vpn.tmp
sudo mv /tmp/vpn.tmp $VPNDIR/client.conf
sudo service openvpn restart
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
