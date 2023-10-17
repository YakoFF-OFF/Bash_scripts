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

<<<<<<< HEAD
<<<<<<< HEAD
local v_domain=$(cat /mnt/distemp/variables/v_domain.txt)
local v_comp=$(cat /mnt/distemp/variables/v_comp.txt)

c_id=$(adcli show-computer -U $first --domain=$v_domain $v_comp --stdin-password <<< $second &> /tmp/comp_check.txt)
=======
c_id=$(adcli show-computer -U $first --domain=ZARGAZ.RU SPB1-241G --stdin-password <<< $second &> /tmp/comp_check.txt)
>>>>>>> parent of a9328f2 (Delete zargaz.sh)
=======
c_id=$(adcli show-computer -U $first --domain=ZARGAZ.RU SPB1-241G --stdin-password <<< $second &> /tmp/comp_check.txt)
>>>>>>> parent of a9328f2 (Delete zargaz.sh)
v_id=$(cat /tmp/comp_check.txt)

if grep -Pq "Couldn't authenticate" <<< "$v_id";
        then
               return 1;

        else
               return 2;

fi
}


<<<<<<< HEAD
<<<<<<< HEAD
=======



>>>>>>> parent of a9328f2 (Delete zargaz.sh)
=======



>>>>>>> parent of a9328f2 (Delete zargaz.sh)
# echo "join-to-domain.sh -d ZARGAZ.RU -n <имя машины> -u $first -p $second --ou "OU=$UnitOU,OU=Workstations,OU=SPB1,OU=GAZPROM INT" -y"
# Монтирование директории с дистрибами rpm файлами для установки
# Создание директории для мониторвания
#mkdir /mnt/distr
# Монтирование сетевой директории в созданную папку
#mount -t cifs -o user=$first,domain=zargaz,password="$second" //spb1-svm01/distrib$/Software/RedOs/rpm /mnt/distr
#dir /mnt/distr
# Удаление точки монтирования и папки
#umount -f /mnt/distr
#rmdir distr


# Функция проверки прохождения аутентификации и существования ПК в домене
# $1 - Имя ПК

ch_comp() {
<<<<<<< HEAD
<<<<<<< HEAD

local v_domain=$(cat /mnt/distemp/variables/v_domain.txt)

check=$(adcli show-computer -U $first --domain=$v_domain $1 --stdin-password <<< $second &> /tmp/comp_check.txt)
=======
check=$(adcli show-computer -U $first --domain=ZARGAZ.RU $1 --stdin-password <<< $second &> /tmp/comp_check.txt)
>>>>>>> parent of a9328f2 (Delete zargaz.sh)
=======
check=$(adcli show-computer -U $first --domain=ZARGAZ.RU $1 --stdin-password <<< $second &> /tmp/comp_check.txt)
>>>>>>> parent of a9328f2 (Delete zargaz.sh)
v_check=$(cat /tmp/comp_check.txt)

if grep -Pq "sAMAccountName" <<< "$v_check";
	then 
		return 1;

	else 
		return 2;
		
fi
}


# Функция получения имени компьютера
# c_name - имя ПК
# Подстановка нолей в имя ПК
# c_namnum - счетчик номеров ПК
# t_num - привдеенный к правильному виду номер компа добавлено 00

true_cname() {

c_namnum=$1
len=${#c_namnum}

if [ "$len" -eq "1" ]
then t_num="SPB1-00${c_namnum}${2}"
	elif [ "$len" -eq "2" ]
	then 
		t_num="SPB1-0${c_namnum}${2}"
	else 
		t_num="SPB1-${c_namnum}${2}"

fi 

}


# Функция вопроса о продолжении поиска компьютера

ch_ask() {
		while true;
                       do
                           read -r -p "Найденое имя $t_num Продолжить поиск (y/n)?  " yn
                           case $yn in
                               [Yy]* ) echo "Продолжаем поиск"; return 4;break;;
                               [Nn]* ) return 3; break;;
			       * ) echo -e ${RED} "Ответьте yes или no" ${NC};;
                           esac
                       done
}

# Проверка имени и пароля админа  
# Ввод переменных
# first - имя пользователя с правами ввода в домен
# second - пароль пользователя с правами ввода в домен


for ((p=1;p<5;p++))
do
read -r -p "Имя пользователя с парвами присоединения в домен: " first
echo ""

#echo $'\n'
read -r -s -p "Пароль пользователя с парвами присоединения в домен: " second
#echo $'\n'
echo ""

ch_idpas

if  [ "$?" -eq "2" ]
then echo -e ${GREEN} "ИД и Пароль верный" ${NC};  break;
else echo -e ${RED} "ИД или Пароль неверный" ${NC}
fi

done

<<<<<<< HEAD
<<<<<<< HEAD
# Перемнные пути юнита из АД, в какую папку ляжет комп после ввода в домен
## v_unit_d  - 

local v_unit_d=$(cat /mnt/distemp/variables/v_unit_d.txt)
local v_unit_l=$(cat /mnt/distemp/variables/v_unit_l.txt)
local v_unit_v=$(cat /mnt/distemp/variables/v_unit_v.txt)


=======
>>>>>>> parent of a9328f2 (Delete zargaz.sh)
=======
>>>>>>> parent of a9328f2 (Delete zargaz.sh)

# Выбор типа нужной рабстанции
while true;
do
    read -r -p "Юнит машины в домене D - desc L - Laptop V - Virtual (D/L/V): " three
    case $three in
<<<<<<< HEAD
<<<<<<< HEAD
        [Dd]*) UnitOU=$v_unit_d; break;;
        [Ll]*) UnitOU=$v_unit_l; break;;
        [Vv]*) UnitOU=$v_unit_v; break;;
=======
        [Dd]*) UnitOU='OU=Desktops,OU=Workstations,OU=SPB1,OU=GAZPROM INT'; break;;
        [Ll]*) UnitOU="OU=Laptops,OU=Workstations,OU=SPB1,OU='GAZPROM INT'"; break;;
        [Vv]*) UnitOU="OU=Geological,OU=Virtual,OU=Desktops,OU=Workstations,OU=SPB1,OU='GAZPROM INT'"; break;;
>>>>>>> parent of a9328f2 (Delete zargaz.sh)
=======
        [Dd]*) UnitOU='OU=Desktops,OU=Workstations,OU=SPB1,OU=GAZPROM INT'; break;;
        [Ll]*) UnitOU="OU=Laptops,OU=Workstations,OU=SPB1,OU='GAZPROM INT'"; break;;
        [Vv]*) UnitOU="OU=Geological,OU=Virtual,OU=Desktops,OU=Workstations,OU=SPB1,OU='GAZPROM INT'"; break;;
>>>>>>> parent of a9328f2 (Delete zargaz.sh)
        * ) echo "Вводить можно только D/L/V.";;
    esac
done

<<<<<<< HEAD
<<<<<<< HEAD
=======
echo $UnitOU

>>>>>>> parent of a9328f2 (Delete zargaz.sh)
=======
echo $UnitOU

>>>>>>> parent of a9328f2 (Delete zargaz.sh)
# Цикл перебора компов для поиска свободного имени

for ((i=40;i<301;i++))
	do 
 	true_cname $i D
	ch_comp $t_num
	if [ "$?" -eq "2" ]
        	then 
			true_cname $i L
                        ch_comp $t_num

		if  [ "$?" -eq "2" ] 
	   		then
			true_cname $i V
		        ch_comp $t_num

		if  [ "$?" -eq "2" ]
   			then
			true_cname $i G
			ch_comp $t_num

		if  [ "$?" -eq "2" ]
			then
			echo "Cвободный номер компа нужный тебе найден и он :"
			true_cname $i $three
			echo $t_num
			echo ""
			echo ""
			ch_ask
		if [ "$?" -eq "3" ]
			then break
		fi				
		                           
		fi
		fi
		fi
		fi

		done



<<<<<<< HEAD
<<<<<<< HEAD
local v_domain=$(cat /mnt/distemp/variables/v_domain.txt)

join-to-domain.sh -d $v_domain -n $t_num -u $first -p $second -o "$UnitOU"  -y
=======


join-to-domain.sh -d ZARGAZ.RU -n $t_num -u $first -p $second -o "$UnitOU"  -y
>>>>>>> parent of a9328f2 (Delete zargaz.sh)
=======


join-to-domain.sh -d ZARGAZ.RU -n $t_num -u $first -p $second -o "$UnitOU"  -y
>>>>>>> parent of a9328f2 (Delete zargaz.sh)


second=1

<<<<<<< HEAD
<<<<<<< HEAD
=======
echo $second

>>>>>>> parent of a9328f2 (Delete zargaz.sh)
=======
echo $second

>>>>>>> parent of a9328f2 (Delete zargaz.sh)

