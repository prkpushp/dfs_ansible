#!/bin/bash

# Prompt for the username
read -p "Enter your AD username[e.g. pk32064]: " username
password=""
prompt="Enter your AD password: "
echo -n "$prompt"
while IFS= read -rs -n 1 char; do
    if [[ $char == $'\0' ]]; then
        break  # Null character indicates the end of input
    elif [[ $char == $'\177' || $char == $'\010' ]]; then  # Check for backspace (ASCII 127) and (ASCII 8)
        if [ ${#password} -gt 0 ]; then
            password=${password%?}  # Remove the last character
            echo -en "\b \b"  # Clear the last character from the screen
        fi
    else
        password+="$char"
        echo -n "*"
    fi
done

echo  # Newline for a clean output



# Create the cred.yml file with the provided values
echo "ansible_user: win\\$username" > cred.yml
echo "ansible_password: $password" >> cred.yml

# Provide confirmation

#Encrypt the file with Ansible vault
ansible-vault encrypt cred.yml

echo "The credential is stored in cred.yml file. Run the below command to view it if needed:"
echo "ansible-vault view cred.yml"
