#!/bin/bash
echo "==> Instalando Postfix..."

sudo debconf-set-selections <<< "postfix postfix/mailname string dalvik.xyz"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

hostname
sudo hostnamectl set-hostname dalvik.xyz
sudo hostnamectl set-hostname --static dalvik.xyz

sudo apt update
sudo apt install -y postfix

sudo cat /etc/mailname

sudo adduser --disabled-password santiago
sudo adduser --disabled-password luisa
sudo adduser --disabled-password medina
sudo adduser --disabled-password yustes

echo "santiago:pass" | sudo chpasswd
echo "luisa:pass" | sudo chpasswd
echo "medina:pass" | sudo chpasswd
echo "yustes:pass" | sudo chpasswd


sudo apt install -y bsd-mailx

sudo cat /var/log/mail.log 

sudo rm /etc/postfix/main.cf
sudo tee /etc/postfix/main.cf > /dev/null <<EOF
smtpd_banner = \$myhostname ESMTP \$mail_name (Ubuntu)
biff = no
append_dot_mydomain = no

readme_directory = no

compatibility_level = 3.6

smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_security_level=may

smtp_tls_CApath=/etc/ssl/certs
smtp_tls_security_level=may
smtp_tls_session_cache_database = btree:\${data_directory}/smtp_scache

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = dalvik.xyz
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = \$myhostname, dalvik.xyz, localhost.xyz, localhost
relayhost =
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 192.168.1.0/24 
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all
home_mailbox = Maildir/
mailbox_command =
EOF

sudo systemctl restart postfix
sudo systemctl enable postfix

sudo systemctl status postfix --no-pager


sudo apt install -y dovecot-pop3d dovecot-imapd
sudo tee /etc/dovecot/conf.d/10-auth.conf > /dev/null <<EOF
disable_plaintext_auth = no
auth_mechanisms = plain
!include auth-system.conf.ext
EOF

sudo tee /etc/dovecot/conf.d/10-mail.conf > /dev/null <<EOF
mail_location = maildir:~/Maildir
namespace inbox {
  inbox = yes
}
mail_privileged_group = mail
protocol !indexer-worker {
}
EOF

sudo systemctl restart dovecot
sudo systemctl enable dovecot

sudo systemctl status dovecot --no-pager