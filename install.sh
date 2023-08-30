#!/bin/bash

# Detecting the OS version
OS_VERSION=$(lsb_release -sr)

if [ "$OS_VERSION" != "10.3" ] && [ "$OS_VERSION" != "11" ]; then
    echo "This script is designed for Debian 10.3 or 11 only!"
    exit 1
fi

# Check if the user is root or if sudo is available
if [ "$(id -u)" -ne 0 ]; then
    if ! command -v sudo &> /dev/null; then
        echo "Error: sudo is not installed and you are not root."
        echo "Please run this script as root or install sudo."
        exit 1
    fi
else
    if ! command -v sudo &> /dev/null; then
        apt update
        apt install -y sudo
    fi
fi

# Updating the system
sudo apt update && sudo apt upgrade -y

# Installing common utilities
sudo apt install -y wget nano sudo

# Setting up a new user
read -p "Enter the new username: " USERNAME
read -s -p "Enter the password: " PASSWORD
echo
read -p "Enter your email for the ssh key: " EMAIL
echo
sudo adduser $USERNAME --gecos "" --disabled-password
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Set up sudo privileges
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Setting up FTP
sudo apt install -y vsftpd
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
echo "chroot_local_user=YES" | sudo tee -a /etc/vsftpd.conf
echo "user_sub_token=$USER" | sudo tee -a /etc/vsftpd.conf
echo "local_root=/home/$USER" | sudo tee -a /etc/vsftpd.conf
sudo systemctl restart vsftpd

# Installing Nginx
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Installing Docker
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
fi

# Allow the non-root user to use Docker
sudo usermod -aG docker $USERNAME

# Installing Docker Compose
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Installing Certbot
sudo apt install -y certbot python3-certbot-nginx

# Installing nvm and Node.js (latest version)
if [ "$OS_VERSION" == "10.3" ]; then
    # Installation steps specific to Debian 10.3
    sudo apt install -y curl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
else
    # Installation steps specific to Debian 11
    sudo apt install -y curl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
fi

# Source nvm to use it immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install node

# Installing Git and its tools
if ! [ -x "$(command -v git)" ]; then
    sudo apt install -y git git-core
fi

# Generate SSH Key
sudo -u "$USER_NAME" ssh-keygen -t rsa -b 4096 -C "$EMAIL"

# End message
echo -e "\e[32m✔ Installation completed successfully!\e[0m"
