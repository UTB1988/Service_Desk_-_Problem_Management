#!/bin/bash

# === === Check if .my.cnf is exists === ===

my_cnf_file="/home/`whoami`/.my.cnf";
if [[ -e $my_cnf_file ]]; then
	rm $my_cnf_file;
fi

# === === Warning === ===

echo -e "";
echo -e "!!! ВНИМАНИЕ !!!";
echo -e "Я сейчас попрошу вас ввести логин и пароль учётной записи MySQL,";
echo -e "которая имеет необходимые привилегии для развёртывания БД.";
echo -e "Это нужно для того, чтобы вам не надо было каждый раз вводить логин и пароль.";
echo -e "";
echo -e "Я запишу эти данные в переменные, затем создам конфигурационный файл '.my.cnf',";
echo -e "который будет распологаться по пути: ($my_cnf_file),";
echo -e "в который я запишу логин и пароль, затем разверну БД,";
echo -e "а в конце сброшу переменные и удалю конфигурационный файл.";
echo -e "";

# === === Login & Password === ===

hint_1='Введи имя пользователя MySQL, имеющего необходимые привилегии для развёртывания БД.';
hint_2='Введи пароль пользователя MySQL, имеющего необходимые привилегии для развёртывания БД.';

# read -p "$hint_1" mysql_user;
mysql_user='root';

# read -p "$hint_2" mysql_password;
mysql_password='!Qwerty123456';

# === === .my.cnf === ===

touch $my_cnf_file;
echo -e "[mysql]\nuser=$mysql_user\npassword=$mysql_password" > $my_cnf_file;

chmod 0600 $my_cnf_file;

# === === Deploy database === ===

mysql < ./1_create_database.sql;
mysql < ./2_create_structure.sql;
mysql < ./3_fill_database_with_data.sql;

# === === Finish === ===

unset mysql_user;
unset mysql_password;

# rm $my_cnf_file;