# NORDOpenVPNCLI
Cli selection menu for NORDVPN using openvpn

Quick and dirty bash script to swap openvpn configs with nord config files.

Script does the following actions:
  -Pull server stats from NORD API
  -Ask user for country code (i.e "UK")
  -Filter server list on country and sort by server load
  -Matches server selection to openvpn config file
  -deletes current config
  -changes out auth method to file read (must read credential from file in daemon mode) and write to new config
  -restarts openvpn (launchctl)

Works on osx 10.12.6 w/ openvpn 2.4.3
  
  
