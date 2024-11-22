#!/bin/bash
sudo apt update
sudo apt install -y dovecot-pop3d


sudo tee /etc/dovecot/conf.d/10-auth.conf > /dev/null <<EOF
disable_plaintext_auth = no
auth_mechanisms = plain
!include auth-system.conf.ext
EOF

sudo tee /etc/dovecot/conf.d/10-main.conf > /dev/null <<EOF
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