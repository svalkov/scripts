#!/bin/bash

users_function () {
echo
echo "Please select one of the options below:"
echo "1. Create new user."
echo "2. Create new group."
echo "3. Add user to a group."
echo "4. Give user sudo rights."
echo "5. Delete user."
echo "6. Delete group."
echo "7. List all users and groups."
echo "8. EXIT!"
echo
echo

read choice
if [[ $choice == '1' ]]; then
echo "Please enter new username: "
read user
useradd $user
echo
echo "User - $user has been successfully created!"
echo

elif [[ $choice == '2' ]]; then
echo "Please enter new groupname: "
read groupname
groupadd $groupname
echo "Group - $groupname has been successfully created!"
echo

elif [[ $choice == '3' ]]; then
echo "Please enter username: "
read user_1
echo "Please enter the group you would like to join: "
read groupname_1
usermod -a -G $groupname_1 $user_1
echo "User - $user_1 is now part of the group - $groupname_1 !"
echo

elif [[ $choice == '4' ]]; then
echo "Please enter the username: "
read user_2
echo "$user_2 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "User - $user_2 has been granted with sudo rights!"
echo

elif [[ $choice == '5' ]]; then
echo "Please enter username for deletion: "
read user_3
userdel $user_3
echo "User - $user_3 has been deleted!"
echo

elif [[ $choice == '6' ]]; then
echo "Please enter groupname for deletion: "
read groupname_2
groupdel $groupname_2
echo "Group - $groupname_2 has been deleted!"
echo

elif [[ $choice == '7' ]]; then
echo "List of all users and groups: "
echo
sleep 1
echo "List of all users: "
cat /etc/passwd | awk -F: '{print $1}'
echo
sleep 1
echo "List of all groups: "
cat /etc/group | awk -F: '{print $1}'

elif [[ $choice == '8' ]]; then
sleep 1
echo
echo "BYE "
echo
fi
}

echo
echo
echo "Hello to the user and group automation tool! :)"
users_function

echo
echo "Do you want to continue?"
echo "1. Yes"
echo "2. No"
echo
read choice
while [ $choice = 1 ]
do
	users_function
done
