source $HOME/.env.fish
set proxy $_proxy_address

set -x http_proxy ''
set -x https_proxy ''
set -x ftp_proxy ''
set -x all_proxy ''
set -x no_proxy ''

function set_proxy
  set -x http_proxy "http://$proxy"
  set -x https_proxy "http://$proxy"
  set -x ftp_proxy "http://$proxy"
  set -x all_proxy "http://$proxy"
  set -x no_proxy '127.0.0.1,localhost'

  set -x HTTP_PROXY "http://$proxy"
  set -x HTTPS_PROXY "http://$proxy"
  set -x FTP_PROXY "http://$proxy"
  set -x ALL_PROXY "http://$proxy"
  set -x NO_PROXY '127.0.0.1,localhost'

  git config --global http.proxy "http://$proxy"
  git config --global https.proxy "https://$proxy"
  git config --global url."https://".insteadOf git://
end

function unset_proxy
  set -e http_proxy
  set -e https_proxy
  set -e ftp_proxy
  set -e all_proxy
  set -e no_proxy
  set -e HTTP_PROXY
  set -e HTTPS_PROXY
  set -e FTP_PROXY
  set -e ALL_PROXY
  set -e NO_PROXY

  git config --global --unset http.proxy
  git config --global --unset https.proxy
  git config --global --unset url."https://".insteadOf
end

if test -e /etc/resolv.conf
  grep $_dns /etc/resolv.conf | read _dns_state
end

if test -n "$_dns_state"
  # echo -e '\e[31mSet proxy settings\e[m' >&2
  set_proxy
else
  # echo -e '\e[36mUnset proxy settings\e[m' >&2
  unset_proxy
end
