echo "Instalando BIND9..."
sudo apt update
sudo apt install -y bind9 bind9utils bind9-doc

echo "Configurando zona DNS..."
sudo mkdir -p /etc/bind/zones
cat <<EOF | sudo tee /etc/bind/named.conf.local
zone "dalvik.xyz" {
    type master;
    file "/etc/bind/zones/db.dalvik.xyz";
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.1";
};
EOF

cat <<EOF | sudo tee /etc/bind/zones/db.dalvik.xyz
\$TTL 604800
@       IN      SOA     dns.dalvik.xyz. admin.dalvik.xyz. (
                        2         ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL
;

@       IN      NS      dns.dalvik.xyz.
@       IN      MX      10 mail.dalvik.xyz.
dns     IN      A       192.168.1.102
mail    IN      A       192.168.1.103
pop     IN      A       192.168.1.104
web     IN      A       192.168.1.105
EOF

cat <<EOF | sudo tee /etc/bind/zones/db.192.168.1
\$TTL 604800
@       IN      SOA     dns.dalvik.xyz. admin.dalvik.xyz. (
                        2         ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL
;

@       IN      NS      dns.dalvik.xyz.
2       IN      PTR     dns.dalvik.xyz.
3       IN      PTR     mail.dalvik.xyz.
4       IN      PTR     pop.dalvik.xyz.
5       IN      PTR     web.dalvik.xyz.
EOF

sudo systemctl restart bind9
echo "BIND9 configurado con éxito."