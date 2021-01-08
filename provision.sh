echo "Updating system and installing curl"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt update
apt upgrade -y
apt dist-upgrade -y

apt install -y ntp
apt install -y curl
apt install -y wget
apt install -y rsync
apt install -y zip
apt install -y unzip
apt install -y build-essential
apt install -y software-properties-common

apt install -y libcurl4-gnutls-dev
apt install -y libxml2-dev

add-apt-repository -y ppa:deadsnakes/ppa
apt update
apt install -y python3.6
apt install -y virtualenv

su -m $USER <<'EOF'
  virtualenv -p python3.6 env
  . env/bin/activate
  pip install rambo-vagrant
  rm VBoxGuestAdditions*
EOF
