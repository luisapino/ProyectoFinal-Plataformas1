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

cat <<EOF | sudo tee /etc/bind/zones/db.dalvik.xyz
\$ORIGIN .
\$TTL 86400      ; 1 day
dalvik.xyz            IN SOA  dalvik.xyz. root.dalvik.xyz. (
                                3 ; serial
                                604800     ; refresh (1 week)
                                86400      ; retry (1 day)
                                2419200    ; expire (4 weeks)
                                86400      ; minimum (1 day)
                                )
                        NS      dns.dalvik.xyz.
dalvik.xyz.             IN MX 10  mail.dalvik.xyz.
\$ORIGIN dalvik.xyz.
\$TTL 300        ; 5 minutes
dns                      A      192.168.1.102
web                      A      192.168.1.104
mail               A      192.168.1.103
pop3  IN CNAME mail
smtp  IN CNAME mail
EOF


cat <<EOF | sudo tee /etc/bind/zones/db.192.168.1
\$ORIGIN .
\$TTL 86400      ; 1 day
1.168.192.in-addr.arpa    IN SOA  dalvik.xyz. root.dalvik.xyz. (
                                3 ; serial
                                604800     ; refresh (1 week)
                                86400      ; retry (1 day)
                                2419200    ; expire (4 weeks)
                                86400      ; minimum (1 day)
                                )
                        NS      dns.dalvik.xyz.
\$ORIGIN 1.168.192.in-addr.arpa.
\$TTL 300        ; 5 minutes
102                     PTR     dns.dalvik.xyz.
103                     PTR     mail.dalvik.xyz.
104                     PTR     web.dalvik.xyz.
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