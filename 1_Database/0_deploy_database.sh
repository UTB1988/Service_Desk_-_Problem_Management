#!/bin/bash

# === === Check OS === ===

os_check=`uname -a | cut -d ' ' -f 1`

if [[ $os_check != 'Linux' ]]; then
	echo -e '\nПрости, я не знаю этой ОС, либо я на уровне пользователя.\n'
	exit
fi

# === === Check Linux Distro === ===

distro_check_1=`cat /etc/os-release | grep '^ID=' | cut -d '=' -f 2`
distro_check_2=`uname -a | cut -d ' ' -f 2`

if [[ $distro_check_1 != 'fedora' ]] || [[ $distro_check_2 != 'fedora' ]]; then
	echo -e '\nПрости, я не знаю этого дистрибутива.\n'
	exit
fi

# === === Check Distro Version === ===

distro_version_check=`cat /etc/os-release | grep 'VERSION_ID=' | cut -d '=' -f 2`

if [[ $distro_version_check -ne 38 ]]; then
	echo -e '\nПрости, я написал скрипт только для 38-ой версии Fedora.'
	echo -e 'Ты можешь посмотреть как устанавливать MySQL на твою версию Fedora тут:'
	echo -e 'https://computingforgeeks.com/how-to-install-mysql-8-on-fedora/\n'
	# xdg-open 'https://computingforgeeks.com/how-to-install-mysql-8-on-fedora/'
	exit
fi

# === === Check if MySQL installed === ===

mysql_installation_check=`mysql --version | cut -d ' ' -f 1`

if [[ $mysql_installation_check != 'mysql' ]]; then

	choice_1='Да, запусти установку MySQL'
	choice_2='Не, я сам установлю MySQL'
	choice_3='У меня, вообще-то, установлен MySQL'
	choice_4='Прервать развёртывание БД'

	choices=("$choice_1" "$choice_2" "$choice_3" "$choice_4")
	choices_count=${#choices[@]}

	IFS=$'\n'
	echo -e '\nЗапустить установку MySQL?'
	echo -e 'Нужно ввести цифру в диапазоне 1-'$choices_count'.'
	
	select choice in ${choices[@]}; do
		
		case $choice in
			$choice_1)
				sudo dnf -y install https://dev.mysql.com/get/mysql80-community-release-fc38-1.noarch.rpm;
				sudo dnf -y install mysql-community-server;
				sudo systemctl start mysqld.service;
				sudo systemctl enable mysqld.service;
				sudo grep 'A temporary password' /var/log/mysqld.log |tail -1;
				sudo mysql_secure_installation;
				break;;
			$choice_2) echo ''; exit;;
			$choice_3) break;;
			$choice_4) echo ''; exit;;
			*) echo 'Выбери один из пунктов.';;
		esac

	done
	unset IFS

fi

# === === Deploy Database === ===

# warning='\nВНИМАНИЕ!!!\nЯ сейчас попрошу тебя ввести имя пользователя и пароль учётной записи MySQL, имеющей необходимые привилегии для развёртывания БД.\nЯ запишу эти данные в переменные, чтобы не дёргать тебя при запуске каждого скрипта, а после развёртывания сброшу эти переменные.\n'
# hint_1='Введи имя пользователя MySQL, имеющего необходимые привилегии для развёртывания БД.'
# hint_2='Введи пароль пользователя MySQL, имеющего необходимые привилегии для развёртывания БД.'

# echo -e "$warning"

# read -p "$hint_1" mysql_user
# mysql_user='root'

# read -p "$hint_2" mysql_password
# mysql_password=''

# sudo mysql --user="$mysql_user" --password="$mysql_password" < ./1_create_database.sql

# unset mysql_user
# unset mysql_password

mysql_user='root'
sudo mysql --user="$mysql_user" --password < ./1_create_database.sql
sudo mysql --user="$mysql_user" --password < ./2_create_structure.sql
sudo mysql --user="$mysql_user" --password < ./3_fill_database_with_data.sql
