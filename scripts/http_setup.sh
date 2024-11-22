#!/bin/bash
echo "Instalando NGINX..."
sudo apt update
sudo apt install -y nginx

cat <<EOF | sudo tee /etc/nginx/sites-available/default
server {
    listen 80;
    server_name web.dalvik.xyz;

    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

echo "<h1>Bienvenido a dalvik.xyz</h1>" | sudo tee /var/www/html/index.html

sudo systemctl restart nginx
echo "NGINX configurado con éxito."