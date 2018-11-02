source $HOME/.env.fish
set proxy $proxy_address

set -x http_proxy ''
set -x https_proxy ''
set -x ftp_proxy ''
set -x all_proxy ''

function set_proxy
  set -x http_proxy "http://$proxy"
  set -x https_proxy "http://$proxy"
  set -x ftp_proxy "http://$proxy"
  set -x all_proxy $proxy

  git config --global http.proxy "http://$proxy"
  git config --global https.proxy "https://$proxy"
  git config --global url."https://".insteadOf git://
end

function unset_proxy
  set -e http_proxy
  set -e https_proxy
  set -e ftp_proxy
  set -e all_proxy

  git config --global --unset http.proxy
  git config --global --unset https.proxy
  git config --global --unset url."https://".insteadOf
end

networksetup -getairportnetwork en0 | awk '{print $4}' | read ssid
for switch_trigger in $ssid_list
  if [ $ssid = $switch_trigger ]
    echo -e '\e[31mSwitch to proxy for school network\e[m' 1>&2
    set_proxy
    exit
  end
end

echo -e '\e[36mUnset proxy settings\e[m' 1>&2
unset_proxy
