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
				
				# === Check if MySQL repository is installed ===

				while true; do
					echo -e "\n=== Проверка установленности репозитория MySQL ===\n"

					repository_package=`dnf list --installed | grep mysql80-community-release | cut -d " " -f 1`;
					repository_file='/etc/yum.repos.d/mysql-community.repo';

					# if repository package is installed and repository file is exists then do...
					if [[ -n $repository_package && -e $repository_file ]]; then
						echo -e "=== MySQL репозиторий установлен ===\n";
						break;
					else
						echo -e "=== MySQL репозиторий не установлен ===";
						echo -e "=== Сейчас будет установлен MySQL репозиторий ===\n";
						sudo dnf -y install https://dev.mysql.com/get/mysql80-community-release-fc38-1.noarch.rpm;
						continue;
					fi
				done;
				
				# === Check if MySQL server is installed ===

				while true; do
					echo -e "\n=== Проверка установленности MySQL server ===\n"

					mysql_server_package=`dnf list --installed | grep mysql-community-server | cut -d " " -f 1`;

					# if server package is not then do...
					if [[ -z $mysql_server_package ]]; then
						echo -e "=== MySQL server не установлен ===";
						echo -e "=== Сейчас будет установлен MySQL server ===\n";
						sudo dnf -y install mysql-community-server;
						continue;
					else
						echo -e "=== MySQL server установлен ===\n";
						break;
					fi
				done;
				
				sudo systemctl start mysqld.service;
				sudo systemctl enable mysqld.service;
				
				temp_root_pass=`sudo grep 'A temporary password' /var/log/mysqld.log | tail -1 | cut -d " " -f 13`

				echo -e "";
				echo -e "+-------------------------------------------------+";
				echo -e "|      \033[1m\033[4m=== ИНСТРУКЦИЯ ПО НАСТРОЙКЕ MySQL ===\033[0m      |";
				echo -e "+-------------------------------------------------+";
				echo -e "| Введите временный пароль root пользователя,     |";
				echo -e "| когда появится сообщение ниже.                  |";
				echo -e "|                                                 |";
				echo -e "| Ваш временный пароль root пользователя такой:   |";
				echo -e "| \033[1m\033[4m$temp_root_pass\033[0m                                    |";
				echo -e "|                                                 |";
				echo -e "| \033[1mСообщение:\033[0m                                      |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "| | Securing the MySQL server deployment.       | |";
				echo -e "| |                                             | |";
				echo -e "| | Enter password for user root: \033[1m\033[3m$temp_root_pass\033[0m  | |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "|                                                 |";
				echo -e "+-------------------------------------------------+";
				echo -e "| Придумайте и введите два раза новый пароль      |";
				echo -e "| для root пользователя, когда появится сообщение |";
				echo -e "| ниже.                                           |";
				echo -e "|                                                 |";
				echo -e "| Пароль должен содержать:                        |";
				echo -e "| - Спецсимволы                                   |";
				echo -e "| - Цифры                                         |";
				echo -e "| - Большие и маленькие латинские буквы           |";
				echo -e "|                                                 |";
				echo -e "| Для подобных ситуаций я использую пароль:       |";
				echo -e "| \033[1m\033[4m!Qwerty123456\033[0m                                   |";
				echo -e "|                                                 |";
				echo -e "| \033[1mСообщение:\033[0m                                      |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "| | The existing password for the user account  | |";
				echo -e "| | root has expired. Please set a new password.| |";
				echo -e "| |                                             | |";
				echo -e "| | New password: \033[1m\033[3m!Qwerty123456\033[0m                 | |";
				echo -e "| | Re-enter new password: \033[1m\033[3m!Qwerty123456\033[0m        | |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "|                                                 |";
				echo -e "+-------------------------------------------------+";
				echo -e "| Введите '\033[1m\033[4mno\033[0m', чтобы окончательно утвердить новый|";
				echo -e "| пароль root пользователя и чтобы продолжить     |";
				echo -e "| настройку MySQL.                                |";
				echo -e "|                                                 |";
				echo -e "| \033[1mСообщение:\033[0m                                      |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "| | Estimated strength of the password: 100     | |";
				echo -e "| | Change the password for root?: \033[1m\033[3mno\033[0m           | |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "|                                                 |";
				echo -e "+-------------------------------------------------+";
				echo -e "| Удалите анонимных пользователей, введя '\033[1m\033[4myes\033[0m',   |";
				echo -e "| когда появится сообщение ниже.                  |";
				echo -e "|                                                 |";
				echo -e "| \033[1mСообщение:\033[0m                                      |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "| | Remove anonymous users?: \033[1m\033[3myes\033[0m                | |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "|                                                 |";
				echo -e "+-------------------------------------------------+";
				echo -e "| Запретите root пользователю подключаться к БД   |";
				echo -e "| удалённо, введя '\033[1m\033[4myes\033[0m', когда появится сообщение |";
				echo -e "| ниже.                                           |";
				echo -e "|                                                 |";
				echo -e "| \033[1mСообщение:\033[0m                                      |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "| | Disallow root login remotely?: \033[1m\033[3myes\033[0m          | |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "|                                                 |";
				echo -e "+-------------------------------------------------+";
				echo -e "| Удалите тестовую базу данных, введя '\033[1m\033[4myes\033[0m',      |";
				echo -e "| когда появится сообщение ниже.                  |";
				echo -e "|                                                 |";
				echo -e "| \033[1mСообщение:\033[0m                                      |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "| | Remove test database and access to it?: \033[1m\033[3myes\033[0m | |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "|                                                 |";
				echo -e "+-------------------------------------------------+";
				echo -e "| Перегрузите таблицу привилегий, введя '\033[1m\033[4myes\033[0m',    |";
				echo -e "| когда появится сообщение ниже.                  |";
				echo -e "|                                                 |";
				echo -e "| \033[1mСообщение:\033[0m                                      |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "| | Reload privilege tables now?: \033[1m\033[3myes\033[0m           | |";
				echo -e "| +---------------------------------------------+ |";
				echo -e "|                                                 |";
				echo -e "+-------------------------------------------------+";
				echo -e "";

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