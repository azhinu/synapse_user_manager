#!/bin/bash

realm="matrix.loc"
domain="https://synapse.loc"
registration_secret="get it in config"
access_token="get it in element"

#Start menu
while [ "$done" != "true" ]
do

#Choose option

echo -e "\n\n\n\n\nWhat do you want to do?\n[1] – Deactivate user\n[2] – Delete Group\n[3] – Change user password\n[4] – Register new user\n[5] – Exit ";
read option
case "$option" in
"1")
#Deactivate user no delete

echo -e "Enter user you'd like to deactivate\n";
read user

curl -XPOST -H "Authorization: Bearer $access_token" "$domain/_synapse/admin/v1/deactivate/@$user:$realm"
;;


"2")
#Remove group

echo -e "Enter Group ID you'd like to delete\n";
read user

curl -XPOST -H "Authorization: Bearer $access_token" "$domain/_synapse/admin/v1/delete_group/@$user:$realm"
;;

"3")
#Reset user pass / Reactivate user

echo -e "Enter user you'd like to change password\n";
read user

echo -e "Enter new passs";
read pass

# curl -XPOST -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -d \
#   '{"new_password":"'$pass'"}' "$domain/_synapse/admin/v1/reset_password/@$user:$realm"
curl --insecure -XPUT -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -d \
  '{"password":"'$pass'","deactivated": false}' "$domain/_synapse/admin/v2/users/@$user:$realm"
;;

"4")

python3 $(dirname "$0")/register_new_matrix_user.py -k $registration_secret $domain
;;
#Register new user

#Exit
"5") exit 1 || return 1;;

esac


#Return to menu
read -p "Choose next operation? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

done

exit 0
