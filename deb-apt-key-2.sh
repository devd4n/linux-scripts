#!/bin/bash
# download this script to the bin folder
# wget -qO /usr/bin/apt-add-repo https://raw.githubusercontent.com/devd4n/linux-scripts/main/deb-apt-key-2.sh
# Run as sudo
repo_name=$0
repo_uri=$1
key_uri=$2

wget -q -O key.gpg $key_uri
typecount=$(file key.gpg | grep -c "PGP public key block Public-Key")
if [ $typecount >= 0 ]
then
  gpg --no-default-keyring --keyring ./tmp.gpg --import key.gpg
  gpg --no-default-keyring --keyring ./tmp.gpg --export --output $repo_name.gpg
  rm tmp.gpg
  sudo mv $repo_name.gpg /etc/apt/keyrings/$repo_name.gpg
else
  sudo mv $key.gpg /etc/apt/keyrings/$repo_name.gpg
fi
rm $key.gpg

#  Write sources list file in DEB822 format
# 
echo "Types: deb" > /etc/apt/sources.list.d/$repo_name.sources
echo "URIs: $repo_uri" > /etc/apt/sources.list.d/$repo_name.sources
echo "Suites: stable" > /etc/apt/sources.list.d/$repo_name.sources
echo "Components: main" > /etc/apt/sources.list.d/$repo_name.sources
echo "Signed-By: /etc/apt/keyrings/$repo_name.gpg" > /etc/apt/sources.list.d/$repo_name.sources



