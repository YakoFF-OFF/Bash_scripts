#!/bin/bash

# Проверка запуска скрипта от root
if [ "$(id -u)" != "0" ]; then
   echo
   echo -e ${RED} " Запустите скрипт с правами пользователя root." ${NC}
   echo
   exit 1
fi

RED='\033[1;31m'
YEL='\033[1;33m'
BLU='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


# Функция проверки имени и пароля админа

ch_idpas() {

c_id=$(adcli show-computer -U $first --domain=ZARGAZ.RU SPB1-241G --stdin-password <<< $second &> /tmp/comp_check.txt)
v_id=$(cat /tmp/comp_check.txt)

if grep -Pq "Couldn't authenticate" <<< "$v_id";
        then
               return 1;

        else
               return 2;

fi
}


# Функция проверки имени и пароля админа

ch_idpas() {

c_id=$(adcli show-computer -U $first --domain=ZARGAZ.RU SPB1-241G --stdin-password <<< $second &> /tmp/comp_check.txt)
v_id=$(cat /tmp/comp_check.txt)

if grep -Pq "Couldn't authenticate" <<< "$v_id";
        then
               return 1;

        else
               return 2;

fi
}


# Функция установки пакета
# 1$ - имя пакета 2$ параметры установки

dp_inst() {
local pkgname="$1"
echo $pkgname
rpm -ivh $pkgname
}	

# Функция проверки присутсвия пакета

ch_package() {
local pkgname="$1"
rpm --quiet -q "$pkgname"

}

# Функция вопроса о продолжении поиска компьютера

ch_ask() {

	local pkgname="$1"
		while true;
                       do
       read -r -p "Пакет $pkgname уже установлен. Переустановить (y/n)? или только удалить (d) " yn
                           case $yn in
                               [Yy]* ) echo -e ${RED}  "Переустановка" ${NC} ; return 4;break;;
                               [Nn]* ) return 3; break;;
			       [Dd]* ) return 5; break;;
			       * ) echo -e ${RED} "Ответьте yes или no или Dd" ${NC};;
                           esac
                       done
}

# Функция проверки сществования службы
service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}


# Функция удаления пакета если он уже есть
dl_package() {
local delpack="$1"
service_exists $delpack
if [ $? = 0  ]; then         
echo "Служба: $delpack найдена и прибита"
	systemctl stop "$delpack"
        rpm -e "$delpack"
else 

echo "Эта днина: $delpack даже службы не имеет"

	rpm -e "$delpack"
fi
	
	
}



# Функция установки KES Agent
# 1$ - имя пакета

dp_kagent() {
local delpack="$1"

export KLAUTOANSWERS=/mnt/distemp/Configs_and_description/Ksl_agent.txt
if ch_package $delpack ; then

       	ch_ask "$delpack"

local ans="$?"

        if [ $ans -eq "4" ]
                        then 
		  		dl_package $delpack

	elif [ $ans -eq "5" ] 
			then 
				dl_package $delpack
		echo -e ${RED} "Пакет  $delpack удален навсегда да и насрать, давай досвидания" ${NC}
		exit
	       	
        else
echo "Ну нет так нет, давай досвидания"
exit
	fi
	fi

dp_inst "/mnt/distemp/rpm/klnagent64-14.2.0-23324.x86_64.rpm"
/opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl
systemctl restart klnagent64

echo -e ${BLU} " Пакет $delpack установлен глаза б мои его не видели" ${NC}



}

# Функция установки 1с 
# 1$ - имя пакета

dp_1csed() {
local delpack="$1"

if ch_package $delpack ; then

       	ch_ask "$delpack"

local ans="$?"

        if [ $ans -eq "4" ]
                        then 
		  		dl_package $delpack

	elif [ $ans -eq "5" ] 
			then 
				dl_package $delpack
		echo -e ${RED}  "Пакет  $delpack удален навсегда да и насрать, давай досвидания" ${NC}
		exit
	       	
        else
echo "Ну нет так нет, давай досвидания"
exit
	fi
	fi

dp_inst "/mnt/distemp/rpm/1c-enterprise-8.rpm"

echo -e ${YEL} " Пакет $delpack установлен глаза б мои его не видели" ${NC}


}






first='i.kostin'
second='M@][@5n'
<< 'MULTILINE-COMMENT'
for ((p=1;p<5;p++))
do
read -r -p "Имя пользователя домена: " first
echo ""

#echo $'\n'
read -r -s -p "Пароль пользователя домена: " second
#echo $'\n'
echo ""


ch_idpas

if  [ "$?" -eq "2" ]
then echo -e ${GREEN} "ИД и Пароль верный" ${NC};  break;
else echo -e ${RED} "ИД или Пароль неверный" ${NC}
fi

done
MULTILINE-COMMENT

# Монтирование директории с дистрибами rpm файлами для установки
# Создание директории для мониторвания
mkdir -m 777 /mnt/distemp

dir /mnt/

mount -t cifs -o user=$first,domain=zargaz,password="$second" //spb1-svm01/distrib$/Software/RedOs /mnt/distemp


# Выбор варианта установки

while true;
do
   read -r -p $'\033[0;32m
 \nВыбери вариант установки 
    \n1 -Kaspersky NetAgent 
    \n2 - 1c-enterprise-thin-client
    \n3 -Ассистент
    \n4 - CryptoPro-5.0.11998
    \n5 - Диск Z
    \n6 - Все ПО без диска Z
    \n7 - Все ПО с диском Z \033[0m 
    \n Введи значение от 1 до 7:  ' three
    case $three in
	[1]*) dp_kagent klnagent64; break;;
        [2]*) dp_1csed 1c-enterprise-8.3.23.1688-thin-client; break;;
        [3]*) UnitOU="OU=Geological,OU=Virtual,OU=Desktops,OU=Workstations,OU=SPB1,OU='GAZPROM INT'"; break;;
        * ) echo "Вводить можно только 1-7.";;
    esac
done





umount -f /mnt/distemp/
rm -r /mnt/distemp

dir /mnt/
