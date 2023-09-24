#!/bin/bash
# download this script to the bin folder
# sudo wget -qO /usr/bin/apt-add-repo https://raw.githubusercontent.com/devd4n/linux-scripts/main/deb-apt-key-2.sh
# make it executable
# sudo chmod +x /usr/bin/apt-add-repo
# Run as sudo
paramsarray=${@}
repo_name=$1
key_uri=$2
repo_uri=$3
suite=$4
unset paramsarray[1]
unset paramsarray[2]
unset paramsarray[3]
unset paramsarray[4]
components=$paramsarray

wget -q -O key.gpg $key_uri
typecount=$(file key.gpg | grep -c "PGP public key block Public-Key")
if [[ $typecount > 0 ]]
then
  gpg --no-default-keyring --keyring ./tmp.gpg --import key.gpg
  gpg --no-default-keyring --keyring ./tmp.gpg --export --output $repo_name.gpg
  rm tmp.gpg
  sudo mv $repo_name.gpg /etc/apt/keyrings/$repo_name.gpg
else
  sudo mv key.gpg /etc/apt/keyrings/$repo_name.gpg
fi
rm key.gpg

#  Write sources list file in DEB822 format
# 
echo "Types: deb deb-src" | sudo tee /etc/apt/sources.list.d/$repo_name.sources
echo "URIs: $repo_uri" | sudo tee -a /etc/apt/sources.list.d/$repo_name.sources
echo "Suites: $suite" | sudo tee -a /etc/apt/sources.list.d/$repo_name.sources
echo "Components: $components" | sudo tee -a /etc/apt/sources.list.d/$repo_name.sources
echo "Signed-By: /etc/apt/keyrings/$repo_name.gpg" | sudo tee -a /etc/apt/sources.list.d/$repo_name.sources
sudo apt update


