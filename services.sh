#!/bin/bash

#### SSH ####
echo -n "Is SSH a required service? [Y/n] "
read -r option
if [[ $option =~ ^[Yy]$ ]]; then
    # Install SSH and OpenSSH Server
    apt-get install -y ssh openssh-server

    # Secure SSH configuration
    ssh_config="/etc/ssh/sshd_config"
    if [[ -f $ssh_config ]]; then
        sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' "$ssh_config"
        sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' "$ssh_config"
        sed -i 's/#Port.*/Port 2222/' "$ssh_config"  # Use a non-standard port
        systemctl restart ssh
        echo "SSH configuration secured."
    fi
else
    # Remove SSH services
    apt-get remove -y ssh openssh-server
    apt-get autoremove -y
fi

#### Apache ####
echo -n "Is Apache required? [Y/n] "
read -r option
if [[ $option =~ ^[Yy]$ ]]; then
    # Install Apache2
    apt-get install -y apache2

    # Secure Apache configuration
    apache_config="/etc/apache2/apache2.conf"
    if [[ -f $apache_config ]]; then
        sed -i 's/ServerTokens.*/ServerTokens Prod/' "$apache_config"
        sed -i 's/ServerSignature.*/ServerSignature Off/' "$apache_config"
        echo "Apache configuration secured."
    fi
    # Restart Apache to apply changes
    systemctl restart apache2
else
    # Remove Apache2
    apt-get remove -y apache2
    apt-get autoremove -y
fi

#### MySQL ####
echo -n "Is MySQL required? [Y/n] "
read -r option
if [[ $option =~ ^[Yy]$ ]]; then
    # Install MySQL
    apt-get install -y mysql-server

    # Secure MySQL configuration
    mysql_config="/etc/mysql/mysql.conf.d/mysqld.cnf"
    if [[ -f $mysql_config ]]; then
        sed -i 's/bind-address.*/bind-address = 127.0.0.1/' "$mysql_config"  # Bind only to localhost
        echo "MySQL configuration secured."
    fi
    # Restart MySQL to apply changes
    systemctl restart mysql
else
    # Remove MySQL
    apt-get remove --purge -y mysql-server
    apt-get autoremove -y
fi
