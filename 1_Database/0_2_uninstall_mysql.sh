#!/bin/bash

sudo systemctl disable mysqld.service;
sudo systemctl stop mysqld.service;

sudo dnf -y remove mysql-community-server;
sudo dnf -y remove mysql80-community-release.noarch;

sudo rm -vrf /etc/mysql;
sudo rm -vrf /var/lib/mysql;

sudo rm -vrf /var/log/mysqld.log;

sudo rm -vrf /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql*;
sudo rm -vrf /etc/yum.repos.d/mysql-community*;