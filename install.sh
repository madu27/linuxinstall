#!/bin/bash

#__________________________________________________Variables____________________________________________________


apt="sudo apt install -y"
snap="sudo snap install -y"
apt_get="sudo apt-get install -y"

#questions de choix
echo "pour les questions suivantes faites 1 pour oui et 0 pour non"
read -p "souhaitez vous installer discord" A_discord
read -p "souhaitez vous installer onlyoffice" A_office
read -p "souhaitez vous installer keepass ou bitwarden (0 pour aucun 1 pour keepass et 2 pour bitwarden)" A_password
read -p "souhaitez vous installer jetbrains ou visual studio code (0 pour aucun 1 pour keepass et 2 pour bitwarden)" A_code






#__________________________________________________FONCTIONS APPLICATIONS____________________________________________


function installation_office () {
	sudo apt-get install postgresql
	sudo -i -u postgres psql -c "CREATE DATABASE onlyoffice;"
	sudo -i -u postgres psql -c "CREATE USER onlyoffice WITH password 'onlyoffice';"
	sudo -i -u postgres psql -c "GRANT ALL privileges ON DATABASE onlyoffice TO onlyoffice;"
	$apt_get rabbitmq-server
	$apt_get nginx-extras
	mkdir -p ~/.gnupg
	chmod 700 ~/.gnupg
	gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
	chmod 644 /tmp/onlyoffice.gpg
	sudo chown root:root /tmp/onlyoffice.gpg
	sudo mv /tmp/onlyoffice.gpg /etc/apt/trusted.gpg.d/
	echo "deb https://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list
	$apt_get update
	$apt_get ttf-mscorefonts-installer
	$apt_get onlyoffice-documentserver
}

function installation_jetbrains () {
	wget -c https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.27.3.14493.tar.gz
	/opt/jetbrains-toolbox-1.27.3.14493/jetbrains-toolbox
	$apt_get libfuse2
}


#__________________________________________________FONCTIONS GENERALES_____________________________________________





function mise_a_jour() {
	echo "mise a jour du systeme"
	sudo apt update && sudo apt upgrade -y
	echo "mise a jour terminee"
}

function installation_indispensables(){
	echo "installation des outils indispensables"
	$apt snapd
	$apt neovim
	$apt git
	$apt gcc
	echo "installation indispensable terminee"
}

function installation_optionnelle(){
	if [$A_discord == "1"] ; then
		echo "installation de discord"
		$snap discord
		echo "installation de discord terminee"
	fi
	if [$A_office == "1"] ; then
		echo "installation de onlyoffice"
		installation_office
		echo "installation de onlyoffice terminee"
	fi
	if [$A_password == "1"] ; then
		echo "installation de keepass"
		$apt keepass2 mono-complete xdotool
		echo "installation de keepass terminee"
	fi
	if [$A_password == "2"] ; then
		echo "installation de bitwarden"
		$snap bitwarden
		echo "installation de bitwarden terminee"
	fi
	if [$A_code == "1"] ; then
		echo "installation de keepass"
		installation_jetbrains
		echo "installation de keepass terminee"
	fi
	if [$A_code == "2"] ; then
		echo "installation de visual studio code"
		$snap code --classic
		echo "installation de visual studio code terminee"
	fi

}




#____________________________________________MAIN____________________________________________________



mise_a_jour
installation_indispensables
#installation_optionnelle
exit
