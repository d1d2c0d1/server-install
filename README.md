# README for install.sh

## 🚀 Introduction

Welcome to the documentation for the install.sh script! This script provides a straightforward way to set up your Debian 11 server with essential components like Docker, Docker Compose, Nginx, and more.

## 🛠 Features

Here's a rundown of what the script does:

- **System Update**: Ensures your system is up-to-date.
- **Essential Tools Installation**: Installs tools like nano, and sudo.
- **Nginx Setup**: Installs and sets up Nginx for web serving and reverse proxying.
- **FTP Configuration**: Allows you to set up FTP for easier file transfers.
- **Docker & Docker-Compose Installation**: Lets you run containerized applications.
- **Certbot Installation**: A tool to obtain free SSL certificates for your domains.
- **NVM & Node.js Setup**: Installs Node Version Manager and the latest version of Node.js.
- **GIT & GIT-Core**: Installs GIT and GIT-Core for use systems of version controll
- **User Configuration**: Creates a new user with specific privileges and access.

## 🖥 Requirements

- A fresh Debian 11 or 10.3 installation.
- Root or sudo access.

## 📖 Usage

1. **Download and Execute the Script**:
```bash
wget https://raw.githubusercontent.com/d1d2c0d1/server-install/main/install.sh && chmod +x install.sh && ./install.sh
```

2. **Follow the Prompts**: The script will ask you for a username, password, and email. Make sure to provide valid inputs!

## 🚧 Important Notes

- Always back up your data before running scripts like this, especially in production environments.
- The FTP setup allows access only to the home directory of the specified user.
- For security reasons, it's advised not to use the root user for daily tasks. Use the newly created user.

## 🌐 Certbot and SSL

After running the script, if you wish to obtain SSL certificates for your domains:

1. Navigate to your Nginx sites-enabled directory.
2. Add your domain configurations.
3. Run Certbot and follow the prompts.

### use Certbot

1. Obtain SSL Certificates:
Replace example.com with your domain name.
```bash
sudo certbot --nginx -d example.com -d www.example.com
```

2. Follow the prompts to configure SSL settings.
3. Certbot will automatically set up the SSL certificates for your Nginx server and configure the virtual host file.
4. Certbot will also add a renewal cron job to ensure that your certificates are automatically renewed before they expire. You can test the renewal process with:
```bash
sudo certbot renew --dry-run
```

Remember to replace example.com with your actual domain name. After completing these steps, your Nginx server will be configured with SSL certificates, and your website will be accessible over HTTPS.

For more details and advanced configurations, refer to the [Certbot documentation](https://certbot.eff.org/docs/).

## 📝 Contribution & Feedback

Feel free to fork this repository, make your changes, and submit a pull request if you think you've made improvements. Feedback is always welcome!

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## ✅ Conclusion

We hope this script makes your server setup process more comfortable and faster. Cheers to more streamlined development and deployment! 🥂

Remember, always test scripts in a safe environment before deploying them into production. Happy coding! 🎉