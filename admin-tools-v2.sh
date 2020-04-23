#!/bin/bash
#getting admin token
realm=matrixl.lt.loc
domain=http://matrix.lt.loc
registration_secret=
admin_user=
admin_pass=
json=`curl -s -XPOST -d '{"type":"m.login.password", "user":"$admin_user", "password":"$admin_pass"}' "$domain/_matrix/client/r0/login"`
access_token=`echo "$json" | jq -r ".access_token"`


#Start menu
while [ "$done" != "true" ]
do

#Choose option

echo -e "\n\n\n\n\nWhat do you want to do?\n[1] – Deactivate user\n[2] – Deactivate user and delete account\n[3] – Check user's loggin info\n[4] – Change user password\n[5] – Register new user\n[6] – Exit ";
read option
case "$option" in
"1")

#Deactivate user no delete

echo -e "Enter user you'd like to deactivate\n";
read user

curl -XPOST -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -d \
  '{}' "$domain/_matrix/client/r0/admin/deactivate/@$user:$realm"  
;;


"2")
#Deactivate user delete

echo -e "Enter user you'd like to deactivate and delete\n";
read user

curl -XPOST -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -d \
  '{"erase": true}' "$domain/_matrix/client/r0/admin/deactivate/@$user:$realm"
;;

"3")
#Check user info

echo -e "Enter user you'd like to check info\n";
read user

curl -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -X GET "$domain/_matrix/client/r0/admin/whois/@$user:$realm"
;;

"4")
#Reset user pass / Reactivate user

echo -e "Enter user you'd like to change password\n";
read user

echo -e "Enter new passs";
read pass

curl -XPOST -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -d \
  '{"new_password":"'$pass'"}' "$domain/_matrix/client/r0/admin/reset_password/@$user:$realm"
;;

"5")

python3 $(dirname "$0")/register_new_matrix_user.py -k $registration_secret $domain
;;
#Register new user

#Exit
"6") exit 1 || return 1;;

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
