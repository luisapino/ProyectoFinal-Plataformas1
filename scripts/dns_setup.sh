echo "Instalando BIND9..."
sudo apt update
sudo apt install -y bind9 bind9utils bind9-doc

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

sudo chown bind:bind /etc/bind/zones
sudo chmod 750 /etc/bind/zones

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
pop     IN      A       192.168.1.103
web     IN      A       192.168.1.104
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
102       IN      PTR     dns.dalvik.xyz.
103       IN      PTR     mail.dalvik.xyz.
103       IN      PTR     pop.dalvik.xyz.
104       IN      PTR     web.dalvik.xyz.
EOF

cat <<EOF | sudo tee /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";
        listen-on { any; };
        allow-query { localhost; 192.168.1.0/24; };
        allow-recursion { localhost; 192.168.1.0/24; };
        forwarders {
                8.8.8.8;
                8.8.4.4;
        };
        listen-on-v6 { none; };
        dnssec-validation no;
};
EOF

sudo systemctl restart bind9